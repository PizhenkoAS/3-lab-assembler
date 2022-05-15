%include "io64.inc"
section .bss
    class: resb 24

section .text
global CMAIN
CEXTERN _ZN4hard4var81C6accessENS0_1SE
CMAIN:
    mov rbp, rsp; for correct debugging
    push rbp
    mov rbp, rsp
    sub rsp, 40
    and rsp, -16
    
    lea rax, [class]
   ; mov rax, 4243504 ;первые 8 байт в классе 
    mov [class], rax 
    mov rax, 0 ;вторые 8 байт
    mov [class + 8], rax 
    mov rax, 5 ;третьи 8 байт 
    mov [class + 16], rax 
 
    lea rcx, [class]
    mov rdx, 46 ;структура
    
    call _ZN4hard4var81C6accessENS0_1SE
    
    mov rsp, rbp
    pop rbp
    
    xor rax, rax
    ret