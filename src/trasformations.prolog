%:-['./operators.prolog'].
% transformation rules for language ldi
% needs to be completed for all language operators

transform_instant_formula(and(X,Y), Transformed, T):-!,
  transform_instant_formula(X, XTr, T),
  transform_instant_formula(Y, YTr, T),
  Transformed = (
    XTr, YTr
  ).


% needs modification...
%transform_durative_formula(~>(L,R), Transformed, I):- fail.

transform_durative_formula(~>(L, R), Transformed, [Ts, Te]) :-
    transform_instant_formula(L, LTr, Ts),
    transform_instant_formula(R, RTr, Te),
    Transformed = (LTr, RTr, Ts < Te, maximal_intervals([Ts], [Te], Intervals), member([Ts, Te], Intervals)).
