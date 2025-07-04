% asserts a event from a stream with alias Alias until instant T
% e.g., the stream could have been opened with:
%    open('./beers.input', read, _, [alias(beerinput)]).
%
assert_events(Alias, T, EndOfFile):-
    % get_stream(IFd, Alias),
    % get_stream_info(IFd, position, Position),
    write('assert_events called with Alias: '), write(Alias), write(' at T: '), write(T), nl,
    stream_property(IFd, alias(Alias)),
    stream_property(IFd, position(Position)),
    read_string(IFd, "\n", "\r", Sep, String), 
    write('Read string: '), write(String), nl,
    assert_events2(IFd, T, Sep, Position, String, EndOfFile).

assert_events2(_IFd, _T, -1, _Position, _String, yes).
assert_events2(IFd, T, Sep, Position, String, no):-
    Sep \= -1,
    term_string(event(_,T1), String),
    T1 > T, 
    set_stream_position(IFd, Position).

assert_events2(IFd, T, PrevSep, _PrevPosition, PrevString, EndOfFile):-
    PrevSep \= -1,
    term_string(event(E,T1), PrevString),
    T1 =< T, 
    assert(event(E,T1)),
    % get_stream_info(IFd, position, Position),
    stream_property(IFd, position(Position)),
    read_string(IFd, "\n", "\r", Sep, String), 
    assert_events2(IFd, T, Sep, Position, String, EndOfFile).

% forgets all event up to instant T
forget_input_events(T):-
    findall(_, (
                event(E,T1), \+t_entity(E,_,user), T1 =< T, retract(event(E, T1))
            ),_).
