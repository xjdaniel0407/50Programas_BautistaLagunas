/*
 ============================================================================ 
 Título     : Ordenamiento de un array usando el método burbuja en ARM64	
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly para ordenar un array utilizando el 
              algoritmo de burbuja en Raspberry Pi OS.
 ============================================================================ 
*/

/*
Solucion en C#

using System;

class Program
{
    static void Main()
    {
        int[] array = { 5, 3, 8, 1, 2 };
        int length = array.Length;

        Console.WriteLine("Ordenando el array usando el método burbuja...");

        // Algoritmo de Burbuja
        for (int i = 0; i < length - 1; i++)
        {
            for (int j = 0; j < length - 1 - i; j++)
            {
                if (array[j] > array[j + 1])
                {
                    // Intercambiar los elementos
                    int temp = array[j];
                    array[j] = array[j + 1];
                    array[j + 1] = temp;
                }
            }
        }

        Console.WriteLine("Array ordenado:");
        foreach (var num in array)
        {
            Console.WriteLine(num);
        }
    }
}
*/

.data
    prompt:       .asciz "Ordenando el array usando el método burbuja...\n"
    sortedMsg:    .asciz "Array ordenado:\n"
    array:        .word 5, 3, 8, 1, 2   // Array a ordenar
    length:       .word 5               // Longitud del array
    newline:      .asciz "\n"           // Nueva línea

.text
    .global _start

_start:
    // Mostrar el mensaje de inicio
    mov x0, #1                      // Descriptor de archivo para STDOUT
    ldr x1, =prompt                 // Dirección de mensaje
    mov x2, #43                     // Longitud del mensaje
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    // Cargar la longitud del array en w1
    ldr x1, =length                 // Dirección de la longitud
    ldr w1, [x1]                    // Cargar la longitud en w1

bubble_sort_outer:
    sub w2, w1, #1                  // w2 = length - 1 (número de pasadas)

    cmp w2, #0                      // Si w2 llega a 0, hemos terminado
    ble end_sort                    // Salir si w2 es 0 o negativo

    // Establecer el contador para el bucle interno
    mov w3, #0                      // Índice inicial del bucle interno

bubble_sort_inner:
    ldr x4, =array                  // Dirección base del array

    // Calcular la dirección de los elementos a comparar
    lsl w5, w3, #2                  // Desplazar w3 para obtener la posición en bytes
    add x6, x4, x5                  // Dirección de array[w3]
    add x7, x6, #4                  // Dirección de array[w3 + 1]

    // Cargar los valores a comparar
    ldr w8, [x6]                    // Valor en array[w3]
    ldr w9, [x7]                    // Valor en array[w3 + 1]

    // Comparar los dos valores
    cmp w8, w9
    ble no_swap                     // Si array[w3] <= array[w3 + 1], no intercambiar

    // Intercambiar los valores
    str w9, [x6]
    str w8, [x7]

no_swap:
    add w3, w3, #1                  // Incrementar índice interno
    cmp w3, w2                      // Verificar si llegamos al final de la pasada
    blt bubble_sort_inner           // Si no, repetir el bucle interno

    sub w1, w1, #1                  // Decrementar el contador externo (número de pasadas)
    b bubble_sort_outer             // Repetir el bucle externo

end_sort:
    // Mostrar el mensaje de array ordenado
    mov x0, #1                      // Descriptor de archivo para STDOUT
    ldr x1, =sortedMsg              // Dirección del mensaje
    mov x2, #16                     // Longitud del mensaje
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    // Imprimir los elementos del array ordenado
    mov w10, #0                     // Inicializar índice en 0

print_array:
    ldr x3, =array                  // Dirección base del array
    lsl w11, w10, #2                // Desplazamiento de w10 (w11 = w10 * 4 bytes por palabra)
    add x3, x3, x11                 // Dirección de array[w10]
    ldr w0, [x3]                    // Cargar el valor en w0

    // Convertir el número a texto (para impresión) llamando a la función print_num
    bl print_num

    // Imprimir una nueva línea
    mov x0, #1                      // Descriptor de archivo para STDOUT
    ldr x1, =newline                // Dirección de la nueva línea
    mov x2, #1                      // Longitud de la nueva línea
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    add w10, w10, #1                // Incrementar índice
    ldr x1, =length                 // Dirección de la longitud
    ldr w1, [x1]                    // Leer la longitud original del array
    cmp w10, w1                     // Comparar índice con la longitud del array
    blt print_array                 // Repetir si aún hay elementos

    // Terminar el programa
    mov x8, #93                     // Syscall para 'exit' (93)
    svc #0                          // Ejecutar syscall

// Función print_num: convierte un número en w0 a una cadena y lo imprime
print_num:
    // Aquí puedes implementar un procedimiento simple para convertir el número en w0 a ASCII.
    // Por simplicidad, asume que w0 contiene un solo dígito para este ejemplo.

    add w0, w0, '0'                 // Convertir el número a su equivalente ASCII
    mov x1, sp                      // Usar la pila para el buffer temporal
    strb w0, [x1, #-1]!             // Guardar el carácter en la pila

    mov x0, #1                      // Descriptor de archivo para STDOUT
    mov x2, #1                      // Longitud del número convertido
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    ret                             // Retornar de la función

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
