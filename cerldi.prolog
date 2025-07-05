% operators of the language
:-['src/operators.prolog'].
% computation of an entity's level
:-['src/levels.prolog'].
% formulae transformation rules
:-['src/trasformations.prolog'].
% definitions preprocessing
:-['src/preprocessing.prolog'].
% implementation of temporal operations
:-['src/temporal_operations.prolog'].
% useful utilies
:-['src/utilities.prolog'].
% read from file, assert and retract events
:-['src/stream.prolog'].

:-dynamic t_entity/3, max_level/1, event/2, state/2, transformed_definition_conditions/3, definition_conditions/2.

% main loop
er(StreamFile, OutputFile, DefinitionsFile, Window, Step):-
    open(StreamFile, read, SF, [alias(inputstream)]),
    open(OutputFile, write, OF,[alias(resultsfile)]),
    write('Writing to resultsfile: '), write(OF), nl,
    compile(DefinitionsFile),
    consult(DefinitionsFile),
    preprocess_definitions,
    CurrentTime is Step,
    er_loop(CurrentTime, Window, Step),
    close(SF),
    close(OF).

er_loop(Tq, Window, Step):-
    assert_events(inputstream, Tq, EndOfFile),
    temporal_query,
    findall(_,(t_entity(X, event, user), event(X,T), writeln(resultsfile, event(X,T))), _),
    findall(_,(t_entity(X, state, user), state(X,T), writeln(resultsfile, state(X,T))), _),
    continue_er_loop(EndOfFile, Tq, Window, Step).

continue_er_loop(yes, _, _, _).
continue_er_loop(no, Tq, Window, Step):-
    Tq1 is Tq + Step,
    NextWindowStart is Tq1 - Window,
    forget_input_events(NextWindowStart),
    forget_output_entities,
    er_loop(Tq1, Window, Step).

% performs a temporal query at instant Tq, over stream with Alias
temporal_query:-
    write('Starting temporal_query'), nl,
    findall(_,
        (
            max_level(MaxLevel),
            write('MaxLevel: '), write(MaxLevel), nl,
            all_between(1, MaxLevel, Levels),
            member(Level, Levels),
            write('Processing Level: '), write(Level), nl,
            t_entity(X, _, user),
            level(X, Level),
            write('Processing entity: '), write(X), nl,
            process_entity(X)
        ),_).

% processes the entity X
process_entity(X):-
    t_entity(X, event, user),!,
    transformed_definition_conditions(X, YTr, C),
    write('Transformed conditions for event: '), write(YTr), write(' with C: '), write(C), nl,
    (   YTr -> 
            assert_if_not_exists(event(X,C)),
            write('Asserted event: '), write(event(X,C)), nl
    ;   write('Condition failed for event: '), write(X), nl
    ).

process_entity(X):-
    t_entity(X, state, user),!,
    transformed_definition_conditions(X, YTr, C),
    write('Transformed conditions for state: '), write(YTr), write(' with C: '), write(C), nl,
    (   YTr -> 
            assert_if_not_exists(state(X,C)),
            write('Asserted state: '), write(state(X,C)), nl
    ;   write('Condition failed for state: '), write(X), nl
    ).

forget_output_entities:-   
    findall(_,(t_entity(X,event,user), retractall(event(X,T))),_),
    findall(_,(t_entity(X,state,user), retractall(state(X,T))),_).