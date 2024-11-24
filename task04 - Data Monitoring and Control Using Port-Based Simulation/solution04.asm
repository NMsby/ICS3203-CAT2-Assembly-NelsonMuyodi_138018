; Water Level Control Simulation Program
; Simulates a water level control system using memory locations

section .data
    motor_on_msg db 'Motor turned ON', 0xA, 0
    motor_off_msg db 'Motor turned OFF', 0xA, 0
    alarm_msg db 'ALARM: Water level too high!', 0xA, 0
    normal_msg db 'Status: Normal operation', 0xA, 0

    ; Control thresholds (0-100 scale)
    HIGH_LEVEL equ 80    ; Water level threshold for alarm
    LOW_LEVEL equ 20     ; Water level threshold to start motor

section .bss
    sensor_value resb 1  ; Simulated sensor reading
    control_reg resb 1   ; Control register for outputs
                         ; Bit 0: Motor status
                         ; Bit 1: Alarm status

section .text
global _start

_start:
    ; Initialize control register
    mov byte [control_reg], 0
    
    ; Simulate reading sensor value (fixed value for simulation)
    mov byte [sensor_value], 85    ; Simulated high water level
    
check_water_level:
    ; Read sensor value
    mov al, [sensor_value]
    
    ; Check for high water level
    cmp al, HIGH_LEVEL
    jge high_water_alarm
    
    ; Check for low water level
    cmp al, LOW_LEVEL
    jle low_water_motor_on
    
    ; Normal range - turn off motor if it's on
    call motor_off
    jmp status_update
    
high_water_alarm:
    ; Set alarm bit in control register
    or byte [control_reg], 2    ; Set bit 1 (alarm on)
    ; Turn off motor
    call motor_off
    ; Display alarm message
    mov eax, 4
    mov ebx, 1
    mov ecx, alarm_msg
    mov edx, 28
    int 0x80
    jmp exit
    
low_water_motor_on:
    ; Turn on motor
    call motor_on
    jmp status_update
    
status_update:
    ; Display normal operation message
    mov eax, 4
    mov ebx, 1
    mov ecx, normal_msg
    mov edx, 23
    int 0x80
    
exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Subroutine to turn motor on
motor_on:
    ; Set motor bit in control register
    or byte [control_reg], 1    ; Set bit 0 (motor on)

    ; Display motor on message
    push eax
    push ebx
    push ecx
    push edx
    mov eax, 4
    mov ebx, 1
    mov ecx, motor_on_msg
    mov edx, 16
    int 0x80
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; Subroutine to turn motor off
motor_off:
    ; Clear motor bit in control register
    and byte [control_reg], ~1    ; Clear bit 0 (motor off)

    ; Display motor off message
    push eax
    push ebx
    push ecx
    push edx
    mov eax, 4
    mov ebx, 1
    mov ecx, motor_off_msg
    mov edx, 17
    int 0x80
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
