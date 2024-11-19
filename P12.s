/*
 ============================================================================
 Título     : Encontrar el valor máximo en un arreglo usando ensamblador ARM64	
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly para encontrar el valor máximo en un arreglo
              y mostrarlo en la consola. 
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
        int max = array[0];

        foreach (int num in array)
        {
            Console.Write(num + " ");
            if (num > max)
            {
                max = num;
            }
        }

        Console.WriteLine("\nEl máximo valor en el arreglo es: " + max);
    }
}
*/

.data
    prompt:       .asciz "El máximo en el arreglo:\n"
    maxMsg:       .asciz "\nEl máximo valor en el arreglo es:\n"
    array:        .word 5, 3, 8, 1, 2    // Array de ejemplo
    length:       .word 5                // Longitud del array
    newline:      .asciz "\n"            // Nueva línea
    space:        .asciz " "             // Espacio en blanco

.text
    .global _start

_start:
    // Mostrar el mensaje de inicio
    mov x0, #1                      // Descriptor de archivo para STDOUT
    ldr x1, =prompt                 // Dirección del mensaje de inicio
    mov x2, #31                     // Longitud del mensaje
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    // Mostrar el contenido del arreglo
    mov w10, #0                     // Índice para impresión

print_array:
    ldr x3, =array                  // Dirección base del array
    lsl w11, w10, #2                // Desplazamiento de w10 (w11 = w10 * 4 bytes por palabra)
    add x3, x3, x11                 // Dirección de array[w10]
    ldr w0, [x3]                    // Cargar el valor en w0

    // Convertir el número a texto (para impresión) llamando a la función print_num
    bl print_num

    // Imprimir un espacio después de cada número
    mov x0, #1                      // Descriptor de archivo para STDOUT
    ldr x1, =space                  // Dirección del espacio
    mov x2, #1                      // Longitud del espacio
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    add w10, w10, #1                // Incrementar índice
    ldr x1, =length                 // Dirección de la longitud
    ldr w1, [x1]                    // Leer la longitud original del array
    cmp w10, w1                     // Comparar índice con la longitud del array
    blt print_array                 // Repetir si aún hay elementos

    // Añadir una nueva línea después del arreglo
    mov x0, #1                      // Descriptor de archivo para STDOUT
    ldr x1, =newline                // Dirección de la nueva línea
    mov x2, #1                      // Longitud de la nueva línea
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    // Cargar la longitud del array en w1
    ldr x1, =length
    ldr w1, [x1]

    // Configurar el índice y el valor inicial máximo
    mov w2, #0                      // Índice del array
    ldr x3, =array                  // Dirección base del array
    ldr w4, [x3]                    // Cargar el primer valor del array en w4 (inicialmente el máximo)

find_max:
    // Cargar el valor actual del array en w5
    lsl w6, w2, #2                  // Calcular desplazamiento de índice (w2 * 4 bytes)
    add x7, x3, x6                  // Dirección de array[w2]
    ldr w5, [x7]                    // Cargar array[w2] en w5

    // Comparar y actualizar el valor máximo
    cmp w5, w4                      // Comparar el valor actual con el máximo actual
    ble skip_update                 // Saltar si w5 <= w4
    mov w4, w5                      // Actualizar el máximo si w5 es mayor

skip_update:
    // Incrementar índice y verificar si se alcanzó el final del array
    add w2, w2, #1                  // Incrementar el índice
    cmp w2, w1                      // Comparar índice con la longitud del array
    blt find_max                    // Repetir mientras el índice sea menor que la longitud

    // Mostrar el mensaje del valor máximo encontrado
    mov x0, #1                      // Descriptor de archivo para STDOUT
    ldr x1, =maxMsg                 // Dirección del mensaje "El máximo valor en el arreglo es:\n"
    mov x2, #34                     // Longitud del mensaje
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    // Imprimir el valor máximo
    mov w0, w4                      // Cargar el máximo valor en w0 para impresión
    bl print_num                    // Llamada a la función para imprimir el número

    // Imprimir una nueva línea
    mov x0, #1                      // Descriptor de archivo para STDOUT
    ldr x1, =newline                // Dirección de la nueva línea
    mov x2, #1                      // Longitud de la nueva línea
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    // Terminar el programa
    mov x8, #93                     // Syscall para 'exit' (93)
    svc #0                          // Ejecutar syscall

print_num:
    // Convertir el número a su equivalente ASCII y luego imprimirlo (considerando solo un dígito en este caso)
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
