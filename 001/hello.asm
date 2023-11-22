section .data

    msg db 'Hello-World!', 0xa
    tam equ 0xc

section .text

global _start

_start:

    mov eax, 0x4
    mov ebx, 0x1
    mov ecx, msg


    mov edx, 0x3 ;representá a quantidade de  valores de saida
    mov edx, 0x4 ;representá a quantidade de  valores de saida



    int 0x80

    mov eax, 0x1
    mov ebx, 0x0
    int 0x80