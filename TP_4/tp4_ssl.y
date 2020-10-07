%{
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

int yylex();

FILE* yyin;

int yywrap(){
	return(1);
}

void yyerror (char const *s) {}

int contadorParametros = 0;
int contadorDeclaraciones = 0;
int contadorSentencias = 0;
int linea = 1;

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
%token <cadena> SUFIJO_UNSIGNED
%token <cadena> SUFIJO_LONG
%token <cadena> SUFIJO_REAL
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

declaracionVariablesSimples:    TIPO_DATO listaVariablesSimples ';' {printf(" de tipo %s.", $<cadena>1);}
;

listaVariablesSimples:  unaVariableSimple       {printf("\nSe declara la variable %s", $<cadena>1);}
                        | listaVariablesSimples ',' unaVariableSimple {printf(", y la variable %s", $<cadena>3);}
;

unaVariableSimple:      IDENTIFICADOR opcionInicializacion      {strcpy($<cadena>$, $<cadena>1);}
;

opcionInicializacion:   /* vacio */
                        | OPER_ASIGNACION expCondicional
;



declaracionFunciones:   TIPO_DATO IDENTIFICADOR '(' opcionArgumentosConTipo ')' ';' {printf("\nSe declara la funcion %s de tipo %s que recibe %i parametro/s.", $<cadena>2, $<cadena>1, contadorParametros); contadorParametros = 0;}
;

opcionArgumentosConTipo:        /* vacio */ 
                                | TIPO_DATO opcionReferencia IDENTIFICADOR {contadorParametros++;}
                                | TIPO_DATO opcionReferencia IDENTIFICADOR ',' argumentosConTipo {contadorParametros++;}
;

argumentosConTipo:      TIPO_DATO opcionReferencia IDENTIFICADOR {contadorParametros++;}
                        | TIPO_DATO opcionReferencia IDENTIFICADOR ',' argumentosConTipo {contadorParametros++;}
;

opcionReferencia:       /* vacio */
                        | '&'
;

definicionFunciones:    TIPO_DATO IDENTIFICADOR '(' opcionArgumentosConTipo ')' sentencia {printf("\nSe define la funcion %s de tipo %s que recibe %i parametro/s.", $<cadena>2, $<cadena>1, contadorParametros); contadorParametros = 0;}

/* --------------------------------------------------------------------------------------
   -----------------------------GRAMATICA DE LAS SENTENCIAS------------------------------
   -------------------------------------------------------------------------------------- */

sentencia:      sentenciaCompuesta
                | sentenciaExpresion
                | sentenciaSeleccion
                | sentenciaIteracion
                | sentenciaSalto
;

sentenciaCompuesta:     '{' opcionListaDeclaraciones opcionListaSentencias '}'  {printf("\nSe encontro una sentencia compuesta con %i declaraciones y otras %i sentencias.", contadorDeclaraciones, contadorSentencias); contadorDeclaraciones = 0; contadorSentencias = 0;}
;

opcionListaDeclaraciones:       /* vacio */
                                | declaracion                           {contadorDeclaraciones++;}
                                | opcionListaDeclaraciones declaracion  {contadorDeclaraciones++;}
;

listaSentencias:        sentencia                       {contadorSentencias++;}
                        | listaSentencias sentencia     {contadorSentencias++;}
;

opcionListaSentencias:  /* vacio*/
                        | sentencia                     {contadorSentencias++;}
                        | listaSentencias sentencia     {contadorSentencias++;}
;

sentenciaExpresion:     ';'                     {printf("\nSe encontro una sentencia vacia.");}
                        | expresion ';'         {printf("\nSe encontro una sentencia expresion.");}
;

sentenciaSeleccion:     IF '(' expresion ')' sentencia                  {printf("\nSe encontro una sentencia de seleccion (if).");}
                        | IF '(' expresion ')' sentencia ELSE sentencia {printf("\nSe encontro una sentencia de seleccion (if y else).");}
                        | SWITCH '(' expresion ')' sentencia            {printf("\nSe encontro una sentencia de seleccion (switch).");}
;

sentenciaIteracion:     WHILE '(' expresion ')' sentencia                                               {printf("\nSe encontro una sentencia de iteracion (while).");}
                        | DO sentencia WHILE '(' expresion ')' ';'                                      {printf("\nSe encontro una sentencia de iteracion (do while).");}
                        | FOR '(' opcionExpresion ';' opcionExpresion ';' opcionExpresion ')' sentencia {printf("\nSe encontro una sentencia de iteracion (for).");}
;

sentenciaSalto: RETURN opcionExpresion ';'      {printf("\nSe encontro una sentencia de salto.");}
;

opcionExpresion:        /* vacio */
                        | expresion
;



/* --------------------------------------------------------------------------------------
   ----------------------------------GRAMATICA AUXILIAR----------------------------------
   -------------------------------------------------------------------------------------- */

constante:      CONSTANTE_DECIMAL sufijo_entero
                | CONSTANTE_OCTAL sufijo_entero
                | CONSTANTE_HEXADECIMAL sufijo_entero
                | CONSTANTE_REAL sufijo_real
                | CONSTANTE_CARACTER
;

sufijo_entero:  /* vacio */
                | SUFIJO_UNSIGNED
                | SUFIJO_LONG
;

sufijo_real:    /* vacio */
                | SUFIJO_REAL
;

%%

int main ()
{
        yyin = fopen("entrada.c", "r");
        yyparse ();
}
