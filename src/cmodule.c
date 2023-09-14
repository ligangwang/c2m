/*
 * Copyright (C) 2020 Ligang Wang <ligangwangs@gmail.com>
 *
 * cmodule implementation: using libclang to parse c header file
 * 
 */
#include "clib/array.h"
#include "clib/string.h"
#include "parser/ast.h"
#include "parser/astdump.h"
#include "parser/parser.h"
#include "sema/analyzer.h"
#include "sema/frontend.h"
#include <clang-c/Index.h>
#include <stdio.h>

struct MType {
    enum type type;
    enum type referee_type;
};

struct MType _get_type(CXType cxtype)
{
    struct MType mtype;
    mtype.type = TYPE_NULL;
    mtype.referee_type = TYPE_NULL;
    if (cxtype.kind == CXType_Double) {
        mtype.type = TYPE_F64;
    } else if (cxtype.kind == CXType_Void) {
        mtype.type = TYPE_UNIT;
    } else if (cxtype.kind == CXType_Bool) {
        mtype.type = TYPE_BOOL;
    } else if (cxtype.kind == CXType_ULong) {
        mtype.type = TYPE_U64;
    } else if (cxtype.kind == CXType_Int || cxtype.kind == CXType_UInt) {
        mtype.type = TYPE_INT;
    } else if (cxtype.kind == CXType_Pointer) {
        CXType pointee_type = clang_getPointeeType(cxtype);
        if (pointee_type.kind == CXType_Char_U || pointee_type.kind == CXType_Char_S || pointee_type.kind == CXType_UChar || pointee_type.kind == CXType_SChar) {
            mtype.type = TYPE_STRING;
        } else {
            mtype.type = TYPE_REF;
            mtype.referee_type = _get_type(pointee_type).type;
        }
    } else if (cxtype.kind == CXType_Char_S) {
        mtype.type = TYPE_CHAR;
    }
    return mtype;
}

struct ast_node *_create_type_item_node(struct type_context *tc, struct MType mtype, struct source_location loc)
{
    symbol type_symbol = mtype.type ? get_type_symbol(tc, mtype.type) : 0;
    if (mtype.type == TYPE_REF) {
        symbol referee_type_symbol = mtype.referee_type ? get_type_symbol(tc, mtype.referee_type) : 0;
        struct ast_node * val_node = type_item_node_new_with_builtin_type(referee_type_symbol, Mutable, loc);
        return type_item_node_new_with_ref_type(val_node->type_item_node, Mutable, loc);
    }
    return type_symbol ? type_item_node_new_with_builtin_type(type_symbol, Mutable, loc) : 0;
}

struct ast_node *create_function_func_type(struct type_context *tc, CXCursor cursor)
{
    CXType cur_type = clang_getCursorType(cursor);

