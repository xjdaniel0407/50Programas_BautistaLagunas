/*
 ============================================================================ 
 Título     : Desplazamiento a la izquierda y derecha en ARM64 
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly para Raspberry Pi OS que muestra el 
              desplazamiento a la izquierda y a la derecha de un valor.
 ============================================================================ 
*/

/*
Solucion en C#

using System;

class Program
{
    static void Main()
    {
        int val = 4;
        Console.WriteLine("Desplazamiento a la izquierda de {0}: {1}, Desplazamiento a la derecha de {0}: {2}",
            val, val << 2, val >> 2);
    }
}
*/

.global _start

.extern printf

.section .data
    fmt: .asciz "Desplazamiento a la izquierda de %d: %d, Desplazamiento a la derecha de %d: %d\n"
    val1: .quad 4  // Valor para el desplazamiento

.section .text
_start:
    // Cargar el valor para desplazamiento
    ldr x0, =val1           // Cargar la dirección de 'val1'
    ldr x1, [x0]            // Cargar el valor de 'val1' en x1

    // Desplazamiento a la izquierda
    mov x2, x1              // Copiar el valor de x1 a x2
    lsl x2, x2, #2          // Desplazar a la izquierda (2 bits)

    // Desplazamiento a la derecha (asegurando que sea lógico, sin signo)
    mov x3, x1              // Copiar el valor de x1 a x3
    mov x4, x3              // Asegurarse de que es interpretado como sin signo
    lsr x4, x4, #2          // Desplazar a la derecha (2 bits)

    // Imprimir el resultado en una sola línea
    ldr x0, =fmt            // Cargar la dirección del formato
    mov x1, x1              // Valor original
    mov x2, x2              // Valor desplazado a la izquierda
    mov x3, x4              // Valor desplazado a la derecha (sin signo)
    bl printf               // Llamada a printf

    // Salir del programa
    mov x8, #93             // Syscall para exit (93 en ARM64)
    mov x0, #0              // Código de salida
    svc #0                  // Llamada al sistema para salir

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
