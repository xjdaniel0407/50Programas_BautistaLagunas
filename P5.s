/*
 ============================================================================
 Título     : División de dos números		
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly Raspberry Pi OS
 ============================================================================
*/

/*
Solucion en C#
using System;

class Program
{
    static void Main()
    {
        // Definir los valores para la división
        int num1 = 40;  // Dividendo
        int num2 = 5;   // Divisor

        // Realizar la división
        int result = num1 / num2;

        // Imprimir el resultado en la consola
        Console.WriteLine($"El resultado de la división de {num1} entre {num2} es: {result}");
    }
}

*/

    .section .data
format_string: 
    .asciz "El resultado de la división de %d entre %d es: %d\n"

num1: 
    .word 40  // Primer número (dividendo)
num2: 
    .word 5   // Segundo número (divisor)

    .section .text
    .global _start

_start:
    // Cargar valores de num1 y num2 en registros
    ldr x0, =num1        // Cargar dirección de num1
    ldr w1, [x0]         // Cargar valor de num1 en w1

    ldr x0, =num2        // Cargar dirección de num2
    ldr w2, [x0]         // Cargar valor de num2 en w2

    // Realizar la división
    udiv w3, w1, w2      // w3 = w1 / w2 (división sin signo)

    // Preparar argumentos para printf
    ldr x0, =format_string // Dirección de la cadena de formato
    mov w1, w1            // Primer argumento: dividendo
    mov w2, w2            // Segundo argumento: divisor
    mov w3, w3            // Tercer argumento: resultado de la división

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
