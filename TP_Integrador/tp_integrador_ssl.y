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

char identificadorAux[50];

Simbolo* simboloAux;

TipoParametro* listaParametrosAux = NULL;

char tipoAux[15];

%}

%union {
char cadena[50];
int entero;
float real;
struct NombreYTipo
        {
                char nombre[50];
                char tipo[15];
        } nomTip;
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
%type <nomTip> expAsignacion
%type <nomTip> expAditiva
%type <nomTip> expRelacional
%type <nomTip> expCondicional
%type <nomTip> expAnd
%type <nomTip> expOr
%type <nomTip> expIgualdad
%type <nomTip> expMultiplicativa
%type <nomTip> expUnaria
%type <nomTip> expPostfijo
%type <nomTip> expPrimaria
%type <cadena> constante

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

expAsignacion:  expCondicional                                  {$<nomTip>$ = $<nomTip>1;}
                | expUnaria OPER_ASIGNACION expAsignacion       {$<nomTip>$ = $<nomTip>1;}
;

expCondicional: expOr                                           {$<nomTip>$ = $<nomTip>1;}
                | expOr '?' expresion ':' expCondicional        {$<nomTip>$ = $<nomTip>1;}
;

expOr:  expAnd                                                  {$<nomTip>$ = $<nomTip>1;}
        | expOr OR expAnd                                       {$<nomTip>$ = $<nomTip>1;}
;

expAnd: expIgualdad                                             {$<nomTip>$ = $<nomTip>1;}
        | expAnd AND expIgualdad                                {$<nomTip>$ = $<nomTip>1;}
;

expIgualdad:    expRelacional                                   {$<nomTip>$ = $<nomTip>1;}
                | expIgualdad OPER_IGUALDAD expRelacional       {$<nomTip>$ = $<nomTip>1;}
;

expRelacional:  expAditiva                                      {$<nomTip>$ = $<nomTip>1;}
                | expRelacional OPER_RELACIONAL expAditiva      {$<nomTip>$ = $<nomTip>1;}
;

expAditiva:     expMultiplicativa                               {$<nomTip>$ = $<nomTip>1;}
                | expAditiva OPER_ADITIVO expMultiplicativa     {$<nomTip>$ = $<nomTip>1;}
;

expMultiplicativa:      expUnaria                                               {$<nomTip>$ = $<nomTip>1;}
                        | expMultiplicativa OPER_MULTIPLICATIVO expUnaria       {$<nomTip>$ = $<nomTip>1; if (strcmp($<nomTip>1.tipo, $<nomTip>3.tipo) != 0) {printf("\nError de tipos en operacion multiplicativa. (linea %i)", linea);}}
;

expUnaria:      expPostfijo                     {$<nomTip>$ = $<nomTip>1;}
                | OPER_INCREMENTO expUnaria     {$<nomTip>$ = $<nomTip>2;}
                | OPER_UNARIO expUnaria         {$<nomTip>$ = $<nomTip>2;}
                | OPER_SIZEOF '(' TIPO_DATO ')'
;

expPostfijo:    expPrimaria                                     {$<nomTip>$ = $<nomTip>1;}
                | expPostfijo '[' expresion ']'
                | expPostfijo '(' opcionListaArgumentos ')'     {simboloAux = buscarSimbolo($<nomTip>1.nombre); if (simboloAux != NULL) {if (compararParametros(&(simboloAux->tiposParametros), &listaParametrosAux) != 0) {printf("\nError semantico: cantidad o tipos de parametros incorrectos en invocacion de la funcion %s. (linea %i)", simboloAux->nombre, linea);}}
                                                                        else {printf("\nError semantico: la funcion %s es invocada sin previa declaracion. (linea %i)", $<cadena>1, linea);}
                                                                listaParametrosAux = NULL;}
;

opcionListaArgumentos:  /* vacio */
                        | expAsignacion                         {add(&listaParametrosAux, $<nomTip>1.tipo);}
                        | listaArgumentos ',' expAsignacion     {add(&listaParametrosAux, $<nomTip>3.tipo);}
;

listaArgumentos:        expAsignacion                           {add(&listaParametrosAux, $<nomTip>1.tipo);}
                        | listaArgumentos ',' expAsignacion     {add(&listaParametrosAux, $<nomTip>3.tipo);}
;

expPrimaria:    IDENTIFICADOR           {simboloAux = buscarSimbolo($<cadena>1); if (simboloAux != NULL) {strcpy($<nomTip>$.nombre, simboloAux->nombre); strcpy($<nomTip>$.tipo, simboloAux->tipo);}}
                | constante             {strcpy($<nomTip>$.nombre, ""); strcpy($<nomTip>$.tipo, $<cadena>1);}
                | LITERAL_CADENA        {strcpy($<nomTip>$.nombre, ""); strcpy($<nomTip>$.tipo, "char*");}
                | '(' expresion ')'     
;

/* --------------------------------------------------------------------------------------
   -------------------GRAMATICA DE LAS DECLARACIONES Y DEFINICIONES----------------------
   -------------------------------------------------------------------------------------- */

declaracion:    declaracionVariablesSimples
                | declaracionFunciones
                | definicionFunciones
;

declaracionVariablesSimples:    TIPO_DATO unaVariableSimple ';' {simboloAux = buscarSimbolo($<cadena>2); if (simboloAux == NULL) {agregarSimbolo($<cadena>2, $<cadena>1); printf("\nSe declara la variable %s de tipo %s.", $<cadena>2, $<cadena>1);} else {printf("\nError: doble declaracion de la variable '%s'.", $<cadena>2);}}
;

unaVariableSimple:      IDENTIFICADOR opcionInicializacion      {strcpy($<cadena>$, $<cadena>1);}
;

opcionInicializacion:   /* vacio */
                        | OPER_ASIGNACION expCondicional
;



declaracionFunciones:   TIPO_DATO IDENTIFICADOR '(' opcionArgumentosConTipo ')' ';' {simboloAux = agregarSimbolo($<cadena>2, $<cadena>1); simboloAux->tiposParametros = listaParametrosAux; listaParametrosAux = NULL; printf("\nSe declara la funcion %s de tipo %s que recibe %i parametro/s (", $<cadena>2, $<cadena>1, contadorParametros); contadorParametros = 0; mostrarTipos(&(simboloAux->tiposParametros)); printf(").");}
;

opcionArgumentosConTipo:        /* vacio */ 
                                | TIPO_DATO opcionReferencia IDENTIFICADOR                              {contadorParametros++;       push(&listaParametrosAux, $<cadena>1);}
                                | TIPO_DATO opcionReferencia IDENTIFICADOR ',' argumentosConTipo        {contadorParametros++;       push(&listaParametrosAux, $<cadena>1);}
;

argumentosConTipo:      TIPO_DATO opcionReferencia IDENTIFICADOR                                        {contadorParametros++;       push(&listaParametrosAux, $<cadena>1);}
                        | TIPO_DATO opcionReferencia IDENTIFICADOR ',' argumentosConTipo                {contadorParametros++;       push(&listaParametrosAux, $<cadena>1);}
;

opcionReferencia:       /* vacio */
                        | '&'
;

definicionFunciones:    TIPO_DATO IDENTIFICADOR '(' opcionArgumentosConTipo ')' sentencia {simboloAux = agregarSimbolo($<cadena>2, $<cadena>1); simboloAux->tiposParametros = listaParametrosAux; listaParametrosAux = NULL; printf("\nSe define la funcion %s de tipo %s que recibe %i parametro/s (", $<cadena>2, $<cadena>1, contadorParametros); contadorParametros = 0; mostrarTipos(&(simboloAux->tiposParametros)); printf(").");}

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

constante:      CONSTANTE_DECIMAL       {strcpy($<cadena>$, "int");}
                | CONSTANTE_OCTAL       {strcpy($<cadena>$, "int");}        
                | CONSTANTE_HEXADECIMAL {strcpy($<cadena>$, "int");} 
                | CONSTANTE_REAL        {strcpy($<cadena>$, "double");}         
                | CONSTANTE_CARACTER    {strcpy($<cadena>$, "char");}                     
;

%%

int main ()
{
        yyin = fopen("entrada.c", "r");
        yyparse ();
}
