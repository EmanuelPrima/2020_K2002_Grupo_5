#include <stdio.h>

const int pilaMax = 5;
typedef struct
{
    int estadoSiguiente;
    char* cadenaAPushear;
} EstadoSiguiente;

void meterString(char strResultado[5], char strAMeter[5])
{
    int i;
    for (i=0; strAMeter[i] != '\0'; i++)
    {
        strResultado[i] = strAMeter[i];
    }
    strResultado[i] = '\0';
}

int ultimoElemento(char pila[pilaMax])
{
    int n;
    for (n=0; pila[n] != '\0'; n++)
    {}
    return n-1;
}

char pop (char pila[pilaMax])
{
    char primerElemento = pila[0];
    for (int i=0; i<pilaMax; i++)
    {
        pila[i] = pila[i+1];
    }
    pila[pilaMax] = '\0';
    return primerElemento;
}

void push (char pila[pilaMax], char caracter)
{
    for (int i=pilaMax; i>0; i--)
    {
        pila[i] = pila[i-1];
    }
    pila[0] = caracter;
}

void pushString (char pila[pilaMax], char string[5])
{
    int cantidadElementos = 0;
    for (int i=0; string[i] != '\0'; i++)
    {
        cantidadElementos++;
    }
    for (cantidadElementos; cantidadElementos > 0; cantidadElementos--)
    {
        push(pila, string[cantidadElementos-1]);
    }
}

int determinarColumna(char c)
{
    int retorno;
    if (c == '0')
        retorno = 0;
    else if (c >= '1' && c <= '9')
        retorno = 1;
    else if (c == '+' || c == '-' || c == '*' || c == '/')
        retorno = 2;
    else if (c == '(')
        retorno = 3;
    else if (c == ')')
        retorno = 4;
    else
        retorno = 5;
    return retorno;
}

int determinarPila (char c)
{
    int retorno = -1;
    if (c == '$')
        retorno = 0;
    else if (c == 'R')
        retorno = 1;
    return retorno;
}

int procesarExpresion (char expresion[100], EstadoSiguiente automata[4][2][6])
{
    char pila[5] = {'$', '\0', '\0', '\0', '\0'};
    int estadoActual = 0;
    EstadoSiguiente estadoSig;
    char caracterActual;
    char cima;
    int valorCima;
    int columna;
    char cadena[5];
    for (int i=0; expresion[i] != '\0'; i++)
    {
        caracterActual = expresion[i];
        cima = pop(pila);
        valorCima = determinarPila(cima);
        columna = determinarColumna(caracterActual);
        estadoSig = automata[estadoActual][valorCima][columna];
        estadoActual = estadoSig.estadoSiguiente;
        pushString(pila, estadoSig.cadenaAPushear);
    }
    cima = pop(pila);
    int retorno;
    if (estadoActual == 1 && cima == '$' || estadoActual == 2 && cima == '$')
        retorno = 0;
    else
        retorno = 1;
    return retorno;
}

int main()
{
    EstadoSiguiente automata[4][2][6];
    automata[0][0][0].estadoSiguiente = 3; automata[0][0][0].cadenaAPushear = ""; automata[0][0][1].estadoSiguiente = 1; automata[0][0][1].cadenaAPushear = "$"; automata[0][0][2].estadoSiguiente = 3; automata[0][0][2].cadenaAPushear = ""; automata[0][0][3].estadoSiguiente = 0; automata[0][0][3].cadenaAPushear = "R$"; automata[0][0][4].estadoSiguiente = 3; automata[0][0][4].cadenaAPushear = ""; automata[0][0][5].estadoSiguiente = 3; automata[0][0][5].cadenaAPushear = "";
    automata[1][0][0].estadoSiguiente = 1; automata[1][0][0].cadenaAPushear = "$"; automata[1][0][1].estadoSiguiente = 1;automata[1][0][1].cadenaAPushear = "$"; automata[1][0][2].estadoSiguiente = 0; automata[1][0][2].cadenaAPushear = "$"; automata[1][0][3].estadoSiguiente = 3; automata[1][0][3].cadenaAPushear = ""; automata[1][0][4].estadoSiguiente = 3; automata[1][0][4].cadenaAPushear = ""; automata[1][0][5].estadoSiguiente = 3; automata[1][0][5].cadenaAPushear = "";
    automata[0][1][0].estadoSiguiente = 3; automata[0][1][0].cadenaAPushear = ""; automata[0][1][1].estadoSiguiente = 1; automata[0][1][1].cadenaAPushear = "R"; automata[0][1][2].estadoSiguiente = 3; automata[0][1][2].cadenaAPushear = ""; automata[0][1][3].estadoSiguiente = 0; automata[0][1][3].cadenaAPushear = "RR"; automata[0][1][4].estadoSiguiente = 3; automata[0][1][4].cadenaAPushear = ""; automata[0][1][5].estadoSiguiente = 3; automata[0][1][5].cadenaAPushear ="";
    automata[1][1][0].estadoSiguiente = 1; automata[1][1][0].cadenaAPushear = "R"; automata[1][1][1].estadoSiguiente = 1; automata[1][1][1].cadenaAPushear = "R"; automata[1][1][2].estadoSiguiente = 0; automata[1][1][2].cadenaAPushear= "R"; automata[1][1][3].estadoSiguiente = 3; automata[1][1][3].cadenaAPushear = ""; automata[1][1][4].estadoSiguiente = 2; automata[1][1][4].cadenaAPushear = ""; automata[1][1][5].estadoSiguiente = 3; automata[1][1][5].cadenaAPushear = "";
    automata[2][1][0].estadoSiguiente = 3; automata[2][1][0].cadenaAPushear = "";  automata[2][1][1].estadoSiguiente = 3; automata[2][1][1].cadenaAPushear = ""; automata[2][1][2].estadoSiguiente = 0; automata[2][1][2].cadenaAPushear = "R"; automata[2][1][3].estadoSiguiente = 3; automata[2][1][3].cadenaAPushear = ""; automata[2][1][4].estadoSiguiente = 2; automata[2][1][4].cadenaAPushear = ""; automata[2][1][5].estadoSiguiente = 3; automata[2][1][5].cadenaAPushear = "";
    automata[2][0][0].estadoSiguiente = 3; automata[2][0][0].cadenaAPushear = ""; automata[2][0][1].estadoSiguiente = 3; automata[2][0][1].cadenaAPushear = ""; automata[2][0][2].estadoSiguiente = 0; automata[2][0][2].cadenaAPushear = "$"; automata[2][0][3].estadoSiguiente = 3; automata[2][0][3].cadenaAPushear = ""; automata[2][0][4].estadoSiguiente = 3; automata[2][0][4].cadenaAPushear = ""; automata[2][0][5].estadoSiguiente = 3; automata[2][0][5].cadenaAPushear = "";
    char resultado[2][100] = {"La expresion ingresada es sintacticamente correcta.", "La expresion ingresada tiene errores."};
    int indiceResultado = 0;
    char expresion[100];
    printf("~~~ Bienvienidos al TP 2 de Sintaxis y Semantica de los Lenguajes del grupo 5 ~~~\n\nEl programa va a terminar al momento de ingresar una expresion sintacticamente incorrecta.\n");
    while (indiceResultado != 1)
    {
        printf("\n---------------------------------------------------------------------------------------------\n\nIngresa una expresion: ");
        gets(expresion);
        indiceResultado = procesarExpresion(expresion, automata);
        printf(resultado[indiceResultado]);
        printf("\n");
    }
    printf("Terminando programa...");
    return 0;
}