/*
 ============================================================================
 Título     : Generación de números aleatorios con semilla en ARM64 Assembly
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
        Random rand = new Random(42); // Semilla inicial
        int randomNumber = rand.Next(); // Generar un número aleatorio
        Console.WriteLine($"Número aleatorio: {randomNumber}");
    }
}
*/

.global _start

.section .data
fmt_string:    .asciz "Número aleatorio: %d\n"
seed_value:    .word 42            // Semilla inicial para el generador

.section .bss
.align 4
random_number: .space 4            // Espacio para almacenar un número aleatorio

.section .text
_start:
    // Configurar la semilla
    ldr x0, =seed_value            // Dirección de la semilla
    ldr w1, [x0]                   // Cargar el valor de la semilla en w1
    mov w0, w1                     // Pasar la semilla como argumento a srand
    bl srand                       // Llamar a srand

    // Generar un número aleatorio
    bl rand                        // Llamar a rand
    mov w1, w0                     // Guardar el resultado en w1
    ldr x0, =fmt_string            // Dirección del formato de cadena
    bl printf                      // Imprimir el número aleatorio

    // Terminar el programa
    mov x8, 93                     // syscall número 93: exit
    mov x0, 0                      // Código de salida 0
    svc 0                          // Llamada al sistema

// Declaración de funciones externas
.extern srand
.extern rand
.extern printf

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
