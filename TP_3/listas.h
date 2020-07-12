#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct
{
	char* str;
	int valor;
	struct Nodo* sig;
} Nodo;

Nodo* listAdd (Nodo** n, char* s)
{
	char* sn = (char*)malloc(sizeof(char)*(strlen(s) + 1));
	strcpy(sn, s);
	Nodo* nuevo = (Nodo*)malloc(sizeof(Nodo));
	nuevo->str = sn;
	nuevo->sig = NULL;
	nuevo->valor = 0;
	if (*n == NULL)
	{
		*n = nuevo;
	}
	else
	{
		Nodo* aux = *n;
		while (aux->sig != NULL)
		{
			aux = (void*)aux->sig;
		}
		aux->sig = (void*)nuevo;
	}
	return nuevo;
}

Nodo* listInsert (Nodo** n, char* s, int criterio (char*, char*))
{
	char* sn = (char*)malloc(sizeof(char)*strlen(s));
	strcpy(sn, s);
	Nodo* nuevo = (Nodo*)malloc(sizeof(Nodo));
	nuevo->str = sn;
	nuevo->sig = (void*)(*n);
	nuevo->valor = 0;
	Nodo* anterior = NULL;
	if (*n == NULL)
	{
		nuevo->sig = NULL;
		*n = nuevo;
	}
	else
	{
		Nodo* aux = *n;
		while (criterio(s, aux->str) > 0 && aux->sig != NULL)
		{
			anterior = aux;
			aux = (void*)aux->sig;
		}
		if (anterior == NULL)
		{
			if (aux->sig != NULL)
			{
				nuevo->sig = (void*)(*n);
				*n = nuevo;
			}
			else
			{
				if (criterio(s, aux->str) <= 0)
				{
					nuevo->sig = (void*)aux;
					*n = nuevo;
				}
				else
				{
					aux->sig = (void*)nuevo;
					nuevo->sig = NULL;
				}

			}
		}
		else if (criterio(s, aux->str) <= 0)
		{
			anterior->sig = (void*)nuevo;
			nuevo->sig = (void*)aux;
		}
		else
		{
			aux->sig = (void*)nuevo;
			nuevo->sig = NULL;
		}
	}
	return nuevo;
}

Nodo* listSearch (Nodo** n, char* s)
{
	Nodo* aux = *n;
	while (aux != NULL && strcmp(aux->str, s) != 0)
	{
		aux = (void*)(aux->sig);
	}
	return aux;
}

Nodo* listInsert1 (Nodo** n, char* s, int criterio(char*, char*))
{
	Nodo* buscado = listSearch(n, s);
	if (buscado == NULL)
	{
		buscado = listInsert(n, s, criterio);
	}
	return buscado;
}

Nodo* listAdd1 (Nodo** n, char* s)
{
	Nodo* buscado = listSearch(n, s);
	if (buscado == NULL)
	{
		buscado = listAdd(n, s);
	}
	return buscado;
}

int criterio_abc (char* a, char* b)
{
	return strcmp(a, b);
}


void showList(Nodo* n)
{
	while (n != NULL)
	{
		printf("%s (%i veces)", n->str, n->valor);
		n = (Nodo*)n->sig;
		if (n != NULL)
			printf(", ");
	}
}