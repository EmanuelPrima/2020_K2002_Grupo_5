%{
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>
#include "listas_TS.c"

int yylex();

FILE* yyin;

int yywrap(){
	return(1);
}

void yyerror (char const *s) {}

int contadorParametros = 0;
int linea = 1;

int hayErrorSemantico = 0;

Simbolo* simboloAux;

TipoParametro* listaParametrosAux = NULL;

%}

%union {
char cadena[50];
int entero;
float real;
}

%token <cadena> TIPO_DATO
%token <cadena> IDENTIFICADOR
%token <cadena> LITERAL_CADENA
%token <entero> CONSTANTE_DECIMAL
%token <entero> CONSTANTE_OCTAL
%token <entero> CONSTANTE_HEXADECIMAL
%token <real>   CONSTANTE_REAL
%token <entero> CONSTANTE_CARACTER
%token <cadena> OPER_ADITIVO
%token <cadena> OPER_MULTIPLICATIVO
%token <cadena> OPER_RELACIONAL
%token <cadena> OPER_UNARIO
%token <cadena> OPER_IGUALDAD
%token <cadena> OPER_ASIGNACION
%token <cadena> OPER_INCREMENTO
%token <cadena> OPER_SIZEOF
%token <cadena> AND
%token <cadena> OR
%token <cadena> IF
%token <cadena> SWITCH
%token <cadena> ELSE
%token <cadena> FOR
%token <cadena> WHILE
%token <cadena> DO
%token <cadena> RETURN

%type <cadena> unaVariableSimple
%type <cadena> error

%%

input:  /* vacio */
        | input line
;

line:   declaracion '\n'        {linea++;}
        | sentencia '\n'        {linea++;}
        | error '\n'            {printf("\nSe detecto un error sintactico en la linea %i.", linea); linea++;}     
;

/* --------------------------------------------------------------------------------------
   -----------------------------GRAMATICA DE LAS EXPRESIONES-----------------------------
   -------------------------------------------------------------------------------------- */

expresion:      expAsignacion
;

expAsignacion:  expCondicional
                | expUnaria OPER_ASIGNACION expAsignacion
;

expCondicional: expOr
                | expOr '?' expresion ':' expCondicional
;

expOr:  expAnd
        | expOr OR expAnd
;

expAnd: expIgualdad
        | expAnd AND expIgualdad
;

expIgualdad:    expRelacional
                | expIgualdad OPER_IGUALDAD expRelacional
;

expRelacional:  expAditiva
                | expRelacional OPER_RELACIONAL expAditiva
;

expAditiva:     expMultiplicativa
                | expAditiva OPER_ADITIVO expMultiplicativa
;

expMultiplicativa:      expUnaria
                        | expMultiplicativa OPER_MULTIPLICATIVO expUnaria
;

expUnaria:      expPostfijo
                | OPER_INCREMENTO expUnaria
                | OPER_UNARIO expUnaria
                | OPER_SIZEOF '(' TIPO_DATO ')'
;

expPostfijo:    expPrimaria
                | expPostfijo '[' expresion ']'
                | expPostfijo '(' opcionListaArgumentos ')'
;

opcionListaArgumentos:  /* vacio*/
                        | expAsignacion
                        | opcionListaArgumentos ',' expAsignacion
;

expPrimaria:    IDENTIFICADOR
                | constante
                | LITERAL_CADENA
                | '(' expresion ')'
;

/* --------------------------------------------------------------------------------------
   -------------------GRAMATICA DE LAS DECLARACIONES Y DEFINICIONES----------------------
   -------------------------------------------------------------------------------------- */

declaracion:    declaracionVariablesSimples
                | declaracionFunciones
                | definicionFunciones
;

declaracionVariablesSimples:    TIPO_DATO listaVariablesSimples ';' {if (!hayErrorSemantico) {printf(" de tipo %s.", $<cadena>1);} else {hayErrorSemantico = 0;}}
;

listaVariablesSimples:  unaVariableSimple                               {simboloAux = buscarSimbolo($<cadena>1); if (simboloAux == NULL) {agregarSimbolo($<cadena>1, 0); printf("\nSe declara la variable %s", $<cadena>1);} else {printf("\nError: doble declaracion de la variable '%s'.", $<cadena>1); hayErrorSemantico = 1;}}
                        | listaVariablesSimples ',' unaVariableSimple   {simboloAux = buscarSimbolo($<cadena>3); if (simboloAux == NULL && !hayErrorSemantico) {agregarSimbolo($<cadena>3, 0); printf(", y la variable %s", $<cadena>3);} else {if (!hayErrorSemantico) {printf("\nError: doble declaracion de la variable '%s'.", $<cadena>3); hayErrorSemantico = 1;}}}
