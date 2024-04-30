.include "m169def.inc"
.cseg
.org	0x0000
jmp 	start

.org 	0x000A ;vektor preruseni
jmp		int_T2

.dseg
.org 0x100
sekundy: .byte 1

.cseg

.org	0x0100
.include "print.inc"


start:
;inicializace zasobniku
ldi		r16, 0x00
out		SPL, r16
ldi		r16, 0x04
out		SPH, r16

call init_disp

cli		;globální zakázání pøerušení
ldi r16, 0b00001000
sts ASSR, r16  ;vyber hodiny od krystaloveho oscilatori 32768 Hz
ldi r16, 0b00000001
sts TIMSK2, r16
ldi r16, 0b00000111
sts TCCR2A, r16 ;spusteni citace s delicim pomerem 128
clr r16			;zakaz preruseni do
out EIMSK, r16 ;joysticku
sei		;globalni povoleni preruseni

ldi r16, '0'
sts sekundy, r16


	ldi r17, 2
zobrazeni:
lds r16, sekundy
	call show_char
jmp zobrazeni



end: rjmp end

;obsluha preruseni
int_T2:
push r16
in r16, SREG
push r16

lds r16, sekundy ;nacteni obsahu promenne sekundy do r16, pamet dat (s tou jsme doted nepracovali)
cpi r16, '9'
breq vynulovani
inc r16
jmp ulozeni

vynulovani:
ldi r16, '0'

ulozeni:
sts sekundy, r16 ;ulozeni obsahu r16 do promenne sekundy v pameti dat

pop r16
out SREG, r16
pop r16
reti
