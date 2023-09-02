* dependencies
```
cp -r ../m/include/clib ./dep/include
cp -r ../m/include/parser ./dep/include
cp -r ../m/include/sema ./dep/include
cp -r ../m/include/lexer ./dep/include
cp ../m/build/lib/libclib.a ./dep/lib/libclib.a
cp ../m/build/lib/libmlrl.a ./dep/lib/libmlrl.a
```

* Generate stdio.m/math.m lib files
```

c2m -i/usr/include -o../mlib stdio.h
c2m -i/usr/include -o../mlib math.h
```
