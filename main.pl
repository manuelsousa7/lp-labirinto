% Goncalo Marques (84719) && Manuel Sousa (84740)

/******************************************************************************
* movs_possiveis /4
*
* Arguments:   	Lab 			(labirinto)
*				(Pos_X, Pos_Y) 	(posicao atual)
*				Movimentos 		(lista com os movimentos efetuados)
*				Poss 			(movimentos possiveis) - RESULTADO
*
* Description:  Devolve uma lista com os movimentos possiveis
*******************************************************************************/

movs_possiveis(Lab, (Pos_X, Pos_Y), Movimentos, Poss_Final) :-
		n_esimo(Pos_X, Lab, Linha),
		n_esimo(Pos_Y, Linha, Restricoes_Lab),
		cria_lista_restricoes(Res),
		remove_elementos_iguais(Res, Restricoes_Lab, Restricoes),
		cria_poss(Restricoes, (Pos_X, Pos_Y), Movimentos, Poss),
		remove_elemento(Poss, [], Poss_Final).


/******************************************************************************
* distancia /3
*
* Arguments:   	(L1,C1): Coordenada 1
*				(L2,C2): Coordenada 2
*				Dist: Distancia entre as duas coordenadas - RESULTADO
*
* Description:  Calcula a distancia entre duas coordenadas
*******************************************************************************/

distancia((L1,C1),(L2,C2),Dist) :- Dist is abs(L1 - L2) + abs(C1 - C2).


/******************************************************************************
* resolve1 /4
*
* Arguments:   	
*
* Description:  Resolve um labirinto na ordem c,b,e,d
*******************************************************************************/
resolve1(_, _, Pos_Final, [(Dir, Pos_Final)|Lista_Movs]) :- Lista_Movs = [].
resolve1(Lab, Pos_inicial, Pos_Final, [(Dir, X, Y)|Lista_Movs]) :-
					verifica_vazio(Lista_Movs, Pos_inicial, Movs),
					movs_possiveis(Lab, Pos_inicial, Movs, [(Dir, X, Y)|Lista_Movs]),
					(X,Y) \= Pos_Final,
					testa_resolve(Lab, Pos_inicial, Pos_Final, Movs, [(Dir, X, Y)|Lista_Movs], Lista_Movs).


testa_resolve(_, ) :- 
testa_resolve(Lab, Pos_inicial, Pos_Final, Movs, [Possiveis|Cauda], [(Dir, X, Y)|Lista_Movs]) :- 
					resolve1(Lab, Pos_inicial, Pos_Final, Movs),
					testa_resolve(Lab, Pos_inicial, Pos_Final, Movs, Cauda, Lista_Movs).

/******************************************************************************
* resolve2 /4
*
* Arguments:   	
*
* Description:  Resolve um labirinto tendo em conta quais das solucoes e mais rapida
*******************************************************************************/

resolve2(Lab, Pos_inicial, Pos_Final, [(Dir, X, Y)|Lista_Movs]) :-
					verifica_vazio(Lista_Movs, Pos_inicial, Movs),
					movs_possiveis(Lab, Pos_inicial, Movs, Poss),
					ordena_poss(Poss, [(Dir, X, Y)|_], Pos_inicial, Pos_Final),
					(X,Y) \= Pos_Final, resolve1(Lab, Pos_inicial, Pos_Final, Movs);
					!.






/******************************************************************************
* predicados auxiliares
*
*******************************************************************************/


% Devolve o N-esimo elemento de uma lista
n_esimo(1, [X|_], X).
n_esimo(N, [_|L], X) :- N > 1, N1 is N - 1, n_esimo(N1, L, X).


% Cria lista de restricoes, para que possam ser eliminadas posteriormente
cria_lista_restricoes(X) :- X = [c, b, e, d].


% Devolve o ultimo elemento de uma lista
ultimo([], (x,y,z)).
ultimo([X],X).
ultimo([_|L],X) :- ultimo(L,X).


% Devolve um tuplo com a nova posicao apos o movimento
adiciona_direcao([], [], []).
adiciona_direcao((H,T), c, L) :- 	H1 is H-1, L = (H1,T).
adiciona_direcao((H,T), b, L) :- 	H1 is H+1, L = (H1,T).
adiciona_direcao((H,T), e, L) :- 	T1 is T-1, L = (H,T1).
adiciona_direcao((H,T), d, L) :- 	T1 is T+1, L = (H,T1).


