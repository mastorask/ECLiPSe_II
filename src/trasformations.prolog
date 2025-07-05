%:-['./operators.prolog'].
% transformation rules for language ldi
% needs to be completed for all language operators

% transform_instant_formula(and(X,Y), Transformed, T):-!,
%   transform_instant_formula(X, XTr, T),
%   transform_instant_formula(Y, YTr, T),
%   Transformed = (
%     XTr, YTr
%   ).

% transformation rules for language ldi
transform_instant_formula(and(X,Y), Transformed, T):-!,
    transform_instant_formula(X, XTr, T),
    transform_instant_formula(Y, YTr, T),
    Transformed = (XTr, YTr).

transform_instant_formula(X, event(X,T), T) :- 
    t_entity(X, event, input), 
    write('Base case for instant: '), write(X), write(' at T: '), write(T), nl.

% needs modification...
%transform_durative_formula(~>(L,R), Transformed, I):- fail.

% transform_durative_formula(~>(L, R), Transformed, [Ts, Te]) :-
%     transform_instant_formula(L, LTr, Ts),
%     transform_instant_formula(R, RTr, Te),
%     Transformed = (LTr, RTr, Ts < Te, maximal_intervals([Ts], [Te], Intervals), member([Ts, Te], Intervals)).

% durative formula transformation
transform_durative_formula(~>(L, R), Transformed, [Ts, Te]) :-
    transform_instant_formula(L, LTr, Ts),
    transform_instant_formula(R, RTr, Te),
    Transformed = (LTr, RTr, Ts < Te, maximal_intervals([Ts], [Te], Intervals), member([Ts, Te], Intervals)).
