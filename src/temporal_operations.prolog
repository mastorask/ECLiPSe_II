% this file should include predicates
% for: 
%   - maximal_interval (~>) (already included)
%   - temporal union (union) (already included)
%   - temporal intersection (intersection)
%   - temporal difference (minus)


% maximal intervals
maximal_intervals([],_,[]).
maximal_intervals([S|STail], E, I):-
    maximal_intervals(S, STail, E, I).

maximal_intervals(Ts, _, [], [[Ts, inf]]).
maximal_intervals(Ts, S, [E|ETail], I) :-
    E =< Ts,!, maximal_intervals(Ts, S, ETail, I).
maximal_intervals(Ts, S, [E|ETail], I):-
    Ts < E, member(E, S),!, maximal_intervals(Ts, S, ETail, I).
maximal_intervals(Ts, S, [Te|ETail], [[Ts,Te]|I]):-
    Ts < Te, advance(S,Te,S1), maximal_intervals(S1, ETail, I).

advance([], _, []).
advance([X|T], Tc, [X|T]):- X >= Tc.
advance([X|T], Tc, L):- X < Tc, advance(T,Tc,L).

% temporal union
temporal_union(A,B,L):-
    merge_ilse(A,B,R),
    compute_union_intervals(R,0,0,_,L).

merge_ilse(A,B,R):-
    flatten_ilist(A, Af),
    flatten_ilist(B, Bf),
    merge_ilse2(Af,Bf, R).

flatten_ilist([],[]).
flatten_ilist([[A,B]|R],[(A,1,0),(B,0,1)|R1]):-
    flatten_ilist(R,R1).

merge_ilse2([],[],[]).
merge_ilse2([],[B|BR],[B|BR]).
merge_ilse2([A|AR],[],[A|AR]).

merge_ilse2([(T,Sa,Ea)|Atail], [(T,Sb,Eb)|BTail], [(T,S,E)|R]):-
   S is Sa + Sb,
   E is Ea + Eb,
   merge_ilse2(Atail, BTail, R).

merge_ilse2([(Ta,Sa,Ea)|Atail], [(Tb,Sb,Eb)|BTail], [(Ta,Sa,Ea)|R]):-
   Ta < Tb,
   merge_ilse2(Atail, [(Tb,Sb,Eb)|BTail], R).

merge_ilse2([(Ta,Sa,Ea)|Atail], [(Tb,Sb,Eb)|BTail], [(Tb,Sb,Eb)|R]):-
   Ta > Tb,
   merge_ilse2([(Ta,Sa,Ea)|Atail], BTail, R).


compute_union_intervals([],_,_,_,[]).
compute_union_intervals([(TS,SC,EC)|R], 0, E, _, IL):-
    SC > 0,
    EN is E+EC,
    compute_union_intervals(R, SC, EN, TS, IL).

compute_union_intervals([(TE,SC,EC)|R],S,E,TS,[[TS,TE]|IL]):-
    S \= 0,
    SN is S+SC,
    EN is E+EC,
    SN=EN,
    compute_union_intervals(R,0,0,_,IL).

compute_union_intervals([(_,SC,EC)|R],S,E,TS,IL):-
    S \= 0,
    SN is S+SC,
    EN is E+EC,
    SN\=EN,
    compute_union_intervals(R,SN,EN,TS,IL).
