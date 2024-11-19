/*
 ============================================================================
 Título     : Inversión de un arreglo en ARM64 Assembly
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly que invierte un arreglo de enteros y 
              muestra el arreglo original e invertido en la consola.
 ============================================================================
*/

/*
Solucion en C#

using System;

class Program
{
    static void Main()
    {
        int[] array = { 1, 2, 3, 4, 5, 6, 7, 8 };
        int n = array.Length;

        // Imprimir arreglo original
        Console.WriteLine("Arreglo original:");
        foreach (int num in array)
        {
            Console.Write(num + " ");
        }
        Console.WriteLine();

        // Invertir el arreglo
        int[] reversed = new int[n];
        for (int i = 0; i < n; i++)
        {
            reversed[i] = array[n - i - 1];
        }

        // Imprimir arreglo invertido
        Console.WriteLine("Arreglo invertido:");
        foreach (int num in reversed)
        {
            Console.Write(num + " ");
        }
        Console.WriteLine();
    }
}
*/

.data
    // Formatos para printf
    fmt1:   .string "Arreglo original: "
    fmt2:   .string "%d "
    fmt3:   .string "\nArreglo invertido: "
    newline: .string "\n"
    
    // Arreglo de números predeterminados
    array:  .word   1, 2, 3, 4, 5, 6, 7, 8
    .equ    n, 8       // Tamaño del arreglo
    
    // Arreglo para almacenar el resultado invertido
    reversed: .skip n*4  // Reservar espacio para n elementos (4 bytes cada uno)

.text
.global main

main:
    // Prólogo
    stp     x29, x30, [sp, -16]!    // Guardar frame pointer y link register
    mov     x29, sp                  // Actualizar frame pointer

    // Imprimir mensaje inicial
    adr     x0, fmt1
    bl      printf

    // Mostrar arreglo original
    bl      print_original

    // Invertir el arreglo
    bl      reverse_array

    // Imprimir mensaje para arreglo invertido
    adr     x0, fmt3
    bl      printf

    // Mostrar arreglo invertido
    bl      print_reversed

    // Imprimir nueva línea
    adr     x0, newline
    bl      printf

    // Epílogo
    mov     x0, #0                   // Retornar 0
    ldp     x29, x30, [sp], #16      // Restaurar frame pointer y link register
    ret

// Función para invertir el arreglo
reverse_array:
    stp     x29, x30, [sp, -16]!    // Guardar registros
    mov     x29, sp

    mov     x19, #0                  // i = 0
    mov     x20, n                   // j = n
    sub     x20, x20, #1            // j = n-1
    adr     x21, array              // Dirección del arreglo original
    adr     x22, reversed           // Dirección del arreglo invertido

reverse_loop:
    cmp     x19, n                   // Comparar i con n
    b.ge    reverse_done            // Si i >= n, terminar

    // Calcular índice para el elemento original
    sub     x23, x20, x19           // j-i
    lsl     x24, x23, #2            // (j-i)*4 para obtener offset
    ldr     w25, [x21, x24]         // Cargar elemento original

    // Guardar en nueva posición
    lsl     x24, x19, #2            // i*4 para obtener offset
    str     w25, [x22, x24]         // Guardar en arreglo invertido

    add     x19, x19, #1            // i++
    b       reverse_loop

reverse_done:
    ldp     x29, x30, [sp], #16     // Restaurar registros
    ret

// Función para imprimir arreglo original
print_original:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    mov     x19, #0                  // contador = 0
    adr     x20, array              // dirección base del arreglo

print_orig_loop:
    cmp     x19, n
    b.ge    print_orig_done

    // Imprimir elemento
    adr     x0, fmt2
    ldr     w1, [x20, x19, lsl #2]
    bl      printf

    add     x19, x19, #1
    b       print_orig_loop

print_orig_done:
    ldp     x29, x30, [sp], #16
    ret

// Función para imprimir arreglo invertido
print_reversed:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    mov     x19, #0                  // contador = 0
    adr     x20, reversed           // dirección base del arreglo invertido

print_rev_loop:
    cmp     x19, n
    b.ge    print_rev_done

    // Imprimir elemento
    adr     x0, fmt2
    ldr     w1, [x20, x19, lsl #2]
    bl      printf

    add     x19, x19, #1
    b       print_rev_loop

print_rev_done:
    ldp     x29, x30, [sp], #16
    ret

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
