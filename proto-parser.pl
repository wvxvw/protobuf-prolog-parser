% -*- mode: prolog -*-

:- [parser].
:- use_module(library(readutil)).

main([_Self, File]) :-
    !,
    format('Parsing: ~w~n', [File]),
    %% read_file_to_codes(File, S, []),
    %% phrase(proto(P), S, Y),
    %% string_codes(C, Y),
    %% length(Y, L),
    %% format('failed to parse: "~w"/~w~n', [C, L]),
    phrase_from_file(proto(P), File),
    format('~w~n', [P]).

main(_) :-
    format('Call this program with Proto file as an argument.~n').
