;log2(tg(x + a)) = b
;x = arctg(2^b) - a
;в виде полиза получится: arctg(2 b ^) a -

%include "C:\Users\Professional\Downloads\SASM3140\SASM\Windows\include\io64_float.inc"
%include "io64.inc"
section .rodata
a: dd -4.6
b: dd -3.2
const_two: dd 2.0
section .data
elem: dd 0.0
x: dd 0.0
result: dd 0.0
section .text
global main
main:
    mov rbp, rsp; for correct debugging
    finit
    fldz
    fld1
    fld dword [b]
    fabs ; |b|
    fsub ;st0 = 1-|b|
    fstp dword [elem] ;вытащили результат
    fldz
    fld dword [elem]
    fcomi ;сравнение st0 и st1
    ja less_elem ; 1-|b| > 0
    jbe more_elem ; 1-|b| <= 0 то есть числа с целой частью
    
less_elem:
    fstp dword [elem]
    fld1
    fld dword [b]
    fprem
    f2xm1;st0 = (2^st0)-1
    fadd st0, st1 ;+1
    
    jmp result_pl
more_elem:
    fstp dword [elem]
    fld1
    fld dword [b]
    fprem
    fstp dword [elem] ;извлекли остаток
    fld dword [b] 
    fld dword [elem] ; st1 = b, st0 = остаток
    fsub ;st1-st0 = целое число 
    fld1
    fscale ; st0 = st0 * 2 ^ st1 - возвели в степень 
    fstp dword [result]
    
    
    finit
    fld1
    fld dword [elem] ;положили остаток
    f2xm1;st0 = (2^st0)-1
    fadd st0, st1 ;+1
    fld dword [result] ;положили 2 в степени целой части
    fmul st1 
    jmp result_pl 
result_pl:
    fld1
    fpatan; st0 = arctg(st1/st0)
    fld dword [a]
    fsub ; st0 = st1-st0  то есть st0 = arctg(2^b) - a
    fstp dword [result] ;извлекли результат
    PRINT_STRING "a = "
    PRINT_FLOAT [a] 
    NEWLINE
    PRINT_STRING "b = "
    PRINT_FLOAT [b]
    NEWLINE
    PRINT_STRING "x = arctg(2^b) - a"
    NEWLINE
    PRINT_STRING "x = "
    PRINT_FLOAT [result]
    PRINT_STRING " + pi * k"
    frndint
    xor rax, rax
    ret