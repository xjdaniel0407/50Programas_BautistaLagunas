/*
 ============================================================================
 Título     : Serie de Fibonacci en ARM64 Assembly
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly para Raspberry Pi OS que calcula e 
              imprime los primeros n términos de la Serie de Fibonacci.
 ============================================================================
*/

/*
Solucion en C#

using System;

class Program
{
    static void Main()
    {
        int numTerms = 10; // Número de términos de la Serie de Fibonacci
        int a = 0, b = 1;

        for (int i = 0; i < numTerms; i++)
        {
            Console.WriteLine($"Fibonacci({i}) = {a}");
            int next = a + b;
            a = b;
            b = next;
        }
    }
}
*/

.section .data
num_terms:    .quad 10                     // Número de términos de Fibonacci a calcular
format_str:   .asciz "Fibonacci(%d) = %d\n" // Formato para printf

.section .text
.global main
.extern printf                             // Declarar printf como una función externa

main:
    // Cargar el número de términos de Fibonacci a calcular
    ldr x1, =num_terms                     // Cargar la dirección del número de términos en x1
    ldr x2, [x1]                           // Cargar el valor en x2 (cantidad de términos)
    
    // Inicializar Fibonacci
    mov x0, 0                              // F(0) = 0
    mov x1, 1                              // F(1) = 1
    mov x3, 0                              // Contador (empezamos desde F(0))

fibonacci_loop:
    cmp x3, x2                             // Comparar el contador con el número de términos
    bge end_fibonacci                      // Si hemos alcanzado el límite, salir del bucle

    // Preparar llamada a printf para imprimir el término actual
    ldr x4, =format_str                    // Dirección de la cadena de formato en x4
    mov x5, x3                             // Pasar el índice como argumento en x5
    mov x6, x0                             // Pasar el valor de Fibonacci como argumento en x6
    mov x0, x4                             // Cadena de formato como primer argumento para printf
    mov x1, x5                             // Índice como segundo argumento para printf
    mov x2, x6                             // Valor Fibonacci como tercer argumento para printf
    bl printf                              // Llamada a printf

    // Calcular el siguiente término de Fibonacci
    add x7, x0, x1                         // x7 = x0 + x1 (nuevo valor de Fibonacci)
    mov x0, x1                             // x0 = x1 (actualizamos al siguiente valor)
    mov x1, x7                             // x1 = x7 (nuevo valor Fibonacci)

    // Incrementar el contador
    add x3, x3, 1
    b fibonacci_loop                       // Repetir el bucle

end_fibonacci:
    // Salir del programa
    mov x8, 93                             // syscall 93 es exit
    mov x0, 0                              // Código de salida 0
    svc 0

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
