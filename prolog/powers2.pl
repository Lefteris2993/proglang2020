:- use_module(library(clpfd)).
/*
 * A predicate that reads the input from File and returns it in
 * the last three arguments: N, K and C.
 * Example:
 *
 * ?- read_input('c1.txt', N, K, C).
 * N = 10,
 * K = 3,
 * C = [1, 3, 1, 3, 1, 3, 3, 2, 2|...].
 */
read_input(File, C) :-
    open(File, read, Stream),
    read_couple(Stream, N),
    read_help(Stream, N, C), !.

read_help(_, 0, []).
read_help(Stream, Iterator, C):-
    read_couple(Stream, A),
    NewIterator is Iterator - 1,
    read_help(Stream, NewIterator, B),
    append(A,B,C).

read_couple(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

%https://stackoverflow.com/questions/27788739/binary-to-decimal-prolog
binary_number(Bits, N) :- 
    binary_number_min(Bits, 0,N, N), !.

binary_number_min([], N,N, _M). 
binary_number_min([Bit|Bits], N0,N, M) :-
    Bit in 0..1,
    N1 #= N0*2 + Bit,
    M #>= N1,
    binary_number_min(Bits, N1,N, M).

sum([],0).
sum([Head|Tail],Sum) :-
    sum(Tail,TailSum),
    Sum is Head + TailSum.

listPP(L1, [0|L2], Res):-
    listPP([0|L1], L2, Res).
listPP([A|L1], [N|L2], Res):-
    N =\= 0,
    B is A + 2,
    Z is N - 1,
    reverse([B|L1], C),
    append(C,[Z|L2], Res), !.
listPP(_,[],[]).

the_thing(L, 0, L).
the_thing([A|L], I, B) :-
    I > -1,
    J is I - 1,
    listPP([A], L, Ret),
    the_thing(Ret, J, B), !.
the_thing(_,I,[]) :-
    I < 0.

remove_zeroes([A|L], [A|L]) :-
    A =\= 0, !.
remove_zeroes([0|L], Ret) :-
    remove_zeroes(L, Ret).
remove_zeroes([],[]).

solve([], []).
solve([M,K|L], ACC) :-
    binary_number(Bits, M),
    sum(Bits, Ones),
    K1 is K - Ones,
    reverse(Bits, BBis),
    the_thing(BBis, K1, Res),
    reverse(Res, BBBis),
    remove_zeroes(BBBis, Ret),
    reverse(Ret, RRet),
    append([RRet],B,ACC),
    solve(L, B).

powers2(File, A) :-
    read_input(File, L),
    once(solve(L, A)).
