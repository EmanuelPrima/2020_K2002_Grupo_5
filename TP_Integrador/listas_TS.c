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

TipoParametro* add(TipoParametro** pila, char agregar[15]) {
    TipoParametro* nuevoNodo = (TipoParametro*)malloc(sizeof(TipoParametro));
    if ((*pila) == NULL) {
        nuevoNodo = push(pila, agregar);
    }
    else {
        strcpy(nuevoNodo->tipo, agregar);
        nuevoNodo->sig = NULL;
        TipoParametro* aux = (*pila);
        while (aux->sig != NULL) {
            aux = aux->sig;
        }
        aux->sig = nuevoNodo;
    }
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
    TipoParametro* aux = *pila;
    int cont = 0;
    while (aux != NULL) {
        cont++;
        aux = aux->sig;
    }
    return cont;
}

int compararParametros(TipoParametro** pila1, TipoParametro** pila2) {
    int ret = 0;    /*0 -> no hay error. 1 -> hay error.*/
    if (cantidadParametros(pila1) != cantidadParametros(pila2)) {
        ret = 1;
    }
    else {
        TipoParametro* aux1 = *pila1;
        TipoParametro* aux2 = *pila2;
        while (aux1 != NULL) {
            if (strcmp(aux1->tipo, aux2->tipo) != 0) {
                ret = 1;
            }
            aux1 = aux1->sig;
            aux2 = aux2->sig;
        }
    }
    return ret;
}


/*-------------------------------------------------------------------------*/

typedef struct {
    char nombre[50];
    char tipo[15];
    TipoParametro* tiposParametros;    /* solo se utiliza si es funcion, sino vale NULL */

    struct Simbolo* sig;
} Simbolo;

Simbolo* tablaSimbolos = NULL;

Simbolo* agregarSimbolo(char nom[50], char tip[15]) {
    Simbolo* nuevoSimbolo = (Simbolo*) malloc(sizeof(Simbolo));
    strcpy(nuevoSimbolo->nombre, nom);
    strcpy(nuevoSimbolo->tipo, tip);
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

/* EJEMPLO DE USO:

  int main() {
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