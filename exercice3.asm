;
; exercice3.asm
; Oussema Hidri
; d.oussema.d@gmail.com
;

printChar macro c
	mov dl, c
	mov ah, 06h
	int 21h
endm

printMsg macro msg
	; printing the offset msg
	mov dx, offset msg
	mov ah, 09h
	int 21h

	; a new line
	printNewLine
endm

printNewLine macro
	
	; save old values
	push ax
	push bx
	push cx
	push dx

	mov dx, 13
  	mov ah, 02h
  	int 21h  
  	mov dx, 10
  	mov ah, 02h
  	int 21h

  	; return ol values
  	pop dx
  	pop cx
  	pop bx
  	pop ax
endm

data segment
	tabT dw 256 dup (?)
	len dw 0
	nbrOcc dw 0
	inputmsg db 'Type in the size of the array$'
	valuesmsg db 'Values: $'
	doneMsg db 'Done inputing array!$'
	contentMsg db 'The content of array is:$'
	occMsg db 'Which value you are looking for:$'
	msg1 db 'the wanted number appears $'
	msg2 db ' time(s) in the array$'
data ends

code segment
	assume cs: code, ds: data
	
	readInt Proc
		; initialize to 0
		mov bx, 0
		mov cx, 0

		; read one char
		mov ah, 01h
		int 21h

		; convert to int
		sub al, '0'

		; first digit
		mov cl, al

		loopint:
			mov ah, 01h
			int 21h

			; user typed ENTER
			cmp al, 13d
			je endInt

			; convert to int
			sub al, '0'

			; save digit in bl
			mov bl, al

			; ax = cx * 10
			mov ax, 10
			mul cx

			; cx = ax
			mov cx, ax
			
			; cx = cx + bx
			add cx, bx
		jmp loopint

		endInt:
			; the integer will be stored in ax
			mov ax, cx

		printNewLine
		ret
	readInt endp

	remplir_tableau Proc 

		printMsg inputmsg

		; input of the size of array
		call readInt

		; save the size of array multiplied twice
		; since we declared the array as dw
		mov len, ax
		mov ax, 2
		mul len
		mov len, ax

		; reading values
		printMsg valuesmsg


		; keeping track of number of inputs
		mov si, 0

		
		itera:

			; output format
			printChar '*'

			; reading integer, then store it in array
			call readInt
			mov tabT[si], ax

			; moving to the next value
			; inc twice because we define the array as word
			inc si
			inc si

			cmp si, len
			jne itera
		
		printMsg doneMsg
		ret
	remplir_tableau endp

	aff_tableau Proc
		printMsg contentMsg
		
		; keeping track of number of elements
		mov si, 0

		; initialize divisor
		mov bx, 10
		
		mov cx, 0
		mov ax, 0

		loopPrint:
			mov ax, tabT[si]
	
			Dloop1:
				xor dx, dx
				; ax / bx
				div bx

				; save remainder of division after converting it
				add dx, '0'
				push dx

				; keep track of the number of digits
				inc cx

				; test for more digits
				cmp ax, 0
				jne Dloop1

			Dloop2:
				; from stack to screen
				pop ax
				printChar al

				loop Dloop2



			printChar '|'
			inc si
			inc si
			cmp si, len
			jne loopPrint

		printNewLine
		ret 
	aff_tableau endp

	compter_occ Proc
		printMsg occMsg
		call readInt

		; save the integer that we will look for
		mov cx, ax

		mov si, 0
		iterate:

			; compare by the wanted value
			cmp tabT[si], cx
			jne skip

			; increment the number of occurence if we found wanted value
			inc nbrOcc

			skip:
				inc si
				inc si
				cmp si, len
				jne iterate


		printMsg msg1

		mov ax, nbrOcc
		mov bx, 10
		mov cx, 0
		floop:
			xor dx, dx
			; ax / bx
			div bx

			; save remainder of division after converting it
			add dx, '0'
			push dx

			; keep track of the number of digits
			inc cx

			; test for more digits
			cmp ax, 0
			jne floop

		sloop:
			; from stack to screen
			pop ax
			printChar al

			loop sloop
		

		printMsg msg2
		ret
	compter_occ endp

	Main:
		
		; load datasegment
		mov ax, data
		mov ds, ax
		
		
		call remplir_tableau

		call aff_tableau

		call compter_occ


		; return to dos
		mov ax, 4c00h
		int 21h
code ends
	end main