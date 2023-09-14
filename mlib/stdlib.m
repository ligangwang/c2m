fun atof __nptr:string -> f64
fun atoi __nptr:string -> int
fun strtod __nptr:string __endptr:ref -> f64
fun strtoul __nptr:string __endptr:ref __base:int -> u64
fun select __nfds:int __readfds:ref __writefds:ref __exceptfds:ref __timeout:ref -> int
fun pselect __nfds:int __readfds:ref __writefds:ref __exceptfds:ref __timeout:ref __sigmask:ref -> int
fun srandom __seed:int -> ()
fun setstate __statebuf:string -> string
fun random_r __buf:ref __result:ref -> int
fun srandom_r __seed:int __buf:ref -> int
fun setstate_r __statebuf:string __buf:ref -> int
fun rand () -> int
fun srand __seed:int -> ()
fun rand_r __seed:ref -> int
fun drand48 () -> f64
fun drand48_r __buffer:ref __result:ref -> int
fun lrand48_r __buffer:ref __result:ref -> int
fun mrand48_r __buffer:ref __result:ref -> int
fun malloc __size:u64 -> ref
fun calloc __nmemb:u64 __size:u64 -> ref
fun realloc __ptr:ref __size:u64 -> ref
fun free __ptr:ref -> ()
fun alloca __size:u64 -> ref
fun aligned_alloc __alignment:u64 __size:u64 -> ref
fun abort () -> ()
fun atexit __func:ref -> int
fun at_quick_exit __func:ref -> int
fun on_exit __func:ref __arg:ref -> int
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
fun ecvt __value:f64 __ndigit:int __decpt:ref __sign:ref -> string
fun fcvt __value:f64 __ndigit:int __decpt:ref __sign:ref -> string
fun gcvt __value:f64 __ndigit:int __buf:string -> string
fun rpmatch __response:string -> int
fun getsubopt __optionp:ref __tokens:ref __valuep:ref -> int
