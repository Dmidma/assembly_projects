.386 
.model flat,stdcall 
option casemap:none 
include WINDOWS.INC
include user32.inc
includelib USER32.LIB
include kernel32.inc
includelib KERNEL32.LIB
include masm32.inc
includelib masm32.lib
include gdi32.inc
includelib GDI32.LIB


.data

; Name of the window class
ClassName db "SimpleWinClass", 0 

; Title of the main window
WindowTitle db "Final Project", 0

; First Menu Content
MenuName db "FirstMenu", 0 


; Decimal Sum Dialog Content
DSDContent db "DecimalDialog", 0

; Encryption Dialog Content
ENCContent db "EncryptionDialog", 0

; Decryption Dialog Content
DECContent db "DecryptionDialog", 0


; Info of the crypt Section
cryptInfoTitle db "Information for the Crypt Section:", 0
cryptInfoContent db "Crypt Section:", 13 , 10, \
			"Caesar Encryption uses a key between 1 and 25 to change the original message to a crypted one.", 13, 10, \
			"Use Encryption to change your message with a specific key.", 13, 10, \
			"Use Decryption to get the original message back. (must use a specific key.)", 0
			

; About
AboutMe db "Hello, World.", 13, 10, \
			"Aslema, Eni Oussema Hidri chohira Dmidma x).", 13, 10, \
			"Hétha houwa e5er projet fil Programmation Masm32.", 13, 10, \
			"Programme avec une interface graphique.", 13, 10, \
			"For more information contact me at: d.oussema.d@gmail.com or 53160059",0
			

; Friendly user messages
Error db "A Simple Mistake", 0
NoMsg db "You must enter a Message to Encrypt", 0
NoKey db "You must enter a key between 1 and 25 to encrypt message", 0

; variable used to print values and results
tmp db "0", 0

; Variable used for Message Encryption
EncMsg db "0", 0
; Variable to hold the key
TmpKey db "0", 0

; Handler of the Decimal Sum Dialog Box
hwndDS dd 0
 
; Handler of the Encryption and Decryption Dialog Boxes
hwndENC dd 0
hwndDEC dd 0

.DATA?
; Instance Handler of the program
hInstance HINSTANCE ?
; Getting the command line
CommandLine LPSTR ?

; Array of bitmaps
hBitmap dd 12 dup (?)

.const
; Menu IDs
IDM_DS equ 2 
IDM_BS equ 3 
IDM_EXIT equ 4
IDM_ABOUT equ 5
IDM_ENC equ 6
IDM_DEC equ 7
IDM_INFCR equ 8

IDC_VAR1  equ 3100
IDC_VAR2  equ 3200
IDC_ADD equ 3001
IDC_SUB equ 3002
IDC_EXIT equ 3003
IDC_CHAN equ 3004
IDC_RFIELD equ 3010

; Bitmap constants
IDB_H equ 111
IDB_E equ 112
IDB_L equ 113
IDB_LL equ 114
IDB_O equ 115
IDB_D equ 116
IDB_M equ 117
IDB_I equ 118
IDB_DD equ 119
IDB_MM equ 120
IDB_A equ 121
IDB_FR equ 122

