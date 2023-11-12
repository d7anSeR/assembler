;приближенное представление 
;экспоненциальной функции инструкциями sse

%include "C:\Users\Professional\Downloads\SASM3140\SASM\Windows\include\io64_float.inc"
%include "io64.inc"
section .rodata
x: dd 9.44
one: dd 1.0
section .data
result: dd 0.0
elem: dd 0.0
section .text
global main
main:
    mov rbp, rsp; for correct debugging
    finit
    fldl2e
    fstp dword [elem]
    movss xmm0, [elem]
    movss xmm1, [x]
    movss xmm2, [one]
    xorps xmm3, xmm3
    mulss xmm0, xmm1
    movss [elem], xmm0 ;взяли степень
    fld dword [elem]
    fabs ;положили в стек и взяли модуль
    fstp dword [elem] ;вернули обратно
    movss xmm4, [elem]
    subss xmm2, xmm4 ;1-|x|
    comiss xmm2, xmm3 ; 1-|x|>=или < 0
    jae less_pl
    jb more_pl
less_pl:
    movss [elem], xmm0 ;берем степень
    fld1
    fld dword [elem]
    fprem
    f2xm1;st0 = (2^st0)-1
    fstp dword [elem]
    movss xmm0, [elem]
    movss xmm1, [one]
    addss xmm0, xmm1
    movss [result], xmm0
    jmp end
more_pl:
    movss [elem], xmm0 ;берем степень
    fld1
    fld dword [elem]
    fprem
    fstp dword [elem] ;забираем остаток
    movss xmm1, [elem] ;xmm1 = остаток
    subss xmm0, xmm1 ; например : 2,04 - 0,04
    movss [result], xmm0
    fld dword [result]; положили целую часть 
    fld1
    fscale ; st0 = st0 * 2 ^ st1 - возвели в степень 
    fstp dword [result]
    
    movss [elem], xmm1 ;положили остаток
    finit
    fld1
    fld dword [elem] ;положили остаток в стек
    f2xm1;st0 = (2^st0)-1
    fstp dword [elem] ;результат временно положили в elem
    movss xmm0, [elem]
    movss xmm1, [one]
    addss xmm0, xmm1 ;добавили недостающую единицу
    movss xmm1, [result]
    mulss xmm0, xmm1 ;перемножили с целой степенью
    movss [result], xmm0
    jmp end
end:
    PRINT_STRING "y = e^x"
    NEWLINE
    PRINT_STRING "y = e^"
    PRINT_FLOAT [x]
    PRINT_STRING " = "
    PRINT_FLOAT [result]
    mov rbp, rsp
    xorps xmm0, xmm0
    xorps xmm1, xmm1
    xorps xmm2, xmm2
    xorps xmm3, xmm3
    xorps xmm4, xmm4
    xor rax, rax
    ret