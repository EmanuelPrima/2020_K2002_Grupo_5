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

char* parteEntera (char* real)
{
	int len;
	char* p_entera;
	for (len=0; real[len] != '.'; len++)
	{
	}
	if (len == 0)
	{
		p_entera = malloc(sizeof(char)*2);
		p_entera = "0";
	}
	else
	{
		p_entera = malloc(sizeof(char)*(len+1));
		strcpy(p_entera, real);
		p_entera[len] = '\0';
	}
	return p_entera;
}

char* mantisa (char* real)
{
	int len;
	for (len=0; real[len] != '.'; len++)
	{
	}
	return (real+sizeof(char)*(len+1));
}