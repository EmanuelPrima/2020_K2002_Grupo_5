typedef struct //declaro una estructura llamada dato
{
	int i;
	int* z;
} dato;

int main ()
{
	int a = 256, b = 065; //declaro un entero ;)
	char* str = "Hola mundo";
	int funcion(int valor_1, int valor_2);
	for (int i=0; i<=a; i++)
	{
		b = funcion(i, b); //esta funcion no sirve en realidad, pero bueno. que se le va a hacer?
	}
	a = b*2;
	str = "Chau mundo :(";
	str[a] = '\0';
	static char c_uno = 'a';
	volatile char c_dos = 'k'; //sin palabras. 
	dato dat;
	dat.i = sizeof(double);
	/* aca me inspire y decidi hacer un super comentario
	de muchas lineas,
	no puedo creerlo :D*/
	dat.z = &i;
	return (funcion(a, b) + 0x34356FF);
}