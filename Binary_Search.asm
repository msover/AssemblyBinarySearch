bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dd 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    len equ ($ - a) / 4
    src dd 10
    
    result dd -1
    left dd 0
    right dd len - 1
    mid resd 1
; our code starts here
segment code use32 class=code
    checkRepetitive:
        mov eax, [left]
        cmp eax, [right]
        jbe repetitive
        jmp endOfBinary
    getMid:
        mov edx, 0
        mov eax, [left]
        add eax, [right]
        mov ebx, 2
        div ebx
        mov [mid], eax
        mov eax, 0
        mov ebx, 0
        mov edx, 0
        jmp resumeGetMid
    pushRes:
        mov eax, [mid]
        mov [result], eax
        mov eax, 0
        jmp endOfBinary
    checkEquality:
        mov ebx, a
        mov ecx, [mid]
        mov eax, [ebx + ecx * 4]
        cmp eax, [src]
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        jz pushRes
        jmp resumeCheckEquality
    isElemLower:
        mov ecx, 1
        mov eax, [mid]
        inc eax
        mov [left], eax
        mov eax, 0
        mov ecx, 0
        jmp resumeCheckSide
    isElemGreater:
        mov ecx, 2
        mov eax, [mid]
        dec eax
        mov [right], eax
        mov eax, 0
        mov ecx, 0
        jmp resumeCheckSide
    checkSide:
        mov ebx, a
        mov ecx, [mid]
        mov eax, [ebx + ecx * 4]
        cmp eax, [src]
        
        jl isElemLower
        jmp isElemGreater
    start:
        repetitive:
            jmp getMid
            resumeGetMid:
            
            jmp checkEquality
            resumeCheckEquality:
            
            jmp checkSide
            resumeCheckSide:
            
            jmp checkRepetitive
        endOfBinary:
            mov eax, [result]
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
