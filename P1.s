/*


*/

/*
Solucion en C#
using System;

class Program
{
    static void Main()
    {
        // Entrada: Temperatura en Celsius
        int celsius = 25;

        // Conversión de Celsius a Fahrenheit
        int fahrenheit = (celsius * 9) / 5 + 32;

        // Imprimir el resultado
        Console.WriteLine("Temperatura en Fahrenheit: {0}", fahrenheit);
    }
}
*/

.global _start

.section .data
celsius_input: .quad 25              // Temperatura en Celsius que queremos convertir
output_string: .asciz "Temperatura en Fahrenheit: %ld\n"  // Cadena para imprimir el resultado

.section .text
_start:
    // Cargar el valor de Celsius desde la memoria
    ldr x0, =celsius_input            // Cargar la dirección de celsius_input en x0
    ldr x1, [x0]                      // Cargar el valor de Celsius en x1

    // Multiplicación por 9
    mov x2, #9                        // Cargar el valor 9 en x2
    mul x1, x1, x2                    // x1 = x1 * 9 (Celsius * 9)

    // División por 5
    mov x2, #5                        // Cargar el valor 5 en x2
    udiv x1, x1, x2                   // x1 = x1 / 5 (Celsius * 9 / 5)

    // Suma de 32
    add x1, x1, #32                   // x1 = x1 + 32 (Celsius * 9 / 5 + 32)

    // Preparar para imprimir el resultado
    ldr x0, =output_string            // Cargar la cadena de salida en x0
    mov x2, x1                        // Cargar el valor de Fahrenheit en x2
    bl printf                         // Llamar a printf para imprimir el valor

    // Salir del programa
    mov x8, #93                       // Número de syscall para salir
    mov x0, #0                        // Código de salida 0
    svc #0                            // Llamada al sistema