.CODE
; Decimal Sum Dialog Box Proc
DSProc PROC hWnd:HWND, iMsg:DWORD, wParam:WPARAM, lParam:LPARAM
        .if iMsg == WM_INITDIALOG
			invoke GetDlgItem, hWnd, IDC_VAR1
			invoke SetFocus, eax
        .elseif iMsg == WM_CLOSE
			invoke EndDialog,hWnd,NULL
			mov hwndDS, 0
        .elseif iMsg == WM_COMMAND
			mov eax,wParam
			mov edx,eax
			shr edx,16
		.if dx == BN_CLICKED
			.if eax== IDC_EXIT
				invoke SendMessage, hWnd, WM_CLOSE, NULL, NULL
			.elseif eax== IDC_ADD
				
				; initilize ebx for result
				xor ebx, ebx
				
				; Get values from fields
				; convert them from ASCII to VALUES
				; After the sum reconvert the result to ASCII
				invoke GetDlgItemText, hWnd, IDC_VAR1, ADDR tmp, 100
				invoke atodw, ADDR tmp
				mov ebx, eax
				invoke GetDlgItemText, hWnd, IDC_VAR2, ADDR tmp, 100
				invoke atodw, ADDR tmp
				add ebx, eax
				invoke dwtoa, ebx, addr tmp
				
				; Set result
				invoke SetDlgItemText, hWnd, IDC_RFIELD, ADDR tmp
			.elseif eax == IDC_SUB
				; initilize ebx for result
				xor ebx, ebx
				
				; Get values from fields
				; convert them from ASCII to VALUES
				; After the sum reconvert the result to ASCII
				invoke GetDlgItemText, hWnd, IDC_VAR1, ADDR tmp, 100
				invoke atodw, ADDR tmp
				mov ebx, eax
				invoke GetDlgItemText, hWnd, IDC_VAR2, ADDR tmp, 100
				invoke atodw, ADDR tmp
				sub ebx, eax
				invoke dwtoa, ebx, addr tmp
				
				; Set result
				invoke SetDlgItemText, hWnd, IDC_RFIELD, ADDR tmp
			.endif
		.endif		   
        .else
		mov eax, FALSE
		; reset tmp to 0
		mov ebx, 0
		invoke dwtoa, ebx, ADDR tmp
		ret
        .endif
        mov  eax, TRUE
        ; reset tmp to 0
		mov ebx, 0
		invoke dwtoa, ebx, ADDR tmp
        ret
DSProc endp

; Encryption Dialog Box Proc
ENCProc PROC hWnd:HWND, iMsg:DWORD, wParam:WPARAM, lParam:LPARAM
        .if iMsg == WM_INITDIALOG
			invoke GetDlgItem, hWnd, IDC_VAR1
			invoke SetFocus, eax
        .elseif iMsg == WM_CLOSE
			invoke EndDialog,hWnd,NULL
			mov hwndDS, 0
        .elseif iMsg == WM_COMMAND
			mov eax,wParam
			mov edx,eax
			shr edx,16
		.if dx == BN_CLICKED
			.if eax == IDC_EXIT
				invoke SendMessage, hWnd, WM_CLOSE, NULL, NULL
			.elseif eax == IDC_CHAN
				
				; Get Key
				invoke GetDlgItemText, hWnd, IDC_VAR2, ADDR TmpKey, 5
				invoke atodw, ADDR TmpKey
			
				mov ecx, eax
				
				push ecx
			
				; if there's no key
				.if eax < 1 || eax > 25
					invoke MessageBox, hwndENC, ADDR NoKey, ADDR Error, MB_OK
					jmp falsEnd
				.endif
				
				
				
				; Get Message
				invoke GetDlgItemText, hWnd, IDC_VAR1, ADDR EncMsg, 100
				invoke atodw, ADDR EncMsg
				; if there's no message
				.if eax == 0
					invoke MessageBox, hwndENC, ADDR NoMsg, ADDR Error, MB_OK
					jmp falsEnd
				.endif
				
				; Determine the length of the text
				invoke StrLen, ADDR EncMsg				
				mov ebx, eax
				
				
				;initialize index
				xor esi, esi
				
				
				pop ecx
				
				; Encrypt Message
				.WHILE esi < ebx 
					
					; LowCase characters
					.if EncMsg[esi] >= 97 && EncMsg[esi] <= 122
						add EncMsg[esi], cl
						.if EncMsg[esi] > 122
							sub EncMsg[esi], 123
							add EncMsg[esi], 97
						.endif
					; UpCase Characters
					.elseif EncMsg[esi] >= 65 && EncMsg[esi] <= 90
						add EncMsg[esi], cl
						.if EncMsg[esi] > 90
							sub EncMsg[esi], 91
							add EncMsg[esi], 65
						.endif
					.endif
					; Inc index
					inc esi
				.ENDW
				
				; Set the encrypted message
				invoke SetDlgItemText, hWnd, IDC_RFIELD, ADDR EncMsg
			.endif
		.endif		   
        .else
        falsEnd:
        ; reset tmp to 0
		mov ebx, 0
		invoke dwtoa, ebx, ADDR EncMsg
		mov eax,FALSE
		ret
        .endif
        ; reset tmp to 0
		mov ebx, 0
		invoke dwtoa, ebx, ADDR EncMsg
        mov  eax,TRUE
        ret
