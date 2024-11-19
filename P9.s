/*
 ============================================================================
 Título     : Verificar si un número es primo
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly Raspberry Pi OS
 ============================================================================
*/

/*
Solución en C#

using System;

class Program
{
    static void Main()
    {
        int num = 29; // Cambia este número según sea necesario
        if (IsPrime(num))
        {
            Console.WriteLine($"El número es primo: {num}");
        }
        else
        {
            Console.WriteLine($"El número no es primo: {num}");
        }
    }

    static bool IsPrime(int num)
    {
        if (num <= 1) return false;
        for (int i = 2; i * i <= num; i++)
        {
            if (num % i == 0) return false;
        }
        return true;
    }
}
*/

.global main
.extern printf

.section .data
prompt: 
    .asciz "El número es primo: %d\n"  // Mensaje para número primo
false_message: 
    .asciz "El número no es primo: %d\n"  // Mensaje para número no primo

.section .text
main:
    // Número a verificar (29 por ejemplo)
    mov x0, #29  // Carga el número en x0

    // Llamada a la función para verificar si es primo
    bl is_prime

    // Comprobar el resultado
    cmp x0, #0  // 0 indica que es primo
    beq print_prime

    // Imprimir "No es primo"
    ldr x0, =false_message
    bl printf
    b end

print_prime:
    // Imprimir "Es primo"
    ldr x0, =prompt
    bl printf

end:
    // Terminar correctamente
    mov x0, #0       // Estado de salida 0
    mov x8, #93      // Llamada al sistema "exit"
    svc #0           // Terminar el programa

is_prime:
    mov x1, x0       // Guardar el número en x1
    cmp x1, #1       // Si el número es menor o igual a 1, no es primo
    ble not_prime

    mov x2, #2       // Comenzar la división desde 2
check_loop:
    mov x3, x1       // Dividendo
    udiv x3, x1, x2  // x3 = x1 / x2
    mul x3, x3, x2   // x3 = (x1 / x2) * x2
    cmp x3, x1       // ¿Es divisible exactamente?
    bne next_divisor // Si no, probar el siguiente divisor

not_prime:
    mov x0, #1       // No es primo
    ret

next_divisor:
    add x2, x2, #1   // Incrementar divisor
    cmp x2, x1       // Si el divisor alcanza el número, es primo
    blt check_loop

    mov x0, #0       // Es primo
    ret

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
