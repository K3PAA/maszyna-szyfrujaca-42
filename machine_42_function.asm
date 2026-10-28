; Autor: Jakub Kepa ( nr. 479425 )
%macro przesun_Q 1
	add al, %1
	sub al, '1'
	
	cmp al, 'Z'
	jbe %%pomin_zawijanie
	sub al, 42
%%pomin_zawijanie: 
%endmacro

%macro zamien_wartosc 1
	sub al, '1'
	movzx rbx, al
	mov al, byte [%1+rbx]
%endmacro

%macro cofnij_Q 1
	sub al, %1
	add al, '1'
	
	cmp al, '1'
	jae %%pomin_zwijanie
	add al, 42
%%pomin_zwijanie:	
%endmacro

global machine_42_function

; rdi - *L
; rsi - *L_1
; rdx - *R
; rcx - *R_1 
; R8 - *T
; R9 - key, dwa najmlodsze bajty

; text, size - na stos
machine_42_function:
	mov r10, [rsp+8]
	mov r11, [rsp+16]
	push rbx
	push r12
	push r13
	
	mov r12b, r9b ; lambda
	shr r9, 8
	mov r13b, r9b ; rho	

.loop:
	test r11, r11
	je .loop_end
	; Wyznaczanie wartosci lambda oraz rho	
	inc r13b;
	cmp r13b, 'Z'
	jbe .pomin_zawijanie_rho
	mov r13b, '1'

.pomin_zawijanie_rho:
	cmp r13b, 'T'
	je .obroc_lambda
	cmp r13b, 'L'
	je .obroc_lambda
	cmp r13b, 'R'
	jne .pomin_lambda
.obroc_lambda:
	inc r12b
	cmp r12b, 'Z'
	jbe .pomin_lambda
	mov r12b, '1'
.pomin_lambda:	
	mov al, byte [r10]
		
	przesun_Q r13b  
	zamien_wartosc rdx 
	cofnij_Q r13b	
	przesun_Q r12b
	zamien_wartosc rdi
	cofnij_Q r12b
	zamien_wartosc r8
	przesun_Q r12b
	zamien_wartosc rsi 
	cofnij_Q r12b
	przesun_Q r13b
	zamien_wartosc rcx
	cofnij_Q r13b	
	
	mov byte [r10], al
	inc r10
	dec r11
	jmp .loop

.loop_end:
	xor rax, rax
	mov al, r13b
	shl ax, 8
	mov al, r12b

	pop r13
	pop r12
	pop rbx
	ret	
