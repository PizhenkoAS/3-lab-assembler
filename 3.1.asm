%include "io64.inc"
section .rodata
    string: db "%llu", 0 
    delimeter: db " ", 0 

section .text
global CMAIN
CEXTERN scanf
CEXTERN printf
CEXTERN malloc
CEXTERN free
CMAIN:
    mov rbp, rsp; for correct debugging    
    push r10
    push r12
    push r13
    push r15
    push rdi
    push rbp
    mov rbp, rsp
    sub rsp, 40
    and rsp, -16; выравнивание стека по границе 16 байт

    ;считываем размерность массива
    lea rcx, [string]
    lea rdx, [rbp-8] 
    call scanf 
    mov r12, [rbp-8] ;кол-во элементов помещаем в регистр r12

    ;выделение памяти
    mov rcx, r12 ;в rcx помещаем количество аргументов
    mov rax, 8 ;в rax помещаем размер одного элемента массива
    mul rcx  
    mov rcx, rax ;передача первым аргументом количество необходимых байт
    call malloc 
    mov r15, rax ;в r15 - указатель на выделенную память
    
    mov r13, r12 
    
    ;ввод массива 
    input_array: 
        lea rcx, [string] 
        lea rdx, [rbp-8] 
        call scanf
        mov rax, [rbp-8] ; помещаем в rax считанное значение
        mov [r15 + 8*r13 - 8], rax ; записываем считанное значение в выделенную память
        dec r13
        jnz input_array

    ;сортировка
    mov r8, 0 ; левый индекс
    mov r9, r12; правый индекс - 1
    dec r9
    ; цикл сортировки
    sort:
        ; если индекс левый больше правого
        cmp r8, r9
        jae done ; выйти из цикла
        ;цикл прохода слева направо
        mov r10, r8
    right:
        ;берем значение
        mov rdx, [r15 + 8*r10]
        ; сравниваем со следующим
        cmp rdx, [r15 + 8*r10 + 8]
        ; если он меньше или равен не делаем обмен
        jbe next_right 
        ; иначе меняем
        mov rdi, r10
        sal rdi, 3
        add rdi, r15 ; адрес элемента
        ; кладем в стек следующий
        push qword [rdi + 8]
        ; текущий меняем со следующим
        mov rdx, [rdi]
        mov [rdi + 8], rdx
        ; из стека пишем в текущий
        pop qword [rdi] 
    next_right:
        inc r10 ; счетчик -1
        cmp r10, r9; если он меньше правого индекса
        jb right ; продолжить цикл
        dec r9 ; правый индекс на 1 меньше
        ; проход справа налево
        mov r10, r9
    left:
        ; берем значение
        mov rdx, [r15 + 8*r10 - 8]
        ; сравниваем с текущим
        cmp rdx, [r15 + 8*r10]
        ; если он меньше, то не делаем обмен
        jb next_left 
        ; меняем местами текущий и перед ним
        ; аналогично в стек и меняем 
        mov rdi, r10
        sal rdi, 3
        add rdi, r15
        push qword [rdi - 8]
        mov rdx, [rdi]
        mov [rdi - 8], rdx
        pop qword [rdi] 
    next_left: 
        ;счетчик -1
        dec r10
        ; если индекс больше левой границы
        cmp r10, r8
        ja left ; продолжать цикл
        
        inc r8
        ; переход в начало цикла 
        jmp sort

    done: 
    xor rcx, rcx
    xor rdx, rdx
    print:
    lea rcx, [string]
    mov rdx, [r15 + 8*r13]
    call printf
    lea rcx, [delimeter] ; передаем аргумент
    call printf
    inc r13
    cmp r13, r12
    jnz print
    
    ;освобождение памяти
    lea rcx, [r15] 
    call free 
    mov rsp, rbp ; в rsp значение rbp
    pop rbp 
    pop rdi
    pop r15
    pop r13
    pop r12 
    pop r10
    xor rax,rax
    ret
