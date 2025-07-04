% cer ldi definition preprocessing

% term expansion: when loading a file that includes terms that match the first argument,
% term expansion if body is succesful asserts the second argument
% term_expansion(input_event_declaration(X), t_entity(X, event, input)).
% here for each definition we assert a definition_conditions\1 fact, as well as the type of the definition (t_entity) 
term_expansion(:=(event_def(X),Y), definition_conditions(X,Y)):- assert(t_entity(X, event, user)).
term_expansion(:=(state_def(X),Y), definition_conditions(X,Y)):- assert(t_entity(X, state, user)).
term_expansion(input_event_declaration(X), t_entity(X, event, input)).

:- dynamic t_entity/3.

% term_expansion((:- event_def X := Y), Clauses) :-
%     assert(t_entity(X, event, user)),
%     assert(definition_conditions(X, Y)),
%     Clauses = [].
% term_expansion((:- state_def X := Y), Clauses) :-
%     assert(t_entity(X, state, user)),
%     assert(definition_conditions(X, Y)),
%     Clauses = [].
% term_expansion((:- input_event_declaration(X)), Clauses) :-
%     assert(t_entity(X, event, input)),
%     Clauses = [].

% before running CER we need to preprocess definitions 
% and assert useful knowledge, for example here we assert the maximum level
% of definitions then we transform the definitions into executable prolog code.
% the predicate below does the above
preprocess_definitions:-
    assert_max_level, % preprocessing order
    transform_definitions. % transformation 

% finds and asserts the maximum level
% assert_max_level:-
%     findall(L, 
%         (
%             t_entity(X,_,_),
%             level(X,L)
%         ), Levels),
%     max_list(Levels, Max),
%     assert(max_level(Max)).

% assert_max_level :-
%     findall(L, (t_entity(X,_,_), level(X,L)), Levels),
%     max_list(Levels, MaxTemp),
%     max(0, MaxTemp, Max), % Ensure Max is at least 0
%     assert(max_level(Max)).

% finds and asserts the maximum level
assert_max_level :-
    findall(L, (t_entity(X,_,_), level(X,L)), Levels),
    (   Levels = [] -> MaxTemp = 0
    ;   max_list(Levels, MaxTemp)
    ),
    max(0, MaxTemp, Max),
    assert(max_level(Max)).

% transforms all definitions and asserts the transformed conditions
transform_definitions:-
    findall(_,
        (
            definition_conditions(X,Y),
            transform_conditions(X,Y,YTr,C),
            assert(transformed_definition_conditions(X,YTr,C))
        ),_).

% transformation for events
transform_conditions(X, Y, YTr, C):-
    t_entity(X, event, user),
    transform_instant_formula(Y,YTr,C).

% transformation for states
transform_conditions(X, Y, YTr, C):-
    t_entity(X, state, user),
    transform_durative_formula(Y,YTr,C).



