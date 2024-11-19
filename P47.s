/*
 ============================================================================
 Título     : Detección de desbordamiento en suma con ARM64 Assembly
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly Raspberry Pi OS para detectar
              desbordamiento en una operación de suma.
 ============================================================================
*/

/*
Solucion en C#

using System;

class Program {
    static void Main() {
        long num1 = 9223372036854775807;  // Número grande (MAX_INT64)
        long num2 = 1;                    // Número pequeño para sumar

        try {
            long result = checked(num1 + num2);  // Realizar la suma con detección de desbordamiento
            Console.WriteLine("No ocurrió desbordamiento en la suma.");
        } catch (OverflowException) {
            Console.WriteLine("¡Desbordamiento detectado en la suma!");
        }
    }
}
*/

.global _start

.section .data
    msg_overflow: .asciz "¡Desbordamiento detectado en la suma!\n"
    msg_nooverflow: .asciz "No ocurrió desbordamiento en la suma.\n"

.section .bss
    .comm sum_result, 8  // Reservar espacio para el resultado de la suma

.section .text
_start:
    // Cargar los números para la suma
    mov x0, #9223372036854775807  // Número grande (MAX_INT64)
    mov x1, #1                   // Número pequeño para sumar

    // Realizar la suma
    add x2, x0, x1               // x2 = x0 + x1 (Resultado de la suma)

    // Comprobar si ocurrió un desbordamiento
    cmp x2, x0                    // Compara el resultado con el primer número
    bne no_overflow               // Si no hay desbordamiento, salta a no_overflow

    // Desbordamiento detectado
    ldr x0, =msg_overflow         // Cargar la dirección del mensaje de desbordamiento
    bl printf                     // Llamar a printf
    b end                         // Salir

no_overflow:
    // No hay desbordamiento
    ldr x0, =msg_nooverflow       // Cargar la dirección del mensaje sin desbordamiento
    bl printf                     // Llamar a printf

end:
    mov x8, #93                   // Código de salida del sistema
    mov x0, #0                    // Estado de salida
    svc #0                        // Hacer la llamada al sistema para terminar el programa

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
