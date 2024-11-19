/*
 ============================================================================ 
 Título     : Búsqueda Binaria en un arreglo ordenado  
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly para realizar una búsqueda binaria en un arreglo de enteros ordenados. 
 ============================================================================ 
*/

/*
Solucion en C#

using System;

class Program
{
    static void Main()
    {
        int[] array = { 3, 5, 7, 9 }; // Arreglo ordenado
        int n = array.Length;

        Console.WriteLine("--- Búsqueda Binaria ---");
        Console.WriteLine("Arreglo: 3, 5, 7, 9");

        Console.Write("\nIngresa el número a buscar: ");
        int target = int.Parse(Console.ReadLine());

        int result = BinarySearch(array, target);
        
        if (result != -1)
            Console.WriteLine("\nElemento encontrado en la posición: " + result);
        else
            Console.WriteLine("\nElemento no encontrado");
    }

    static int BinarySearch(int[] arr, int target)
    {
        int left = 0;
        int right = arr.Length - 1;

        while (left <= right)
        {
            int mid = left + (right - left) / 2;

            if (arr[mid] == target)
                return mid;
            else if (arr[mid] < target)
                left = mid + 1;
            else
                right = mid - 1;
        }

        return -1;
    }
}
*/

.section .data
array:      .word 3, 5, 7, 9                         // Arreglo ordenado de elementos 3, 5, 7, 9
array_len:  .word 4                                  // Longitud del arreglo
msg_title:  .asciz "\n--- Búsqueda Binaria ---\n"    // Mensaje indicando que es una búsqueda binaria
msg_array:  .asciz "Arreglo: 3, 5, 7, 9\n"           // Mensaje con los elementos del arreglo
msg_prompt: .asciz "\nIngresa el número a buscar: "  // Mensaje de solicitud de entrada con salto de línea
msg_found:  .asciz "\nElemento encontrado\n\n"       // Mensaje si encuentra el elemento, con salto de línea extra al final
msg_not_found: .asciz "\nElemento no encontrado\n\n" // Mensaje si no encuentra el elemento, con salto de línea extra al final
buffer:     .space 10                                // Espacio para leer la entrada del usuario (suficiente para varios dígitos)

.section .text
.global _start

_start:
    // Mostrar el mensaje de título
    MOV x0, #1                   // File descriptor 1 (stdout)
    LDR x1, =msg_title           // Mensaje de título "Búsqueda Binaria"
    MOV x2, #28                  // Longitud del mensaje
    MOV x8, #64                  // Syscall número para write
    SVC #0                       // Llama al sistema para imprimir el mensaje

    // Mostrar el contenido del arreglo
    MOV x0, #1                   // File descriptor 1 (stdout)
    LDR x1, =msg_array           // Mensaje con los elementos del arreglo
    MOV x2, #18                  // Longitud del mensaje
    MOV x8, #64                  // Syscall número para write
    SVC #0                       // Llama al sistema para imprimir el mensaje

    // Solicitar al usuario el número a buscar
    MOV x0, #1                   // File descriptor 1 (stdout)
    LDR x1, =msg_prompt          // Mensaje de solicitud de entrada
    MOV x2, #29                  // Longitud del mensaje
    MOV x8, #64                  // Syscall número para write
    SVC #0                       // Llama al sistema para imprimir el mensaje

    // Leer el número ingresado por el usuario
    MOV x0, #0                   // File descriptor 0 (stdin)
    LDR x1, =buffer              // Dirección del buffer para almacenar la entrada del usuario
    MOV x2, #10                  // Longitud máxima de lectura (permitiendo múltiples dígitos)
    MOV x8, #63                  // Syscall número para read
    SVC #0                       // Llama al sistema para leer la entrada del usuario

    // Convertir la entrada en buffer a un número entero
    MOV w3, #0                   // Inicializar w3 (donde almacenaremos el número resultante) a 0
    MOV x4, #0                   // Índice para recorrer el buffer
    MOV w6, #10                  // Multiplicador 10 para la conversión

convert_to_int:
    LDRB w5, [x1, x4]            // Leer el siguiente byte del buffer usando x4 como índice
    CMP w5, #10                  // Comprobar si es un salto de línea (fin de la entrada)
    BEQ end_convert              // Si es un salto de línea, termina la conversión
    SUB w5, w5, #'0'             // Convertir el carácter ASCII a valor numérico
    MUL w3, w3, w6               // Multiplicar el número acumulado por 10 (usando w6)
    ADD w3, w3, w5               // Añadir el dígito actual al número acumulado
    ADD x4, x4, #1               // Incrementar el índice
    B convert_to_int             // Repetir el proceso para el siguiente carácter

end_convert:
    // Configuración inicial para la búsqueda binaria
    LDR x1, =array               // x1 = dirección del arreglo
    LDR x2, =array_len           // x2 = dirección de array_len
    LDR w2, [x2]                 // Cargar el valor de array_len en w2

    // Llamada a la función de búsqueda binaria
    BL binary_search

    // Verificar el resultado de la búsqueda
    CMP w0, #-1
    BEQ print_not_found          // Si el resultado es -1, no se encontró

print_found:
    // Imprimir mensaje de éxito
    MOV x0, #1                   // File descriptor 1 (stdout)
    LDR x1, =msg_found           // Mensaje de éxito con salto de línea extra
    MOV x2, #22                  // Longitud del mensaje
    MOV x8, #64                  // Syscall número para write
    SVC #0                       // Llama al sistema para imprimir el mensaje
    B exit                       // Salir del programa

print_not_found:
    MOV x0, #1                   // File descriptor 1 (stdout)
    LDR x1, =msg_not_found       // Mensaje de fracaso con salto de línea extra
    MOV x2, #28                  // Longitud del mensaje
    MOV x8, #64                  // Syscall número para write
    SVC #0                       // Llama al sistema para imprimir el mensaje

exit:
    MOV x8, #93                  // Syscall número para salir (exit en Linux)
    SVC #0

// Función binary_search: Busca un número en un arreglo ordenado y devuelve la posición o -1.
binary_search:
    MOV x4, #0                   // Índice inicial (left) = 0
    SUB x5, x2, #1               // Índice final (right) = array_len - 1

binary_search_loop:
    CMP x4, x5                   // Comparar left y right
    BGT not_found                // Si left > right, no se encontró el valor

    // Calcular el índice central: mid = (left + right) / 2
    ADD x6, x4, x5               // x6 = left + right
    LSR x6, x6, #1               // x6 = (left + right) / 2 (shift right by 1 para dividir entre 2)

    // Comparar el valor en el índice medio con el valor buscado
    LDR w7, [x1, x6, LSL #2]     // Leer array[mid] en w7 (4 bytes cada elemento), usando x6 como desplazamiento
    CMP w7, w3                   // Comparar array[mid] con el valor buscado
    BEQ found                    // Si son iguales, encontró el valor

    // Actualizar los límites de búsqueda
    BLT update_left              // Si array[mid] < valor, mover el índice left
    MOV x5, x6                   // Si array[mid] > valor, mover el índice right
    SUB x5, x5, #1               // right = mid - 1
    B binary_search_loop         // Repetir el bucle

update_left:
    ADD x4, x6, #1               // left = mid + 1
    B binary_search_loop         // Repetir el bucle

not_found:
    MOV w0, #-1                  // Retorna -1 si no se encontró el valor
    BR LR                        // Usar BR LR en lugar de RET

found:
    MOV w0, w6                   // Retorna la posición donde se encontró el valor
    BR LR                        // Usar BR LR en lugar de RET

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