    CXString cx_fun_name = clang_getCursorSpelling(cursor);
    string fun_name;
    string_init_chars(&fun_name, clang_getCString(cx_fun_name));
    clang_disposeString(cx_fun_name);
    if (string_eq_chars(&fun_name, "malloc")) {
        printf("test\n");
    }
    CXType cx_type = clang_getResultType(cur_type);
    struct MType ret_mtype = _get_type(cx_type);
    if (!ret_mtype.type) {
        printf("failed to find m type for c return type %d: fun: %s\n", cx_type.kind, string_get(&fun_name));
        return 0;
    }
    struct type_item *ret_type = create_nullary_type(tc, ret_mtype.type);
    ARRAY_FUN_PARAM(fun_params);
    int num_args = clang_Cursor_getNumArguments(cursor);
    bool is_variadic = clang_isFunctionTypeVariadic(cur_type);
    for (int i = 0; i < num_args; ++i) {
        CXType cx_arg_type = clang_getArgType(cur_type, i);
        struct MType arg_type = _get_type(cx_arg_type);
        if (!arg_type.type) {
            printf("failed to find m type for c arg type %d: fun: %s\n", cx_arg_type.kind, string_get(&fun_name));
            return 0;
        }
        if (arg_type.type == TYPE_REF && !arg_type.referee_type) {
            printf("failed to find m ref type for c arg type %d: fun: %s\n", cx_arg_type.kind, string_get(&fun_name));
            return 0;
        }
        CXCursor arg_cursor = clang_Cursor_getArgument(cursor, i);
        CXString cx_arg_name = clang_getCursorSpelling(arg_cursor);

        symbol var_name = to_symbol(clang_getCString(cx_arg_name));
        clang_disposeString(cx_arg_name);
        if (!string_size(var_name)) {
            string format = str_format("arg%d", i);
            var_name = to_symbol(string_get(&format));
        }
        struct source_location param_loc = {0, 0, 0, 0};
        struct ast_node *is_of_type = _create_type_item_node(tc, arg_type, param_loc);
        struct ast_node *var = ident_node_new(var_name, param_loc);
        struct ast_node *fun_param = var_node_new(var, is_of_type, 0, true, true, param_loc);
        fun_param->type = create_nullary_type(tc, arg_type.type);
        array_push(&fun_params, &fun_param);
    }
    struct source_location loc = { 0, 1, 0, 0 };
    struct ast_node *params = block_node_new(&fun_params);
    symbol ret_type_symbol = ret_type && ret_type->type ? get_type_symbol(tc, ret_type->type) : 0;
    struct ast_node *ret_type_item_node = _create_type_item_node(tc, ret_mtype, loc);
    return func_type_item_node_default_new(tc, string_2_symbol(&fun_name), params, ret_type_symbol, ret_type_item_node, is_variadic, true, loc);
}

struct client_data {
    struct type_context *tc;
    struct array func_types;
};

void client_data_init(struct client_data *data, struct type_context *tc)
{
    data->tc = tc;
    array_init(&data->func_types, sizeof(struct ast_node *));
}

enum CXChildVisitResult cursor_visitor(CXCursor cursor, CXCursor parent, CXClientData client_data)
{
    (void)parent;
    (void)client_data;
    enum CXCursorKind kind = clang_getCursorKind(cursor);
    struct client_data *data = (struct client_data *)client_data;
    // Consider functions and methods
    if (kind == CXCursor_FunctionDecl || kind == CXCursor_CXXMethod) {
        struct ast_node *node = create_function_func_type(data->tc, cursor);
        if (node) {
            array_push(&data->func_types, &node);
        }
    }
    return CXChildVisit_Recurse;
}

struct array parse_c_file(struct type_context *tc, const char *file_path)
{
    struct client_data data;
    client_data_init(&data, tc);
    CXIndex index = clang_createIndex(0, 0);
    CXTranslationUnit unit = clang_parseTranslationUnit(
        index,
        file_path, 0, 0,
        0, 0,
        CXTranslationUnit_None);
    if (unit == 0) {
        printf("Unable to parse translation unit for %s. Quitting.\n", file_path);
        return data.func_types;
    }
    CXCursor cursor = clang_getTranslationUnitCursor(unit);
    clang_visitChildren(
        cursor,
        cursor_visitor,
        &data);
    clang_disposeTranslationUnit(unit);
    clang_disposeIndex(index);
    return data.func_types;
}

void _write_to_file(struct array *codes, const char *mfile)
{
    FILE *fp;
    fp = fopen(mfile, "w");
    for (size_t i = 0; i < array_size(codes); i++) {
        string *code = array_get(codes, i);
        fprintf(fp, "%s\n", string_get(code));
    }
    fclose(fp);
}

bool transpile_2_m(const char *head, const char *mfile)
{
    struct frontend *fe = frontend_init();
    struct array protos = parse_c_file(fe->parser->tc, head);
    ARRAY_STRING(codes);
    for (size_t i = .0; i < array_size(&protos); i++) {
        struct ast_node *node = array_get_ptr(&protos, i);
        analyze(fe->sema_context, node);
        string code = dump(fe->sema_context, node);
        printf("code: %s\n", string_get(&code));
        array_push(&codes, &code);
    }
    _write_to_file(&codes, mfile);
    array_deinit(&protos);
    printf("parsing c file done!\n");
    frontend_deinit(fe);
    return true;
}
