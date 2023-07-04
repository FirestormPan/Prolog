%% Coursework 2 2022-2023
%% Libraries
:-lib(ic).
:-lib(ic_global).
:-lib(branch_and_bound).
:-lib(ic_edge_finder).
:-lib(listut).
%%%% Exec1 
%%% generator facts
generator(1,20).
generator(2,40).
generator(3,50).
generator(4,50).
generator(5,20).
generator(6,30).
generator(7,40).
generator(8,70).
generator(9,50).
generator(10,60).

% demand facts
demand(1,10).
demand(2,60).
demand(3,70).
demand(4,50).
demand(5,20).
demand(6,10).
demand(7,30).
demand(8,40).
demand(9,40).
demand(10,30).

% gen_schedule(List)/1
gen_schedule(List):-
% I assume a list LIST that has all the ids of Generators. Each index is the coresponding demand
length(LIST,10),
ic:alldifferent(LIST),
apply_constraints(LIST,1),
labeling(LIST),!,
pretify(LIST, List, 1).

pretify([],[],_).
pretify([H|List], [dto(Iter,H)|L], Iter):-
Iter2 is Iter+1,
pretify(List, L, Iter2).

% apply_constraints/2
apply_constraints([],_).
apply_constraints([H|List], N):-
dTo(N,H),
N2 is N+1,
apply_constraints(List,N2).

dTo(IdNeed,IdGen):-
demand(IdNeed,Need),
generator(IdGen,Gen),
Need =< Gen.