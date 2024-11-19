/*
 ============================================================================ 
 Título     : Contador de Bits Activados (1) en un Número (ARM64 Assembly)
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
        Console.Write("Introduce un número: ");
        ulong number = Convert.ToUInt64(Console.ReadLine());

        int count = CountSetBits(number);
        
        Console.WriteLine($"Número de bits activados: {count}");
    }

    static int CountSetBits(ulong number)
    {
        int count = 0;

        while (number != 0)
        {
            count += (int)(number & 1); // Verifica el bit menos significativo
            number >>= 1; // Desplaza el número a la derecha
        }

        return count;
    }
}
*/

.data
    msg1:    .ascii      "Introduce un número: \0"
    msg1_len = . - msg1
    msg2:    .ascii      "Número de bits activados: \0"
    msg2_len = . - msg2
    fmt:     .ascii      "%d\n\0"
    number:  .quad       0
    result:  .quad       0

.text
.global _start

// Función principal
_start:
    // Imprimir mensaje inicial
    mov     x0, #1              // stdout
    adr     x1, msg1           // mensaje
    mov     x2, msg1_len       // longitud
    mov     x8, #64            // syscall write
    svc     #0

    // Leer número del usuario
    mov     x0, #0              // stdin
    adr     x1, number         // buffer
    mov     x2, #8             // máximo 8 bytes
    mov     x8, #63            // syscall read
    svc     #0

    // Cargar número en x0
    ldr     x0, number

    // Llamar a la función de contar bits
    bl      count_set_bits

    // Guardar resultado
    str     x0, result

    // Imprimir mensaje de resultado
    mov     x0, #1
    adr     x1, msg2
    mov     x2, msg2_len
    mov     x8, #64
    svc     #0

    // Convertir resultado a string y mostrar
    ldr     x0, result
    bl      print_number

    // Salir
    mov     x0, #0
    mov     x8, #93            // syscall exit
    svc     #0

// Función para contar bits activados
count_set_bits:
    mov     x2, #0              // contador de bits
    mov     x3, #64             // número de bits a procesar

count_loop:
    cbz     x3, count_done      // si no quedan bits, terminar
    and     x4, x0, #1          // obtener bit menos significativo
    add     x2, x2, x4          // sumar al contador si es 1
    lsr     x0, x0, #1          // desplazar derecha
    sub     x3, x3, #1          // decrementar contador
    b       count_loop

count_done:
    mov     x0, x2              // retornar resultado
    ret

// Función para imprimir número
print_number:
    // Guardar registros
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Convertir número a ASCII
    mov     x1, #10             // divisor
    mov     x2, sp              // usar stack para string
    sub     sp, sp, #16         // reservar espacio

convert_loop:
    udiv    x3, x0, x1          // dividir por 10
    msub    x4, x3, x1, x0      // obtener resto
    add     x4, x4, #'0'        // convertir a ASCII
    strb    w4, [x2], #-1       // guardar dígito
    mov     x0, x3              // actualizar número
    cbnz    x0, convert_loop    // continuar si no es 0

    // Imprimir número
    add     x2, x2, #1          // ajustar puntero
    mov     x0, #1              // stdout
    mov     x8, #64             // syscall write
    svc     #0

    // Imprimir nueva línea
    mov     x0, #1
    adr     x1, newline
    mov     x2, #1
    mov     x8, #64
    svc     #0

    // Restaurar registros y retornar
    mov     sp, x29
    ldp     x29, x30, [sp], #16
    ret

.data
newline:    .ascii      "\n"

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*
*/
