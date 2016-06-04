# Building MoWEB

Make sure you have make and crystal-lang installed and run `make`.

>> Makefile

```Makefile
CRYSTAL_BIN ?= $(shell which crystal)
MOWEB_BIN ?= $(shell which moweb)
FLAGS ?= --release --link-flags="-static"

# Builds a static binary for current arch.
all: src/moweb.cr bin/moweb

src/moweb.cr:
	$(MOWEB_BIN) src

bin/moweb:
	$(CRYSTAL_BIN) build $(FLAGS) -o bin/moweb src/moweb.cr

clean:
	rm -rf .crystal bin/moweb

test:
	$(CRYSTAL_BIN) spec

```
