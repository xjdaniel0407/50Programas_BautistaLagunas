/*
 ============================================================================ 
 Título     : Verificación de Palíndromos en ARM64 Assembly	
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly para Raspberry Pi OS 
 ============================================================================ 
*/

/*
Solucion en C#

using System;

class Program
{
    static void Main()
    {
        while (true)
        {
            Console.WriteLine("\nIngresa la cadena para ver si es palindromo:");
            string input = Console.ReadLine().Trim();
            
            bool isPalindrome = CheckPalindrome(input);
            if (isPalindrome)
                Console.WriteLine("La cadena es un palíndromo.");
            else
                Console.WriteLine("La cadena no es un palíndromo.");
        }
    }

    static bool CheckPalindrome(string str)
    {
        int left = 0, right = str.Length - 1;
        while (left < right)
        {
            if (str[left] != str[right])
                return false;
            left++;
            right--;
        }
        return true;
    }
}
*/

.data
    prompt:       .asciz "\nIngresa la cadena para ver si es palindromo:   \n" // Mensaje para solicitar la cadena, con salto de línea inicial
    palindromeMsg: .asciz "La cadena es un palindromo.\n"                        // Mensaje si es palíndromo
    notPalindromeMsg: .asciz "La cadena no es un palindromo.\n"                  // Mensaje si no es palíndromo
    exitMsg:       .asciz "Programa terminado.\n"                               // Mensaje de salida
    buffer:       .space 100                                                     // Espacio para leer la entrada del usuario

.text
    .global _start

_start:
    // Mostrar el mensaje para solicitar la cadena
    mov x0, #1                      // Descriptor de archivo para STDOUT
    ldr x1, =prompt                 // Dirección del mensaje "Ingrese una cadena para verificar si es palindromo: "
    mov x2, #66                     // Longitud correcta del mensaje de entrada
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    // Leer la cadena ingresada por el usuario
    mov x0, #0                      // Descriptor de archivo para STDIN
    ldr x1, =buffer                 // Dirección del buffer para almacenar la entrada del usuario
    mov x2, #100                    // Longitud máxima a leer
    mov x8, #63                     // Syscall para 'read' (63)
    svc #0                          // Ejecutar syscall

    // Calcular la longitud de la cadena y eliminar el salto de línea si está presente
    mov x2, #0                      // Índice para encontrar el final de la cadena
find_length:
    ldrb w3, [x1, x2]               // Cargar el siguiente byte en la cadena
    cmp w3, #10                     // Comparar con el carácter de nueva línea '\n'
    beq found_newline               // Si es una nueva línea, reemplazarla con un terminador nulo
    cbz w3, check_palindrome        // Si es un terminador nulo, terminar la búsqueda
    add x2, x2, #1                  // Incrementar el índice
    b find_length                   // Repetir para el siguiente carácter

found_newline:
    strb wzr, [x1, x2]              // Reemplazar nueva línea con terminador nulo
    sub x2, x2, #1                  // Ajustar índice final al último carácter real

check_palindrome:
    // Comparar los caracteres desde ambos extremos hacia el centro
    mov x3, #0                      // Índice inicial (inicio de la cadena)
check_loop:
    cmp x3, x2                      // Comparar índices de inicio y fin
    bge is_palindrome               // Si se cruzan o se encuentran, es un palíndromo

    // Comparar caracteres en los extremos
    ldrb w4, [x1, x3]               // Leer carácter desde el inicio
    ldrb w5, [x1, x2]               // Leer carácter desde el final
    cmp w4, w5                      // Comparar los dos caracteres
    bne not_palindrome              // Si no son iguales, no es palíndromo

    // Actualizar índices y continuar
    add x3, x3, #1                  // Incrementar índice inicial
    sub x2, x2, #1                  // Decrementar índice final
    b check_loop                    // Repetir el bucle

is_palindrome:
    // Mostrar el mensaje "La cadena es un palindromo."
    mov x0, #1                      // Descriptor de archivo para STDOUT
    ldr x1, =palindromeMsg          // Dirección del mensaje "La cadena es un palindromo.\n"
    mov x2, #28                     // Longitud del mensaje
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    // Ahora forzamos la salida inmediatamente
    b exit_program                  // Terminar el programa y devolver el control

not_palindrome:
    // Mostrar el mensaje "La cadena no es un palindromo."
    mov x0, #1                      // Descriptor de archivo para STDOUT
    ldr x1, =notPalindromeMsg       // Dirección del mensaje "La cadena no es un palindromo.\n"
    mov x2, #31                     // Longitud del mensaje
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    // Ahora forzamos la salida inmediatamente
    b exit_program                  // Terminar el programa y devolver el control

exit_program:
    // Mostrar mensaje de salida
    mov x0, #1                      // Descriptor de archivo para STDOUT
    ldr x1, =exitMsg                // Dirección del mensaje "Programa terminado."
    mov x2, #21                     // Longitud del mensaje
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    // Salir del programa
    mov x8, #93                     // Syscall para 'exit' (93)
    mov x0, #0                      // Código de salida (0)
    svc #0                          // Ejecutar syscall

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
