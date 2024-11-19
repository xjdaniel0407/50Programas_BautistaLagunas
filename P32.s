/*
 ============================================================================ 
 Título     : Cálculo de la potencia de un número (x^n) en ARM64 Assembly	
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly para calcular la potencia de un número
              (base elevada a un exponente) en Raspberry Pi OS.
 ============================================================================ 
*/

/*
Solución en C#

using System;

class Program
{
    static void Main()
    {
        // Solicitar base y exponente al usuario
        Console.Write("Introduce la base (x): ");
        long baseValue = Convert.ToInt64(Console.ReadLine());

        Console.Write("Introduce el exponente (n): ");
        long exponent = Convert.ToInt64(Console.ReadLine());

        // Calcular la potencia
        long result = Power(baseValue, exponent);

        // Mostrar el resultado
        Console.WriteLine($"El resultado de {baseValue}^{exponent} es: {result}");
    }

    // Función para calcular la potencia
    static long Power(long x, long n)
    {
        long result = 1;

        // Si el exponente es 0, devolver 1
        if (n == 0)
            return result;

        // Calcular potencia
        for (long i = 0; i < n; i++)
        {
            result *= x;
        }

        return result;
    }
}
*/

.data
    prompt1: .asciz "Introduce la base (x): "
    prompt2: .asciz "Introduce el exponente (n): "
    result_fmt: .asciz "El resultado de %ld^%ld es: %ld\n"
    scan_fmt: .asciz "%ld"
    
.text
.extern printf
.extern scanf
.global _start

_start:
    // Prólogo
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Imprimir prompt para la base
    adr     x0, prompt1
    bl      printf

    // Leer la base (x)
    sub     sp, sp, 16         // Espacio para la variable
    mov     x1, sp             // Dirección donde guardar el número
    adr     x0, scan_fmt       // Formato para scanf
    bl      scanf

    // Guardar la base en x19
    ldr     x19, [sp]

    // Imprimir prompt para el exponente
    adr     x0, prompt2
    bl      printf

    // Leer el exponente (n)
    mov     x1, sp             // Reutilizar el espacio en la pila
    adr     x0, scan_fmt
    bl      scanf

    // Guardar el exponente en x20
    ldr     x20, [sp]
    add     sp, sp, 16         // Restaurar el sp

    // Calcular potencia
    mov     x0, x19            // Base en x0
    mov     x1, x20            // Exponente en x1
    bl      power              // Llamar a la función power

    // Imprimir resultado
    mov     x3, x0             // Resultado en x3 (tercer argumento de printf)
    mov     x2, x20            // Exponente en x2 (segundo argumento)
    mov     x1, x19            // Base en x1 (primer argumento)
    adr     x0, result_fmt     // Formato para printf
    bl      printf

    // Salir del programa
    mov     x0, #0             // código de retorno 0
    mov     x8, #93            // syscall exit
    svc     #0

// Función power: calcula x^n
// Parámetros: x0 = base (x), x1 = exponente (n)
// Retorna: x0 = resultado
power:
    // Prólogo
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Guardar base y exponente
    mov     x2, x0             // x2 = base
    mov     x3, x1             // x3 = exponente

    // Inicializar resultado
    mov     x0, #1             // resultado = 1

    // Si exponente es 0, retornar 1
    cbz     x3, power_done

power_loop:
    // Mientras exponente > 0
    cbz     x3, power_done     // Si exponente == 0, terminar
    
    // resultado *= base
    mul     x0, x0, x2
    
    // exponente--
    sub     x3, x3, #1
    
    b       power_loop

power_done:
    // Epílogo
    ldp     x29, x30, [sp], 16
    ret

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
