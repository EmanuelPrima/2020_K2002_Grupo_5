%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "listas.h"
    #include "convertidor.h"
    
    Nodo* listaIdentificadores = NULL;
    Nodo* listaLiteralesCadena = NULL;
    Nodo* listaPalabrasReservadas = NULL;
    Nodo* listaConstantesDec = NULL;
    Nodo* listaConstantesOct = NULL;
    Nodo* listaConstantesHex = NULL;
    Nodo* listaConstantesReales = NULL;
    Nodo* listaConstantesCaracter = NULL;
    Nodo* listaOperadoresYPuntuacion = NULL;
    Nodo* listaComentarios = NULL;
    Nodo* listaNoReconocidos = NULL;

    Nodo* aux;

    const char* tiposPalabrasReservadas[4] = {"tipo de dato", "estructura de control", "modificador", "miscelaneo"};
    const char* tiposComentarios[2] = {"comentario simple", "comentario de multiples lineas"};

    int acumuladorDecimales = 0;
    int indiceCaracteres = 1;

    int num_linea = 1;
%}

%%

\n {num_linea++;}

"//".*$ {aux = listAdd(&listaComentarios, yytext); aux->valor = 0;}

"/*"[^"*/"]*"*/" {aux = listAdd(&listaComentarios, yytext); aux->valor = 1;}

"char"|"double"|"enum"|"float"|"int"|"void" {aux = listAdd(&listaPalabrasReservadas, yytext); aux->valor = 0;}

"break"|"case"|"continue"|"default"|"do"|"else"|"for"|"goto"|"if"|"return"|"switch"|"while" {aux = listAdd(&listaPalabrasReservadas, yytext); aux->valor = 1;}

"auto"|"const"|"extern"|"long"|"register"|"short"|"signed"|"static"|"unsigned"|"volatile" {aux = listAdd(&listaPalabrasReservadas, yytext); aux->valor = 2;}

"sizeof"|"struct"|"typedef"|"union" {aux = listAdd(&listaPalabrasReservadas, yytext); aux->valor = 3;}

[a-zA-Z_][a-zA-Z0-9_]* {aux = listInsert1(&listaIdentificadores, yytext, criterio_abc); aux->valor++;}

\".*\" {aux = listAdd(&listaLiteralesCadena, yytext); aux->valor = yyleng - 2;}

[1-9][0-9]* {listAdd(&listaConstantesDec, yytext); acumuladorDecimales = acumuladorDecimales + atoi(yytext);}

0[0-7]* {aux = listAdd(&listaConstantesOct, yytext); aux->valor = octalADecimal(atoi(aux->str));}

0[xX][0-9a-fA-F]+ {aux = listAdd(&listaConstantesHex, yytext); aux->valor = hexaADecimal((aux->str)+2);}

[0-9]+(\.)([eE][\+\-]?[0-9]+)? {listAdd(&listaConstantesReales, yytext);}

[0-9]*(\.)[0-9]+([eE]([\+\-]?)[0-9]+)? {listAdd(&listaConstantesReales, yytext);}

\'\\?.\' {aux = listAdd(&listaConstantesCaracter, yytext); aux->valor = indiceCaracteres; indiceCaracteres++;}

"#"|"%"|")"|"-"|";"|"?"|"]"|"&"|"*"|"."|"<"|"@"|"^"|"'"|"+"|"/"|"="|"["|"_"|"("|","|":"|">"|">="|"<="|"=="|"&&"|"||"|"++"|"--"|"!="|"<<"|"<<="|">>"|">>="|"~"|"&="|"|="|"^="|"->"|"->*"|".*"|"{"|"}"|"$"|" "|"\t" {aux = listAdd1(&listaOperadoresYPuntuacion, yytext); aux->valor++;}

. {aux = listAdd(&listaNoReconocidos, yytext); aux->valor = num_linea;}

%%

