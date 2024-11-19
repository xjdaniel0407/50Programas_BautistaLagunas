/*
 ============================================================================
 Título     : Operaciones Bitwise AND, OR, XOR en ARM64 Assembly Raspberry Pi OS
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly que realiza operaciones AND, OR y XOR a nivel de bits y las imprime con printf.
 ============================================================================
*/

/*
Solucion en C#

using System;

class Program
{
    static void Main()
    {
        int a = 5;
        int b = 3;

        // Operación AND
        Console.WriteLine("Resultado de AND: " + (a & b));

        // Operación OR
        Console.WriteLine("Resultado de OR: " + (a | b));

        // Operación XOR
        Console.WriteLine("Resultado de XOR: " + (a ^ b));
    }
}
*/

.global _start

.section .data
    msg_and:      .asciz "Resultado de AND: %d\n"
    msg_or:       .asciz "Resultado de OR: %d\n"
    msg_xor:      .asciz "Resultado de XOR: %d\n"

.section .bss
    .comm result, 8   // Reservar espacio para un entero de 64 bits

.section .text
_start:
    // Operación AND: 5 & 3
    mov x0, #5           // Cargar 5 en x0
    mov x1, #3           // Cargar 3 en x1
    and x2, x0, x1       // AND entre x0 y x1, resultado en x2
    ldr x0, =msg_and     // Cargar dirección del mensaje de AND
    mov x1, x2           // Mover resultado de AND a x1 para printf
    bl printf            // Llamada a printf

    // Operación OR: 5 | 3
    mov x0, #5           // Cargar 5 en x0
    mov x1, #3           // Cargar 3 en x1
    orr x2, x0, x1       // OR entre x0 y x1, resultado en x2
    ldr x0, =msg_or      // Cargar dirección del mensaje de OR
    mov x1, x2           // Mover resultado de OR a x1 para printf
    bl printf            // Llamada a printf

    // Operación XOR: 5 ^ 3
    mov x0, #5           // Cargar 5 en x0
    mov x1, #3           // Cargar 3 en x1
    eor x2, x0, x1       // XOR entre x0 y x1, resultado en x2
    ldr x0, =msg_xor     // Cargar dirección del mensaje de XOR
    mov x1, x2           // Mover resultado de XOR a x1 para printf
    bl printf            // Llamada a printf

    // Salir del programa
    mov x0, #0           // Código de salida 0
    mov x8, #93          // Número de syscall para exit
    svc #0               // Hacer la llamada al sistema

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
