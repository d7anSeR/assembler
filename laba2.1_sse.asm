%include "C:\Users\Professional\Downloads\SASM3140\SASM\Windows\include\io64_float.inc"
%include "io64.inc"
section .data
input_number: dd -7.5
mxcsr_value: dd 0
int_elem: dq 0
section .text
global main
main:
    mov rbp, rsp
    stmxcsr [mxcsr_value]
    mov ebx, [mxcsr_value]
    or ebx, 0b11000000000000 ; Устанавливаем биты 13 и 14 в "01"
    mov [mxcsr_value], ebx

    ; Загружаем новое значение MXCSR
    ldmxcsr [mxcsr_value]
    movss xmm0, [input_number]
    cvtss2si rbx, xmm0
    mov [int_elem], rbx
end:
    PRINT_STRING "First value: "
    PRINT_FLOAT [input_number] 
    NEWLINE
    PRINT_STRING "Last value: "
    PRINT_DEC 8, int_elem
    finit
    xorps xmm0, xmm0
    xor rax, rax
    ret