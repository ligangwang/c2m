fun remove __filename:string -> int
fun rename __old:string __new:string -> int
fun renameat __oldfd:int __old:string __newfd:int __new:string -> int
fun fclose __stream:ref -> int
fun tmpfile () -> ref
fun tempnam __dir:string __pfx:string -> string
fun fflush __stream:ref -> int
fun fflush_unlocked __stream:ref -> int
fun fopen __filename:string __modes:string -> ref
fun freopen __filename:string __modes:string __stream:ref -> ref
fun fdopen __fd:int __modes:string -> ref
fun open_memstream __bufloc:ref __sizeloc:ref -> ref
fun setbuf __stream:ref __buf:string -> ()
fun setlinebuf __stream:ref -> ()
fun fprintf __stream:ref __format:string ... -> int
fun printf __format:string ... -> int
fun sprintf __s:string __format:string ... -> int
fun vfprintf __s:ref __format:string __arg:ref -> int
fun vprintf __format:string __arg:ref -> int
fun vsprintf __s:string __format:string __arg:ref -> int
fun snprintf __s:string __maxlen:u64 __format:string ... -> int
fun vsnprintf __s:string __maxlen:u64 __format:string __arg:ref -> int
fun dprintf __fd:int __fmt:string ... -> int
fun fscanf __stream:ref __format:string ... -> int
fun scanf __format:string ... -> int
fun sscanf __s:string __format:string ... -> int
fun fscanf __stream:ref __format:string ... -> int
fun scanf __format:string ... -> int
fun sscanf __s:string __format:string ... -> int
fun vfscanf __s:ref __format:string __arg:ref -> int
fun vscanf __format:string __arg:ref -> int
fun vsscanf __s:string __format:string __arg:ref -> int
fun vfscanf __s:ref __format:string __arg:ref -> int
fun vscanf __format:string __arg:ref -> int
fun vsscanf __s:string __format:string __arg:ref -> int
fun fgetc __stream:ref -> int
fun getc __stream:ref -> int
fun getchar () -> int
fun getc_unlocked __stream:ref -> int
fun getchar_unlocked () -> int
fun fgetc_unlocked __stream:ref -> int
fun fputc __c:int __stream:ref -> int
fun putc __c:int __stream:ref -> int
fun putchar __c:int -> int
fun fputc_unlocked __c:int __stream:ref -> int
fun putc_unlocked __c:int __stream:ref -> int
fun putchar_unlocked __c:int -> int
fun getw __stream:ref -> int
fun putw __w:int __stream:ref -> int
fun fgets __s:string __n:int __stream:ref -> string
fun fputs __s:string __stream:ref -> int
fun puts __s:string -> int
fun ungetc __c:int __stream:ref -> int
fun fread __ptr:ref __size:u64 __n:u64 __stream:ref -> u64
fun fwrite __ptr:ref __size:u64 __n:u64 __s:ref -> u64
fun rewind __stream:ref -> ()
fun fgetpos __stream:ref __pos:ref -> int
fun fsetpos __stream:ref __pos:ref -> int
fun clearerr __stream:ref -> ()
fun feof __stream:ref -> int
fun ferror __stream:ref -> int
fun clearerr_unlocked __stream:ref -> ()
fun feof_unlocked __stream:ref -> int
fun ferror_unlocked __stream:ref -> int
fun perror __s:string -> ()
fun fileno __stream:ref -> int
fun fileno_unlocked __stream:ref -> int
fun pclose __stream:ref -> int
fun popen __command:string __modes:string -> ref
fun ctermid __s:string -> string
fun flockfile __stream:ref -> ()
fun ftrylockfile __stream:ref -> int
fun funlockfile __stream:ref -> ()
fun __uflow arg0:ref -> int
fun __overflow arg0:ref arg1:int -> int
