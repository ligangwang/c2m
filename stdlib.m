fun atof __nptr:string -> f64
fun atoi __nptr:string -> int
fun strtod __nptr:string __endptr -> f64
fun strtoul __nptr:string __endptr __base:int -> u64
fun srandom __seed:int -> ()
fun setstate __statebuf:string -> string
fun rand () -> int
fun srand __seed:int -> ()
fun rand_r __seed -> int
fun drand48 () -> f64
fun malloc __size:u64 -> &()
fun calloc __nmemb:u64 __size:u64 -> &()
fun realloc __ptr __size:u64 -> &()
fun free __ptr -> ()
fun alloca __size:u64 -> &()
fun aligned_alloc __alignment:u64 __size:u64 -> &()
fun abort () -> ()
fun exit __status:int -> ()
fun quick_exit __status:int -> ()
fun _Exit __status:int -> ()
fun getenv __name:string -> string
fun putenv __string:string -> int
fun setenv __name:string __value:string __replace:int -> int
fun unsetenv __name:string -> int
fun clearenv () -> int
fun mktemp __template:string -> string
fun mkstemp __template:string -> int
fun mkstemps __template:string __suffixlen:int -> int
fun mkdtemp __template:string -> string
fun system __command:string -> int
fun realpath __name:string __resolved:string -> string
fun abs __x:int -> int
fun ecvt __value:f64 __ndigit:int __decpt __sign -> string
fun fcvt __value:f64 __ndigit:int __decpt __sign -> string
fun gcvt __value:f64 __ndigit:int __buf:string -> string
fun rpmatch __response:string -> int
fun getsubopt __optionp __tokens __valuep -> int