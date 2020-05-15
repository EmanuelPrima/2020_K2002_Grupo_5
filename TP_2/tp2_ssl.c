#include <stdio.h>

const int pilaMax = 5;
char pila[5] = {'$', 0, 0, 0, 0};

struct EstadoSiguiente
{
    int estadoSiguiente;
    char cadenaAPushear[5];
};

void meterString(char str1[5], char str2[5])
{
    for (int i=0; str2[i] != '\0'; i++)
    {
        str1[i] = str2[i];
    }
}

struct EstadoSiguiente estadoSiguienteCreate(int es, char cad[5])
{
    struct EstadoSiguiente e;
    e.estadoSiguiente = es;
    meterString(e.cadenaAPushear, cad);
    return e;
}

char pop (char pila[pilaMax])
{
    char c = pila[0];
    for (int i=0; 1<pilaMax; i++)
    {
        pila[i] = pila[i+1];
    }
    return c;
}

void push (char pila[pilaMax], char caracter)
{
    for (int i=pilaMax; i>0; i--)
    {
        pila[i] = pila[i-1];
    }
    pila[0] = caracter;
}

int main()
{
    struct EstadoSiguiente automata[4][2][6];
    automata[0][0][0] = estadoSiguienteCreate(3, ""); automata[0][0][1] = estadoSiguienteCreate(1, "$"); automata[0][0][2] = estadoSiguienteCreate(3, ""); automata[0][0][3] = estadoSiguienteCreate(0, "R$"); automata[0][0][4] = estadoSiguienteCreate(3, ""); automata[0][0][5] = estadoSiguienteCreate(3, ""); 
    automata[1][0][0] = estadoSiguienteCreate(1, "$"); automata[1][0][1] = estadoSiguienteCreate(1, "$"); automata[1][0][2] = estadoSiguienteCreate(0, "$"); automata[1][0][3] = estadoSiguienteCreate(3, ""); automata[1][0][4] = estadoSiguienteCreate(3, ""); automata[1][0][5] = estadoSiguienteCreate(3, "");
    automata[0][1][0] = estadoSiguienteCreate(3, "");  automata[0][1][1] = estadoSiguienteCreate(1, "R"); automata[0][1][2] = estadoSiguienteCreate(3, ""); automata[0][1][3] = estadoSiguienteCreate(0, "RR"); automata[0][1][4] = estadoSiguienteCreate(3, ""); automata[0][1][5] = estadoSiguienteCreate(3, ""); 
    automata[1][1][0] = estadoSiguienteCreate(1, "R"); automata[1][1][1] = estadoSiguienteCreate(1, "R"); automata[1][1][2] = estadoSiguienteCreate(0, "R"); automata[1][1][3] = estadoSiguienteCreate(3, ""); automata[1][1][4] = estadoSiguienteCreate(2, ""); automata[1][1][5] = estadoSiguienteCreate(3, "");
    automata[2][1][0] = estadoSiguienteCreate(3, ""); automata[2][1][1] = estadoSiguienteCreate(3, ""); automata[2][1][2] = estadoSiguienteCreate(0, "R"); automata[2][1][3] = estadoSiguienteCreate(3, ""); automata[2][1][4] = estadoSiguienteCreate(2, ""); automata[2][1][5] = estadoSiguienteCreate(3, "");
    automata[2][0][0] = estadoSiguienteCreate(3, ""); automata[2][0][1] = estadoSiguienteCreate(3, ""); automata[2][0][2] = estadoSiguienteCreate(0, "$"); automata[2][0][3] = estadoSiguienteCreate(3, ""); automata[2][0][4] = estadoSiguienteCreate(3, ""); automata[2][0][5] = estadoSiguienteCreate(3, ""); 
    
    char expresion[100];
    for (int i=5; i>0; i--)
    {
        printf("---------------------------------------------------------------------------------------------\nIngresa una expresion: ");
        gets(expresion);
        printf("Vos pusiste: ");
        puts(expresion);
    }
    printf("FIN :)");
    return 0;
}