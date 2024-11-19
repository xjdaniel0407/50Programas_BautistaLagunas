/*
 ============================================================================
 Título     : Rotación de un arreglo (izquierda/derecha) en ARM64 Assembly
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly Raspberry Pi OS que rota un arreglo 
              a la derecha e imprime el resultado con printf.
 ============================================================================
*/

/*
Solucion en C#

using System;

class Program
{
    static void Main()
    {
        int[] array = {0, 1, 2, 3, 4};

        // Rotación a la derecha
        int last = array[array.Length - 1];
        for (int i = array.Length - 1; i > 0; i--)
        {
            array[i] = array[i - 1];
        }
        array[0] = last;

        // Mostrar el arreglo después de la rotación
        Console.WriteLine("Arreglo después de la rotación: " + string.Join(" ", array));
    }
}
*/

.global _start
.extern printf

.section .data
    msg:    .asciz "Arreglo después de la rotación: %d %d %d %d %d\n"

.section .bss
    array:  .skip 20   // Reservamos espacio para 5 enteros (5 * 4 bytes = 20 bytes)

.section .text
_start:
    // Inicializar el arreglo
    mov x0, 0          // x0 es el índice del primer valor
    mov x1, 1
    mov x2, 2
    mov x3, 3
    mov x4, 4

    // Guardar los valores en el arreglo
    ldr x5, =array     // Dirección base del arreglo

    str x0, [x5]       // array[0] = 0
    str x1, [x5, #4]   // array[1] = 1
    str x2, [x5, #8]   // array[2] = 2
    str x3, [x5, #12]  // array[3] = 3
    str x4, [x5, #16]  // array[4] = 4

    // Rotación a la derecha (shift)
    mov x6, 1          // número de posiciones a rotar
    bl rotate_right

    // Mostrar el arreglo después de la rotación
    ldr x0, =msg
    ldr x1, [x5]
    ldr x2, [x5, #4]
    ldr x3, [x5, #8]
    ldr x4, [x5, #12]
    ldr x5, [x5, #16]
    bl printf

    // Terminar el programa
    mov x8, 93         // syscall número 93 (exit)
    mov x0, 0          // código de salida 0
    svc 0

// Función para rotar a la derecha
rotate_right:
    mov x7, 0          // Guardamos el primer elemento en x7
    ldr x7, [x5]
    
    // Desplazamos a la derecha
    ldr x8, [x5, #16]  // Cargamos el último elemento (array[4])
    str x8, [x5]       // Guardamos el último elemento en array[0]

    // Mueve el resto del arreglo una posición a la derecha
    mov x9, 4          // Empieza en el último índice
    mov x10, 0         // Empieza en el índice 0
rotate_loop:
    cmp x9, 0          // Si llegamos al primer índice, detenemos
    beq rotate_done
    ldr x11, [x5, x9, lsl #2]  // Cargar el valor de array[i]
    str x11, [x5, x9, lsl #2]  // Guardar el valor en array[i + 1]
    sub x9, x9, 1      // Decrementamos el índice
    b rotate_loop

rotate_done:
    ret

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
