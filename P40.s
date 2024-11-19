/*
 ============================================================================
 Título     : Conversión de binario a decimal en ARM64 Assembly	
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly para Raspberry Pi OS
 ============================================================================
*/

/*
Solucion en C#

using System;

class Program
{
    static void Main(string[] args)
    {
        string binario = "1101"; // Número binario como cadena
        int decimalValue = Convert.ToInt32(binario, 2); // Conversión binaria a decimal
        Console.WriteLine("El decimal es: " + decimalValue);
    }
}
*/

.section .data
binario:    .asciz "1101"            // Número binario como string
mensaje:    .asciz "El decimal es: %d\n"

.section .bss
.resultado: .space 4                 // Espacio para almacenar el resultado decimal

.section .text
.global _start

_start:
    // Cargar direcciones
    ldr x0, =binario                 // Dirección del número binario
    ldr x1, =resultado               // Dirección del espacio para resultado

    // Llamar a convertir binario a decimal
    bl binario_a_decimal

    // Preparar parámetros para printf
    ldr x0, =mensaje                 // Cargar mensaje
    ldr x1, [resultado]              // Cargar el resultado calculado
    bl printf                        // Llamar a printf

    // Salida del programa
    mov x8, 60                       // syscall exit
    mov x0, 0                        // Código de salida
    svc 0

// Función: binario_a_decimal
// Convierte un número binario a decimal
binario_a_decimal:
    mov x2, 0                        // Resultado decimal inicializado en 0
    mov x3, 0                        // Potencia de 2 inicializada en 0

    // Leer cada carácter del binario (al revés)
1:
    ldrb w4, [x0], 1                 // Leer un byte (carácter)
    cmp w4, 0                        // Comprobar si es el fin del string
    beq 2                            // Si fin, saltar

    sub w4, w4, '0'                  // Convertir carácter a número (ASCII -> binario)
    lsl x4, x4, x3                   // Multiplicar por 2^potencia actual
    add x2, x2, x4                   // Sumar al resultado decimal
    add x3, x3, 1                    // Incrementar potencia de 2
    b 1                              // Continuar con el siguiente carácter

2:
    str x2, [x1]                     // Guardar el resultado en memoria
    ret                              // Volver

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
