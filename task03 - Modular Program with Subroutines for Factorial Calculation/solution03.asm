section .data
    prompt db 'Enter a number (0-8): ', 0
    result_msg db 'Factorial is: ', 0
    newline db 0xA, 0

section .bss
    num resb 1       ; Input number storage
    result resq 1    ; Result storage (8 bytes for 64-bit)

section .text
global _start

_start:
    ; Display prompt
    mov rax, 1           ; syscall: write
    mov rdi, 1           ; file descriptor: stdout
    mov rsi, prompt      ; message address
    mov rdx, 20          ; message length
    syscall

    ; Read input
    mov rax, 0           ; syscall: read
    mov rdi, 0           ; file descriptor: stdin
    mov rsi, num         ; buffer address
    mov rdx, 2           ; buffer size
    syscall

    ; Convert ASCII to number
    mov al, [num]
    sub al, '0'

    ; Preserve registers before calling subroutine
    movzx rdi, al        ; Pass input number in rdi (64-bit argument)
    call factorial       ; Call factorial subroutine

    ; Result is now in rax
    ; Convert result to ASCII (if single digit)
    add rax, '0'
    mov [result], al     ; Store ASCII result

    ; Print result message
    mov rax, 1
    mov rdi, 1
    mov rsi, result_msg
    mov rdx, 14
    syscall

    ; Print result
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 1
    syscall

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Exit program
    mov rax, 60         ; syscall: exit
    xor rdi, rdi        ; exit code: 0
    syscall

; Factorial subroutine
; Input: Number in rdi
; Output: Result in rax
factorial:
    ; Preserve registers
    push rbx

    ; Initialize result
    mov rax, 1          ; Result accumulator
    mov rcx, rdi        ; Counter

factorial_loop:
    cmp rcx, 1          ; Check if we've reached 1
    jle factorial_done

    ; Multiply current result by counter
    imul rax, rcx       ; rax *= rcx
    dec rcx             ; Decrement counter
    jmp factorial_loop

factorial_done:
    ; Restore registers
    pop rbx
    ret
