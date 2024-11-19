/*
 ============================================================================ 
 Título     : Suma de los elementos de un arreglo en ARM64 Assembly  
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
        int[] array = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        int sum = 0;

        foreach (int num in array)
        {
            sum += num;
        }

        Console.WriteLine("La suma del arreglo es: " + sum);
    }
}
*/

.data
    // Formato para printf
    fmt:    .string "La suma del arreglo es: %d\n"
    
    // Arreglo de números predeterminados
    array:  .word   1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    .equ    n, 10   // Tamaño del arreglo

.text
.global main

main:
    // Prólogo
    stp     x29, x30, [sp, -16]!    // Guardar frame pointer y link register
    mov     x29, sp                  // Actualizar frame pointer

    // Inicializar registros
    mov     x19, #0                  // x19 = suma total
    mov     x20, #0                  // x20 = contador
    adr     x21, array               // x21 = dirección base del arreglo

loop:
    // Verificar si llegamos al final del arreglo
    cmp     x20, n                   // Comparar contador con tamaño del arreglo
    b.ge    done                     // Si es mayor o igual, salir del loop

    // Cargar elemento actual y sumarlo
    ldr     w22, [x21, x20, lsl #2]  // Cargar elemento (w22 = array[x20])
    add     x19, x19, x22            // Sumar al total

    // Incrementar contador
    add     x20, x20, #1             // contador++
    b       loop                     // Volver al inicio del loop

done:
    // Llamar a printf
    adr     x0, fmt                  // Primer argumento: formato
    mov     x1, x19                  // Segundo argumento: suma total
    bl      printf                   // Llamar printf

    // Epílogo
    mov     x0, #0                   // Retornar 0
    ldp     x29, x30, [sp], #16      // Restaurar frame pointer y link register
    ret

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
