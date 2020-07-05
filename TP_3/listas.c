#include <stdio.h>
#include <stdlib.h>

typedef struct
{
	char* str;
	struct Nodo* sig;
} Nodo;

char* nuevoString (char* s)
{
	char* nuevo = (char*)malloc(sizeof(char)*50);
	int i;
	for (i=0; s[i] != '\0'; i++)
	{
		nuevo[i] = s[i];
	}
	nuevo[i] = '\0';
	return nuevo;
}

Nodo* listAdd (Nodo** n, char* s)
{
	char* sn = nuevoString(s);
	Nodo* nuevo = (Nodo*)malloc(sizeof(Nodo));
	nuevo->str = sn;
	nuevo->sig = NULL;
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
	char* sn = nuevoString(s);
	Nodo* nuevo = (Nodo*)malloc(sizeof(Nodo));
	nuevo->str = sn;
	nuevo->sig = (void*)(*n);
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

int criterio_abc (char* a, char* b)
{
	int ret = 0;
	int i;
	for (i = 0; a[i] == b[i] && a[i] != '\0' && b[i] != '\0'; i++)
	{}
	if (a[i] != '\0' && b[i] != '\0')
		ret = a[i] - b[i];
	else
	{
		if (a[i] == '\0')
			ret = -1;
		else
			ret = 1;
	}
	return ret;
}


void showList(Nodo* n)
{
	while (n != NULL)
	{
		printf("%s", n->str);
		n = (Nodo*)n->sig;
		if (n != NULL)
			printf(", ");
	}
}