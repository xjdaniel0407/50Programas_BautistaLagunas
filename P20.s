/*
 ============================================================================
 Título     : Multiplicación de matrices 3x3 en ARM64 Assembly	
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly para multiplicar dos matrices 3x3
              en Raspberry Pi OS.
 ============================================================================
*/

/*
Solucion en C#

//
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
                int suma = 0;
                for (int k = 0; k < 3; k++)
                {
                    suma += matrizA[i, k] * matrizB[k, j];
                }
                resultado[i, j] = suma;
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
//
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
    .global matrix_multiplication

matrix_multiplication:
    // Cargar las direcciones de las matrices en registros
    ldr x0, =matrizA           // Dirección de matrizA
    ldr x1, =matrizB           // Dirección de matrizB
    ldr x2, =resultado         // Dirección de resultado

    mov w3, #0                 // Índice i (contador de filas de A)
    mov x12, #3                // Guardar el valor 3 en x12 para usarlo en multiplicaciones

fila_loop:
    mov w4, #0                 // Índice j (contador de columnas de B)

columna_loop:
    mov w8, #0                 // Acumulador para resultado[i][j]
    mov w5, #0                 // Índice k para multiplicación A[i][k] * B[k][j]

multiplicacion_loop:
    // Calcular posición en A para A[i][k] = matrizA[i][k]
    mov x6, x3                 // x6 = i
    mul x6, x6, x12            // x6 = i * 3
    add x6, x6, x5             // x6 = i * 3 + k

    // Calcular posición en B para B[k][j] = matrizB[k][j]
    mov x7, x5                 // x7 = k
    mul x7, x7, x12            // x7 = k * 3
    add x7, x7, x4             // x7 = k * 3 + j

    // Cargar y multiplicar los elementos A[i][k] y B[k][j]
    ldr w9, [x0, x6, LSL #2]   // w9 = matrizA[i][k]
    ldr w10, [x1, x7, LSL #2]  // w10 = matrizB[k][j]
    mul w11, w9, w10           // w11 = matrizA[i][k] * matrizB[k][j]

    // Acumular en w8 el producto parcial
    add w8, w8, w11            // w8 += matrizA[i][k] * matrizB[k][j]

    add w5, w5, #1             // k++
    cmp w5, #3                 // Comparar k con el tamaño de la fila/columna
    blt multiplicacion_loop    // Si k < 3, repetir multiplicacion_loop

    // Guardar el resultado en la posición correspondiente
    mov x10, x3                // x10 = i
    mul x10, x10, x12          // x10 = i * 3
    add x10, x10, x4           // x10 = i * 3 + j
    str w8, [x2, x10, LSL #2]  // resultado[i][j] = acumulador w8

    add w4, w4, #1             // j++
    cmp w4, #3                 // Comparar j con el tamaño de la fila
    blt columna_loop           // Si j < 3, repetir columna_loop

    add w3, w3, #1             // i++
    cmp w3, #3                 // Comparar i con el tamaño de la columna
    blt fila_loop              // Si i < 3, repetir fila_loop

    ret                        // Fin de la función

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
