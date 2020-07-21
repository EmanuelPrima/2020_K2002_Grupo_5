#include <math.h>
#include <string.h>
#include <stdlib.h>

int octalADecimal(int octal)
{
    int decimal = 0, i = 0;

    while(octal != 0)
    {
        decimal += (octal%10) * pow(8,i);
        ++i;
        octal/=10;
    }
    i = 1;
    return decimal;
}

int hexaADecimal(char hexVal[]) 
{    
    int len = strlen(hexVal); 
    int base = 1;      
    int dec_val = 0;       
    for (int i=len-1; i>=0; i--) 
    {    
        if (hexVal[i]>='0' && hexVal[i]<='9') 
        { 
            dec_val += (hexVal[i] - 48)*base; 
            base = base * 16; 
        } 

        else if (hexVal[i]>='A' && hexVal[i]<='F') 
        { 
            dec_val += (hexVal[i] - 55)*base; 
            base = base*16; 
        }
	else if (hexVal[i]>='a' && hexVal[i]<='f') 
        { 
            dec_val += (hexVal[i] - 87)*base; 
            base = base*16; 
        } 
    } 
      
    return dec_val; 
}

char* parteEntera(char* real)
{
	float valor = atof(real);
	char* parte_entera = malloc(30);
	sprintf(parte_entera, "%f", valor);
	int i = 0;
	for (i; parte_entera[i] != '.'; i++)
	{}
	parte_entera[i] = '\0';
	return parte_entera;
}

char* mantisa(char* real)
{
	float valor = atof(real);
	char* parte_mantisa = malloc(30);
	sprintf(parte_mantisa, "%f", valor);
	int i = 0;
	for (i; parte_mantisa[i] != '.'; i++)
	{}
	parte_mantisa = &parte_mantisa[i+1];
	char* ret = malloc(strlen(parte_mantisa)+3);
	strcpy(ret, "0.");
	strcat(ret, parte_mantisa);
	return ret;
}