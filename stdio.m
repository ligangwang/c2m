fun remove(__filename:string) -> int
fun rename(__old:string __new:string) -> int
fun renameat(__oldfd:int __old:string __newfd:int __new:string) -> int
fun tempnam(__dir:string __pfx:string) -> string








fun getchar() -> int
fun getchar_unlocked() -> int
fun putchar(__c:int) -> int
fun putchar_unlocked(__c:int) -> int
fun puts(__s:string) -> int
fun perror(__s:string) -> None
fun ctermid(__s:string) -> string
