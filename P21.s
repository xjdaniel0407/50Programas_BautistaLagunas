/*
 ============================================================================
 Título     : Transposición de una Matriz	
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly Raspberry Pi OS
 ============================================================================
*/

/*
Solución en C#

// Solución para la transposición de una matriz en C#:
using System;

class Program {
    static void Main() {
        int[,] matrix = { { 1, 2 }, { 3, 4 } };
        int[,] transpose = new int[2, 2];

        // Transponer la matriz
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
                transpose[j, i] = matrix[i, j];
            }
        }

        // Imprimir la matriz transpuesta
        Console.Write("La matriz transpuesta es: ");
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
                Console.Write(transpose[i, j] + (i == 1 && j == 1 ? "" : ", "));
            }
        }
        Console.WriteLine();
    }
}
*/

.global _start
.extern printf

.section .data
msg_transpose:
    .asciz "La matriz transpuesta es:\n"
msg_format:
    .asciz "%d, %d, %d, %d\n"  // Formato para imprimir los cuatro elementos en una sola línea

matrix:
    .word 1, 2       // Primera fila de la matriz original
    .word 3, 4       // Segunda fila de la matriz original

.section .text
_start:
    // Llamada a main
    bl main
    // Salida del programa
    mov x0, #0        // Código de salida 0
    mov x8, #93       // Número del sistema para "exit"
    svc #0            // Llamada al sistema para "exit"

main:
    // Imprimir mensaje de inicio
    ldr x0, =msg_transpose
    bl printf

    // Cargar la dirección de la matriz original
    ldr x1, =matrix

    // Leer y cargar los elementos de la matriz
    ldr w2, [x1]        // Elemento (0,0) = 1
    ldr w3, [x1, #4]    // Elemento (0,1) = 2
    ldr w4, [x1, #8]    // Elemento (1,0) = 3
    ldr w5, [x1, #12]   // Elemento (1,1) = 4

    // Imprimir la matriz transpuesta en una sola línea
    mov w6, w2  // Transposición: (0,0) -> (0,0)
    mov w7, w4  // Transposición: (1,0) -> (0,1)
    mov w8, w3  // Transposición: (0,1) -> (1,0)
    mov w9, w5  // Transposición: (1,1) -> (1,1)

    // Usar registros w1, w2, w3, w4 para imprimir
    mov w1, w6
    mov w2, w7
    mov w3, w8
    mov w4, w9

    // Llamada a printf para imprimir los cuatro elementos
    ldr x0, =msg_format
    bl printf

    // Terminar el programa y devolver el control al sistema operativo
    mov x0, #0        // Código de salida 0
    mov x8, #93       // Número del sistema para "exit"
    svc #0            // Llamada al sistema para "exit"

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
