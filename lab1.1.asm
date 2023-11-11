%include "io64.inc"
section .bss
array: resQ 1024
size: resq 1

section .text
global main
main:
    mov rbp, rsp
    xor rax,rax     
    GET_UDEC 8, rdx 
    test rdx, rdx  
    jz size_zero       
    cmp rdx, 1024  
    ja too_long 

    ; for(rcx=0; rcx<rdx; ++rcx) ...
    xor rcx,rcx 
input_cycle:         
    GET_DEC 8, r8           
    mov [array + 8*rcx], r8  
    add rcx, 1             
    cmp rcx,rdx           
    jl input_cycle
    
    
    mov rcx,rdx 
    dec rcx
    mov [size], rdx
    mov rbx, -1 
outer_cycle:
    mov rdx, rcx
    dec rdx
inner_cycle_first:
    sub rsp, 8
    mov [rsp], rbx
    mov rax, [array + 8*rdx]
    mov rbx, [array + 8*(rdx + 1)]
    cmp rax, rbx
    jng end_swap_first 

    ; Меняем местами текущий и следующий элементы
    mov [array + 8*rdx], rbx
    mov [array + 8*(rdx + 1)], rax

end_swap_first:
    dec rdx 
    mov rbx, [rsp]
    add rsp, 8
    cmp rdx, rbx;
    jg inner_cycle_first
    
    inc rbx

    mov rdx, rbx
    sub rsp, 8
    mov [rsp], rbx
inner_cycle_second:
    mov rax, [array + 8*rdx]
    mov rbx, [array + 8*(rdx + 1)]
    cmp rax, rbx
    jle end_swap_second

    ; Меняем местами текущий и следующий элементы
    mov [array + 8*rdx], rbx
    mov [array + 8*(rdx + 1)], rax

end_swap_second:
    inc rdx 
    cmp rdx, rcx
    jb inner_cycle_second
    
    dec rcx
    
    mov rbx, [rsp]
    add rsp, 8
    cmp rbx, rcx
    jbe outer_cycle
    
    PRINT_STRING "RESULT OF SHAKER SORT: "
    NEWLINE
    xor rbx, rbx
print_cycle:
    PRINT_DEC 8,[array + 8*rbx]
    inc rbx
    cmp rbx,[size]
    NEWLINE
    jb print_cycle

end:
    xor eax, eax            ; set the exit code to 0
    ret    
too_long:
    PRINT_STRING "TOO LONG (max 1024)"
    mov eax, 1              ; set the exit code to 1 (exit code !=0 means error)
    ret
size_zero:
    PRINT_STRING "SIZE = 0"
    mov eax, 1              ; set the exit code to 1 (exit code !=0 means error)
    ret    
    