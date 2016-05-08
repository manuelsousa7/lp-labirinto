% TG-01 | Goncalo Marques (84719) && Manuel Sousa (84740)

/******************************************************************************
* movs_possiveis /4
*
* Arguments:    Lab             Labirinto
*               (Pos_X, Pos_Y)  Posicao atual
*               Movimentos      Lista com os movimentos efetuados
*               Poss            Movimentos possiveis - PRETENDIDO
*
* Description:  Devolve uma lista com os movimentos possiveis
*******************************************************************************/

movs_possiveis(Lab, (Pos_X, Pos_Y), Movimentos, Poss_Final) :-
		n_esimo(Pos_X, Lab, Linha),
		n_esimo(Pos_Y, Linha, Restricoes_Lab),
		remove_elementos_iguais([c, b, e, d], Restricoes_Lab, Restricoes),
		cria_poss(Restricoes, (Pos_X, Pos_Y), Movimentos, Poss),
		remove_elemento(Poss, [], Poss_Final), !.

/******************************************************************************
*
* predicados auxiliares (usados no movs_possiveis)
*
*******************************************************************************/

% Devolve o N-esimo elemento de uma lista
n_esimo(1, [X|_], X).
n_esimo(N, [_|L], X) :- N > 1, N1 is N - 1, n_esimo(N1, L, X).


% Devolve um tuplo com a nova posicao apos o movimento
adiciona_direcao([], [], []).
adiciona_direcao((H,T), c, L) :-    H1 is H-1, L = (H1,T).
adiciona_direcao((H,T), b, L) :-    H1 is H+1, L = (H1,T).
adiciona_direcao((H,T), e, L) :-    T1 is T-1, L = (H,T1).
adiciona_direcao((H,T), d, L) :-    T1 is T+1, L = (H,T1).


% Remove os elementos iguais a X da lista
remove_elemento(H, x, H) :- !.
remove_elemento([], _, []) :- !.
remove_elemento([H|T1], H, L) :-        remove_elemento(T1, H, L).
remove_elemento([H|T1], X, [H|L]) :-    H \= X, remove_elemento(T1, X, L).


% Remove da primeira lista elementos que sejam iguais aos da segunda
remove_elementos_iguais(L, [], L) :- !.
remove_elementos_iguais(H1, [H2|T2], L) :-      
					remove_elemento(H1, H2, L1),
					remove_elementos_iguais(L1, T2, L).

% Cria uma lista de possibilidades de movimento
cria_poss([], _, _, []) :- !.
cria_poss([H|T], Poss_Lista, Movs, [Lista|L]) :- 
					adiciona_direcao(Poss_Lista, H, Posicao),
					verifica_percorrida((H, Posicao), Movs, Lista),
					cria_poss(T, Poss_Lista, Movs, L).

% Devolve lista vazia se a posicao ja tiver sido percorrida
verifica_percorrida(Poss, [], Poss) :- !.
verifica_percorrida((Dir, Pos_X, Pos_Y), [(_,Movs_X, Movs_Y)|Cauda], Lista) :- 
					(Pos_X, Pos_Y) == (Movs_X, Movs_Y), Lista = [];
					verifica_percorrida((Dir, Pos_X, Pos_Y), Cauda, Lista).



/******************************************************************************
* distancia /3
*
* Arguments:    (L1,C1)         Coordenada 1
*               (L2,C2)         Coordenada 2
*               Dist            Distancia entre as duas coordenadas - PRETENDIDO
*
* Description:  Calcula a distancia entre duas coordenadas
*******************************************************************************/

distancia((L1,C1),(L2,C2),Dist) :- Dist is abs(L1 - L2) + abs(C1 - C2).

/******************************************************************************
* resolve1 /4
*
* Arguments:    Lab             Labirinto
*               Pos_Inicial     Posicao inicial
*               Pos_Final       Posicao final
*               Pos_Atual       Posicao atual
*               Lista_Movs      Lista com os movimentos efetuados - PRETENDIDO
*
* Description:  Resolve um labirinto na ordem c,b,e,d
*******************************************************************************/

resolve1(Lab, Pos_Inicial, Pos_Final, Lista_Movs) :-
			movs_possiveis(Lab, Pos_Inicial, [(i, Pos_Inicial)], Poss),
			resolve1(Lab, Pos_Final, Pos_Inicial, Poss, [(i, Pos_Inicial)], Lista_Movs), !.
					
resolve1(_, Pos_Final, Pos_Final, _, Lista_Movs, Lista_Movs) :- !.

resolve1(_, _, _, [], _, _).

resolve1(Lab, Pos_Final, Pos_Atual, [(Dir, X, Y)|Poss_Resto], Movs, Lista_Movs) :-
			var(Lista_Movs),(
				Pos_Final \= Pos_Atual,
				[(Dir, X, Y)|Poss_Resto] \= [],
				append(Movs, [(Dir, X, Y)], Movimentos),
				movs_possiveis(Lab, (X,Y), Movimentos, Poss),
				resolve1(Lab,  Pos_Final, (X,Y), Poss, Movimentos, Lista_Movs),
				resolve1(Lab, Pos_Final, Pos_Atual, Poss_Resto, Movs, Lista_Movs)
			);
			!.

/******************************************************************************
* resolve2 /4
*
* Arguments:    Lab             Labirinto
*               Pos_Inicial     Posicao inicial
*               Pos_Final       Posicao final
*               Pos_Atual       Posicao atual
*               Lista_Movs      Lista com os movimentos efetuados - PRETENDIDO  
*
* Description:  Resolve um labirinto tendo em conta qual das solucoes esta mais proxima do final
*******************************************************************************/

