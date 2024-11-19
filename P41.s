/*
 ============================================================================
 Título     : Conversión de decimal a hexadecimal
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly Raspberry Pi OS
 ============================================================================
*/

/*
Solución en C#

// Conversión de decimal a hexadecimal en C#
using System;

class Program
{
    static void Main(string[] args)
    {
        int decimalNumber = 12345; // Número decimal
        string hexValue = decimalNumber.ToString("X"); // Conversión a hexadecimal
        Console.WriteLine($"El número en hexadecimal es: 0x{hexValue}");
    }
}
*/

.section .data
inputNumber:    .word 12345                // Número decimal a convertir
formatString:   .asciz "El número en hexadecimal es: 0x%X\n"

.section .text
.global _start

_start:
    // Cargar número decimal en el registro
    ldr r0, =inputNumber       // Dirección del número
    ldr w1, [r0]               // Cargar el valor del número decimal en w1

    // Configurar parámetros para printf
    ldr x0, =formatString      // Dirección de la cadena de formato
    mov w2, w1                 // Mover el número decimal a w2 para convertirlo a hexadecimal

    // Llamar a printf
    bl printf                  // printf("El número en hexadecimal es: 0x%X", número)

    // Finalizar el programa
    mov w8, 93                 // Código de syscall para exit (93 en ARM64)
    mov x0, 0                  // Código de salida (0 = éxito)
    svc 0                      // Llamar al sistema

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