int main ()
{
    yyin = fopen("entrada.c", "r");
    yylex();
    FILE* fsalida = fopen("reporte.txt", "w");
    char* valorStr;

    fputs("----:IDENTIFICADORES:----\n", fsalida);
    aux = listaIdentificadores;
    while (aux != NULL)
    {
        fputs(aux->str, fsalida);
        itoa(aux->valor, valorStr, 10);
        fputs("\t-> ocurrencias: ", fsalida);
        fputs(valorStr, fsalida);
        fputs(".\n", fsalida);
        aux = (void*)aux->sig;
    }

    fputs("\n----:LITERALES CADENA:----\n", fsalida);
    aux = listaLiteralesCadena;
    while (aux != NULL)
    {
        fputs(aux->str, fsalida);
        itoa(aux->valor, valorStr, 10);
        fputs("\t-> longitud de cadena: ", fsalida);
        fputs(valorStr, fsalida);
        fputs(".\n", fsalida);
        aux = (void*)aux->sig;
    }

    fputs("\n----:PALABRAS RESERVADAS:----\n", fsalida);
    aux = listaPalabrasReservadas;
    while (aux != NULL)
    {
        fputs(aux->str, fsalida);
        fputs(" (", fsalida);
        fputs(tiposPalabrasReservadas[aux->valor], fsalida);
        fputs(").\n", fsalida);
        aux = (void*)aux->sig;
    }

    fputs("\n----:CONSTANTES DECIMALES:----\n", fsalida);
    aux = listaConstantesDec;
    while (aux != NULL)
    {
        fputs(aux->str, fsalida);
        fputs(" -> valor: ", fsalida);
        fputs(aux->str, fsalida);
        fputs(".\n", fsalida);
        aux = (void*)aux->sig;
    }
    fputs("Suma total: ", fsalida);
    itoa(acumuladorDecimales, valorStr, 10);
    fputs(valorStr, fsalida);

    fputs("\n\n----:CONSTANTES OCTALES:----\n", fsalida);
    aux = listaConstantesOct;
    while (aux != NULL)
    {
        fputs(aux->str, fsalida);
        fputs(" -> valor: ", fsalida);
        itoa(aux->valor, valorStr, 10);
        fputs(valorStr, fsalida);
        fputs(".\n", fsalida);
        aux = (void*)aux->sig;
    }

    fputs("\n----:CONSTANTES HEXADECIMALES:----\n", fsalida);
    aux = listaConstantesHex;
    while (aux != NULL)
    {
        fputs(aux->str, fsalida);
        fputs(" -> valor: ", fsalida);
        itoa(aux->valor, valorStr, 10);
        fputs(valorStr, fsalida);
        fputs(".\n", fsalida);
        aux = (void*)aux->sig;
    }

    fputs("\n----:CONSTANTES REALES:----\n", fsalida);
    aux = listaConstantesReales;
    while (aux != NULL)
    {
        fputs(aux->str, fsalida);
        fputs("\t-> parte entera: ", fsalida);
        fputs(parteEntera(aux->str), fsalida);
        fputs(", mantisa: ", fsalida);
        fputs(mantisa(aux->str), fsalida);
        fputs(".\n", fsalida);
        aux = (void*)aux->sig;
    }

    fputs("\n----:CONSTANTES CARACTER:----\n", fsalida);
    aux = listaConstantesCaracter;
    while (aux != NULL)
    {
        itoa(aux->valor, valorStr, 10);
        fputs(valorStr, fsalida);
        fputs(": ", fsalida);
        fputs(aux->str, fsalida);
        fputs(".\n", fsalida);
        aux = (void*)aux->sig;
    }

    fputs("\n----:OPERADORES Y CARACTERES DE PUNTUACION----\n", fsalida);
    aux = listaOperadoresYPuntuacion;
    while (aux != NULL)
    {
        fputs(aux->str, fsalida);
        fputs("\t-> ocurrencias: ", fsalida);
        itoa(aux->valor, valorStr, 10);
        fputs(valorStr, fsalida);
        fputs(".\n", fsalida);
        aux = (void*)aux->sig;
    }

    fputs("\n----:COMENTARIOS:----\n", fsalida);
    aux = listaComentarios;
    while (aux != NULL)
    {
        fputs(aux->str, fsalida);
        fputs(" (", fsalida);
        fputs(tiposComentarios[aux->valor], fsalida);
        fputs(").\n", fsalida);
        aux = (void*)aux->sig;
    }

    fputs("\n----:CARACTERES NO RECONOCIDOS:----\n", fsalida);
    aux = listaNoReconocidos;
    while (aux != NULL)
    {
        fputs(aux->str, fsalida);
        fputs(" en la linea ", fsalida);
        itoa(aux->valor, valorStr, 10);
        fputs(valorStr, fsalida);
        fputs(".\n", fsalida);
        aux = (void*)aux->sig;
    }

    fclose(fsalida);
    return 0;
}