;

unaVariableSimple:      IDENTIFICADOR opcionInicializacion      {strcpy($<cadena>$, $<cadena>1);}
;

opcionInicializacion:   /* vacio */
                        | OPER_ASIGNACION expCondicional
;



declaracionFunciones:   TIPO_DATO IDENTIFICADOR '(' opcionArgumentosConTipo ')' ';' {simboloAux = agregarSimbolo($<cadena>2, 1); simboloAux->tiposParametros = listaParametrosAux; listaParametrosAux = NULL; printf("\nSe declara la funcion %s de tipo %s que recibe %i parametro/s (", $<cadena>2, $<cadena>1, contadorParametros); contadorParametros = 0; mostrarTipos(&(simboloAux->tiposParametros)); printf(").");}
;

opcionArgumentosConTipo:        /* vacio */ 
                                | TIPO_DATO opcionReferencia IDENTIFICADOR                              {contadorParametros++;       push(&listaParametrosAux, $<cadena>1);}
                                | TIPO_DATO opcionReferencia IDENTIFICADOR ',' argumentosConTipo        {contadorParametros++;       push(&listaParametrosAux, $<cadena>1);}
;

argumentosConTipo:      TIPO_DATO opcionReferencia IDENTIFICADOR {contadorParametros++; push(&listaParametrosAux, $<cadena>1);}
                        | TIPO_DATO opcionReferencia IDENTIFICADOR ',' argumentosConTipo {contadorParametros++; push(&listaParametrosAux, $<cadena>1);}
;

opcionReferencia:       /* vacio */
                        | '&'
;

definicionFunciones:    TIPO_DATO IDENTIFICADOR '(' opcionArgumentosConTipo ')' sentencia {simboloAux = agregarSimbolo($<cadena>2, 1); simboloAux->tiposParametros = listaParametrosAux; listaParametrosAux = NULL; printf("\nSe declara la funcion %s de tipo %s que recibe %i parametro/s (", $<cadena>2, $<cadena>1, contadorParametros); contadorParametros = 0; mostrarTipos(&(simboloAux->tiposParametros)); printf(").");}

/* --------------------------------------------------------------------------------------
   -----------------------------GRAMATICA DE LAS SENTENCIAS------------------------------
   -------------------------------------------------------------------------------------- */

sentencia:      sentenciaCompuesta
                | sentenciaExpresion
                | sentenciaSeleccion
                | sentenciaIteracion
                | sentenciaSalto
;

sentenciaCompuesta:     '{' opcionListaDeclaraciones opcionListaSentencias '}'  
;

opcionListaDeclaraciones:       /* vacio */
                                | declaracion                           
                                | opcionListaDeclaraciones declaracion
;

listaSentencias:        sentencia                       
                        | listaSentencias sentencia  
;

opcionListaSentencias:  /* vacio*/
                        | sentencia                    
                        | listaSentencias sentencia   
;

sentenciaExpresion:     ';'                     
                        | expresion ';'         
;

sentenciaSeleccion:     IF '(' expresion ')' sentencia                  
                        | IF '(' expresion ')' sentencia ELSE sentencia 
                        | SWITCH '(' expresion ')' sentencia            
;

sentenciaIteracion:     WHILE '(' expresion ')' sentencia                                               
                        | DO sentencia WHILE '(' expresion ')' ';'                                      
                        | FOR '(' opcionExpresion ';' opcionExpresion ';' opcionExpresion ')' sentencia 
;

sentenciaSalto: RETURN opcionExpresion ';'      
;

opcionExpresion:        /* vacio */
                        | expresion
;



/* --------------------------------------------------------------------------------------
   -------------------------------GRAMATICA DE LAS CONSTANTES----------------------------
   -------------------------------------------------------------------------------------- */

constante:      CONSTANTE_DECIMAL             
                | CONSTANTE_OCTAL               
                | CONSTANTE_HEXADECIMAL       
                | CONSTANTE_REAL                 
                | CONSTANTE_CARACTER                         
;

%%

int main ()
{
        yyin = fopen("entrada.c", "r");
        yyparse ();
}
