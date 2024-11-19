/*
 ============================================================================
 Título     : Conversión de Entero a ASCII e Impresión de Caracter	
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly Raspberry Pi OS
 ============================================================================
*/

/*
Solución en C#

using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("El carácter ASCII es: " + (char)66);
        Console.WriteLine("Fin del programa.");
    }
}
*/

.global _start

.section .data
    msg:    .asciz "El carácter ASCII es: "  // Cadena de texto
    fin_msg: .asciz "\nFin del programa.\n"   // Mensaje de fin

.section .text
_start:
    // Escribir el texto "El carácter ASCII es: "
    ldr x0, =msg                // Dirección de la cadena de formato
    mov x1, 1                   // Número de archivo (stdout)
    mov x2, 23                  // Longitud de la cadena (23 caracteres)
    mov x8, 64                  // Número de llamada al sistema "write"
    svc 0                        // Llamada al sistema

    // Escribir el carácter ASCII 'B' (66 en ASCII)
    mov x0, 1                   // Número de archivo (stdout)
    mov x1, 66                  // El valor de carácter a escribir (66 = 'B')
    mov x2, 1                   // Longitud de 1 byte
    mov x8, 64                  // Número de llamada al sistema "write"
    svc 0                        // Llamada al sistema

    // Confirmación de finalización
    ldr x0, =fin_msg            // Cargar mensaje de fin
    mov x1, 1                   // Número de archivo (stdout)
    mov x2, 17                  // Longitud del mensaje de fin (17 caracteres)
    mov x8, 64                  // Número de llamada al sistema "write"
    svc 0                        // Llamada al sistema

    // Finalizar el programa
    mov x8, 93                  // Llamada al sistema "exit"
    mov x0, 0                   // Código de salida (0)
    svc 0                        // Llamada al sistema

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/

