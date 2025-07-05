% cer ldi definition preprocessing

% term expansion: when loading a file that includes terms that match the first argument,
% term expansion if body is successful asserts the second argument
term_expansion(:=(event_def(X),Y), definition_conditions(X,Y)):- assert(t_entity(X, event, user)).
term_expansion(:=(state_def(X),Y), definition_conditions(X,Y)):- assert(t_entity(X, state, user)).
term_expansion(input_event_declaration(X), t_entity(X, event, input)).

:- dynamic t_entity/3.

% before running CER we need to preprocess definitions 
% and assert useful knowledge, for example here we assert the maximum level
% of definitions then we transform the definitions into executable prolog code.
preprocess_definitions:-
    write('Starting preprocess_definitions'), nl,
    assert_max_level, % preprocessing order
    transform_definitions. % transformation 

% finds and asserts the maximum level
assert_max_level :-
    findall(L, (t_entity(X,_,_), level(X,L)), Levels),
    (   Levels = [] -> MaxTemp = 0
    ;   max_list(Levels, MaxTemp)
    ),
    max(0, MaxTemp, Max),
    write('Asserting max_level: '), write(Max), nl,
    assert(max_level(Max)).

% transforms all definitions and asserts the transformed conditions
transform_definitions:-
    write('Starting transform_definitions'), nl,
    findall(_,
        (
            definition_conditions(X,Y),
            write('Transforming: '), write(X), write(' := '), write(Y), nl,
            transform_conditions(X,Y,YTr,C),
            write('Transformed to: '), write(YTr), write(' with C: '), write(C), nl,
            assert(transformed_definition_conditions(X,YTr,C))
        ),_).

% transformation for events
transform_conditions(X, Y, YTr, C):-
    t_entity(X, event, user),
    write('Transforming event: '), write(X), nl,
    transform_instant_formula(Y,YTr,C).

% transformation for states
transform_conditions(X, Y, YTr, C):-
    t_entity(X, state, user),
    write('Transforming state: '), write(X), nl,
    transform_durative_formula(Y,YTr,C).