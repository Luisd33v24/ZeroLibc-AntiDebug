BITS 64

%define THRESHOLD 0xFFFFF

global _start

; Impede que a stack seja marcada como executável
section .note.GNU-stack

section .data
    msg_clean db "[+] Execucao limpa. Sistema seguro.", 10
    len_clean equ $ - msg_clean

    msg_debug db "[-] ALERTA: Debugger ou VM detectado! Abortando.", 10
    len_debug equ $ - msg_debug

section .text

_start:
    ; 1) Leitura inicial serializada
    xor eax, eax
    push rbx
    cpuid
    pop rbx
    rdtsc
    
    shl rdx, 32
    or rax, rdx
    mov r8, rax

    ; 2) Delay artificial
    xor rcx, rcx
.delay:
    inc rcx
    cmp rcx, 50000
    jne .delay

    ; 3) Leitura final serializada
    rdtscp
    
    shl rdx, 32
    or rax, rdx
    sub rax, r8

    ; Verifica o threshold definido no topo
    cmp rax, THRESHOLD
    jg .debugger_detected

.normal_execution:
    ; Syscall ofuscada: sys_write (1)
    mov rax, 5
    sub rax, 4
    mov rdi, 3
    sub rdi, 2
    mov rsi, msg_clean
    mov rdx, len_clean
    syscall
    
    ; Exit 0
    mov rax, 100
    sub rax, 40
    xor rdi, rdi
    syscall

.debugger_detected:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_debug
    mov rdx, len_debug
    syscall

    ; Exit 1
    mov rax, 100
    sub rax, 40
    mov rdi, 1
    syscall