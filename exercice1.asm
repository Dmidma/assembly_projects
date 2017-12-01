;
; exercice1.asm
; Oussema Hidri
; d.oussema.d@gmail.com
;

printMsg macro msg
	mov dx, offset msg
	mov ah, 09h
	int 21h
endm

data segment
	tab db 30h, 10h, 128, 14
	numb db 0
	msg db 'Number is: $'
data ends

code segment
	assume cs: code, ds: data
	
	Main:
		
		; load datasegment
		mov ax, data
		mov ds, ax
		
		; initialize tab's index
		xor di, di
		
		calc:
			cmp di, 4
			jz fin
		
		; is the 4th bit of the character is 1
		and tab[di], 10000b

		; increments the number of characters which have 1 as their 4th bit
		jnz incr
		
		; else, test the other characters
		add di, 1
		jmp calc
		
		; increments number, then test the others
		incr:
			add numb, 1
			add di, 1
			jmp calc
		
		fin:
			; print a message
			printMsg msg
		
		; print the number of characters
		mov dl, numb
		; print one character
		add dl, 30h
		mov ah, 06h
		int 21h


		; return to dos
		mov ax, 4c00h
		int 21h
code ends
	end main