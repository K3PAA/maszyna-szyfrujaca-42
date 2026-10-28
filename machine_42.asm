; Autor: Jakub Kepa ( nr. 479425 )
extern machine_42_function
global _start

section .bss
    lodw: resb 42
    rodw: resb 42
    buf: resb 4096

section .text
_start:
    mov r9, [rsp]
    cmp r9, 5
    je .poprawna_dl
.blad:
    mov rax, 60
    mov rdi, 1
    syscall

.poprawna_dl:
    mov rdi, [rsp+16]; L
    mov rdx, [rsp+24]; R
    mov r8,  [rsp+32]; T
    mov r9,  [rsp+40]; klucz
	
    cmp byte [r9], '1'
    jb .blad
    cmp byte [r9], 'Z'
    ja .blad
    cmp byte [r9+1], '1'
    jb .blad
    cmp byte [r9+1], 'Z'
    ja .blad
    cmp byte [r9+2], 0
    jnz .blad
    
    lea r14, [rel lodw]
    xor rcx, rcx
.odwroc_l:
    mov al, byte [rdi+rcx]
    cmp al, 0; Koniec napisu
    je .sprawdz_napis_l

    cmp al, '1'
    jb .blad
    cmp al, 'Z'
    ja .blad
    
    sub al, '1'    
    movzx r10, al; index tablicy
    
    cmp byte [r14+r10], 0
    jnz .blad
    
    mov r11, rcx    
    add r11, '1'
    mov byte [r14+r10], r11b        
    
    inc rcx
    jmp .odwroc_l

.sprawdz_napis_l:
    cmp rcx, 42
    jne .blad
    
    lea r14, [rel rodw]
    xor rcx, rcx
.odwroc_r:
    mov al, byte [rdx+rcx]
    cmp al, 0; Koniec napisu
    je .sprawdz_napis_r

    cmp al, '1'
    jb .blad
    cmp al, 'Z'
    ja .blad
    
    sub al, '1'    
    movzx r10, al; index tablicy
    
    cmp byte [r14+r10], 0
    jnz .blad
    
    mov r11, rcx    
    add r11, '1'
    mov byte [r14+r10], r11b        
    
    inc rcx
    jmp .odwroc_r

.sprawdz_napis_r:
    cmp rcx, 42
    jne .blad

    xor rcx, rcx
.sprawdz_t:
    cmp rcx, 42
    je .koniec_t
    
    mov al, byte [r8+rcx]
    
    cmp al, '1'
    jb .blad
    cmp al, 'Z'
    ja .blad

    mov r11, rcx
    add r11, '1'

    cmp al, r11b
    je .blad

    sub al, '1'
    movzx r10, al
    
    mov r12b, byte [r8+r10]
    cmp r12b, r11b
    jne .blad

    inc rcx
    jmp .sprawdz_t

.koniec_t:
    cmp byte [r8+ 42], 0
    jne .blad
    
    mov r9, [rsp+40]; Adres klucza z argv
    movzx r14, word [r9]
.petla:
    xor rax, rax
    xor rdi, rdi
    lea rsi, [rel buf]
    mov rdx, 4096
    syscall
    
    cmp rax, 0
    je .koniec_petli
    jl .blad
    
    mov r15, rax; Ilość wczytanych znaków

    xor rcx, rcx
    lea r13, [rel buf]
.walidacja_buf:
    cmp rcx, r15
    je .koniec_walidacji
    
    mov al, byte [r13 + rcx]
    cmp al, '1'
    jb .blad
    cmp al, 'Z'
    ja .blad
    
    inc rcx
    jmp .walidacja_buf
    
.koniec_walidacji:
    push r15
    lea r10, [rel buf]
    push r10
    
    mov rdi, [rsp+32]
    lea rsi, [rel lodw]
    mov rdx, [rsp+40]
    lea rcx, [rel rodw]
    mov r8, [rsp+48]
    mov r9, r14
    
    call machine_42_function

    add rsp, 16
    mov r14, rax

    ; Wypisanie tekstu na ekran
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel buf]
    mov rdx, r15
    syscall
    
    cmp rax, 0
    jl .blad
    jmp .petla

.koniec_petli:
    mov rax, 60
    mov rdi, 0
    syscall
