% -*- mode: prolog -*-

:- use_module(library(dcg/basics)).

%% Based on https://developers.google.com/protocol-buffers/docs/reference/proto3-spec

%% Utils

question(P, S, _) --> P, { S }.
question(P, _, F) --> [], { term_variables(P, V), maplist('='([]), V), F }.

question(P) --> question(P, true, true).

plus(P) --> { copy_term(P, R) }, R, !, (plus(P) | []).

plus(P, [H | T]) -->
    { copy_term(P, R) },
    call(R, H), !,
    (plus(P, T) | { T = [] }).

plus(P, D, [H | T]) -->
    { copy_term(P, R) },
    call(R, H), !,
    ((D, plus(P, D, T)) | { T = [] }).

acc(P, A, R) --> call(P, H), acc(P, A, T), { call(A, H, T, R) }.
acc(P, A, R) --> call(P, H), { call(A, H, [], R) }.

acc(P, D, A, R) --> call(P, H), D, acc(P, A, T), { call(A, H, T, R) }.
acc(P, _, A, R) --> call(P, H), { call(A, H, [], R) }.

star(P) --> (plus(P), ! | []).

star(P, X) --> plus(P, X), ! | { X = [] }.

star(P, D, X) --> plus(P, D, X), ! | { X = [] }.

choice([X | Xs]) --> X, ! | choice(Xs).
choice([X]) --> X.

choice([X | Xs], R) --> call(X, R), ! | choice(Xs, R).
choice([X], R) --> call(X, R).

%% Basic types

line_comment --> "//", string_without(`\n`, _), "\n".

not_slash --> [X], { not(X = 47) }.
multi_comment_body --> string_without(`*`, _).
multi_comment_body --> string_without(`*`, _), "*", not_slash, !, multi_comment_body.
multi_comment --> "/*", multi_comment_body, "*/".

must_blank --> blank, !, blanks.

proto_blanks --> star(choice([must_blank, line_comment, multi_comment])).

semicolon --> proto_blanks, ";", proto_blanks.
semicolon([]) --> proto_blanks, ";", proto_blanks.

comma --> proto_blanks, ",", proto_blanks.

identifier_head(H) --> [H], { code_type(H, csymf) }.
identifier_tail([H | T]) --> [H], { code_type(H, csym) }, !, identifier_tail(T).
identifier_tail([]) --> [].

identifier(I) -->
    identifier_head(H), !, identifier_tail(T),
    { string_codes(I, [H | T]) }.

octal_digit(O) --> [X], { O is X - 48, O < 8, O >= 0 }.

quote(39) --> "'".
quote(34) --> "\"".

escaped(92) --> "\\".
escaped(7) --> "a".
escaped(8) --> "b".
escaped(12) --> "f".
escaped(10) --> "n".
escaped(13) --> "r".
escaped(9) --> "t".
escaped(11) --> "v".
escaped(X) --> ("x" | "X"), xdigit(A), xdigit(B), { X is A * 16 + B }.
escaped(O) -->
    octal_digit(A),
    octal_digit(B),
    octal_digit(C),
    { O is A * 64 + B * 8 + C }.

string_content([E | T], Q) -->
    "\\", escaped(E), !,
    string_content(T, Q).
string_content([Q | T], Q) -->
    "\\", [Q], !,
    string_content(T, Q).
string_content([H | T], Q) -->
    [H],
    { not(member(H, [Q, 92, 10, 0])) }, !,
    string_content(T, Q).
string_content([], _) --> [].

string_literal(S) -->
    quote(Q),
    string_content(I, Q),
    quote(Q),
    { string_codes(S, I) }.

boolean(true) --> "true".
boolean(false) --> "false".

int_literal(I) --> integer(I) | octal_int(I) | hex_int(I).

literal(L) --> string_literal(L) | int_literal(L) | boolean(L).

delimited(A, P, B) --> A, proto_blanks, P, proto_blanks, B.

block(P) --> delimited("{", P, "}").
parens(P) --> delimited("(", P, ")").
brakets(P) --> delimited("[", P, "]").

with_blanks([P | Ps]) --> { not(Ps = []) }, P, !, proto_blanks, with_blanks(Ps).
with_blanks([P]) --> P.

named(N, P, R) -->
    N, proto_blanks,
    { term_variables(P, V) },
    P, proto_blanks, ";",
    { atom_string(A, N), R =.. [A | V] }.

user_defined_type(type(T)) --> ("." | []), plus(identifier, ".", T).


%% Type

built_in_type(type(double))   --> "double".
built_in_type(type(float))    --> "float".
built_in_type(type(int32))    --> "int32".
built_in_type(type(int64))    --> "int64".
built_in_type(type(uint32))   --> "uint32".
built_in_type(type(uint64))   --> "uint64".
built_in_type(type(sint32))   --> "sint32".
built_in_type(type(fixed32))  --> "fixed32".
built_in_type(type(fixed64))  --> "fixed64".
built_in_type(type(sfixed32)) --> "sfixed32".
built_in_type(type(bool))     --> "bool".
built_in_type(type(string))   --> "string".
built_in_type(type(bytes))    --> "bytes".

built_ins(["double",
           "float",
           "int32",
           "int64",
           "uint32",
           "uint64",
           "sint32",
           "fixed32",
           "fixed64",
           "sfixed32",
           "bool",
           "string",
           "bytes"]).

not_built_in_type(type([X | Xs])) :-
    ( built_ins(B),
      not(member(X, B)) )
    ;
    not(Xs = []).

