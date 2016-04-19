% Goncalo Marques () && Manuel Sousa (84740)

/******************************************************************************
* distancia
*
* Arguments:   	(L1,C1): Coordenada 1
*				(L2,C2): Coordenada 2
*				Dist: Distancia calculada da Coordenada 1 a Coordeanda 2 
*
* Description:  Calcula a distancia entre duas coordenadas
*****************************************************************************/
distancia((L1,C1),(L2,C2),Dist) :- Dist is abs(L1 - L2) + abs(C1 - C2).


/******************************************************************************
* ordena
*
*****************************************************************************/
append([ ], X, X).
append([X | L1], L2, [X | L3]) :- 		append(L1, L2, L3).
partition(_, [ ], [ ], [ ]).
partition(A, [H | T], [H | P], S) :- 	A >= H,
										partition(A, T, P, S).
partition(A, [H | T], P, [H | S]) :- 	A < H,
										partition(A, T, P, S).

ordena([ ], [ ]).
ordena([A | L1], L2) :- 	partition(A, L1, P1, S1),
						   	ordena(P1, P2), 
							ordena(S1, S2),
							append(P2, [A | S2], L2).