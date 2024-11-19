/*
 ============================================================================ 
 Título     : Contar vocales y consonantes en una cadena (Hola Mundo) 
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
        string input = "Hola Mundo";  // Cadena de entrada
        int vocales = 0;
        int consonantes = 0;

        foreach (char c in input)
        {
            if ("aeiouAEIOU".IndexOf(c) >= 0)
            {
                vocales++;  // Contar vocales
            }
            else if (Char.IsLetter(c))
            {
                consonantes++;  // Contar consonantes
            }
        }

        Console.WriteLine($"Vocales: {vocales}");
        Console.WriteLine($"Consonantes: {consonantes}");
    }
}

*/
.global _start

.section .data
    cadena: .asciz "Hola Mundo"   // Cadena de entrada solo con palabras

.section .bss
    vocales:     .skip 4
    consonantes: .skip 4

.section .text
_start:
    // Inicialización de los contadores
    mov x0, 0          // vocales = 0
    mov x1, 0          // consonantes = 0

    // Dirección de la cadena que se va a analizar
    adr x2, cadena     // x2 = &cadena

contar:
    // Cargar un byte (carácter) de la cadena
    ldrb w3, [x2], #1  // w3 = *x2++, carga un byte de la cadena y avanza el puntero

    // Verificar si llegamos al final de la cadena (byte nulo)
    cmp w3, #0
    beq terminar       // Si el carácter es nulo, salimos del bucle

    // Comprobar si el carácter es una vocal (minúscula o mayúscula)
    blt no_vocal
    cmp w3, #'a'
    beq es_vocal
    cmp w3, #'e'
    beq es_vocal
    cmp w3, #'i'
    beq es_vocal
    cmp w3, #'o'
    beq es_vocal
    cmp w3, #'u'
    beq es_vocal
    cmp w3, #'A'
    beq es_vocal
    cmp w3, #'E'
    beq es_vocal
    cmp w3, #'I'
    beq es_vocal
    cmp w3, #'O'
    beq es_vocal
    cmp w3, #'U'
    beq es_vocal
    b no_vocal

es_vocal:
    add x0, x0, #1    // Incrementar contador de vocales
    b no_vocal

no_vocal:
    // Comprobar si es una consonante (letras del alfabeto)
    cmp w3, #'a'
    blt siguiente
    cmp w3, #'z'
    bgt siguiente
    cmp w3, #'A'
    blt siguiente
    cmp w3, #'Z'
    bgt siguiente

    add x1, x1, #1    // Incrementar contador de consonantes

siguiente:
    b contar

terminar:
    // Finalizar el programa y devolver el control al sistema operativo
    mov x8, #93         // syscall número 93: exit
    mov x0, #0          // código de salida 0
    svc #0              // Llamada al sistema para salir

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
