
my_max(X,Y,X):-X>=Y,!.
my_max(_,Y,Y).

max_list([X|Xs], Max) :- max_list(Xs, X, Max).
max_list([], Max, Max).
max_list([X|Xs], CurrentMax, Max) :-
    my_max(X, CurrentMax, NewMax),
    max_list(Xs, NewMax, Max).

all_between(Min,Max,L):- findall(X, between(Min, Max, X), L).

assert_if_not_exists(X):-
    X-> true ; assertz(X).
