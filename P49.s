/*
 ============================================================================
 Título     : Leer entrada desde el teclado e imprimirla con printf en ARM64
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
        Console.Write("Introduzca algo: ");
        string input = Console.ReadLine();
        Console.WriteLine(input);
    }
}
*/

    .global _start

    .text
_start:
    // Llamada al sistema para configurar printf (llamamos a la función C para imprimir)
    // Preparamos el stack para llamar a la función printf.
    mov x0, prompt            // Dirección de la cadena "Introduzca algo:"
    bl  printf                // Llamada a printf

    // Llamada al sistema para leer la entrada desde el teclado
    mov x0, input_buffer      // Dirección del buffer para almacenar la entrada
    mov x1, 100               // Tamaño máximo de la entrada
    bl  scanf                 // Llamada a scanf

    // Llamada a printf para imprimir lo que el usuario introdujo
    mov x0, input_buffer      // Dirección del buffer de entrada
    bl  printf                // Llamada a printf para imprimir la entrada

    // Salir del programa
    mov x0, 0                 // Código de salida
    mov x8, 93                // Llamada al sistema para salir
    svc 0

    .data
prompt: 
    .asciz "Introduzca algo: " // Texto que se imprime antes de la entrada
input_buffer:
    .space 100                 // Espacio de 100 bytes para almacenar la entrada del usuario

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
