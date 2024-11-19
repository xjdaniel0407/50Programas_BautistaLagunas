/*
 ============================================================================
 Título     : Encontrar prefijo común más largo en cadenas
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly Raspberry Pi OS
 ============================================================================
*/

/*
Solución en C#

using System;

class Program {
    static string FindCommonPrefix(string str1, string str2) {
        int length = Math.Min(str1.Length, str2.Length);
        string commonPrefix = "";

        for (int i = 0; i < length; i++) {
            if (str1[i] == str2[i]) {
                commonPrefix += str1[i];
            } else {
                break;
            }
        }

        return commonPrefix;
    }

    static void Main() {
        string str1 = "apple";
        string str2 = "apricot";
        
        string commonPrefix = FindCommonPrefix(str1, str2);
        Console.WriteLine("El prefijo común más largo es: " + commonPrefix);
    }
}
*/

.global _start

.extern printf

.section .data
    str1:   .asciz "apple"
    str2:   .asciz "apricot"
    format: .asciz "El prefijo común más largo es: %s\n"

.section .bss
    common_prefix: .skip 100  // Reservamos espacio para el prefijo común

.section .text
_start:
    // Inicializamos los registros
    mov x0, str1        // Cargar la primera cadena en x0
    mov x1, str2        // Cargar la segunda cadena en x1
    mov x2, common_prefix  // Cargar la dirección del prefijo común

find_prefix:
    ldrb w3, [x0], #1  // Cargar un byte de str1 (primer carácter) en w3
    ldrb w4, [x1], #1  // Cargar un byte de str2 (primer carácter) en w4

    cmp w3, w4         // Comparar los caracteres
    b.ne done           // Si son diferentes, terminamos

    strb w3, [x2], #1  // Si son iguales, almacenamos el carácter en common_prefix
    cbz w3, done        // Si llegamos al final de la cadena, terminamos

    b find_prefix       // Continuar con el siguiente carácter

done:
    // Llamar a printf para imprimir el prefijo común
    mov x0, format      // Cargar el formato de impresión
    mov x1, common_prefix // Cargar la dirección del prefijo común
    bl printf           // Llamar a printf

    // Salir del programa
    mov x8, #93         // Número de syscall para _exit
    mov x0, #0          // Código de salida
    svc 0               // Llamar a la syscall

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
