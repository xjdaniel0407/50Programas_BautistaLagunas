/*
 ============================================================================
 Título     : Medir el tiempo de ejecución de una función en ARM64 Assembly	
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly para medir el tiempo de ejecución de una función sobre Raspberry Pi OS.
 ============================================================================
*/

/*
Solucion en C#

using System;
using System.Diagnostics;

class Program
{
    static void Main()
    {
        // Crear un cronómetro para medir el tiempo de ejecución
        Stopwatch stopwatch = new Stopwatch();

        // Iniciar el cronómetro
        stopwatch.Start();

        // Llamar a la función cuyo tiempo queremos medir
        MiFuncion();

        // Detener el cronómetro
        stopwatch.Stop();

        // Mostrar el tiempo de ejecución
        Console.WriteLine("Tiempo de ejecución: " + stopwatch.ElapsedMilliseconds + " milisegundos");
    }

    static void MiFuncion()
    {
        // Función de ejemplo que hace algo de trabajo
        for (int i = 0; i < 1000000; i++) { }
    }
}
*/

.global _start

.extern printf

.section .data
    msg: .asciz "Tiempo de ejecución: %lld segundos\n"

.section .bss
    result: .skip 8  // Para almacenar el tiempo de ejecución

.section .text
_start:
    // Obtener el tiempo inicial
    mrs x0, CNTVCT_EL0       // Leer el contador de tiempo del sistema (CNTVCT_EL0) en x0

    // Llamar a la función que quieres medir
    bl mi_funcion

    // Obtener el tiempo final
    mrs x1, CNTVCT_EL0       // Leer el contador de tiempo del sistema (CNTVCT_EL0) en x1

    // Calcular el tiempo transcurrido
    sub x1, x1, x0           // x1 = x1 - x0 (tiempo final - tiempo inicial)

    // Imprimir el tiempo
    ldr x0, =msg             // Cargar la dirección del mensaje en x0
    mov x2, x1               // Mover el tiempo de ejecución a x2 para pasarlo a printf
    bl printf                // Llamar a printf

    // Salir del programa
    mov x8, #93              // Código de salida del sistema
    mov x0, #0               // Código de salida (0)
    svc #0                   // Llamada al sistema (exit)

mi_funcion:
    // Esta es la función cuya ejecución vamos a medir
    // Aquí puedes poner cualquier código que desees medir
    mov x0, #0               // Simplemente retorna 0
    ret

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
