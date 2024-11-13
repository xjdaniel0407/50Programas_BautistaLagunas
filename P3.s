/*
Titulo: Resta de dos números	
Autor: Bautista Lagunas Jose Daniel 

*/

/*
Solucion en C#
using System;

class Program
{
    static void Main()
    {
        // Definir los números a restar
        int minuendo = 15;
        int sustraendo = 7;

        // Realizar la resta
        int resultado = minuendo - sustraendo;

        // Mostrar el resultado
        Console.WriteLine("El resultado de la resta es: {0}", resultado);

        // Terminar el programa
        Environment.Exit(0);
    }
}

*/

.global _start

.section .data
format_string: .asciz "El resultado de la resta es: %d\n"

.section .text
.extern printf

_start:
    // Define los números a restar
    mov x0, #15          // Primer número (minuendo)
    mov x1, #7           // Segundo número (sustraendo)

    // Realiza la resta
    sub x2, x0, x1       // x2 = x0 - x1

    // Configura los argumentos para printf
    ldr x0, =format_string  // Primer argumento (cadena de formato)
    mov x1, x2              // Segundo argumento (resultado de la resta)

    // Llama a printf
    bl printf

    // Termina el programa
    mov x8, #93           // syscall number for exit in Raspberry Pi OS (Linux)
    mov x0, #0            // exit code 0
    svc #0                // llamada al sistema para salir

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
