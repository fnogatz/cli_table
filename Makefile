.PHONY: all test

version := $(shell swipl -q -s pack -g 'version(V),writeln(V)' -t halt)
packfile = clitable-$(version).tgz

SWIPL := swipl

all: test

version:
	echo $(version)

check: test

install:
	echo "(none)"

dependencies:
	@$(SWIPL) -q -g 'pack_install(tap, [interactive(false)]), halt(0)' -t 'halt(1)'

test:
	@$(SWIPL) -q -g 'main,halt(0)' -t 'halt(1)' -s test/test.pl

package: test
	tar cvzf $(packfile) prolog test pack.pl README.md LICENSE

release: test
	hub release create -m v$(version) v$(version)
