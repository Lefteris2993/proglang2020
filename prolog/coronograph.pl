:- use_module(library(assoc)).
:- use_module(library(ordsets)).

emptyGraph(G , 0, G) :- !.
emptyGraph(Gin ,N, G) :-
    N > 0,
    put_assoc(N, Gin, [], Gout),
    N1 is N - 1,
    emptyGraph(Gout, N1, G), !.
    
createGraph(N, L, G) :-
    N > 0,
    emptyGraph(t, N, Empt),
    createGraph_(Empt, L, G), !.

createGraph_(Gavl, [], Gavl) :- !.
createGraph_(Avl ,[A, B| C], Gavl) :-
    get_assoc(A, Avl, Value1, TempA1, TempV1),
    append(Value1, [B], T1),
    list_to_ord_set(T1, TempV1),
    get_assoc(B, TempA1, Value2, TempA2, TempV2),
    append(Value2, [A], T2),
    list_to_ord_set(T2, TempV2),    
    createGraph_(TempA2, C, Gavl), !.

createStack_(_, [], Stack, Stack) :- !.
createStack_(Prev , [A |L], Stack, NewStack) :-
    createStack_(Prev, L, [A, Prev |Stack], NewStack), !.

stackAcces_([A, B |_], A, B) :- !.

cutUntil_(_, [], []) :- !.
cutUntil_(A, [A |L], [A |L]) :- !.
cutUntil_(A, [B |L], NewL) :-
    A \== B,
    cutUntil_(A, L, NewL), !.

editPath_(A, A, _, Path, [A |Path]) :- !.
editPath_(Cur, NewCur, NewPrev, Path, NewPath) :-
    Cur \== NewCur,
    cutUntil_(NewPrev, Path, Temp),
    append([NewCur], Temp, NewPath), !.


traversal(_, [], _, _, _, Count, [], Count) :- !.
traversal(_, [Cur, _ |_], Visited, L, BackEdges, _, L, 0) :-
    BackEdges \== 1,
    get_assoc(Cur, Visited, _), !.
traversal(Gavl, [Cur, Prev |StackTl], Visited, L, BackEdges, Count, Path, Num) :-
    BackEdges \== 1,
    \+get_assoc(Cur, Visited, _),
    put_assoc(Cur, Visited, [], NewVisited),
    get_assoc(Cur, Gavl, Adj),
    delete(Adj, Prev, FilteredAdj),
    createStack_(Cur, FilteredAdj, StackTl, NewStack),
    (NewStack == [] -> NewCur is 42; stackAcces_(NewStack, NewCur, _)),
    (NewStack == [] -> NewPrev is 17; stackAcces_(NewStack, _, NewPrev)),
    editPath_(Cur, NewCur, NewPrev, L, NewL),
    NewCount is Count + 1,
    traversal(Gavl, NewStack, NewVisited, NewL, 0, NewCount, Path, Num), !.

findCyrcleHelp_(Hd, [Hd |_], Cyrcle, Cyrcle) :- !.
findCyrcleHelp_(Hd, [A |Path], Acc, Cyrcle) :-
    Hd \== A,
    findCyrcleHelp_(Hd, Path, [A |Acc], Cyrcle), !.

findCyrcle(Gavl, Cyrcle, Hd) :-
    empty_assoc(A),
    traversal(Gavl, [1, 0], A, [1], 0, 1, [Hd |Path], _),
    findCyrcleHelp_(Hd, Path, [Hd], Cyrcle), !.
    

countConnectedNodes(Ver, Gavl, Num, A, B) :-
    get_assoc(Ver, Gavl, TempAdj),
    delete(TempAdj, A, Temp),
    delete(Temp, B, Adj),
    createStack_(Ver, Adj, [], Stack),
    empty_assoc(E),
    traversal(Gavl, Stack, E, [Ver], 0, 1, _, Num), !.

sum([],0) :- !.
sum([Head|Tail],Sum) :-
    sum(Tail,TailSum),
    Sum is Head + TailSum, !.

read_input(File, N, C) :-
    open(File, read, Stream),
    read_couple(Stream, N),
    read_help(Stream, N, C), !.

read_help(_, 0, []) :- !.
read_help(Stream, Iterator, C):-
    read_couple(Stream, [N, E]),
    NewIterator is Iterator - 1,
    read_Nlines(Stream, E, B),
    append([N, E, B],D, C),
    read_help(Stream, NewIterator, D), !.

read_Nlines(_, 0, []) :- !.
read_Nlines(Stream, Iterator, C):-
    read_couple(Stream, A),
    NewIterator is Iterator - 1,
    read_Nlines(Stream, NewIterator, B),
    append(A,B,C), !.

read_couple(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L), !.


trees(Path, Last, Gavl, L) :-
    %%write(ep),
    trees_(Path, Path, Gavl, [], Temp, 42, Last),
    sort(0, @=<, Temp, L), !.

trees_([Last |_], _, _, Result, Result, _, Last) :-
    %%write(ti),
    !.
trees_([A, Last], [C |Path], Gavl, L, Result, _, Last) :-
    %%write(kaneis),
    countConnectedNodes(Last, Gavl, Num, A, C),
    append(L,[Num], L1),
    trees_([Last], Path, Gavl, L1, Result, _, Last), !.
trees_([A, B, C |Rest], Path, Gavl, L, Result, 42, Last) :- 
    %%write(esu),
    countConnectedNodes(A, Gavl, Num, B, Last),
    append(L, [Num], L1),
    trees_([A, B, C |Rest], Path, Gavl, L1, Result, 17, Last), !.
trees_([A, B, C |Rest], Path, Gavl, L, Result, 17, Last) :- 
    %%write(edo),
    countConnectedNodes(B, Gavl, Num, A, C),
    append(L, [Num], L1),
    trees_([B, C |Rest], Path, Gavl, L1, Result, 17, Last), !.

solve_([N,E,_], ['''NO CORONA''']) :-
    N \== E, !.
solve_([N, N, Adj], [[CyrcleLength, Nums]]) :-
    %writeln(1),
    createGraph(N, Adj, Graph),
    %writeln(2),
    findCyrcle(Graph, Cyrcle, Last),
    %writeln([ep ,Cyrcle, Last]),
    trees(Cyrcle, Last, Graph, Nums),
    %writeln(4),
    sum(Nums, Sum),
    Sum == N,
    length(Cyrcle, CyrcleLength), !.
solve_([_, _, _], ['''NO CORONA''']) :- !.

solve([],Result, Result) :- !.
solve([A, B, C |D], Acc, Result) :-
    once(solve_([A, B, C], Res)),
    append(Acc, Res, NewAcc),
    solve(D, NewAcc, Result), !.

coronograph(File, A) :-
    read_input(File, _, C),
    once(solve(C, [], A)), !, !.
