:- encoding(utf8).
:- module(cli_table, [
    cli_table/1,
    cli_table/2
  ]).

cli_table(Rows) :-
  cli_table(Rows, []).

cli_table(Rows, Options) :-
  transpose(Rows, Cols),
  add_headers_to_cols(Options, Cols, Cols_),
  maplist(get_col_width, Cols_, ColWidths),
  default_options(Default_Options),
  merge_options(Options, Default_Options, Options_),
  cli_table(Rows, Options_, ColWidths).

cli_table(Rows, Options, ColWidths) :-
  print_header(Options, ColWidths),
  forall(
    member(Row, Rows),
    print_row(Options, Row, ColWidths)
  ),
  print_footer(Options, ColWidths).

default_options(Default_Options) :-
  Default_Options = [
    top('═'), top_left('╔'), top_mid('╤'), top_right('╗'),
    bottom('═'), bottom_left('╚'), bottom_mid('╧'), bottom_right('╝'),
    space(' '), left('║'), mid('│'), right('║'),
    mid_space('─'), mid_left('╟'), mid_mid('┼'), mid_right('╢')
  ].

add_headers_to_cols(Options, Cols, Cols_With_Headers) :-
  ( option(head(Header), Options) ->
    maplist(add_header_to_col, Cols, Header, Cols_With_Headers)
  ; Cols_With_Headers = Cols ).

add_header_to_col(Col, Header, [Header|Col]).

print_header(Options, ColWidths) :-
  print_char_row(Options, ColWidths, [top, top_left, top_mid, top_right]),
  ( option(head(Header), Options) ->
    print_row(Options, Header, ColWidths),
    print_char_row(Options, ColWidths, [mid_space, mid_left, mid_mid, mid_right])
  ; true ).

print_footer(Options, ColWidths) :-
  print_char_row(Options, ColWidths, [bottom, bottom_left, bottom_mid, bottom_right]).

print_char_row(Options, ColWidths, Identifiers) :-
  maplist(option_char(Options), Identifiers, [Space, Left, Mid, Right]),
  option(space(OriginalSpace), Options),
  atom_length(OriginalSpace, OriginalSpace_Length),
  apply_length(OriginalSpace_Length, Space, Space_),
  merge_options([space(Space_), left(Left), mid(Mid), right(Right)], Options, Char_Row_Options),
  maplist(mock_cell(Space), ColWidths, CellMocks),
  print_row(Char_Row_Options, CellMocks, ColWidths).

apply_length(Length, Space, Space_With_Length) :-
  atom_length(Space, 0), !,
  apply_length(Length, ' ', Space_With_Length).
apply_length(Length, Space, Space_With_Length) :-
  atomic_list_concat(['~`', Space, 't~', Length, '|'], Format),
  format(atom(Space_With_Length), Format, []).

option_char(Options, Option, Char) :-
  KV =.. [Option, Char],
  option(KV, Options).

print_row(Options, [First|Cells], [FirstWidth|ColWidths]) :-
  print_first_cell(Options, First, FirstWidth),
  maplist(print_cell(Options), Cells, ColWidths),
  option(right(Char), Options),
  write(Char),
  nl.

print_first_cell(Options, Cell, ColWidth) :-
  option(left(Char), Options),
  merge_options([mid(Char)], Options, Options_For_First),
  print_cell(Options_For_First, Cell, ColWidth).

print_cell(Options, Cell, ColWidth) :-
  option(space(Space), Options),
  option(mid(Middle), Options),
  Width is ColWidth,
  Center = '~t~w~t',
  atomic_list_concat([Center, '~', Width, '|'], Format),
  format(atom(Entry), Format, [ Cell ]),
  atomic_list_concat([Middle, Space, Entry, Space], Result),
  write(Result).

get_col_width(Cells, MaxWidth) :-
  maplist(get_cell_width, Cells, CellWidths),
  max_list(CellWidths, MaxWidth).

get_cell_width(Cell, Width) :-
  atom_length(Cell, Width).

mock_cell(_Char, 0, '') :- !.
mock_cell(Char, N, A) :-
  N_ is N-1,
  mock_cell(Char, N_, A_),
  atomic_concat(Char, A_, A).

transpose([], []).
transpose([L|Ls], Ts) :-
  maplist(same_length(L), Ls),
  foldl(transpose_, L, Ts, [L|Ls], _).

transpose_(_, Fs, Lists0, Lists) :-
  maplist(list_first_rest, Lists0, Fs, Lists).

list_first_rest([L|Ls], L, Ls).
