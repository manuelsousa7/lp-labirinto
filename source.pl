% Goncalo Marques () && Manuel Sousa (84740)

/******************************************************************************
* distancia
*
* Arguments:   	(L1,C1): Coordenada 1
*              	(L2,C2): Coordenada 2
				Dist: Distancia calculada da Coordenada 1 a Coordeanda 2 
*
* Description:  Calcula a distancia entre duas coordenadas
*****************************************************************************/
distancia((L1,C1),(L2,C2),Dist) :- Dist is abs(L1 - L2) + abs(C1 - C2).
