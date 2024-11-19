/*
 ============================================================================
 Título     : Calcular la longitud de una cadena	
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
        string input = "Raspberry Pi";
        int length = input.Length;
        Console.WriteLine($"La longitud de la cadena es: {length}");
    }
}
*/

.global _start

.section .data
    input:  .asciz "Raspberry Pi"   // La cadena cuya longitud calcularemos

.section .text
_start:
    // Calcular la longitud de la cadena "input"
    mov x0, input          // Poner la dirección de la cadena 'input' en x0
    bl strlen              // Llamada a la función strlen para obtener la longitud

    // Terminar el programa con exit
    mov x0, 0              // Código de salida 0
    mov x8, 93             // Llamada al sistema para salir
    svc 0                  // Hacer la llamada al sistema

// Función strlen: Calcula la longitud de una cadena
strlen:
    mov x1, x0             // x1 = dirección de la cadena
    mov x0, 0              // x0 = contador (longitud)

strlen_loop:
    ldrb w2, [x1], #1      // Cargar un byte de la cadena y mover el puntero
    cbz w2, strlen_done    // Si el byte es cero (fin de cadena), salir
    add x0, x0, 1          // Incrementar el contador de longitud
    b strlen_loop          // Volver al inicio del bucle

strlen_done:
    ret                    // Regresar con la longitud en x0

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
