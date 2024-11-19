/*
 ============================================================================ 
 Título     : Establecer, borrar y alternar bits en ARM64 Assembly Raspberry Pi OS 
 Autor      : Bautista Lagunas Jose Daniel 
 Descripción: Programa en ARM64 Assembly para Raspberry Pi OS que establece, borra y alterna bits en un valor binario 
 ============================================================================ 
*/

/*
Solucion en C#

using System;

class BitOperations
{
    static void Main()
    {
        // Inicializamos el valor con todos los bits en 0
        ulong value = 0b00000000; // Para 64 bits
        int bitPosition = 3; // El bit que vamos a operar (en este caso el 3)

        // Establecer el bit
        value = SetBit(value, bitPosition);
        Console.WriteLine("Establecer bit: " + Convert.ToString((long)value, 2).PadLeft(64, '0'));

        // Borrar el bit
        value = ClearBit(value, bitPosition);
        Console.WriteLine("Borrar bit: " + Convert.ToString((long)value, 2).PadLeft(64, '0'));

        // Alternar el bit
        value = ToggleBit(value, bitPosition);
        Console.WriteLine("Alternar bit: " + Convert.ToString((long)value, 2).PadLeft(64, '0'));
    }

    // Establecer un bit en la posición indicada
    static ulong SetBit(ulong number, int bitPosition)
    {
        return number | ((ulong)1 << bitPosition);
    }

    // Borrar un bit en la posición indicada
    static ulong ClearBit(ulong number, int bitPosition)
    {
        return number & ~((ulong)1 << bitPosition);
    }

    // Alternar un bit en la posición indicada
    static ulong ToggleBit(ulong number, int bitPosition)
    {
        return number ^ ((ulong)1 << bitPosition);
    }
}
*/

.global _start

.section .data
    msg_set: .asciz "Establecer bit: "
    msg_clear: .asciz "Borrar bit: "
    msg_toggle: .asciz "Alternar bit: "
    bit_position: .quad 3           // El bit que vamos a operar (en este caso el 3)

.section .bss
    bin_str: .skip 65               // Cadena para almacenar el número binario (hasta 64 bits + terminador)

.section .text
_start:
    // Cargar los valores iniciales
    mov x0, 0b00000000           // Registro con todos los bits en 0 (operación inicial)
    ldr x1, =bit_position        // Cargar la dirección de la posición del bit a manipular

    // Establecer el bit
    ldr x2, [x1]                 // Cargar el valor de la posición del bit
    mov x3, 1                    // 1 para establecer el bit
    lsl x3, x3, x2               // Desplazar el 1 hacia la posición del bit
    orr x0, x0, x3               // Establecer el bit en la posición indicada

    // Imprimir el valor después de establecer el bit
    ldr x0, =msg_set
    bl printf
    mov x1, x0                   // Guardamos el valor de x0 para impresión binaria
    bl print_bin

    // Borrar el bit
    ldr x2, [x1]                 // Cargar nuevamente la posición del bit
    mov x3, 1                    // 1 para borrar el bit
    lsl x3, x3, x2               // Desplazar el 1 hacia la posición del bit
    neg x3, x3                   // Negar el valor (invirtiendo los bits)
    and x0, x0, x3               // Borrar el bit en la posición indicada

    // Imprimir el valor después de borrar el bit
    ldr x0, =msg_clear
    bl printf
    mov x1, x0                   // Guardamos el valor de x0 para impresión binaria
    bl print_bin

    // Alternar el bit
    ldr x2, [x1]                 // Cargar nuevamente la posición del bit
    mov x3, 1                    // 1 para alternar el bit
    lsl x3, x3, x2               // Desplazar el 1 hacia la posición del bit
    eor x0, x0, x3               // Alternar el bit en la posición indicada

    // Imprimir el valor después de alternar el bit
    ldr x0, =msg_toggle
    bl printf
    mov x1, x0                   // Guardamos el valor de x0 para impresión binaria
    bl print_bin

    // Salir del programa
    mov x0, 0
    mov x8, 93                   // Syscall número 93 para terminar el programa
    svc 0

// Función para imprimir un número en formato binario
print_bin:
    ldr x2, =bin_str             // Dirección de la cadena binaria
    mov x3, 64                   // Número de bits (en 64 bits)
    mov x4, x0                   // Valor a imprimir

    // Convertir a binario
    bin_loop:
        and x5, x4, 1            // Extraer el bit más bajo
        add w5, w5, #48          // Convertir 0 o 1 a ASCII ('0' o '1')
        strb w5, [x2], 1         // Almacenar en la cadena y avanzar
        lsr x4, x4, 1            // Desplazar el valor a la derecha
        subs x3, x3, 1           // Decrementar el contador
        bne bin_loop             // Repetir si quedan más bits

    // Añadir el terminador nulo
    mov w5, 0
    strb w5, [x2]

    // Imprimir la cadena binaria
    mov x0, 1                   // File descriptor 1 (stdout)
    mov x1, x2                  // Dirección de la cadena
    mov x2, 64                  // Longitud de la cadena
    mov x8, 64                  // Syscall número 64 para write
    svc 0

    ret

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
