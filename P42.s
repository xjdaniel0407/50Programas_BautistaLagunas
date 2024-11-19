/*
 ============================================================================
 Título     : Conversión de hexadecimal a decimal en ARM64
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly Raspberry Pi OS
 ============================================================================
*/

/*
Solucion en C#

using System;

class Program {
    static void Main(string[] args) {
        string hexInput = "1A3F"; // Número hexadecimal
        int decimalValue = Convert.ToInt32(hexInput, 16); // Conversión a decimal
        Console.WriteLine($"El número hexadecimal {hexInput} es {decimalValue} en decimal.");
    }
}

*/

.global _start

.section .data
    hexInput:    .asciz "0x1A3F"        // Número hexadecimal a convertir
    fmt:         .asciz "El número hexadecimal %s es %d en decimal.\n"
    decimal:     .quad 0                // Almacena el valor decimal después de la conversión

.section .text
_start:
    // Llama a sscanf para convertir el número hexadecimal a decimal
    ldr x0, =hexInput                  // Dirección del string hexadecimal
    ldr x1, ="%x"                      // Formato de sscanf para hexadecimal
    ldr x2, =decimal                   // Almacena el resultado aquí
    bl sscanf                         // Llama a sscanf (convierte el valor)

    // Llama a printf para imprimir el resultado
    ldr x0, =fmt                       // Dirección del formato
    ldr x1, =hexInput                  // String original en hexadecimal
    ldr x2, [x2]                       // Carga el valor decimal
    bl printf                         // Llama a printf

    // Llama a exit(0) para terminar el programa
    mov w0, 0                          // Código de salida 0
    bl exit                           // Llama a exit

.section .rodata
    .asciz "%x"

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
