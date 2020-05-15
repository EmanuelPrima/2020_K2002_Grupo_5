#include <stdio.h>

int main()
{
    char expresion[100];
    for (int i=5; i>0; i--)
    {
        printf("---------------------------------------------------------------------------------------------\nIngresa una expresion: ");
        gets(expresion);
        printf("Vos pusiste: ");
        puts(expresion);
    }
    return 0;
}