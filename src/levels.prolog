% given the name of an event/state (X), 
% level should return the level of X
% e.g. an event that depends only on 
% input events should have level 0

% Input events have level 0
level(X, 0) :-
    t_entity(X, event, input), !.

% User-defined events: level is max of dependencies + 1
level(X, L) :-
    t_entity(X, event, user),
    definition_conditions(X, Y),
    findall(LD, (
        subterm(Y, D),
        t_entity(D, _, _),
        level(D, LD)
    ), Levels),
    max_list(Levels, Max),
    L is Max + 1, !.

% States: level is max of dependencies + 1
level(X, L) :-
    t_entity(X, state, user),
    definition_conditions(X, Y),
    findall(LD, (
        subterm(Y, D),
        t_entity(D, _, _),
        level(D, LD)
    ), Levels),
    max_list(Levels, Max),
    L is Max + 1.

% Extract subterms from a formula
subterm(and(X, Y), Sub) :- !, (subterm(X, Sub) ; subterm(Y, Sub)).
subterm(union(X, Y), Sub) :- !, (subterm(X, Sub) ; subterm(Y, Sub)).
subterm(intersection(X, Y), Sub) :- !, (subterm(X, Sub) ; subterm(Y, Sub)).
subterm(min(X, Y), Sub) :- !, (subterm(X, Sub) ; subterm(Y, Sub)).
subterm(~>(X, Y), Sub) :- !, (subterm(X, Sub) ; subterm(Y, Sub)).
subterm(tnot(X), Sub) :- !, subterm(X, Sub).
subterm(X, X) :- atomic(X), t_entity(X, _, _).