#include <stdio.h>

int stringLength (char* str)
{
	int i = 0;
	while (str[i] != '\0')
	{
		i++;
	}
	return i;
}

void stringVaciar (char* str)
{
	int i = stringLength(str);
	while (i>=0)
	{
		str[i] = '\0';
		i--;
	}
}


void addChar (char* str, char c)
{
	str[stringLength(str)] = c;
	str[stringLength(str)+1] = '\0';
}

int verificarCaracter(char c)
{
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

void actualizarEstado(int* estado, char c, int automata[7][5])
{
	int columna = verificarCaracter(c);
	if (columna == -1)
		*estado = 6;
	else
		*estado = automata[*estado][columna];
}


int procesarCadena (char* str, int automata[7][5])
{
	int estado;
	int res;
	estado = 0;
	char c;
	int max = stringLength(str), i = 0;
	while (i<max)
	{
		c = str[i];
		actualizarEstado(&estado, c, automata);
		i++;
	}
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
	FILE* f;
	FILE * m;
	char str[100] = "";
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
		if (c == ',' || c == '\n')
		{
			indice = procesarCadena(str, automata);
			fputs ("\n",m);
			fputs(str, m);
			fputs(" es un ", m);
			fputs(resultado[indice],m);
			stringVaciar(str);
		}
		else
		{
			addChar(str, c);
		}
	}
	fclose(f);
	return 0;
}
