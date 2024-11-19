/*
 ============================================================================
 Título     : Escribir en un archivo usando ARM64 Assembly en Raspberry Pi OS
 Autor      : Bautista Lagunas Jose Daniel
 Descripción: Programa en ARM64 Assembly para abrir un archivo y escribir un mensaje en él
 ============================================================================
*/

/*
Solucion en C#

using System;
using System.IO;

class Program
{
    static void Main()
    {
        string path = "example.txt";
        string message = "Este es un mensaje escrito en el archivo.";

        try
        {
            // Escribir el mensaje en el archivo
            File.WriteAllText(path, message);
            Console.WriteLine("Mensaje escrito en el archivo correctamente.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error al escribir en el archivo: {ex.Message}");
        }
    }
}
*/

.global _start

.extern printf
.extern fopen
.extern fprintf
.extern fclose

.section .data
    filename:    .asciz "example.txt"
    message:     .asciz "Este es un mensaje escrito en el archivo.\n"
    error_message: .asciz "Error al abrir el archivo.\n"

.section .text
_start:
    // Llamar a fopen para abrir el archivo en modo de escritura
    mov x0, filename          // Nombre del archivo
    mov x1, 0                  // Modo: "w" (escritura)
    bl fopen                   // Llamada a fopen (x0: nombre de archivo, x1: modo)

    // Guardar el puntero al archivo en x1
    mov x1, x0                 // Guardamos el puntero al archivo retornado por fopen

    // Verificar si fopen falló (x0 debe ser NULL si hay error)
    cmp x1, 0
    beq fopen_error

    // Llamar a fprintf para escribir en el archivo
    mov x0, x1                 // Puntero al archivo
    mov x1, message            // El mensaje a escribir
    bl fprintf                 // Llamada a fprintf

    // Llamar a fclose para cerrar el archivo
    mov x0, x1                 // Puntero al archivo
    bl fclose                  // Llamada a fclose

    // Finalizar el programa (salida limpia)
    mov x0, 0                  // Código de salida
    mov x8, 93                 // Llamada al sistema exit
    svc 0

fopen_error:
    // Imprimir mensaje de error si fopen falla
    mov x0, error_message
    bl printf

    // Salir con código de error
    mov x0, 1
    mov x8, 93
    svc 0

/*
**********************************************************************
Link de asciinema:

**********************************************************************
*/
