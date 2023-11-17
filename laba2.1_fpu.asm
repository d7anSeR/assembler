%include "C:\Users\Professional\Downloads\SASM3140\SASM\Windows\include\io64_float.inc"
%include "io64.inc"
section .data
input_number: dd -7.0
control_word: dd 0
int_elem: dq 0
section .text
global main
main:
    mov rbp, rsp
    ; загрузка текущего значения управляющего регистра FPU
    fstcw [control_word]

    ; изменение нужных битов (10 и 11) на 01
    mov eax, [control_word]
    and eax, 0xFFFFF3FF  ; сброс битов 10 и 11
    or  eax, 0x00000400  ; установка бита 10 в 1 (01)
    
    ; сохранение нового значения управляющего регистра FPU
    mov [control_word], eax
    fldcw [control_word]
    fld dword [input_number]
    fistp qword [int_elem]
end:
    PRINT_STRING "First value: "
    PRINT_FLOAT [input_number] 
    NEWLINE
    PRINT_STRING "Last value: "
    PRINT_DEC 8, int_elem
    finit
    xor rax, rax
    ret