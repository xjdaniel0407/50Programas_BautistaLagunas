/*
 ============================================================================ 
 Título     : Cálculo del Máximo Común Divisor (MCD) usando el algoritmo de Euclides
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly para Raspberry Pi OS que calcula el 
              MCD de dos números introducidos por el usuario.
 ============================================================================ 
*/

/*
Solución en C#

using System;

class Program
{
    static void Main()
    {
        Console.Write("Introduce el primer número: ");
        int num1 = int.Parse(Console.ReadLine());
        
        Console.Write("Introduce el segundo número: ");
        int num2 = int.Parse(Console.ReadLine());
        
        int mcd = CalcularMCD(num1, num2);
        
        Console.WriteLine($"El MCD es: {mcd}");
    }

    static int CalcularMCD(int a, int b)
    {
        while (b != 0)
        {
            int temp = b;
            b = a % b;
            a = temp;
        }
        return a;
    }
}
*/

.data
    msg1:    .ascii      "Introduce el primer número: \0"
    msg1_len = . - msg1
    msg2:    .ascii      "Introduce el segundo número: \0"
    msg2_len = . - msg2
    msg_result: .ascii   "El MCD es: \0"
    msg_result_len = . - msg_result
    buffer:  .skip       16
    num1:    .quad      0
    num2:    .quad      0
    result:  .quad      0

.text
.global _start

_start:
    // Imprimir mensaje para primer número
    mov     x0, #1              // stdout
    adr     x1, msg1           // mensaje
    mov     x2, msg1_len       // longitud
    mov     x8, #64            // syscall write
    svc     #0

    // Leer primer número
    bl      read_number
    str     x0, num1

    // Imprimir mensaje para segundo número
    mov     x0, #1
    adr     x1, msg2
    mov     x2, msg2_len
    mov     x8, #64
    svc     #0

    // Leer segundo número
    bl      read_number
    str     x0, num2

    // Cargar números para calcular MCD
    ldr     x0, num1
    ldr     x1, num2
    bl      calc_mcd
    str     x0, result

    // Imprimir mensaje de resultado
    mov     x0, #1
    adr     x1, msg_result
    mov     x2, msg_result_len
    mov     x8, #64
    svc     #0

    // Imprimir resultado
    ldr     x0, result
    bl      print_number

    // Salir del programa
    mov     x0, #0
    mov     x8, #93            // syscall exit
    svc     #0

// Función para calcular MCD usando algoritmo de Euclides
// Parámetros: x0 = num1, x1 = num2
// Retorna: x0 = MCD
calc_mcd:
    // Guardar link register
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

mcd_loop:
    // Si num2 es 0, el MCD está en num1
    cbz     x1, mcd_done

    // Calcular resto (num1 % num2)
    udiv    x2, x0, x1         // x2 = num1 / num2
    msub    x2, x2, x1, x0     // x2 = num1 - (num1/num2 * num2) = resto

    // num1 = num2, num2 = resto
    mov     x0, x1
    mov     x1, x2

    b       mcd_loop

mcd_done:
    // Restaurar registros y retornar
    ldp     x29, x30, [sp], #16
    ret

// Función para leer número
read_number:
    // Guardar registros
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Leer entrada
    mov     x0, #0              // stdin
    adr     x1, buffer         // buffer
    mov     x2, #16            // tamaño máximo
    mov     x8, #63            // syscall read
    svc     #0

    // Convertir string a número
    adr     x1, buffer
    mov     x0, #0              // resultado
    mov     x2, #10             // base 10

convert_loop:
    ldrb    w3, [x1], #1       // cargar byte
    sub     w3, w3, #'0'       // convertir ASCII a número
    cmp     w3, #9             // verificar si es dígito válido
    bhi     convert_done
    mul     x0, x0, x2         // resultado *= 10
    add     x0, x0, x3         // resultado += dígito
    b       convert_loop

convert_done:
    // Restaurar registros y retornar
    ldp     x29, x30, [sp], #16
    ret

// Función para imprimir número
print_number:
    // Guardar registros
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Convertir número a ASCII
    mov     x1, #10             // divisor
    mov     x2, sp              // usar stack para string
    sub     sp, sp, #16         // reservar espacio

print_convert_loop:
    udiv    x3, x0, x1          // dividir por 10
    msub    x4, x3, x1, x0      // obtener resto
    add     x4, x4, #'0'        // convertir a ASCII
    strb    w4, [x2], #-1       // guardar dígito
    mov     x0, x3              // actualizar número
    cbnz    x0, print_convert_loop

    // Imprimir número
    add     x2, x2, #1          // ajustar puntero
    mov     x0, #1              // stdout
    mov     x8, #64             // syscall write
    svc     #0

    // Imprimir nueva línea
    mov     x0, #1
    adr     x1, newline
    mov     x2, #1
    mov     x8, #64
    svc     #0

    // Restaurar registros y retornar
    mov     sp, x29
    ldp     x29, x30, [sp], #16
    ret

.data
newline:    .ascii      "\n"

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
