:-['./operators.prolog'].
% transformation rules for language ldi
% needs to be completed for all language operators

transform_instant_formula(and(X,Y), Transformed, T):-!,
  transform_instant_formula(X, XTr, T),
  transform_instant_formula(Y, YTr, T),
  Transformed = (
    XTr, YTr
  ).


% needs modification...
transform_durative_formula(~>(L,R), Transformed, I):- fail.


