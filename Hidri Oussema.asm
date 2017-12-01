TITLE EXAMEN1


affiMsg      Macro msg
    
    mov DX, offset msg
    mov AH, 09
    int 21h    
 
 
ENDM



DSEG segment
    
    msg1 db 0ah, 0dh, "Donnez les chiffres :$"
    msg2 db 0ah, 0dh, "Le nombre de chiffres entres est :$"
    msg3 db 0ah, 0dh, "La somme des elements est :$"
    msg4 db 0ah, 0dh, "L'affichage a l'envers :$"
    
    somme db ?
    
    tab db 20 dup(?)
    tab2 db 20 dup(?)
    
    
DSEG ends


CSEG segment
    
    ASSUME CS:CSEG, DS:DSEG
    
        convertion proc
        
        MOV BL, 10d
                
        MOV DI, 0
        
        division:
        
        DIV BL    
           
        add AH, 30H       
        
        
        
        
        MOV tab[DI], AH
        
        inc DI
        CMP AL, 0 
        JE affiFinal
        MOV AH, 0
        JMP division
        
        
        
        
        affiFinal:
        
        
        dec DI
        
        MOV DL, tab[DI] 
        
        MOV AH, 06H
        int 21H
        
        cmp DI, 0
        JNE affiFinal
    
   
    ret 
    convertion endP
    
   
   
   
    main:
    
    mov AX, DSEG
    mov DS, AX
    
    
    affiMsg msg1
    
    
        
    
    saisie:     ;Saisie de la chaine
    
    
    
    mov Ah, 01
    int 21h
    
        
        
    CMP AL, '$'
    JE affi
        
    CMP AL, '3'
    JB saisie
        
    CMP AL, '9'
    JA saisie 
    
    
    
    mov tab2[si], al
    
    inc SI
    
    cmp si, 20
    je affi
    
    
    
    sub AL, 30h
    add somme, AL
    
    jmp saisie
    
     
    
    affi:
 
    
    affiMsg msg2
   
    
    mov AX, SI
    
    
    
    
    call convertion
    
    affiMsg msg3
    
    mov AL, somme
    
    mov AH, 0
    
    call convertion
    
    
    
    affiMsg msg4
    
     
    
     
    enver:
        
    
    dec SI    
    
    MOV DL, tab2[SI] 
    
    
        
    MOV AH, 06H
    int 21H
        
    cmp SI, 0
    jne enver
    
   
    
    mov AH, 4CH
    int 21H
    
    
CSEG ends

    end main
    
    