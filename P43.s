/*
 ============================================================================
 Título     : Calculadora Simple (Suma, Resta, Multiplicación, División)
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly Raspberry Pi OS
 ============================================================================
*/

/*
Solución en C#

using System;

class Program
{
    static void Main(string[] args)
    {
        int num1 = 10;
        int num2 = 5;

        Console.WriteLine("Resultado de la suma: " + (num1 + num2));
        Console.WriteLine("Resultado de la resta: " + (num1 - num2));
        Console.WriteLine("Resultado de la multiplicación: " + (num1 * num2));
        Console.WriteLine("Resultado de la división: " + (num1 / num2));
    }
}
*/

.section .data
    mensaje_suma:      .asciz "Resultado de la suma: %d\n"
    mensaje_resta:     .asciz "Resultado de la resta: %d\n"
    mensaje_multiplicacion: .asciz "Resultado de la multiplicación: %d\n"
    mensaje_division:  .asciz "Resultado de la división: %d\n"

.section .text
    .global _start

_start:
    // Inicialización de valores
    ldr x0, =10        // Primer número
    ldr x1, =5         // Segundo número

    // Suma
    add x2, x0, x1     // x2 = x0 + x1
    ldr x3, =mensaje_suma
    mov x8, x2         // Resultado en x8
    bl imprimir

    // Resta
    sub x2, x0, x1     // x2 = x0 - x1
    ldr x3, =mensaje_resta
    mov x8, x2         // Resultado en x8
    bl imprimir

    // Multiplicación
    mul x2, x0, x1     // x2 = x0 * x1
    ldr x3, =mensaje_multiplicacion
    mov x8, x2         // Resultado en x8
    bl imprimir

    // División
    udiv x2, x0, x1    // x2 = x0 / x1
    ldr x3, =mensaje_division
    mov x8, x2         // Resultado en x8
    bl imprimir

    // Salir del programa
    mov x8, 60         // syscall: exit
    mov x0, 0          // status 0
    svc 0

// Subrutina para imprimir usando printf
imprimir:
    mov x0, x3         // Dirección del mensaje
    mov x1, x8         // Valor a imprimir
    bl printf          // Llamar a printf
    ret

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
