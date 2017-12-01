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
	msg db "This is a message", 0
	chercher db ' '
	indice dw 0
	wasup db "indice est", 0
	existe db "Le char n'existe pas", 0
	
.code
	charChaine proc uneChaine:Dword, char:Dword
		xor esi, esi
		xor edi, edi
		xor eax, eax
		
		mov esi, uneChaine
		mov edi, char
		
		mov cl, 0
	
		mov al, [esi]
		mov bl, [edi]
		.while ((al != 0) && (al != bl))
			inc esi
			mov al, [esi]
			inc cl
		.endw
		
		
		
		.if (al == bl)
			movzx eax, cl
			invoke dwtoa, eax, addr indice
			invoke MessageBox, NULL, addr indice, addr wasup, MB_OK
		.ELSE		
			invoke MessageBox, NULL, addr existe, addr wasup, MB_OK
		.ENDIF
		
		ret

	charChaine endp
	
	start:
	
		invoke charChaine, addr msg, addr chercher
		invoke ExitProcess, 0
	
	end start	