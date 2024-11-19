/*
 ============================================================================
 Título     : Conversión de un carácter ASCII a su valor entero en ARM64
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly Raspberry Pi OS
 ============================================================================
*/

/*
Solución en C#

using System;

class Program
{
    static void Main(string[] args)
    {
        char inputChar = 'A'; // Carácter a convertir
        int asciiValue = (int)inputChar; // Conversión de carácter a entero
        Console.WriteLine($"El valor ASCII '{inputChar}' convertido a entero es: {asciiValue}");
    }
}
*/

.global main
.extern printf

.section .data
prompt:
    .asciz "El valor ASCII '%c' convertido a entero es: %d\n"  // Mensaje con el valor ASCII y su conversión
input_char:
    .asciz "A"  // El carácter ASCII 'A' que queremos convertir

.section .text
main:
    // Comienza el código principal

    // Cargar la dirección de la cadena con el carácter 'A' en el registro x0
    ldr x0, =input_char    // Cargar la dirección de 'input_char' (la cadena que contiene 'A')
    ldrb w1, [x0]          // Cargar el primer byte de la cadena en w1 (carácter ASCII)

    // Imprimir el carácter 'A' convertido a su valor ASCII (solo una vez)
    ldr x0, =prompt         // Cargar la dirección del mensaje
    mov w2, w1              // Mover el valor del carácter a w2
    bl printf               // Llamar a printf para imprimir el valor de 'A'

    // Terminar el programa de manera correcta
    mov x0, #0              // Estado de salida 0
    mov x8, #93             // Número del sistema para "exit"
    svc #0                  // Llamada al sistema para terminar el programa

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
