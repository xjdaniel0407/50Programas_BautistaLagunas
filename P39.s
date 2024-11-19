/*
 ============================================================================ 
 Título     : Conversión de Decimal a Binario en ARM64 Assembly	
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly para convertir un número decimal a binario 
              y mostrarlo utilizando printf en Raspberry Pi OS
 ============================================================================ 
*/

/*
Solución en C#

using System;

class Program
{
    static void Main()
    {
        int decimalNumber = 13;  // Número decimal a convertir
        string binaryString = Convert.ToString(decimalNumber, 2);  // Convertir a binario
        Console.WriteLine($"Decimal: {decimalNumber} => Binario: {binaryString}");
    }
}
*/

.global _start

.section .data
    msg:    .asciz "Decimal: %d => Binario: %s\n"  # Formato de printf

.section .bss
    binario: .skip 64  # Buffer para almacenar el número binario

.section .text
_start:
    // Guardar el número decimal que vamos a convertir
    mov x0, #13  // Número decimal (por ejemplo, 13)

    // Llamar a la función que convierte el número decimal a binario
    mov x1, binario
    bl decimal_a_binario

    // Preparar los argumentos para printf
    mov x2, x0           // Número decimal
    mov x3, binario      // Cadena de binario
    mov x8, #64          // Llamada al sistema para printf (64 es la syscall para printf en ARM64)
    mov x0, #1           // File descriptor para la salida estándar
    bl printf            // Llamada a la función printf

    // Terminar el programa
    mov x8, #93          // Llamada al sistema para terminar el proceso (exit)
    mov x0, #0           // Código de salida 0
    svc #0

decimal_a_binario:
    // Convertir número decimal a binario (almacenando en binario[])
    mov x2, x0           // Guardar el valor original
    mov x3, #63          // Iniciar con el bit más significativo (63 bits)
    add x1, binario, #63 // Apuntar al final del buffer de binario

    // Llenar el buffer de binario con los valores
conv_loop:
    ubfx x4, x2, x3, #1  // Obtener el bit más significativo
    add x4, x4, #'0'      // Convertir a carácter ('0' o '1')
    strb w4, [x1]         // Almacenar el carácter en el buffer
    sub x3, x3, #1        // Decrementar el índice del bit
    cmp x3, #0            // ¿Todos los bits procesados?
    bge conv_loop         // Continuar si no

    // Asegurar que el buffer tiene una cadena terminada en null
    mov x4, #0
    strb w4, [x1]         // Poner '\0' al final del string

    ret
*/

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
