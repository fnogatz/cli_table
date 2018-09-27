.PHONY: all test clean

version := $(shell swipl -q -s pack -g 'version(V),writeln(V)' -t halt)
packfile = clitable-$(version).tgz

SWIPL := swipl

package: test
	tar cvzf $(packfile) prolog pack.pl README.md LICENSE

release: test
	hub release create -m v$(version) v$(version)
