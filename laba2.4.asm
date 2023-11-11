;проверить, что (x, y) удовлетворяет
; условию y = th a / x
; th a = (e^a - e^(-a)) / (e^a + e^(-a))
;
%include "C:\Users\Professional\Downloads\SASM3140\SASM\Windows\include\io64_float.inc"
%include "io64.inc"
section .rodata
y: dd -0.126
x: dd -3.87
section .data
a: dd 0.53
elem: dd 0.0
result: dd 0.0
pos_e: dd 0.0
neg_e: dd 0.0
hundred: dd 100.0
section .text
global main
main:
    mov rbp, rsp; for correct debugging
    finit
    fldz
    fld1
    fld dword [a]
    fldl2e
    fmul st1
    fstp dword [a]
    fld dword [a]
    fabs ; |a|
    fld1
    fsubr ;st0 = st0-st1 = 1-|a|
    fstp dword [elem] ;вытащили результат
    fldz
    fld dword [elem]
    fcomi ;сравнение st0 и st1
    ja less_elem ; 1-|a| > 0
    jbe more_elem ; 1-|a| <= 0 то есть числа с целой частью
    
less_elem:
    finit
    fld1
    fld dword [a] 
    fprem
    f2xm1;st0 = (2^st0)-1
    fadd st0, st1 ;+1
    jmp result_pl
more_elem:
    fstp dword [elem]
    fld1
    fld dword [a] 
    fprem
    fstp dword [elem] ;извлекли остаток
    fld dword [a] 
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
    fstp dword [pos_e]  
    fld dword [pos_e]
    fld1
    fdiv st0, st1
    fstp dword [neg_e] 
    ;сохранили значения
    
    fld dword [neg_e]
    fsub ;вычитаем одно из другого
    fstp dword [result]
    fld dword [neg_e]
    fld dword [pos_e]
    fadd st0, st1
    fld dword [result]
    fdiv st0, st1 ; st0 /= st1 =>(e^a - e^(-a)) / (e^a + e^(-a))
    fld dword [x]
    fdivr st0, st1 ; st0 = st1 / st0
    fstp dword [result]
    
    finit
    fld1
    fld dword [hundred]
    fld dword [result]
    fmul st1 
    frndint
    fstp dword [elem]
    fld dword [y]
    fld dword [hundred]
    fmul st1
    frndint
    fld dword [elem]
    fcomi
    je exit1
    jne exit2
exit1:
    PRINT_STRING "result = "
    PRINT_FLOAT [result]
    NEWLINE
    PRINT_STRING "y = "
    PRINT_FLOAT [y]
    NEWLINE
    PRINT_STRING "(YES)"
    jmp end
exit2:
    PRINT_STRING "result = "
    PRINT_FLOAT [result]
    NEWLINE
    PRINT_STRING "y = "
    PRINT_FLOAT [y]
    NEWLINE
    PRINT_STRING "(NO)"
    jmp end
end:
    finit
    ;write your code here
    xor rax, rax
    ret