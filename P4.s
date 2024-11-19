/*
 ============================================================================
 Título     : Multiplicación de dos números	
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
        // Definición de los dos números a multiplicar
        int num1 = 6;  // Primer número
        int num2 = 7;  // Segundo número

        // Realizar la multiplicación
        int resultado = num1 * num2;

        // Imprimir el resultado
        Console.WriteLine("El resultado de la multiplicación es: {0}", resultado);
        
        // Salir del programa
        Environment.Exit(0);
    }
}

*/

    .section .data
format_string: 
    .asciz "El resultado de la multiplicación es: %d\n"

num1: 
    .word 6  // Primer número
num2: 
    .word 7  // Segundo número

    .section .text
    .global _start

_start:
    // Cargar valores de num1 y num2 en registros
    ldr x0, =num1        // Cargar dirección de num1
    ldr w1, [x0]         // Cargar valor de num1 en w1

    ldr x0, =num2        // Cargar dirección de num2
    ldr w2, [x0]         // Cargar valor de num2 en w2

    // Realizar la multiplicación
    mul w3, w1, w2       // w3 = w1 * w2

    // Preparar argumentos para printf
    ldr x0, =format_string // Dirección de la cadena de formato
    mov w1, w3            // Resultado de la multiplicación

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
