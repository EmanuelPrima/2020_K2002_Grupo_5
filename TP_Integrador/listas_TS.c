#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char tipo[15];
    struct TipoParametro* sig;
} TipoParametro;

TipoParametro* push(TipoParametro** pila, char agregar[15]) {
    TipoParametro* nuevoNodo = (TipoParametro*)malloc(sizeof(TipoParametro));
    strcpy(nuevoNodo->tipo, agregar);
    nuevoNodo->sig = (*pila);
    (*pila) = nuevoNodo;

    return nuevoNodo;
}

void mostrarTipos(TipoParametro** pila) {
    TipoParametro* aux = (*pila);
    while (aux != NULL) {
        if (aux->sig != NULL)
            printf("%s, ", aux->tipo);
        else
            printf("%s", aux->tipo);
        aux = aux->sig;
    }
}

int cantidadParametros(TipoParametro** pila) {
    TipoParametro* aux = (*pila);
    int cont = 0;
    while (aux != NULL) {
        cont++;
        aux = aux->sig;
    }
    return cont;
}

/*-------------------------------------------------------------------------*/

typedef struct {
    char nombre[50];
    int naturaleza;         /* 0 si es variable, 1 si es funcion */
    TipoParametro* tiposParametros;    /* solo se utiliza si es funcion */

    struct Simbolo* sig;
} Simbolo;

Simbolo* tablaSimbolos = NULL;

Simbolo* agregarSimbolo(char nom[50], int nat) {
    Simbolo* nuevoSimbolo = (Simbolo*) malloc(sizeof(Simbolo));
    strcpy(nuevoSimbolo->nombre, nom);
    nuevoSimbolo->naturaleza = nat;
    nuevoSimbolo->tiposParametros = NULL;

    nuevoSimbolo->sig = (Simbolo*)tablaSimbolos;
    tablaSimbolos = (Simbolo*)nuevoSimbolo;

    return nuevoSimbolo;
}

Simbolo* buscarSimbolo(char nom[50]) {
    Simbolo* aux = tablaSimbolos;
    while (aux != NULL && strcmp(nom, aux->nombre) != 0) {
        aux = aux->sig;
    }
    
    return aux;
}

/*int main() {
    TipoParametro* listaTipos = NULL;
    push(&listaTipos, "int");
    push(&listaTipos, "double");
    push(&listaTipos, "char");

    agregarSimbolo("pichula", 0);
    agregarSimbolo("fun", 1);

    Simbolo* A = buscarSimbolo("fun");
    Simbolo* B = buscarSimbolo("pichula");
    A->tiposParametros = &listaTipos;

    printf("\nnombre: %s\n", B->nombre);
    printf("\nnombre: %s\nparametros: %i (", A->nombre, cantidadParametros(A->tiposParametros));
    mostrarTipos(A->tiposParametros);
    printf(")");
}*/