.586
.model flat, stdcall
option casemap :none

include WINDOWS.INC
include user32.inc
includelib USER32.LIB
include kernel32.inc
includelib KERNEL32.LIB
includelib masm32.lib
include masm32.inc

.data
	Liste dd -100, -326, -7, -21, -4, -8, -9, -700, -2
	leng dd 9
	Msg db "Le max dans la liste est: ", 0
	Max dw 0

.code

	FindMaxVector proc uneListe:Dword, taille:Dword
		
		mov esi, uneListe
		mov eax, taille
		dec eax
		mov ecx, eax
		
		
		mov eax, [esi]
		
		nextElem:
		add esi, 4
		
		cmp [esi], eax
		jl notBigger
		mov eax, [esi]
		notBigger:
		loop nextElem
		
		
		; convert it to a string
	 	invoke dwtoa, eax, addr Max
		
		
		ret
	FindMaxVector endp
	
	start:
		
	 	invoke FindMaxVector, addr Liste, leng
		invoke MessageBox, NULL, addr Max, addr Msg, MB_OK
		invoke ExitProcess, 0
	end start
	
	
	