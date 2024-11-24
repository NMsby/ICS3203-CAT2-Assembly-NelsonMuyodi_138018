; Number Classification Program
; This program takes a number input and classifies it as positive, negative, or zero
; using conditional and unconditional jumps.

section .data
    prompt db 'Enter a number: ', 0
    pos_msg db 'POSITIVE', 0xA, 0
    neg_msg db 'NEGATIVE', 0xA, 0
    zero_msg db 'ZERO', 0xA, 0

section .bss
    num resw 1      ; Reserve a word (2 bytes) for input number

section .text
global _start

_start:
    ; Display prompt
    mov eax, 4      ; sys_write system call
    mov ebx, 1      ; file descriptor (stdout)
    mov ecx, prompt ; message to write
    mov edx, 15     ; message length
    int 0x80        ; call kernel

    ; Read input
    mov eax, 3      ; sys_read system call
    mov ebx, 0      ; file descriptor (stdin)
    mov ecx, num    ; buffer to read into
    mov edx, 2      ; number of bytes to read
    int 0x80

    ; Convert ASCII to number and store in AL
    mov al, [num]
    sub al, '0'     ; Convert from ASCII

    ; Compare number with zero
    cmp al, 0
    je is_zero      ; Jump if equal (ZF=1)
    jl is_negative  ; Jump if less (SF=1)
    jg is_positive  ; Jump if greater (SF=0 and ZF=0)

is_positive:
    ; Display "POSITIVE"
    mov eax, 4
    mov ebx, 1
    mov ecx, pos_msg
    mov edx, 9
    int 0x80
    jmp exit        ; Unconditional jump to exit

is_negative:
    ; Display "NEGATIVE"
    mov eax, 4
    mov ebx, 1
    mov ecx, neg_msg
    mov edx, 9
    int 0x80
    jmp exit        ; Unconditional jump to exit

is_zero:
    ; Display "ZERO"
    mov eax, 4
    mov ebx, 1
    mov ecx, zero_msg
    mov edx, 6
    int 0x80
    ; No jump needed here as exit follows

exit:
    ; Exit program
    mov eax, 1      ; sys_exit system call
    xor ebx, ebx    ; return 0
    int 0x80

; Jump Instructions Explanation:
; je (Jump if Equal): Used when the comparison result shows equality (ZF=1)
;     - This is used to check if the number is exactly zero
; jl (Jump if Less): Used when the comparison shows the value is less than zero (SF=1)
;     - This is used to identify negative numbers
; jg (Jump if Greater): Used when the value is greater than zero (SF=0 and ZF=0)
;     - This is used to identify positive numbers
; jmp (Unconditional Jump): Used to skip over other sections once we've found our case
;     - This is used to go directly to the exit after printing our result