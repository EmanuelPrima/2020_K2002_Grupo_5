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

%token <cadena> IDENTIFICADOR
%token <cadena> LITERAL_CADENA
%token <entero> CONSTANTE_DECIMAL
%token <entero> CONSTANTE_OCTAL
%token <entero> CONSTANTE_HEXADECIMAL
%token <real>   CONSTANTE_REAL
%token <entero> CONSTANTE_CARACTER
%token <cadena> SUFIJO_UNSIGNED
%token <cadena> SUFIJO_LONG
%token <cadena> OPER_ADITIVO
%token <cadena> OPER_MULTIPLICATIVO
%token <cadena> OPER_RELACIONAL
%token <cadena> OPER_UNARIO
%token <cadena> OPER_IGUALDAD
%token <cadena> OPER_ASIGNACION
%token <cadena> OPER_INCREMENTO
%token <cadena> AND
%token <cadena> OR

%type <cadena> expresion
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
%type <entero> constante
%type <cadena> sufijo_entero
%type <cadena> sufijo_real


%%

input:  /* vacio */
        | input line
;

line:   '\n'
        | expresion '\n'        {printf("\nSe leyo una expresion exitosamente.\n");}
;

expresion:      expAsignacion
;

expAsignacion:  expCondicional
                | expUnaria OPER_ASIGNACION expAsignacion
;

expCondicional: expOr
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
                | OPER_UNARIO expUnaria                         /* sin terminar*/
;

expPostfijo:    expPrimaria
                | expPostfijo '[' expresion ']'
                | expPostfijo '(' opcionListaArgumentos ')'
;

opcionListaArgumentos:  /* vacio */
                        | expAsignacion
                        | opcionListaArgumentos ',' expAsignacion
;

expPrimaria:    IDENTIFICADOR
                | constante
                | LITERAL_CADENA
                | '(' expresion ')'
;

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
