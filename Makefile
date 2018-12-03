.PHONY: all test

version := $(shell swipl -q -s pack -g 'version(V),writeln(V)' -t halt)
packfile = clitable-$(version).tgz

SWIPL := swipl

all:
	echo "clitable installed"

install:
	echo "(none)"

test:
	@$(SWIPL) -q -g 'main,halt(0)' -t 'halt(1)' -s test/test.pl

package:
	tar cvzf $(packfile) prolog pack.pl README.md LICENSE

release:
	hub release create -m v$(version) v$(version)
