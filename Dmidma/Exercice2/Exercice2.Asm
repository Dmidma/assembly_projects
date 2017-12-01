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
	Msg db "ceci esest un msg", 0
	subMsg db "est", 0
	
	titre db "Sous chaine ahther ben.", 0
	pas db "Sous chaine n'existe pas dans la chaine", 0
	
	indice dw 0
.code
	souschaineChaine proc chaine: Dword, sousChaine: Dword
		; Registre ebx pour l'indice d'occurence
		; pointeur esi pour le msg
		; pointeur edi pour le sous msg
	
		; initialiser les registres a utiliser
		xor eax, eax
		xor esi, esi
		xor edi, edi
		xor edx, edx
		
		mov esi, chaine
		mov edi, sousChaine
		
		compare:
		mov bl, [edi]
		mov cl, [esi]
		; tester si on a arrivé à la fin de la sous chaine
		cmp bl, 0
		je success
		
		; tester si on a arrivé à la fin de la chaine
		cmp cl, 0
		je reachedEnd
		
		; comparer les caracteres
		cmp bl, cl
		je luckyDay
		
		; les caracters ne se coincident pas
		
		; affecter 0 à edi
		mov edi, sousChaine
		
		mov bl, [edi]
		mov cl, [esi]
		cmp bl, cl
		je careful
		
		; incrimenter esi
		inc esi
		inc edx
		
		careful:
		; affecter indice de la caractre suivant du msg a ebx
		mov eax, edx
		 
		; repeter la comparaison
		jmp compare
		
		; les caracteres se coincident
		; incrimenter esi et edi
		luckyDay:
		inc esi
		inc edx
		inc edi
		; repeter la comparaison
		jmp compare
		
		; arriver a la fin de la chaine
		reachedEnd:
		; sous chaine n'existe pas
		invoke MessageBox, NULL, addr pas, addr titre, MB_OK
		jmp fin
		
				
		; arriver à la fin de la sous chaine
		; ce qui veux dire on a trouver la sous chaine dans la chaine
		success:
		
		; convertir l'indie à fin de l'afficher
		invoke dwtoa, eax, addr indice
		invoke MessageBox, NULL, addr indice, addr titre, MB_OK
		
		fin:
		
		
		ret
	souschaineChaine endp
	
	start:
		
		invoke souschaineChaine, addr Msg, addr subMsg
		invoke ExitProcess, 0 
		
	end start