resolve2(Lab, Pos_Inicial, Pos_Final, Lista_Movs) :-
			movs_possiveis(Lab, Pos_Inicial, [(i, Pos_Inicial)], Possibilidades),
			ordena_poss(Possibilidades, Poss, Pos_Inicial, Pos_Final),
			resolve2(Lab, Pos_Final, Pos_Inicial, Poss, [(i, Pos_Inicial)], Lista_Movs).
					
resolve2(_, Pos_Final, Pos_Final, _, Lista_Movs, Lista_Movs) :- !.

resolve2(_, _, _, [], _, _).

resolve2(Lab, Pos_Final, Pos_Atual, [(Dir, X, Y)|Poss_Resto], [(Dir_Ini, X_Ini, Y_Ini)|Movs_Resto], Lista_Movs) :-
			var(Lista_Movs),(
				Pos_Final \= Pos_Atual,
				[(Dir, X, Y)|Poss_Resto] \= [],
				append([(Dir_Ini, X_Ini, Y_Ini)|Movs_Resto], [(Dir, X, Y)], Movimentos),
				movs_possiveis(Lab, (X,Y), Movimentos, Possibilidades),
				ordena_poss(Possibilidades, Poss, (X_Ini, Y_Ini), Pos_Final),
				resolve2(Lab,  Pos_Final, (X,Y), Poss, Movimentos, Lista_Movs),
				resolve2(Lab, Pos_Final, Pos_Atual, Poss_Resto, [(Dir_Ini, X_Ini, Y_Ini)|Movs_Resto], Lista_Movs)
			);
			!.

/******************************************************************************
* ordena_poss /4
*
* Arguments:    Possibilidades de movimento
*               Possibilidades de movimento organizadas - PRETENDIDO
*               Posicao inicial
*               Posicao final   
*
* Description:  Ordena a lista de movimentos possiveis (baseado em InsertionSort)
*******************************************************************************/

ordena_poss([],[],(_,_),(_,_)).
ordena_poss([(A,Pos_X1,Pos_Y1)|Xs],Cauda,(IX,IY),(FX,FY)) :-
					ordena_poss(Xs,Zs,(IX,IY),(FX,FY)), 
					!,
					ordena((A,Pos_X1,Pos_Y1),Zs,Cauda,(IX,IY),(FX,FY)).
ordena((A,Pos_X1,Pos_Y1),[],[(A,Pos_X1,Pos_Y1)],(_,_),(_,_)).

ordena((A,Pos_X1,Pos_Y1),[(B,Pos_X2,Pos_Y2)|Cauda],[(B,Pos_X2,Pos_Y2)|Zs],(IX,IY),(FX,FY)) :-   
					distancia((Pos_X1,Pos_Y1),(FX,FY),Dist1),
					distancia((Pos_X2,Pos_Y2),(FX,FY),Dist2),
					Dist1 > Dist2, 
					!, 
					ordena((A,Pos_X1,Pos_Y1),Cauda,Zs,(IX,IY),(FX,FY)).

ordena((A,Pos_X1,Pos_Y1),[(B,Pos_X2,Pos_Y2)|Cauda],[(A,Pos_X1,Pos_Y1),(B,Pos_X2,Pos_Y2)|Cauda],(_,_),(FX,FY)) :-    
					distancia((Pos_X1,Pos_Y1),(FX,FY),Dist1),
					distancia((Pos_X2,Pos_Y2),(FX,FY),Dist2),
					Dist1 < Dist2.

ordena((A,Pos_X1,Pos_Y1),[(B,Pos_X2,Pos_Y2)|Cauda],[(B,Pos_X2,Pos_Y2)|Zs],(IX,IY),(FX,FY)) :-   
					distancia((Pos_X1,Pos_Y1),(FX,FY),Dist1),
					distancia((Pos_X2,Pos_Y2),(FX,FY),Dist2),
					Dist1 == Dist2,
					distancia((Pos_X1,Pos_Y1),(IX,IY),Dist11),
					distancia((Pos_X2,Pos_Y2),(IX,IY),Dist22),
					Dist11 < Dist22, 
					!, 
					ordena((A,Pos_X1,Pos_Y1),Cauda,Zs,(IX,IY),(FX,FY)).


ordena((A,Pos_X1,Pos_Y1),[(B,Pos_X2,Pos_Y2)|Cauda],[(A,Pos_X1,Pos_Y1),(B,Pos_X2,Pos_Y2)|Cauda],(IX,IY),(FX,FY)) :-  
					distancia((Pos_X1,Pos_Y1),(FX,FY),Dist1),
					distancia((Pos_X2,Pos_Y2),(FX,FY),Dist2),
					Dist1 == Dist2,
					distancia((Pos_X1,Pos_Y1),(IX,IY),Dist11),
					distancia((Pos_X2,Pos_Y2),(IX,IY),Dist22),
					Dist11 > Dist22.

ordena((A,Pos_X1,Pos_Y1),[(B,Pos_X2,Pos_Y2)|Cauda],[(A,Pos_X1,Pos_Y1),(B,Pos_X2,Pos_Y2)|Cauda],(IX,IY),(FX,FY)) :-  
					distancia((Pos_X1,Pos_Y1),(FX,FY),Dist1),
					distancia((Pos_X2,Pos_Y2),(FX,FY),Dist2),
					Dist1 == Dist2,
					distancia((Pos_X1,Pos_Y1),(IX,IY),Dist11),
					distancia((Pos_X2,Pos_Y2),(IX,IY),Dist22),
					Dist11 == Dist22.

