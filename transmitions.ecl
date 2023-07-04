%%% Coursework 2 2022-2023
%% Libraries
:-lib(ic).
:-lib(ic_global).
:-lib(branch_and_bound).
:-lib(ic_edge_finder).
:-lib(listut).

%% Data for Exec 2
%% transmit(ID,Duration,Bandwidth,Cost)
transmit(1,10,140,23).
transmit(2,8, 190,33).
transmit(3,5, 240,12).
transmit(4,13,110,10).
transmit(5,15,130,70).
transmit(6,25,140,60).
transmit(7,10,20,90).

not_broadcasted_together([vid(1,2), vid(3,5)]).

% broadcast(Starts,Cost)/2
broadcast(Starts,FullCost):-
findall(Transmision, transmit(Transmision,_,_,_), Transmisions),
findall(Duration, transmit(_,Duration,_,_), Durations),
findall(Bandwidth, transmit(_,_,Bandwidth,_), Bandwidths),
findall(Cost, transmit(_,_,_,Cost), Costs),
length(Transmisions,N),
length(Starts,N),
Starts #:: 0..inf,
% not broadcasted together check
not_broadcasted_together(NotTogether),
restrict_together(Starts, Durations, NotTogether, StartPairs, DurationPairs),
% calculate costs and find minimum
find_end_times(Starts,Durations,Ends),
find_actual_costs(Costs,Ends,FullCosts),
ic_global:sumlist(FullCosts, FullCost),
% labeling(Starts).
cumulative(Starts,Durations,Bandwidths,400),
bb_min(labeling(Starts),FullCost,bb_options{strategy:restart}).

restrict_together(Starts, Durations, NotTogether, StartPairs, DurationPairs):-
findall(
    StartPair,
    (
        member(NTa, NotTogether),
        NTa =.. [vid, V1, V2],

        nth1(V1, Starts, StartingTime1),
        nth1(V2, Starts, StartingTime2),
        StartPair=[StartingTime1,StartingTime2]
    ),
    StartPairs
),
findall(
    DurationPair,
    (
        member(NTa, NotTogether),
        NTa =.. [vid, V1, V2],
        nth1(V1, Durations, DurationTime1),
        nth1(V2, Durations, DurationTime2),
        DurationPair=[DurationTime1,DurationTime2]
    ),
    DurationPairs
),
maplist(disjunctive, StartPairs, DurationPairs).


find_end_times([],[],[]).
find_end_times([S|Starts], [D|Durations], [End|Ends]):-
    S + D #= End,
    find_end_times(Starts, Durations, Ends).

find_actual_costs([],[],[]).
find_actual_costs([C|Costs], [E|Ends], [F|FullCosts]):-
    C * E #= F,
    find_actual_costs(Costs,Ends,FullCosts).
