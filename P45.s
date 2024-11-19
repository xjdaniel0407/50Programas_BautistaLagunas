/*
 ============================================================================
 Título     : Verificar si un número es Armstrong en ARM64
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly Raspberry Pi OS que verifica si un número
              es Armstrong y lo imprime usando printf.
 ============================================================================
*/

/*
Solucion en C#

using System;

class Program
{
    static void Main()
    {
        Console.Write("Introduzca un número: ");
        int num = int.Parse(Console.ReadLine());

        int numOriginal = num;
        int numDigits = num.ToString().Length;
        int sum = 0;

        while (num > 0)
        {
            int digit = num % 10;
            sum += (int)Math.Pow(digit, numDigits);
            num /= 10;
        }

        if (sum == numOriginal)
        {
            Console.WriteLine($"{numOriginal} es un número Armstrong.");
        }
        else
        {
            Console.WriteLine($"{numOriginal} no es un número Armstrong.");
        }
    }
}
*/

.global _start

.section .data
    fmt db "El número %d es un número Armstrong.", 10, 0
    num db "Introduzca un número: ", 0

.section .bss
    input resb 10    // Reservar espacio para la entrada del usuario

.section .text
_start:
    // Mostrar mensaje de solicitud de número
    mov x0, 1              // file descriptor 1 (stdout)
    ldr x1, =num           // mensaje
    mov x2, 24             // longitud del mensaje
    mov x8, 64             // syscall número para write
    svc 0                  // llamada al sistema

    // Leer número de entrada del usuario
    mov x0, 0              // file descriptor 0 (stdin)
    ldr x1, =input         // buffer de entrada
    mov x2, 10             // tamaño del buffer
    mov x8, 63             // syscall número para read
    svc 0                  // llamada al sistema

    // Convertir la cadena a un número
    ldr x0, =input         // dirección del buffer
    bl str_to_int          // Convertir a entero

    // Guardar el número en x1
    mov x1, x0

    // Calcular el número de dígitos
    mov x2, x1
    mov x3, 0
count_digits:
    cmp x2, 0
    beq calc_armstrong
    add x3, x3, 1
    udiv x2, x2, 10
    b count_digits

calc_armstrong:
    mov x2, x1            // Restaurar número original
    mov x4, 0             // Variable para la suma
    mov x5, x3            // Número de dígitos

sum_digits:
    cmp x2, 0
    beq check_armstrong
    udiv x6, x2, 10       // Obtener el dígito
    mul x6, x6, x6        // Elevar el dígito al cuadrado
    mul x6, x6, x5        // Elevar a la potencia del número de dígitos
    add x4, x4, x6        // Sumar al total
    udiv x2, x2, 10       // Reducir el número
    b sum_digits

check_armstrong:
    cmp x4, x1            // Verificar si la suma es igual al número original
    beq armstrong_message
    b not_armstrong_message

armstrong_message:
    ldr x0, =fmt          // Cargar el formato
    mov x1, x1            // El número original
    mov x8, 64            // syscall número para printf
    svc 0                  // Llamada al sistema para imprimir

    b exit

not_armstrong_message:
    ldr x0, =fmt          // Cargar el formato
    mov x1, x1            // El número original
    mov x8, 64            // syscall número para printf
    svc 0                  // Llamada al sistema para imprimir

exit:
    mov x8, 93            // syscall número para exit
    mov x0, 0             // Código de salida
    svc 0                  // Llamada al sistema para salir

// Función para convertir cadena a entero
str_to_int:
    mov x2, 0              // Inicializamos el número a 0
    mov x3, 10             // Base decimal
str_to_int_loop:
    ldrb w4, [x0], 1       // Cargar el siguiente byte de la cadena
    cmp w4, 10             // Comparar con el salto de línea (fin de cadena)
    beq str_to_int_end
    sub w4, w4, '0'        // Convertir de carácter a número
    mul x2, x2, x3         // Multiplicar el número por 10 (desplazar a la izquierda)
    add x2, x2, w4         // Sumar el dígito al número
    b str_to_int_loop

str_to_int_end:
    mov x0, x2             // Devolver el número
    ret

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
