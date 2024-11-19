/*
 ============================================================================
 Título     : Invertir una cadena	
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
        string cadena = "Hola Mundo";
        char[] invertida = cadena.ToCharArray();
        Array.Reverse(invertida);
        Console.WriteLine("Cadena invertida: " + new string(invertida));
    }
}
*/

.global _start

.section .data
    format: .asciz "Cadena invertida: %s\n"
    cadena: .asciz "Hola Mundo"

.section .bss
    invertida: .skip 100  // Espacio para la cadena invertida

.section .text
_start:
    // Cargar la dirección de la cadena original
    ldr x0, =cadena         // Cargar la dirección de la cadena
    ldr x1, =invertida      // Cargar la dirección del buffer invertido

    // Encontrar la longitud de la cadena original
    mov x2, #0              // Inicializamos el contador de longitud
find_end:
    ldrb w3, [x0, x2]      // Cargar el byte en la posición actual de la cadena
    cmp w3, #0             // Comprobar si hemos llegado al final (NUL)
    beq start_invertir      // Si hemos llegado al final, saltar al proceso de inversión
    add x2, x2, #1          // Incrementar el contador de longitud
    b find_end              // Continuar buscando el final de la cadena

start_invertir:
    // Inicializar el puntero de destino para la cadena invertida
    add x1, x1, x2          // Mueve x1 al final del buffer invertido
    subs x1, x1, #1         // Retroceder al último byte disponible en el buffer

invertir:
    ldrb w3, [x0], #1      // Cargar un byte de la cadena y avanzar el puntero
    cmp w3, #0             // Comprobar si hemos llegado al final de la cadena (NUL)
    beq terminar           // Si hemos llegado al final, salir del bucle

    strb w3, [x1], #-1     // Guardar el carácter invertido y retroceder el puntero
    b invertir             // Continuar con el siguiente carácter

terminar:
    // Añadir el carácter de terminación de cadena NUL
    mov w3, #0
    strb w3, [x1]          // Terminar la cadena invertida

    // Imprimir la cadena invertida usando printf
    ldr x0, =format        // Cargar el formato para printf
    ldr x1, =invertida     // Cargar la dirección de la cadena invertida
    bl printf              // Llamada a printf

    // Terminar el programa
    mov x8, #93            // syscall number for exit
    mov x0, #0             // status code 0
    svc #0                 // hacer la llamada al sistema (exit)

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
