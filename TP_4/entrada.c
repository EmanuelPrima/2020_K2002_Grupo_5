int funcionLoca(int a, int b) { int nuevoValor = 56; return a + b / nuevoValor; }

void cumplirAnios(int &edadActual) { edadActual += 1; }

char genero = 'm';
int edad = 42, dni = 19355648;
float ahorroEnDolares = 2556.622;
int a = funcionLoca(edad, dni);
if (genero == 'm') { printf("es mujer"); } else printf("es varon");
while (edad < 18 && dni >= 40000000) cumplirAnios(edad);
char fun1(int m, int k, char c);
int fun2(float f);

