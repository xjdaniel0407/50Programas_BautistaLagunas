/*
 ============================================================================ 
 Título     : Implementación de una Cola usando un Arreglo en ARM64 Assembly
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly para Raspberry Pi OS que implementa una cola 
              utilizando un arreglo y usa printf para imprimir los elementos de la cola.
 ============================================================================ 
*/

/*
Solucion en C#

using System;
using System.Collections.Generic;

class Cola
{
    private Queue<int> cola;

    public Cola()
    {
        cola = new Queue<int>();
    }

    public void Enqueue(int valor)
    {
        if (cola.Count < 5)  // Verificar que la cola no esté llena
        {
            cola.Enqueue(valor);
        }
        else
        {
            Console.WriteLine("Cola llena, no se puede agregar el elemento.");
        }
    }

    public void ImprimirCola()
    {
        foreach (int valor in cola)
        {
            Console.WriteLine("Elemento en la cola: " + valor);
        }
    }
}

class Programa
{
    static void Main()
    {
        Cola miCola = new Cola();
        miCola.Enqueue(10);
        miCola.Enqueue(20);
        miCola.Enqueue(30);
        miCola.Enqueue(40);
        miCola.ImprimirCola();
    }
}
*/

/*
 Código en Assembly ARM64
*/

    .global _start

    .section .data
queue:  
    .skip 40              // Reserva 40 bytes para una cola de 5 enteros (4 bytes por entero)
size:   
    .quad 0               // Tamaño de la cola (inicialmente 0)
front:  
    .quad 0               // Indice del frente de la cola
rear:   
    .quad 0               // Indice del final de la cola
msg:    
    .asciz "Elemento en la cola: %d\n" // Mensaje para imprimir un elemento

    .section .text
_start:
    // Inicialización
    mov x0, 5            // Establecer tamaño máximo de la cola
    mov x1, 0            // Inicializar índice de frente a 0
    mov x2, 0            // Inicializar índice de rear a 0
    str x1, [front]      // Guardar el valor de 'front' en memoria
    str x2, [rear]       // Guardar el valor de 'rear' en memoria
    str x1, [size]       // Establecer tamaño inicial de la cola a 0

    // Agregar elementos a la cola
    mov x0, 10           // Primer elemento para agregar
    bl enqueue
    mov x0, 20           // Segundo elemento para agregar
    bl enqueue
    mov x0, 30           // Tercer elemento para agregar
    bl enqueue
    mov x0, 40           // Cuarto elemento para agregar
    bl enqueue

    // Imprimir los elementos de la cola
    bl print_queue

    // Finalizar
    mov x8, 93           // Código de salida del sistema
    mov x0, 0            // Código de salida
    svc 0

// Función enqueue (agregar un elemento a la cola)
enqueue:
    ldr x3, [size]       // Cargar el tamaño actual de la cola
    ldr x4, [front]      // Cargar el índice del frente de la cola
    ldr x5, [rear]       // Cargar el índice del rear de la cola
    ldr x6, [size]       // Cargar el tamaño de la cola
    cmp x6, 5            // Comprobar si la cola está llena (máximo de 5 elementos)
    bge queue_full       // Si la cola está llena, saltar a queue_full

    // Si la cola no está llena, agregar el elemento
    str x0, [queue, x5, LSL #2]  // Guardar el elemento en la posición rear
    add x5, x5, #1         // Incrementar el índice de rear
    cmp x5, 5              // Si rear llega a 5, volver a 0
    blt update_rear
    mov x5, 0              // Reiniciar el índice de rear a 0

update_rear:
    str x5, [rear]         // Guardar el nuevo índice de rear
    add x3, x3, #1         // Incrementar el tamaño de la cola
    str x3, [size]         // Actualizar el tamaño de la cola
    ret

queue_full:
    // Cola llena, no hacer nada
    ret

// Función print_queue (imprimir los elementos de la cola)
print_queue:
    ldr x3, [size]       // Cargar el tamaño actual de la cola
    ldr x4, [front]      // Cargar el índice del frente de la cola
    ldr x5, [rear]       // Cargar el índice del rear de la cola
    mov x6, 0            // Inicializar contador

print_loop:
    cmp x6, x3           // Comprobar si se han impreso todos los elementos
    bge print_done

    ldr x7, [queue, x4, LSL #2]  // Cargar el elemento en el índice front
    mov x0, x7           // Pasar el elemento a x0 para printf
    ldr x1, =msg         // Cargar la dirección del mensaje
    bl printf            // Llamar a printf para imprimir el elemento

    add x4, x4, #1       // Incrementar el índice de front
    cmp x4, 5            // Si front llega a 5, volver a 0
    blt no_wrap
    mov x4, 0            // Reiniciar el índice de front a 0

no_wrap:
    add x6, x6, #1       // Incrementar el contador
    b print_loop         // Continuar el bucle

print_done:
    ret

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
