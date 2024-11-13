/*
Titulo: Suma de los N primeros números naturales	
Autor: Bautista Lagunas Jose Daniel 

*/

/*
Solucion en C#
using System;

class Program
{
    static void Main()
    {
        // Valor de N (puedes cambiar este valor según necesites)
        int N = 10;

        // Calcular la suma de los primeros N números naturales usando la fórmula Suma = N * (N + 1) / 2
        int suma = N * (N + 1) / 2;

        // Imprimir el resultado
        Console.WriteLine("La suma de los primeros {0} números naturales es: {1}", N, suma);

        // Salir del programa (en C#, no es necesario ningún código adicional para salir)
    }
}

*/

    .section .data
format_string: 
    .asciz "La suma de los primeros %d números naturales es: %d\n"

N: 
    .word 10  // Valor de N (puedes cambiar este valor según necesites)

    .section .text
    .global _start

_start:
    // Cargar el valor de N en un registro
    ldr x0, =N         // Cargar la dirección de N
    ldr w1, [x0]       // Cargar el valor de N en w1 (N)

    // Calcular la suma de los primeros N números naturales: Suma = N * (N + 1) / 2
    add w2, w1, 1      // w2 = N + 1
    mul w3, w1, w2     // w3 = N * (N + 1)

    // Cargar 2 en un registro para la división
    mov w4, 2          // Cargar 2 en w4

    // Realizar la división: Suma = (N * (N + 1)) / 2
    sdiv w5, w3, w4    // w5 = w3 / w4

    // Preparar argumentos para printf
    ldr x0, =format_string // Dirección de la cadena de formato
    mov w1, w1            // Primer parámetro: N
    mov w2, w5            // Segundo parámetro: Resultado de la suma

    // Llamar a printf
    bl printf

    // Salir del programa
    mov w0, 0            // Código de salida 0
    mov x8, 93           // Número de syscall para exit en ARM64
    svc 0                // Llamada al sistema

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
