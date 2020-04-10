
#include <stdio.h>
#include <stdlib.h>

#define Q0 0
#define Q1 1
#define Q2 2
#define Q3 3
#define Q4 4
#define Q5 5
#define RECHAZO 6

int del_1_al_7(int numero);
int letras_posibles(int numero);
int ocho_y_nueve(int numero);
int todo_menos_xX(int numero);
int definir_numero(int numero);


int main(){
    int estado = Q0;
    FILE * flujo = fopen("entrada.txt", "rb");
    FILE * flujo_2 = fopen("salida.txt", "w");
   if  (flujo == NULL){
       perror("error en la apertura del archivo\n");
       return 1;
   }
   
    int c = getchar();
    
   while(feof (flujo) == 0) {
       while(c != '\n'){
       	while (c!= ','){
       		definir_numero(c);
		   }
		   
	  }

   }

   fclose (flujo);
   
   return 0;
}

int definir_numero(int numero){
	int estado = Q0;
            switch(estado){
	  	        case Q0:
	  		     if(del_1_al_7(numero) == 1 || ocho_y_nueve(numero) == 1)
			      estado = Q1;
			     else if (numero== 0){
			       estado = Q2;
				   }
				 else {estado = RECHAZO;};
				   
			      break;
			 
	            case Q1:
	    	       if (numero == 0 || del_1_al_7(numero) == 1 || ocho_y_nueve(numero) == 1)
	    	         estado = Q1;
	    	       else {estado = RECHAZO;};
	    	       break;
	    	       
	    	    case Q2:
	    	     if (numero == 0 || del_1_al_7(numero) == 1)
	    	     	estado = Q1;
	    	     else if (numero == 'x' || numero == 'X') { 
	    	        estado = Q3;}
	    	     else { estado = RECHAZO;};
				 break;
				 
				case Q3:
				 if(todo_menos_xX(numero) == 1)
                  estado = Q4;
                 else estado = RECHAZO;
                 break;
                 
                case Q4:
                 if(todo_menos_xX(numero) == 1)
                  estado = Q4;
                 else estado = RECHAZO;
                 break;
                 
                case Q5:
                 if (numero == 0 || del_1_al_7(numero) == 1)
                	 estado = Q5;
                 else estado = RECHAZO;
                 break;
				 
				 } 
				 
	   return estado;	    
}

int del_1_al_7(int numero){
	int retorno = 0;
	int i;
	for(i = 1; i<8; i++){
	 if (numero == i){
	 	retorno = 1;
	 };
	}
	
	return retorno;
}

int ocho_y_nueve(int numero){
	int retorno = 0;
	 if (numero == 8 || numero == 9)
	  retorno = 1;
	return retorno;
}

int todo_menos_xX(int numero){
	int retorno = 0;
	 if(ocho_y_nueve(numero) == 1 || del_1_al_7(numero) == 1 || numero == 0 || letras_posibles(numero) == 1)
	  retorno = 1;
	  
	return retorno;
}

int letras_posibles(int numero){
	char letras[16]= {'a','b','c','d','e','f','A','B','C','D','E','F'};
	int i;
	int retorno = 0;
	
	for (i=0;i<15;i++){
		if(letras[i] == numero){
			retorno = 1;
		}
	}
	
	return retorno;
}