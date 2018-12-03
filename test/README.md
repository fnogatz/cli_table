# TAP Input/Output Test Suite

Definition of input/output tests for the `clitable` package following the [Test Anything Protocol](http://testanything.org/) (TAP).

## Run Tests

The defined tests can be run using the following command:

```shell
swipl -q -g main -t halt -s test.pl
```

This produces a TAP compatible output like the following:

```
TAP version 13
1..1
ok 1 - clitable([[a,bb,ccc], [111,22,3]])
```

The identifier is the tested call with the mentioned input data.

## Define Tests

In the file `tests.pl` new tests can be specified in the following form:

```prolog
clitable(Input) -> Expected.
```
