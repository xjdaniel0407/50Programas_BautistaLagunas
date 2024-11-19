/*
 ============================================================================ 
 Título     : Suma de dos matrices 3x3 en ARM64 Assembly	
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly para Raspberry Pi OS que suma dos matrices 3x3.
 ============================================================================ 
*/

/*
Solucion en C#

using System;

class Program
{
    static void Main()
    {
        int[,] matrizA = new int[3, 3] { { 1, 2, 3 }, { 4, 5, 6 }, { 7, 8, 9 } };
        int[,] matrizB = new int[3, 3] { { 9, 8, 7 }, { 6, 5, 4 }, { 3, 2, 1 } };
        int[,] resultado = new int[3, 3];

        for (int i = 0; i < 3; i++)
        {
            for (int j = 0; j < 3; j++)
            {
                resultado[i, j] = matrizA[i, j] + matrizB[i, j];
            }
        }

        // Imprimir resultado
        for (int i = 0; i < 3; i++)
        {
            for (int j = 0; j < 3; j++)
            {
                Console.Write(resultado[i, j] + " ");
            }
            Console.WriteLine();
        }
    }
}
*/

    .data
    .global matrizA, matrizB, resultado

matrizA:
    .word 1, 2, 3
    .word 4, 5, 6
    .word 7, 8, 9

matrizB:
    .word 9, 8, 7
    .word 6, 5, 4
    .word 3, 2, 1

resultado:
    .space 36    // 3x3 = 9 elementos de 4 bytes

    .text
    .global suma_matrices
    .global _start          // Hacer global _start para ser el punto de entrada

_start:                     // Definir _start como punto de entrada
    bl suma_matrices        // Llamar a la función suma_matrices
    bl imprimir_resultado   // Llamar a la función para imprimir el resultado
    mov x0, #0              // Código de salida 0
    mov x8, #93             // Syscall para salir (exit)
    svc #0                  // Ejecutar la syscall

suma_matrices:
    // Cargar las direcciones de las matrices en registros
    ldr x0, =matrizA           // Dirección de matrizA
    ldr x1, =matrizB           // Dirección de matrizB
    ldr x2, =resultado         // Dirección de resultado

    mov w3, #0                 // Índice i (contador de filas)

fila_loop:
    mov w4, #0                 // Índice j (contador de columnas)

columna_loop:
    // Calcular la posición en el arreglo lineal: pos = i * 3 + j
    mov x5, x3                 // x5 = i
    add x5, x5, x5             // x5 = i * 2
    add x5, x5, x3             // x5 = i * 3
    add x5, x5, x4             // x5 = i * 3 + j

    // Cargar los elementos de matrizA y matrizB y sumarlos
    ldr w6, [x0, x5, LSL #2]   // w6 = matrizA[i][j]
    ldr w7, [x1, x5, LSL #2]   // w7 = matrizB[i][j]
    add w8, w6, w7             // w8 = matrizA[i][j] + matrizB[i][j]

    // Guardar el resultado en la posición correspondiente
    str w8, [x2, x5, LSL #2]   // resultado[i][j] = matrizA[i][j] + matrizB[i][j]

    add w4, w4, #1             // j++ 
    cmp w4, #3                 // Comparar j con el tamaño de la fila
    blt columna_loop           // Si j < 3, repetir columna_loop

    add w3, w3, #1             // i++ 
    cmp w3, #3                 // Comparar i con el tamaño de la columna
    blt fila_loop              // Si i < 3, repetir fila_loop

    ret                        // Fin de la función

imprimir_resultado:
    mov w3, #0                 // Índice i (contador de filas)
    
imprimir_fila:
    mov w4, #0                 // Índice j (contador de columnas)
    
imprimir_columna:
    // Cargar el valor de resultado[i][j]
    mov x5, x3                 // x5 = i
    add x5, x5, x5             // x5 = i * 2
    add x5, x5, x3             // x5 = i * 3
    add x5, x5, x4             // x5 = i * 3 + j

    ldr w6, [x2, x5, LSL #2]   // w6 = resultado[i][j]

    // Convertir w6 a su valor ASCII
    add w6, w6, #30            // Convertir el número a carácter (ASCII)

    // Imprimir el número (usando la syscall write)
    mov x0, #1                 // File descriptor 1 = stdout
    mov x1, x6                 // El valor a imprimir
    mov x2, #1                 // Escribir 1 byte
    mov x8, #64                // Syscall número 64 = write
    svc #0                     // Ejecutar la syscall

    add w4, w4, #1             // j++ 
    cmp w4, #3                 // Comparar j con el tamaño de la fila
    blt imprimir_columna       // Si j < 3, repetir imprimir_columna

    add w3, w3, #1             // i++ 
    cmp w3, #3                 // Comparar i con el tamaño de la columna
    blt imprimir_fila          // Si i < 3, repetir imprimir_fila

    ret                        // Fin de la función

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
