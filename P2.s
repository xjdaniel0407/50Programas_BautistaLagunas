/*
 ============================================================================
 Título     : Suma de dos números
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly Raspberry Pi OS
 ============================================================================
*/

/*
Solucion en C#
using System;

class Program
{
    static void Main()
    {
        // Definimos los números iniciales y el mensaje
        int num1 = 5;
        int num2 = 10;
        string message = "El resultado es: ";
        
        // Realizamos la suma de los dos números
        int result = num1 + num2;
        
        // Imprimimos el mensaje y el resultado
        PrintString(message);
        PrintInt(result);
        
        // Salir del programa
        Environment.Exit(0);
    }

    // Método para imprimir una cadena de caracteres
    static void PrintString(string str)
    {
        Console.Write(str);
    }

    // Método para imprimir un número entero en base 10
    static void PrintInt(int number)
    {
        Console.WriteLine(number);
    }
}

*/

.global _start          // Punto de entrada para el código

.section .data
    num1: .quad 5        // Primer número
    num2: .quad 10       // Segundo número
    msg:  .asciz "El resultado es: " // Mensaje que precede al resultado

.section .bss
    result: .skip 8      // Reservar espacio para el resultado

.section .text
    .extern write       // Declarar la función write

_start:
    // Cargar los números desde la sección .data en los registros
    ldr x0, =num1        // Cargar la dirección de num1 en x0
    ldr x1, [x0]         // Cargar el valor de num1 en x1
    ldr x0, =num2        // Cargar la dirección de num2 en x0
    ldr x2, [x0]         // Cargar el valor de num2 en x2

    // Realizar la suma
    add x3, x1, x2       // Sumar num1 (x1) y num2 (x2), el resultado va en x3

    // Almacenar el resultado en la sección .bss (en la variable result)
    ldr x0, =result      // Cargar la dirección de la variable result
    str x3, [x0]         // Almacenar el resultado en la dirección de result

    // Imprimir el mensaje "El resultado es: "
    ldr x0, =msg         // Cargar la dirección del mensaje en x0
    bl print_string      // Llamada a la subrutina para imprimir el mensaje

    // Imprimir el resultado de la suma
    ldr x0, =result      // Cargar la dirección de la variable result
    ldr x1, [x0]         // Cargar el resultado de la suma en x1
    bl print_int         // Llamada a la subrutina para imprimir el entero

    // Terminar el programa (salir)
    mov x8, 93           // Código para terminar el programa (exit)
    mov x0, 0            // Código de salida 0
    svc 0                // Llamada al sistema (exit)

print_string:
    // Subrutina para imprimir una cadena de caracteres
    mov x2, 0            // Inicializamos el contador
print_char_loop:
    ldrb x1, [x0, x2]    // Cargar el siguiente carácter de la cadena
    cmp x1, 0            // Comprobar si es el final de la cadena (nulo)
    beq print_string_done // Si es nulo, terminamos
    mov x8, 64           // Llamada al sistema para escribir (sys_write)
    mov x0, 1            // Descriptor de archivo 1 (stdout)
    mov x2, 1            // Escribir un solo carácter
    svc 0                // Hacer la llamada al sistema
    add x2, x2, 1        // Incrementar el índice de la cadena
    b print_char_loop    // Repetir para el siguiente carácter
print_string_done:
    ret

print_int:
    // Subrutina para imprimir un número entero en base 10
    mov x2, 10           // Base decimal
    mov x3, 0            // Inicializamos el resultado (inverso del número)
print_int_loop:
    udiv x4, x1, x2      // Dividir el número por 10 (almacenar cociente en x4)
    msub x5, x4, x2, x1  // x5 = x1 - x4 * 10 (resto, último dígito)
    add x5, x5, '0'      // Convertir el dígito a carácter ASCII
    mov x0, 1            // Descriptor de archivo 1 (stdout)
    mov x6, 1            // Número de caracteres a imprimir
    mov x1, x5           // Carácter que se va a imprimir
    mov x8, 64           // Llamada al sistema para escribir (sys_write)
    svc 0                // Llamada al sistema
    mov x1, x4           // Actualizamos x1 con el cociente
    cmp x1, 0            // Si el cociente es 0, terminamos
    bne print_int_loop   // Si no es 0, seguimos con el siguiente dígito
    ret

/*
nano P2.s
as -o P2.o P2.s   
ld -o P2 P2.o     
**********************************************************************
Link de asciinema:

**********************************************************************
*/
