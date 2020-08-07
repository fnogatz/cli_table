:- asserta(user:file_search_path(library, 'prolog')).

:- use_module(library(cli_table)).

% 10 is newline character
term_expansion(Callable -> [10|Expected], (Head :- Test)) :-
  format(atom(Head), '~w', [Callable]),
  Test = (
    with_output_to(codes(Actual), Callable), !,
    Actual = Expected
  ),
  tap:register_test(Head).

:- use_module(library(tap)).
:- [ 'tests.pl' ].
