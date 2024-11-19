/*
 ============================================================================
 Título     : Factorial de un número	
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly Raspberry Pi OS
 ============================================================================
*/

/*
Solucion en C#
using System;

class Program
{
    static void Main(string[] args)
    {
        Console.Write("Introduce un número: ");
        int number = int.Parse(Console.ReadLine());

        long factorial = CalculateFactorial(number);

        Console.WriteLine($"El factorial de {number} es {factorial}");
    }

    static long CalculateFactorial(int n)
    {
        if (n < 0)
        {
            throw new ArgumentException("El factorial no está definido para números negativos.");
        }

        long result = 1;
        for (int i = 1; i <= n; i++)
        {
            result *= i;
        }
        return result;
    }
}

*/
.section .data
input_number: .quad 5                     // Número del cual calcular el factorial
format_str: .asciz "El factorial de %d es %d\n"  // Formato para printf

.section .text
.global _start
.extern printf                            // Declarar printf como una función externa

_start:
    // Cargar el número a calcular
    ldr x1, =input_number                  // Cargar la dirección del número en x1
    ldr x0, [x1]                           // Cargar el número en x0
    mov x1, x0                             // Copiar el número a x1 (para impresión)

    // Inicializar variables
    mov x2, 1                              // x2 almacenará el resultado, comenzamos en 1

factorial_loop:
    cmp x0, 1                              // Comparar x0 con 1
    ble end_factorial                      // Si x0 <= 1, salimos del bucle
    mul x2, x2, x0                         // x2 = x2 * x0
    sub x0, x0, 1                          // Decrementamos x0
    b factorial_loop                       // Repetir el bucle

end_factorial:
    // Preparar llamada a printf
    ldr x0, =format_str                    // Cargar dirección de cadena de formato en x0
    mov x3, x2                             // Pasar el resultado en x3
    bl printf                              // Llamar a printf

    // Salir del programa
    mov x8, 93                             // syscall 93 es exit
    mov x0, 0                              // Código de salida 0
    svc 0

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
