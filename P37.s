/*
 ============================================================================ 
 Título     : Implementación de una pila usando un arreglo en ARM64 Assembly
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly para Raspberry Pi OS que implementa 
              una pila utilizando un arreglo y realiza operaciones de apilado 
              y desapilado, mostrando los resultados con printf.
 ============================================================================ 
*/

/*
Solucion en C#

using System;
using System.Collections.Generic;

class Program
{
    static void Main()
    {
        // Definimos una pila con un arreglo
        int[] stack = new int[5];
        int top = -1;  // Puntero de la pila

        // Apilamos algunos elementos
        Push(stack, ref top, 10);
        Push(stack, ref top, 20);
        Push(stack, ref top, 30);

        // Desapilamos e imprimimos los elementos
        Pop(stack, ref top);
        Pop(stack, ref top);
        Pop(stack, ref top);
    }

    static void Push(int[] stack, ref int top, int value)
    {
        if (top < stack.Length - 1)
        {
            top++;
            stack[top] = value;
            Console.WriteLine($"Elemento apilado: {value}");
        }
        else
        {
            Console.WriteLine("La pila está llena.");
        }
    }

    static void Pop(int[] stack, ref int top)
    {
        if (top >= 0)
        {
            Console.WriteLine($"Elemento desapilado: {stack[top]}");
            top--;
        }
        else
        {
            Console.WriteLine("La pila está vacía.");
        }
    }
}
*/

/*
 Código en ensamblador ARM64
*/

.global _start

.section .data
    prompt: .asciz "Pila vacía.\n"
    format: .asciz "Elemento desapilado: %d\n"

.section .bss
    stack: .skip 40  // Pila de tamaño 5 (usando 8 bytes por entero)

.section .text
_start:
    // Inicializamos el puntero de la pila
    mov x0, 0          // x0 es el índice de la pila (inicia en 0)
    mov x1, 5          // x1 es el tamaño máximo de la pila
    mov x2, stack      // x2 es el puntero al inicio de la pila

    // Apilamos algunos valores
    mov x3, 10         // Elemento 1
    bl push

    mov x3, 20         // Elemento 2
    bl push

    mov x3, 30         // Elemento 3
    bl push

    // Desapilamos e imprimimos los elementos
    bl pop
    bl pop
    bl pop

    // Salimos del programa
    mov x0, 0
    mov x8, 93         // syscall para exit
    svc 0

push:
    // Verificamos si la pila está llena
    cmp x0, x1         // x0 = índice, x1 = tamaño máximo
    bge .stack_full    // Si x0 >= x1, la pila está llena

    // Guardamos el valor en la pila
    str x3, [x2, x0, lsl #3]  // Almacenamos en stack[x0]
    add x0, x0, 1              // Incrementamos el índice de la pila
    ret

.stack_full:
    // La pila está llena, mostramos un mensaje
    mov x0, prompt
    bl printf
    ret

pop:
    // Verificamos si la pila está vacía
    cmp x0, 0         // x0 = índice
    beq .stack_empty  // Si x0 == 0, la pila está vacía

    // Desapilamos el valor
    sub x0, x0, 1     // Decrementamos el índice
    ldr x3, [x2, x0, lsl #3]  // Cargamos el valor desapilado
    mov x0, x3
    bl printf         // Imprimimos el valor
    ret

.stack_empty:
    // La pila está vacía, mostramos un mensaje
    mov x0, prompt
    bl printf
    ret

printf:
    // Llamada al sistema de printf
    mov x8, 64         // syscall para write
    mov x1, x0         // Dirección del string
    mov x2, 100        // Longitud máxima (ajustable según el string)
    mov x0, 1          // Descriptor de archivo (stdout)
    svc 0
    ret

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
