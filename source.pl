% Goncalo Marques (84719) && Manuel Sousa (84740)

/******************************************************************************
* distancia/3
*
* Arguments:   	(L1,C1): Coordenada 1
*				(L2,C2): Coordenada 2
*				Dist: Distancia calculada da Coordenada 1 a Coordeanda 2 
*
* Description:  Calcula a distancia entre duas coordenadas
*******************************************************************************/

distancia((L1,C1),(L2,C2),Dist) :- Dist is abs(L1 - L2) + abs(C1 - C2).


/******************************************************************************
* movs_possiveis/4
*
* Arguments:   	Lab 	(labirinto)
*				[Pos_X|Pos_Y] 	(posicao atual)
*				[Movs|Ultimo_Mov] 	(lista com so movimentos efetuados)
*				Poss 	(movimentos possiveis)
*
* Description:  Calcula a distancia entre duas coordenadas
*******************************************************************************/

movs_possiveis(Lab, [Pos_X|Pos_Y], [Movs|[Ultima_Dir|Ultima_Pos]], Poss) :-	
		n_esimo(Pos_Y, Lab, Linha),
		n_esimo(Pos_X, Linha, Restricoes_Lab),
		cria_lista_restricoes(Res),
		remove_elementos_iguais(Res, Lab, Restricoes),
		remove_elemento(Restricoes, Ultima_Dir, Restricoes_Finais),
		cria_poss(Restricoes_Finais, [Pos_X|Pos_Y], Poss).


/******************************************************************************
* auxiliares
*
*******************************************************************************/


% Vai buscar o N-esimo elemento de uma lista
n_esimo(X, [X|_], 1).
n_esimo(X, [_|L], N) :- N > 1, N1 is N - 1, n_esimo(X, L, N1).


% Cria lista de restricoes, para que possam ser eliminadas posteriormente
cria_lista_restricoes(X) :- X = [d, e, b, c].


% Devolve uma lista com a nova posicao apos o movimento
adiciona_direcao([], [], []).
adiciona_direcao([H|T], c, L) :- 	H1 is H-1, L = [H1,T].
adiciona_direcao([H|T], b, L) :- 	H1 is H+1, L = [H1,T].
adiciona_direcao([H|T], e, L) :- 	T1 is T-1, L = [H,T1].
adiciona_direcao([H|T], d, L) :- 	T1 is T+1, L = [H,T1].

% Remove os elementos iguais a X da lista
remove_elemento([], _, []).
remove_elemento([H|T1], H, L) :- 		remove_elemento(T1, H, L).
remove_elemento([H|T1], X, [H|L]) :-	H =\= X, remove_elemento(T1, X, L).


% Remove da primeira lista elementos que sejam iguais aos da segunda
remove_elementos_iguais(L, [], L).
remove_elementos_iguais(H1, [H2|T2], L) :- 		remove_elemento(H1, H2, L1),
												remove_elementos_iguais(L1, T2, L).


% Cria uma lista de possibilidades de movimento
cria_poss([], []).
cria_poss([H|T], Poss_Lista, [Lista|L]) :-		adiciona_direcao(Poss_Lista, H, Posicao),
												append(H, Posicao, Lista),
												cria_poss(T, L).


/******************************************************************************
* ordena
*
*******************************************************************************/
append([], X, X).
append([X|L1], L2, [X|L3]) :- 	append(L1, L2, L3).

partition(_, [], [], []).
partition(A, [H|T], [H|P], S) :- 	A >= H,
									partition(A, T, P, S).
partition(A, [H|T], P, [H|S]) :- 	A < H,
									partition(A, T, P, S).

ordena([], []).
ordena([A | L1], L2) :- 	partition(A, L1, P1, S1),
							ordena(P1, P2), 
							ordena(S1, S2),
							append(P2, [A | S2], L2).