type(X) --> built_in_type(X) | user_defined_type(X), { not_built_in_type(X) }.

octal_carry(H, [], H) :- !.
octal_carry(H, T, D) :- D is T * 8 + H.
octal_digits(D) --> acc(octal_digit, octal_carry, D).
octal_int(I) --> "0", octal_digits(I).

hex_int(I) --> ("x" | "X"), xdigits(I).

%% Package

package_name(N) --> plus(identifier, ".", N).

package(P) --> named("package", package_name(_), P).

%% Import

import_kind([weak]) --> "weak".
import_kind([public]) --> "public".

import_body(M, I) -->
    question(import_kind(M)),
    proto_blanks,
    string_literal(I).

import(I) --> named("import", import_body(_, _), I).

%% Syntax

syntax_body(S) --> "=", proto_blanks, string_literal(S).
syntax(S) --> named("syntax", syntax_body(_), S).

%% Option

option_name(name(P, N)) -->
    parens(plus(identifier, ".", P)),
    ((".", proto_blanks, plus(identifier, ".", N)) | { N = [] }).
option_name(name([], N)) --> plus(identifier, ".", N).

option_def(O) -->
    named("option", with_blanks([option_name(_), "=", literal(_)]), O).

%% Field

field_options(O) --> brakets(star(assignment, comma, O)).

field_label([required]) --> "required", !.
field_label([repeated]) --> "repeated", !.
field_label([optional]) --> "optional", !.
field_label([]) --> [].

field(field(R, T, N, I, O)) -->
    with_blanks(
        [
            field_label(R),
            type(T),
            identifier(N),
            "=",
            integer(I),
            question(field_options(O)),
            ";"
        ]).

%% Oneof

oneof_field(field(T, N, I, O)) -->
    with_blanks(
        [
            type(T),
            identifier(N),
            "=",
            integer(I),
            question(field_options(O)),
            ";"
        ]).

oneof(oneof(N, O)) -->
    with_blanks(
        [
            "oneof",
            identifier(N),
            block(star(choice([oneof_field, semicolon]), proto_blanks, O))
        ]).


%% Map field

key_type(type(int32))    --> "int32".
key_type(type(int64))    --> "int64".
key_type(type(uint32))   --> "uint32".
key_type(type(uint64))   --> "uint64".
key_type(type(sint32))   --> "sint32".
key_type(type(sint64))   --> "sint64".
key_type(type(fixed32))  --> "fixed32".
key_type(type(fixed64))  --> "fixed64".
key_type(type(sfixed32)) --> "sfixed32".
key_type(type(sfixed64)) --> "sfixed64".
key_type(type(bool))     --> "bool".
key_type(type(string))   --> "string".

map_field(field(false, [T, V], N, I, O)) -->
    with_blanks(
        [
            "map",
            "<",
            key_type(T),
            ",",
            type(V),
            ">",
            identifier(N),
            "=",
            integer(I),
            question(field_options(O)),
            ";"
        ]).

%% Reserved

range(From-To) -->
    integer(From), proto_blanks,
    "to", proto_blanks, !,
    ("max" , {To = max} | integer(To)).
range(From-From) --> integer(From).

ranges(ranges(R)) --> plus(range, comma, R).

reversed_body(R) --> ranges(R) | plus(string_literal, comma, R).
reserved(R) --> named("reserved", reversed_body(_), R).

%% Enum

enum_option(option(N, V)) -->
    with_blanks(["option", option_name(N), "=", literal(V)]).

enum_value_option(value(N, C)) -->
    with_blanks([option_name(N), "=", literal(C)]).

enum_field(field(N, I, V)) -->
    with_blanks(
        [
            identifier(N),
            "=",
            integer(I),
            question(brakets(star(enum_value_option, comma, V)))
        ]).

enum_body(B) -->
    star(choice([enum_option, enum_field, semicolon]), semicolon, B),
    semicolon.

enum(enum(N, B)) -->
    with_blanks(
        [
            "enum",
            identifier(N),
            block(enum_body(B))
        ]).

%% Extensions

extensions(extensions(From, To)) -->
    with_blanks(
        [
            "extensions",
            range(From-To)
        ]).

%% Message

message_block(B) -->
    star(
        choice(
            [
                enum,
                message,
                option_def,
                oneof,
                map_field,
                field,
                reserved,
                extensions,
                semicolon
            ]
        ),
        proto_blanks,
        B).

message(message(N, M)) -->
    with_blanks(
        [
            "message",
            identifier(N),
            block(message_block(M))
        ]).

%% Service

rpc_type(T) --> question("stream"), proto_blanks, type(T).

rpc_options(options([])) --> ";".
rpc_options(options(O)) -->
    block(plus(choice([option_def, semicolon]), O)).

rpc(rpc(N, IT, OT, V)) -->
    with_blanks(
        [
            "rpc",
            identifier(N),
            parens(rpc_type(IT)),
            "returns",
            parens(rpc_type(OT)),
            rpc_options(V)
        ]).

service(service(N, S)) -->
    with_blanks(
        [
            "service",
            identifier(N),
            block(star(choice([option_def, rpc, semicolon]), S))
        ]).

%% Proto

proto(proto(S, D)) -->
    proto_blanks,
    syntax(S), proto_blanks,
    star(
        choice(
            [
                import,
                package,
                option_def,
                message,
                enum,
                service
            ]
        ),
        proto_blanks,
        D
    ),
    proto_blanks.
