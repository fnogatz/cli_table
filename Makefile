.PHONY: all test

version := $(shell swipl -q -s pack -g 'version(V),writeln(V)' -t halt)
packfile = clitable-$(version).tgz

SWIPL := swipl

all:
	echo "clitable installed"

check:
	@$(SWIPL) -q -g 'use_module(library(clitable)),clitable([[successfully,installed]]),halt(0)' -t 'halt(1)'

test: check

package:
	tar cvzf $(packfile) prolog pack.pl README.md LICENSE

release:
	hub release create -m v$(version) v$(version)
