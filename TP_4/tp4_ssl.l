%{
    #include "tp4_ssl.tab.h"
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
%}

option noyywrap


%%

"\n" {return '\n';}

"("|")"|"["|"]"|"," {return yytext[0];}

"++"|"--" {return OPER_INCREMENTO;}

"*"|"/"|"%" {return OPER_MULTIPLICATIVO;}

"+"|"-" {return OPER_ADITIVO;}

"&&" {return AND;}

"||" {return OR;}

">"|"<"|"<="|">=" {strcpy(yylval.cadena, yytext); return OPER_RELACIONAL;}

"=="|"!=" {return OPER_IGUALDAD;}

"="|"+="|"-=" {return OPER_ASIGNACION;}

[a-zA-Z_][a-zA-Z0-9_]* {strcpy(yylval.cadena, yytext); return IDENTIFICADOR;}

\"[^\"]*\" {strcpy(yylval.cadena, yytext); return LITERAL_CADENA;}

[1-9][0-9]* {yylval.entero = atoi(yytext); return CONSTANTE_DECIMAL;}

0[0-7]* {yylval.entero = atoi(yytext); return CONSTANTE_OCTAL;}

0[xX][0-9a-fA-F]+ {yylval.entero = atoi(yytext); return CONSTANTE_HEXADECIMAL;}

[0-9]+(\.)([eE][\+\-]?[0-9]+)? {yylval.real = strtol(yytext, NULL, 0); return CONSTANTE_REAL;}

[0-9]*(\.)[0-9]+([eE]([\+\-]?)[0-9]+)? {yylval.real = strtol(yytext, NULL, 0); return CONSTANTE_REAL;}

[uU][lL]? {return SUFIJO_UNSIGNED;}

[lL][uL]? {return SUFIJO_LONG;}

[fFlL] {return SUFIJO_REAL;}

\'[^']*\' {return CONSTANTE_CARACTER;}

.

%%