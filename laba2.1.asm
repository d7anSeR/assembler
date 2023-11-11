%include "C:\Users\Professional\Downloads\SASM3140\SASM\Windows\include\io64_float.inc"
%include "io64.inc"
section .data
elem: dd 0.0
one: dd 1.0
five: dd 5.0
ten: dd 10.0
hundred: dd 100.0
input_number: dd -0.1
section .text
global main
main:
    mov rbp, rsp
    finit ;сбрасывает fpu в состояние, в котором он попадает при вкл питания
    fldz ;0
    fld dword [one]
    fld dword[five]
    fld dword[hundred]
    fld dword [ten]
    fld dword[input_number]
    fcomi st5
    ja positive_elem
    jb negative_elem
    
positive_elem:
    fmul st0, st1
    fprem ;берем остаток
    fcomi st3 ;сравниваем с 5
    jb less_five
    jae more_five
less_five:  ;остаток < 5
    fstp dword [elem]
    fld dword [input_number]
    frndint
    fstp dword [elem]
    jmp end
more_five: ;остаток >= 5
    fstp dword [elem]
    fld dword [input_number]
    frndint
    fsub st4 ; вычитаем 1
    fst dword [elem]
    jmp end
    
    
negative_elem:
    fmul st0, st1
    fprem ;берем остаток
    fabs ;убираем знак
    fcomi st5
    je zero
    fcomi st3 ;сравниваем с 5
    jb neg_less_five
    jae neg_more_five
neg_less_five:  ;остаток < 5
    fstp dword [elem]
    fld dword [input_number]
    frndint
    fsub st4 ; вычитаем 1
    fstp dword [elem]
    jmp end
neg_more_five: ;остаток >= 5
    fstp dword [elem]
    fld dword [input_number]
    frndint
    fst dword [elem]
    jmp end
zero: ;для отрицательных чисел, 
      ;чтобы нормально округляло для целого числа
    fstp dword [elem]
    fld dword [input_number]
    fst dword [elem]
    jmp end
end:
    PRINT_STRING "First value: "
    PRINT_FLOAT [input_number] 
    NEWLINE
    PRINT_STRING "Last value: "
    PRINT_FLOAT [elem]
    frndint
    xor rax, rax
    ret