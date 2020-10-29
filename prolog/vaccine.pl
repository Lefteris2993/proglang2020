empty(queue([],[])).
add(A,queue(X,Y),queue(X,[A|Y])).
remove(queue([],Z),A,queue(X,[])) :- reverse(Z,[A|X]).
remove(queue([A|T],X),A,queue(T,X)).

read_input(File, N, C) :-
    open(File, read, Stream),
    read_line(Stream, N),
    read_rest(Stream, N, C).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

read_rest(_, [0], []):- !.
read_rest(Stream, [N], C):-
    read_string(Stream, "\n", "\r", _, String),
    string_chars(String, List),
    N1 is N - 1,
    read_rest(Stream, [N1], C1),
    append([List], C1, C).

bfs((_, [], _, _, RET, _, _, _, _, _, _),_, RET).
bfs((Comp, [H|T], Head, Tail, Res, Prev1, Prev2, A, U, G, C),Queue, RET):-
    (Comp == 1 -> 
        ((H == 'A' -> Cur = 'U');
        (H == 'U' -> Cur = 'A');
        (H == 'G' -> Cur = 'C');
        (H == 'C' -> Cur = 'G'));
        Cur = H),
            
    (Prev1 == 'p' ->
        NC is Comp * -1,
        add((NC, [H|T], Head, Tail, ['c'|Res], 'c', Prev1, A, U, G, C), Queue, Q1)
    ;Q1 = Queue),
    
    ((Head == Cur ; ((Cur == 'A' , A == 0) ; (Cur == 'U' , U == 0) ; (Cur == 'G' , G == 0) ; (Cur == 'C' , C == 0))) -> 
        ((Cur == 'A' -> A1 is 1, U1 is U, G1 is G, C1 is C);
        (Cur == 'U' -> A1 is A, U1 is 1, G1 is G, C1 is C);
        (Cur == 'G' -> A1 is A, U1 is U, G1 is 1, C1 is C);
        (Cur == 'C' -> A1 is A, U1 is U, G1 is G, C1 is 1)),
        add((Comp, T, Cur, Tail, ['p'|Res], 'p', Prev1, A1,U1, G1, C1), Q1, Q2)
    ;Q2 = Q1),

    (Prev1 \== 'r', \+ ((Prev1 == 'r', Prev2 == 'c') ; (Prev1 == 'c', Prev2 == 'r')) ->
        add((Comp, [H|T], Tail, Head, ['r'|Res], 'r', Prev1, A, U, G, C), Q2, Q3)
    ;Q3 = Q2),

    remove(Q3, Next, Q4),
    bfs(Next, Q4, RET).

solve([], []).
solve([H|T], A):-
    reverse(H, [First|Hrev]),
    ((First == 'A' -> A1 is 1, U1 is 0, G1 is 0, C1 is 0);
    (First == 'U' -> A1 is 0, U1 is 1, G1 is 0, C1 is 0);
    (First == 'G' -> A1 is 0, U1 is 0, G1 is 1, C1 is 0);
    (First == 'C' -> A1 is 0, U1 is 0, G1 is 0, C1 is 1)),
    empty(Queue),
    bfs((-1, Hrev, First, First, ['p'], 'p', 'Z', A1, U1, G1, C1), Queue,RET),
    solve(T, NewA),
    reverse(RET, RETT), 
    string_chars(S, RETT),
    
    append([S], NewA, A).   

vaccine(File, A):-
    read_input(File, _, C),
    solve(C, A).
