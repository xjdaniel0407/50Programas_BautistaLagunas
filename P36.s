/*
 ============================================================================
 Título     : Encontrar el segundo elemento más grande en un arreglo
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly Raspberry Pi OS
 ============================================================================
*/

/*
Solucion en C#

using System;

class Program
{
    static void Main()
    {
        int[] arr = { 3, 5, 7, 2, 8, 1, 6, 10, 4 };
        int firstMax = int.MinValue;
        int secondMax = int.MinValue;

        foreach (int num in arr)
        {
            if (num > firstMax)
            {
                secondMax = firstMax;
                firstMax = num;
            }
            else if (num > secondMax && num != firstMax)
            {
                secondMax = num;
            }
        }

        Console.WriteLine("El segundo elemento más grande es: " + secondMax);
    }
}
*/

.global _start

.extern printf

.section .data
    format: .asciz "El segundo elemento más grande es: %d\n"
    
    # Ejemplo de arreglo
    arr:    .quad 3, 5, 7, 2, 8, 1, 6, 10, 4  # Arreglo de enteros de 64 bits

.section .bss
    second_max: .skip 8  # Espacio para guardar el segundo máximo

.section .text
_start:
    # Inicialización de registros
    mov x0, 0           # x0: índice de iteración
    mov x1, 0           # x1: primer máximo
    mov x2, 0           # x2: segundo máximo
    mov x3, arr         # x3: dirección del arreglo
    mov x4, 9           # x4: longitud del arreglo (9 elementos)

find_max:
    cmp x0, x4          # Comparar índice con el tamaño del arreglo
    bge done            # Si hemos pasado el último índice, terminar

    ldr x5, [x3, x0, lsl #3]  # Cargar el valor del arreglo en x5 (cada valor es de 8 bytes)
    
    # Verificar si el valor es mayor que el primer máximo
    cmp x5, x1
    ble check_second_max
    mov x2, x1          # Actualizar segundo máximo
    mov x1, x5          # Actualizar primer máximo
    b next_iteration

check_second_max:
    # Verificar si el valor es mayor que el segundo máximo y diferente del primero
    cmp x5, x2
    ble next_iteration
    cmp x5, x1
    beq next_iteration
    mov x2, x5          # Actualizar segundo máximo

next_iteration:
    add x0, x0, 1       # Incrementar el índice
    b find_max

done:
    # Imprimir el segundo máximo
    mov x0, x2          # Cargar el segundo máximo en x0 (primer argumento de printf)
    ldr x1, =format     # Cargar la dirección del formato en x1
    bl printf           # Llamar a printf

    # Salir del programa
    mov x8, 93          # syscall para salir
    mov x0, 0           # Código de salida
    svc 0
*/

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
