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

void yyerror (char const *s) {
   fprintf (stderr, "%s\n", s);
}

%}

%union {
char cadena[30];
int entero;
int tipo;
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

%type <cadena> expresion
%type <cadena> opcionExpresion
%type <cadena> expAsignacion
%type <cadena> expCondicional
%type <cadena> expOr
%type <cadena> expAnd
%type <cadena> expIgualdad
%type <cadena> expRelacional
%type <cadena> expAditiva
%type <cadena> expMultiplicativa
%type <cadena> expUnaria
%type <cadena> expPostfijo
%type <cadena> opcionListaArgumentos
%type <cadena> expPrimaria

%type <cadena> declaracion
%type <cadena> declaracionVariablesSimples
%type <cadena> declaracionFunciones
%type <cadena> listaVariablesSimples
%type <cadena> unaVariableSimple
%type <cadena> opcionInicializacion
%type <cadena> opcionArgumentosConTipo
%type <cadena> argumentosConTipo

%type <cadena> sentencia
%type <cadena> sentenciaCompuesta
%type <cadena> sentenciaExpresion
%type <cadena> sentenciaIteracion
%type <cadena> sentenciaSalto
%type <cadena> sentenciaSeleccion
%type <cadena> opcionListaDeclaraciones
%type <cadena> opcionListaSentencias

%type <entero> constante
%type <cadena> sufijo_entero
%type <cadena> sufijo_real


%%

input:  /* vacio */
        | input line
;

line:   '\n'
        | expresion '\n'        {printf("\nSe leyo una expresion exitosamente.\n");}
        | declaracion '\n'      {printf("\nSe leyo una declaracion exitosamente.\n");}
        | sentencia '\n'        {printf("\nSe leyo una sentencia exitosamente.\n");}
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
;

declaracionVariablesSimples:    TIPO_DATO listaVariablesSimples ';'
;

listaVariablesSimples:  unaVariableSimple
                        | listaVariablesSimples ',' unaVariableSimple
;

unaVariableSimple:      IDENTIFICADOR opcionInicializacion
;

opcionInicializacion:   /* vacio */
                        | OPER_ASIGNACION expCondicional
;



declaracionFunciones:   TIPO_DATO IDENTIFICADOR '(' opcionArgumentosConTipo ')' ';'
;

opcionArgumentosConTipo:        /* vacio */
                                | TIPO_DATO IDENTIFICADOR
                                | TIPO_DATO IDENTIFICADOR ',' argumentosConTipo
;

argumentosConTipo:      TIPO_DATO IDENTIFICADOR
                        | TIPO_DATO IDENTIFICADOR ',' argumentosConTipo
;

/* --------------------------------------------------------------------------------------
   -----------------------------GRAMATICA DE LAS SENTENCIAS-----------------------------
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
