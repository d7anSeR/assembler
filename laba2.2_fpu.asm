;приближенное представление 
;экспоненциальной функции инструкциями sse

%include "C:\Users\Professional\Downloads\SASM3140\SASM\Windows\include\io64_float.inc"
%include "io64.inc"
section .rodata
x: dd 8.1
one: dd 1.0
section .data
result: dd 0.0
elem: dd 0.0
section .text
global main
main:
    mov rbp, rsp; for correct debugging
    finit
    fld dword [x]
    fldl2e
    fmul st1
    fst dword [result] ;взяли степень
    fabs ;взяли модуль
    fstp dword [elem]
    fldz
    fld1
    fld dword [elem]
    fsub ;1-|x|
    fcomi ; 1-|x|>=или < 0
    jae less_pl
    jb more_pl
less_pl:
    fld1
    fld dword [result] ;кладем степень
    fprem
    f2xm1;st0 = (2^st0)-1
    fadd st0, st1
    fstp dword [result]
    jmp end
more_pl:
    fld1
    fld dword [result]
    fprem
    fstp dword [elem] ;забираем остаток
    fld dword [result]; положили целую часть 
    fld dword [elem] ;положили степень
    fsub
    fld1
    fscale ; st0 = st0 * 2 ^ st1 - возвели в степень 
    fstp dword [result]
    
    finit
    fld1
    fld dword [elem] ;положили остаток в стек
    f2xm1;st0 = (2^st0)-1
    fadd st0, st1
    fld dword [result] ;положили результат
    fmul st1
    fstp dword [result]
    jmp end
end:
    PRINT_STRING "y = e^x"
    NEWLINE
    PRINT_STRING "y = e^"
    PRINT_FLOAT [x]
    PRINT_STRING " = "
    PRINT_FLOAT [result]
    finit
    xor rax, rax
    ret