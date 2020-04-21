#include <stdio.h>



int verificarCaracter(char c){
	int i;
	if (c == '0')
		i = 0;
	else if (c >= '1' && c <= '7')
		i = 1;
	else if (c == '8' || c == '9')
		i = 2;
	else if (c == 'x' || c == 'X')
		i = 3;
	else if (c >= 'a' && c <= 'f' || c >= 'A' && c <= 'F')
		i = 4;
	else
		i = -1;
	return i; 
	
}

int actualizarEstado(int estado, char c, int automata[7][5])
{
	int columna = verificarCaracter(c);
	if (columna == -1)
		return 6;
	else
		return automata[estado][columna];
		
}

int procesarCaracter (char c, int automata[7][5],int estado)
{
	int res;
	if (estado == 1)
		res = 0;
	else if (estado == 2 || estado == 3)
		res = 1;
	else if (estado == 5)
		res = 2;
	else
		res = 3;
	return res;
}


int main ()
{
	int estado = 0;
	FILE* f;
	FILE * m;
	char c;
	int indice;
	char resultado[4][20] = {{"decimal"}, {"octal"}, {"hexadecimal"}, {"desastre :("}};
	int automata[7][5] = {{2, 1, 1, 6, 6}, 
	                    {1, 1, 1, 6, 6},
			            {3, 3, 6, 4, 6},
			            {3, 3, 6, 6, 6},
			            {5, 5, 5, 6, 5},
			            {5, 5, 5, 6, 5},
			            {6, 6, 6, 6, 6}};
			      
	f = fopen("entrada.txt", "r");
	
	m = fopen("salida.txt", "w");
	
	fputs("BIENVENIDOS AL TP N°1 DE SINTAXIS Y SEMANTICA DE LOS LENGUAJES DEL GRUPO 5\n",m);
	
	while (!feof(f))
	{
		c = fgetc(f);
	
	    if(c == ',' || c == EOF){
	        
			indice = procesarCaracter(c, automata,estado);
			fputs (" es un ", m);
			fputs(resultado[indice], m);
			fputc('\n', m);
			estado = 0;
		}
		else {	
			estado = actualizarEstado(estado,c,automata);
			fputc(c,m);
		} 
	}
	fclose(f);
	fclose(m);
	return 0;
}
