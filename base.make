.POSIX:
SHELL = /bin/sh

ARTIFACTS = c/code \
	    cpp/code \
	    go/code \
	    jvm/code.class \
	    scala/code scala/code-native \
	    rust/target \
	    kotlin/code.jar \
	    kotlin/code.kexe \
	    dart/code \
	    inko/build inko/code \
	    nim/code \
	    js/bun \
	    common-lisp/code \
	    fpc/code \
	    crystal/code \
	    ada/code ada/code.ali ada/code.o \
	    d/code \
	    odin/code \
	    objc/code \
	    fortran/code \
	    zig/code \
	    lua/code \
	    swift/code \
	    haxe/code.jar \
	    csharp/bin \
	    csharp/obj \
	    csharp/code-aot \
	    csharp/code \
	    fsharp/bin \
	    fsharp/obj \
	    fsharp/code-aot \
	    fsharp/code \
	    haskell/code haskell/*.hi haskell/*.o \
	    v/code \
	    emojicode/code emojicode/code.o \
	    chez/code.so \
	    clojure/classes clojure/.cpcache \
	    cobol/main

clean:
	rm -fr $(ARTIFACTS)
