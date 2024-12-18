.POSIX:
SHELL = /bin/sh

.SUFFIXES: \
	.c \
	.cpp \
	.go \
	.java \
	.class \
	.bun \
	.rs \
	.kt \
	.jar \
	.kexe \
	.dart \
	.inko \
	.nim \
	.lisp \
	.pas \
	.cr \
	.scala \
	.d \
	.odin \
	.m \
	.f90 \
	.zig \
	.lua \
	.swift \
	.cs \
	.fs \
	.hs \
	.v \
	.emojic \
	.ss \
	.so \
	.cbl


ARTIFACTS = c/code \
	    cpp/code \
	    go/code \
	    jvm/code.class \
	    scala/code \
	    rust/target \
	    rust/Cargo.lock \
	    rust/code \
	    kotlin/code.jar \
	    kotlin/code.kexe \
	    dart/code \
	    inko/build inko/code \
	    nim/code \
	    js/code \
	    common-lisp/code \
	    fpc/code \
	    crystal/code \
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
	    csharp/build-aot \
	    csharp/code \
	    csharp/build \
	    fsharp/bin \
	    fsharp/obj \
	    fsharp/build-aot \
	    fsharp/code \
	    fsharp/build \
	    haskell/code haskell/*.hi haskell/*.o \
	    v/code \
	    emojicode/code emojicode/code.o \
	    chez/code.so \
	    clojure/classes clojure/.cpcache \
	    cobol/main

all: \
	c/code \
	cpp/code \
	go/code \
	java/code.class \
	js/code \
	rust/code \
	kotlin/code.jar kotline/code.kexe \
	dart/code \
	inko/code \
	nim/code \
	common-lisp/code \
	fpc/code \
	crystal/code \
	scala/code \
	d/code \
	odin/code \
	objc/code \
	fortran/code \
	zig/code \
	lua/code \
	swift/code \
	csharp/code \
	fsharp/code \
	haskell/code \
	v/code \
	emojicode/code \
	chez/code.so \
	cobol/main

# C: single-inference rule handles the default; set optimization flags
CFLAGS = -O3

.cpp:
	clang++ -std=c++23 -march=native -O3 -Ofast -o $@ $<

.go:
	go build -ldflags "-s -w" -o $@ $<

.java.class:
	javac $<

.bun:
	bun build --bytecode --compile $< --outfile $@

# native-image (GraalVM): skipping commented out in run.sh

# pass CARGO_TOOLCHAIN=+nightly RUSTFLAGS="-Zlocation-detail=none" for a
# different kind of build
.rs:
	cargo $(CARGO_TOOLCHAIN) build --manifest-path $(<D)/Cargo.toml --release
	cp $(<D)/target/release/$(*F) $@

.kt.jar:
	kotlinc -include-runtime $< -d $@

.kt.kexe:
	kotlinc-native $< -o $* -opt

.dart:
	dart compile exe $< -o $@ --target-os=macos

.inko:
	cd inko && inko build --opt=aggressive $(<F) -o $(@F)

# suggested flags:
# -d:danger (or -d:release) -d:passC -a:off --threads:off --stackTrace:off --lineTrace:off
.nim:
	nim c $(NIMFLAGS) -x:off --opt:speed -o:$@ $<

.lisp:
	sbcl --noinform --non-interactive --load $< --build

.pas:
	fpc -O3 $<

.cr:
	crystal build -o $@ --release $<

# pass SCALA_OPTS='--native --native-mode release-full' for a native build
.scala:
	scala-cli --power $(SCALA_OPTS) package $< -f -o $@

.d:
	ldc2 -O3 -release -boundscheck=off -mcpu=native flto=thin $<

.odin:
	odin build $< -o:speed -file -out:$@

.m:
	clang -O3 -framework Foundation $< -o $@

.f90:
	gfortran -O3 $< -o $@

.zig:
	zig build-exe -O ReleaseFast -femit-bin=$@ $<

.lua:
	luajit -b $< $@

.swift:
	swiftc -O -parse-as-library -Xcc -funroll-loops -Xcc -march=native -Xcc -ftree-vectorize -Xcc -ffast-math $< -o $@

.cs:
	dotnet publish $(<D) -o $(*D)/build
	cp $(*D)/code $@

.fs:
	dotnet publish $(<D) -o $(*D)/build
	cp $(*D)/code $@

.hs:
	ghc -O2 -fllvm $< -o $@ || ghc -O2 $< -o $@

.v:
	v -prod -cc clang -d no_backtrace -gc none -o $@ $<

.emojic:
	emojicodec $<

.ss.so:
	printf '%s\n' '(compile-program "$<")' | chez --optimize-level 3 -q

clojure/classes/code.class: clojure/code.clj
	cd clojure && \
		mkdir -p classes && \
		clojure -Sdeps '{:paths ["."]}' -M -e "(compile 'code)"

.cbl:
	cobc -I /opt/homebrew/include/ -O -O2 -O3 -Os -x -o $@ $<

# skipping lean4: not present in run.sh

clean:
	rm -fr $(ARTIFACTS)
