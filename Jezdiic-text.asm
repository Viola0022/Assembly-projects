.cseg ; nasledujici umistit do pameti programu (implicitni)
; definice pro nas typ procesoru
.include "m169def.inc"
; podprogramy pro praci s displejem
.org 0x1000
.include "print.inc"

; Zacatek programu - po resetu
.org 0
jmp start

.org 0x100
delka: .db 6 ; definice read-only konstanty v pameti programu (jeden bajt s hodnotou 6) 1
retez: .db "NEBUDE-LI PRSET NEZMOKNEM",0 ; retezec zakonceny nulou (nikoli znakem "0") 1


start:
    ; Inicializace zasobniku
    ldi r16, 0xFF
    out SPL, r16
    ldi r16, 0x04
    out SPH, r16
    ; Inicializace displeje
    call init_disp
zacatek:
    ldi r30, low(2*retez)
    ldi r31, high(2*retez)

	call clearRegs
cteni:
    lpm r16, Z+ 
	cpi r16, 0
	breq konecTextu
	
	;r22 je 2.pozice displeje
	;r27 je 7.pozice displeje 
	
	mov r27, r16


	call printAllChars        
	call incAllPositions
	call wait

jmp cteni

konecTextu:
	ldi r27, ' ' 
	call incAllPositions
	call printAllChars
	call wait

	call incAllPositions
	call printAllChars
	call wait

	call incAllPositions
	call printAllChars
	call wait

	call incAllPositions
	call printAllChars
	call wait

	call incAllPositions
	call printAllChars
	call wait

jmp zacatek
	

end: jmp end


wait:
	push r16
	push r17
	ldi r17, 128
cyklus:
	ldi r16, 255
	
cyklus1:
	dec r16
	nop ;žádná operace, trvá jeden takt
	brne cyklus1

	dec r17
	brne cyklus1

	pop r16
	pop r17
ret

printAllChars:
	ldi r17, 2
	mov r16, r22
	call show_char

	inc r17
	mov r16, r23
	call show_char

	inc r17
	mov r16, r24
	call show_char

	inc r17
	mov r16, r25
	call show_char

	inc r17
	mov r16, r26
	call show_char

	inc r17
	mov r16, r27
	call show_char



ret

;vyèistit registry (žádné pushe and popy, jsou to globální registry)
clearRegs:
	ldi r22, ' '
	ldi r23, ' '
	ldi r24, ' '
	ldi r25, ' '
	ldi r26, ' '

ret

incAllPositions:
	mov r22, r23
	mov r23, r24
	mov r24, r25
	mov r25, r26
	mov r26, r27



