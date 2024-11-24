; Array Reversal Program (64-bit version)
; This program takes 5 integers as input and reverses them in place

section .data
    prompt db 'Enter 5 numbers (press Enter after each): ', 0xA, 0
    prompt_len equ $ - prompt
    output_msg db 'Reversed array: ', 0xA, 0
    output_len equ $ - output_msg
    space db ' ', 0
    newline db 0xA, 0

section .bss
    array resb 5    ; Reserve 5 bytes for the array
    temp resb 1     ; Temporary storage for swapping

section .text
global _start

_start:
    ; Display input prompt
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, prompt     ; message
    mov rdx, prompt_len ; length
    syscall

    ; Read 5 numbers
    mov r12, 5          ; Counter for input loop
    mov r13, array      ; Pointer to array
input_loop:
    push r12            ; Save counter
    push r13            ; Save array pointer
    
    ; Read single number
    mov rax, 0          ; sys_read
    mov rdi, 0          ; stdin
    mov rsi, temp       ; Input buffer
    mov rdx, 2          ; Read 2 bytes (number + newline)
    syscall
    
    pop r13             ; Restore array pointer
    pop r12             ; Restore counter
    
    ; Convert ASCII to number and store
    mov al, [temp]
    sub al, '0'         ; Convert from ASCII
    mov [r13], al       ; Store in array
    
    inc r13             ; Move to next array position
    dec r12             ; Decrement counter
    jnz input_loop      ; Continue if counter not zero

    ; Reverse the array in place
    mov rsi, array      ; Start of array
    mov rdi, array + 4  ; End of array
reverse_loop:
    cmp rsi, rdi        ; Check if pointers have met or crossed
    jge print_array     ; If so, we're done
    
    ; Swap elements
    mov al, [rsi]       ; Get element from start
    mov bl, [rdi]       ; Get element from end
    mov [rsi], bl       ; Put end element at start
    mov [rdi], al       ; Put start element at end
    
    inc rsi             ; Move start pointer forward
    dec rdi             ; Move end pointer backward
    jmp reverse_loop    ; Continue swapping

print_array:
    ; Print "Reversed array: "
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, output_msg ; message
    mov rdx, output_len ; length
    syscall

    ; Print reversed array
    mov r12, 5          ; Counter for printing
    mov r13, array      ; Pointer to start of array
print_loop:
    push r12            ; Save counter
    push r13            ; Save array pointer
    
    ; Convert number to ASCII
    mov al, [r13]
    add al, '0'         ; Convert to ASCII
    mov [temp], al
    
    ; Print number
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, temp       ; number to print
    mov rdx, 1          ; length
    syscall
    
    ; Print space
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall
    
    pop r13             ; Restore array pointer
    pop r12             ; Restore counter
    inc r13             ; Move to next number
    dec r12             ; Decrement counter
    jnz print_loop      ; Continue if counter not zero

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

exit:
    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; return 0
    syscall

; Memory Management Notes:
; - We use a single array (array) to store all numbers
; - The reversal is done in-place using two pointers (rsi and rdi)
; - We only use one additional byte (temp) for temporary storage during swaps
; - The array is accessed directly through memory addressing
; - We use r12 and r13 as our loop counters and array pointers
; - All system calls are done using the 64-bit syscall interface