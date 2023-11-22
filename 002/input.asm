; Programa para receber um nome do usuario

segment .data

    lf equ 0xa
    null equ 0xd
    sys_exit equ 0x1
    ret_exit equ 0x0
    std_in equ 0x1
    std_out equ 0x1
    sys_read equ 0x3
    sys_write equ 0x4
    sys_call equ 0x80

section .data

    mgs db "Digite o Seu Nome: ", lf, null
    tam equ $- mgs

section .bss 
    nome resb 1

section .text

global _start

_start:

    mov eax, sys_write
    mov ebx, std_out
    mov ecx, mgs
    mov edx, tam
    mov sys_call

    mov eax, sys_read
    mov ebx, std_in
    mov ecx, nome 
    mov edx, 0xA
    mov sys_call

    mov EAX, sys_exit
    mov EBX, ret_exit
    int sys_call