ENCProc endp


; Decryption Dialog Box Proc
DECProc PROC hWnd:HWND, iMsg:DWORD, wParam:WPARAM, lParam:LPARAM
        .if iMsg == WM_INITDIALOG
			invoke GetDlgItem, hWnd, IDC_VAR1
			invoke SetFocus, eax
        .elseif iMsg == WM_CLOSE
			invoke EndDialog,hWnd,NULL
			mov hwndDS, 0
        .elseif iMsg == WM_COMMAND
			mov eax,wParam
			mov edx,eax
			shr edx,16
		.if dx == BN_CLICKED
			.if eax == IDC_EXIT
				invoke SendMessage, hWnd, WM_CLOSE, NULL, NULL
			.elseif eax == IDC_CHAN
				
				; Get Key
				invoke GetDlgItemText, hWnd, IDC_VAR2, ADDR TmpKey, 5
				invoke atodw, ADDR TmpKey
			
				mov ecx, eax
				
				push ecx
			
				; if there's no key
				.if eax < 1 || eax > 25
					invoke MessageBox, hwndENC, ADDR NoKey, ADDR Error, MB_OK
					jmp falsEnd
				.endif
				
				
				
				; Get Message
				invoke GetDlgItemText, hWnd, IDC_VAR1, ADDR EncMsg, 100
				invoke atodw, ADDR EncMsg
				; if there's no message
				.if eax == 0
					invoke MessageBox, hwndENC, ADDR NoMsg, ADDR Error, MB_OK
					jmp falsEnd
				.endif
				
				; Determine the length of the text
				invoke StrLen, ADDR EncMsg				
				mov ebx, eax
				
				
				;initialize index
				xor esi, esi
				
				
				pop ecx
				
				; Encrypt Message
				.WHILE esi < ebx 
					
					; LowCase characters
					.if EncMsg[esi] >= 97 && EncMsg[esi] <= 122
						sub EncMsg[esi], cl
						.if EncMsg[esi] < 97
							sub EncMsg[esi], 96
							add EncMsg[esi], 122
						.endif
					; UpCase Characters
					.elseif EncMsg[esi] >= 65 && EncMsg[esi] <= 90
						sub EncMsg[esi], cl
						.if EncMsg[esi] < 65
							sub EncMsg[esi], 64
							add EncMsg[esi], 90
						.endif
					.endif
					; Inc index
					inc esi
				.ENDW
				
				; Set the encrypted message
				invoke SetDlgItemText, hWnd, IDC_RFIELD, ADDR EncMsg
			.endif
		.endif		   
        .else
        falsEnd:
        ; reset tmp to 0
		mov ebx, 0
		invoke dwtoa, ebx, ADDR EncMsg
		mov eax,FALSE
		ret
        .endif
        ; reset tmp to 0
		mov ebx, 0
		invoke dwtoa, ebx, ADDR EncMsg
        mov  eax,TRUE
        ret
DECProc endp


; Window Main Functions

WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD 
    LOCAL wc:WNDCLASSEX                                            ; create local variables on stack 
    LOCAL msg:MSG 
    LOCAL hwnd:HWND

    mov   wc.cbSize,SIZEOF WNDCLASSEX                   ; fill values in members of wc 
    mov   wc.style, CS_HREDRAW or CS_VREDRAW 
    mov   wc.lpfnWndProc, OFFSET WndProc 
    mov   wc.cbClsExtra,NULL 
    mov   wc.cbWndExtra,NULL 
    push  hInstance 
    pop   wc.hInstance 
    mov   wc.hbrBackground,COLOR_WINDOW+1 
    mov   wc.lpszMenuName, OFFSET MenuName 
    mov   wc.lpszClassName,OFFSET ClassName 
    invoke LoadIcon,NULL,IDI_APPLICATION 
    mov   wc.hIcon,eax 
    mov   wc.hIconSm,eax 
    invoke LoadCursor,NULL,IDC_ARROW 
    mov   wc.hCursor,eax 
    invoke RegisterClassEx, addr wc 
    invoke CreateWindowEx,NULL,\ 
                ADDR ClassName,\ 
                ADDR WindowTitle,\ 
                WS_OVERLAPPEDWINDOW,\ 
                CW_USEDEFAULT,\ 
                CW_USEDEFAULT,\ 
                1300,\ 
                800,\ 
                NULL,\ 
                NULL,\ 
                hInst,\ 
                NULL 
    mov   hwnd,eax 
    invoke ShowWindow, hwnd,CmdShow 
    invoke UpdateWindow, hwnd

    .WHILE TRUE 
                invoke GetMessage, ADDR msg,NULL,0,0 
                .BREAK .IF (!eax)
                .if hwndDS != 0
                	invoke IsDialogMessage, hwndDS, addr msg
                	.if eax == TRUE
                		.continue
                	.endif
                .endif
                invoke TranslateMessage, ADDR msg 
                invoke DispatchMessage, ADDR msg 
   .ENDW 
    mov     eax,msg.wParam  
    ret 
WinMain endp


WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 
    LOCAL hdc:HDC
    LOCAL hMemDC:HDC
    LOCAL ps:PAINTSTRUCT 
    LOCAL rect:RECT 
    
    .IF uMsg == WM_DESTROY 
        invoke PostQuitMessage,NULL
    .ELSEIF uMsg == WM_COMMAND
    	mov eax, wParam
    	.if eax == IDM_DS
    		invoke CreateDialogParam, hInstance, ADDR DSDContent, hWnd, OFFSET DSProc, NULL
    		mov hwndDS, eax
    	.elseif eax == IDM_INFCR
    		invoke MessageBox, hWnd, ADDR cryptInfoContent, ADDR cryptInfoTitle, MB_OK
    	.elseif eax == IDM_ENC
    		invoke CreateDialogParam, hInstance, ADDR ENCContent, hWnd, OFFSET ENCProc, NULL
    		mov hwndENC, eax
    	.elseif eax == IDM_DEC
    		invoke CreateDialogParam, hInstance, ADDR DECContent, hWnd, OFFSET DECProc, NULL
    		mov hwndDEC, eax
    	.elseif eax == IDM_ABOUT
    		invoke MessageBeep,0FFFFFFFFh
    		
    	.else
    		invoke DestroyWindow, hWnd
    	.endif
    .ELSEIF uMsg == WM_CREATE
		invoke LoadBitmap, hInstance, IDB_H
		mov hBitmap[0], eax
		invoke LoadBitmap, hInstance, IDB_E
		mov hBitmap[4], eax
		invoke LoadBitmap, hInstance, IDB_L
		mov hBitmap[8], eax
		invoke LoadBitmap, hInstance, IDB_LL
		mov hBitmap[12], eax
		invoke LoadBitmap, hInstance, IDB_O
		mov hBitmap[16], eax
		invoke LoadBitmap, hInstance, IDB_D
		mov hBitmap[20], eax
		invoke LoadBitmap, hInstance, IDB_M
		mov hBitmap[24], eax
		invoke LoadBitmap, hInstance, IDB_I
		mov hBitmap[28], eax
		invoke LoadBitmap, hInstance, IDB_DD
		mov hBitmap[32], eax
		invoke LoadBitmap, hInstance, IDB_MM
		mov hBitmap[36], eax
		invoke LoadBitmap, hInstance, IDB_A
		mov hBitmap[40], eax
		invoke LoadBitmap, hInstance, IDB_FR
		mov hBitmap[44], eax
    .ELSEIF uMsg == WM_PAINTICON
        invoke BeginPaint, hWnd, addr ps
      	mov hdc, eax 
      	invoke CreateCompatibleDC,hdc
      	mov hMemDC,eax
      	invoke GetClientRect, hWnd, addr rect
      	
      	; Printing Hello
      	invoke SelectObject, hMemDC, hBitmap[0]
      	invoke BitBlt, hdc, 20, 20, rect.right, rect.bottom, hMemDC, 0, 0, SRCCOPY
      	
      	invoke Sleep, 500
      	
      	invoke SelectObject, hMemDC, hBitmap[4]
      	invoke BitBlt, hdc, 250, 20, rect.right, rect.bottom, hMemDC, 0, 0, SRCCOPY
      	
      	invoke Sleep, 500
      	
      	invoke SelectObject, hMemDC, hBitmap[8]
      	invoke BitBlt, hdc, 450, 20, rect.right, rect.bottom, hMemDC, 0, 0, SRCCOPY
      	
      	invoke Sleep, 500
      	
      	invoke SelectObject, hMemDC, hBitmap[12]
      	invoke BitBlt, hdc, 630, 15, rect.right, rect.bottom, hMemDC, 0, 0, SRCCOPY
      	
      	invoke Sleep, 500
      	
      	invoke SelectObject, hMemDC, hBitmap[16]
      	invoke BitBlt, hdc, 830, 20, rect.right, rect.bottom, hMemDC, 0, 0, SRCCOPY
      	
      	; Printing From
      	
      	invoke Sleep, 500
     
      	invoke SelectObject, hMemDC, hBitmap[44]
      	invoke BitBlt, hdc, 450, 250, rect.right, rect.bottom, hMemDC, 0, 0, SRCCOPY
      	
      	; Printing Dmidma
      	
      	invoke Sleep, 500
      	
      	invoke SelectObject, hMemDC, hBitmap[20]
      	invoke BitBlt, hdc, 20, 400, rect.right, rect.bottom, hMemDC, 0, 0, SRCCOPY
      	
      	invoke Sleep, 500
      	
      	invoke SelectObject, hMemDC, hBitmap[24]
      	invoke BitBlt, hdc, 230, 400, rect.right, rect.bottom, hMemDC, 0, 0, SRCCOPY
      	
      	invoke Sleep, 500
      	
      	invoke SelectObject, hMemDC, hBitmap[28]
      	invoke BitBlt, hdc, 470, 400, rect.right, rect.bottom, hMemDC, 0, 0, SRCCOPY
      	
      	invoke Sleep, 500
      	
      	invoke SelectObject, hMemDC, hBitmap[32]
      	invoke BitBlt, hdc, 580, 400, rect.right, rect.bottom, hMemDC, 0, 0, SRCCOPY
      	
      	invoke Sleep, 500
      	
      	invoke SelectObject, hMemDC, hBitmap[36]
      	invoke BitBlt, hdc, 780, 400, rect.right, rect.bottom, hMemDC, 0, 0, SRCCOPY
      	
      	invoke Sleep, 500
      	
      	invoke SelectObject, hMemDC, hBitmap[40]
      	invoke BitBlt, hdc, 1030, 400, rect.right, rect.bottom, hMemDC, 0, 0, SRCCOPY
      	 
      	
      	; End printing
      	invoke DeleteDC, hMemDC
      	invoke EndPaint, hWnd, addr ps
		
    .ELSE 
        invoke DefWindowProc, hWnd, uMsg, wParam, lParam 
        ret 
    .ENDIF 
    xor   eax, eax 
    ret 

WndProc endp




start:
    ; A must call that will get the instance handle of the program
    invoke GetModuleHandle, NULL 
    mov hInstance, eax 
    ; Get the handle of the Command Line
    invoke GetCommandLine                        
    mov CommandLine, eax
    
    ; Call the main function that will print the window
    invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT 
    
    ; Exit 
    invoke ExitProcess, eax
end start