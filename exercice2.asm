;
; exercice2.asm
; Oussema Hidri
; d.oussema.d@gmail.com
;

affich macro c
	mov dl, c
	mov ah, 06h
	int 21h
endm

data segment
	msg db 'HELLO, WORLD$'
data ends

code segment
	assume cs: code, ds: data
	
	Main:
		
		; load datasegment
		mov ax, data
		mov ds, ax
		
		; initialize string's index
		xor di, di
		
		itera:
		; is it uppercase
		mov al, msg[di]
			
		cmp al, 41h
		jb printnext
		cmp al, 5ah
		ja printnext

		; convert to lowercase
		add al, 20h

		; print character, move to the next one
		printnext:
			affich al
			add di, 1

		; are we there yet?
		cmp msg[di], '$'
		jne itera


		; return to dos
		mov ax, 4c00h
		int 21h
code ends
	end main