% Remove os elementos iguais a X da lista
remove_elemento(H, x, H).
remove_elemento([], _, []).
remove_elemento([H|T1], H, L) :- 		remove_elemento(T1, H, L).
remove_elemento([H|T1], X, [H|L]) :-	H \= X, remove_elemento(T1, X, L).


% Remove da primeira lista elementos que sejam iguais aos da segunda
remove_elementos_iguais(L, [], L).
remove_elementos_iguais(H1, [H2|T2], L) :- 		remove_elemento(H1, H2, L1),
												remove_elementos_iguais(L1, T2, L).


% Devolve lista vazia se a posicao ja tiver sido percorrida
verifica_percorrida(Poss, [], Poss).
verifica_percorrida((Dir, Pos_X, Pos_Y), [(_,Movs_X, Movs_Y)|Cauda], Lista) :- 
			(Pos_X, Pos_Y) == (Movs_X, Movs_Y), Lista = [];
			verifica_percorrida((Dir, Pos_X, Pos_Y), Cauda, Lista).


% Cria uma lista de possibilidades de movimento
cria_poss([], _, _, []).
cria_poss([H|T], Poss_Lista, Movs, [Lista|L]) :- 
					adiciona_direcao(Poss_Lista, H, Posicao),
					verifica_percorrida((H, Posicao), Movs, Lista),
					cria_poss(T, Poss_Lista, Movs, L).


% Se a lista de movimentos estiver vazia, devolve uma lista com (i, PosX, PosY)
verifica_vazio([], (PosX,PosY), Movs) :-		Movs = [(i, PosX, PosY)].
verifica_vazio(M, _, M).






/******************************************************************************
* ordena_poss /4
*
* Arguments:   	
*
* Description:  Ordena (baseado em InsertionSort)
*******************************************************************************/
ordena_poss([],[],(_,_),(_,_)).
ordena_poss([(A,X,Y)|Xs],Ys,(Ix,Iy),(Fx,Fy)) :-
            			ordena_poss(Xs,Zs,(Ix,Iy),(Fx,Fy)), 
            			!, 
            			insert((A,X,Y),Zs,Ys,(Ix,Iy),(Fx,Fy)).
insert((A,X,Y),[],[(A,X,Y)],(_,_),(_,_)).
insert((A,X,Y),[(B,XX,YY)|Ys],[(B,XX,YY)|Zs],(Ix,Iy),(Fx,Fy)) :- 	
						distancia((X,Y),(Fx,Fy),Dist1),
						distancia((XX,YY),(Fx,Fy),Dist2),
						Dist1 > Dist2, 
						!, 
						insert((A,X,Y),Ys,Zs,(Ix,Iy),(Fx,Fy)).

insert((A,X,Y),[(B,XX,YY)|Ys],[(A,X,Y),(B,XX,YY)|Ys],(_,_),(Fx,Fy)) :- 	
						distancia((X,Y),(Fx,Fy),Dist1),
						distancia((XX,YY),(Fx,Fy),Dist2),
						Dist1 < Dist2.

insert((A,X,Y),[(B,XX,YY)|Ys],[(B,XX,YY)|Zs],(Ix,Iy),(Fx,Fy)) :- 	
						distancia((X,Y),(Fx,Fy),Dist1),
						distancia((XX,YY),(Fx,Fy),Dist2),
						Dist1 == Dist2,
						distancia((X,Y),(Ix,Iy),Dist11),
						distancia((XX,YY),(Ix,Iy),Dist22),
						Dist11 < Dist22, 
						!, 
						insert((A,X,Y),Ys,Zs,(Ix,Iy),(Fx,Fy)).


insert((A,X,Y),[(B,XX,YY)|Ys],[(A,X,Y),(B,XX,YY)|Ys],(Ix,Iy),(Fx,Fy)) :- 	
						distancia((X,Y),(Fx,Fy),Dist1),
						distancia((XX,YY),(Fx,Fy),Dist2),
						Dist1 == Dist2,
						distancia((X,Y),(Ix,Iy),Dist11),
						distancia((XX,YY),(Ix,Iy),Dist22),
						Dist11 > Dist22.

insert((A,X,Y),[(B,XX,YY)|Ys],[(A,X,Y),(B,XX,YY)|Ys],(Ix,Iy),(Fx,Fy)) :- 	
						distancia((X,Y),(Fx,Fy),Dist1),
						distancia((XX,YY),(Fx,Fy),Dist2),
						Dist1 == Dist2,
						distancia((X,Y),(Ix,Iy),Dist11),
						distancia((XX,YY),(Ix,Iy),Dist22),
						Dist11 == Dist22.


