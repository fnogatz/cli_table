# CLI Table

Pretty unicode tables for the CLI with Prolog.

## Installation

This pack is available from the [add-on registry of SWI-Prolog](http://www.swi-prolog.org/pack/list).

It can be installed with `pack_install/1`:

```prolog
?- pack_install(clitable).
```

Only for development purposes [`library(tap)`](https://github.com/fnogatz/tap) is required. It can be installed by calling `?- pack_install(tap).` from within SWI-Prolog.

## Usage

This module exports the two predicates `clitable(+Data)` and `clitable(+Data,+Options)`.

```prolog
:- use_module(library(clitable)).
?- Data = [[a,bb,ccc], [111,22,3]],
   clitable(Data).
╔═════╤════╤═════╗
║  a  │ bb │ ccc ║
║ 111 │ 22 │  3  ║
╚═════╧════╧═════╝

?- Data = [[a,bb,ccc], [111,22,3]],
   Head = ['First', 'Second', 'Third'],
   clitable(Data, [head(Head)]).
╔═══════╤════════╤═══════╗
║ First │ Second │ Third ║
╟───────┼────────┼───────╢
║   a   │   bb   │  ccc  ║
║  111  │   22   │   3   ║
╚═══════╧════════╧═══════╝
```

## Custom Styles

The style can be changed by setting the appropriate chars in the `Options` list. The following defaults can be overridden by specifying the corresponding options:

```prolog
top('═'), top_left('╔'), top_mid('╤'), top_right('╗'),
bottom('═'), bottom_left('╚'), bottom_mid('╧'), bottom_right('╝'),
space(' '), left('║'), mid('│'), right('║'),
mid_space('─'), mid_left('╟'), mid_mid('┼'), mid_right('╢')
```
