; definice pro nas typ procesoru
.include "m169def.inc"
; podprogramy pro praci s displejem
.org 0x1000
.include "print.inc"

; Zacatek programu - po resetu
.org 0
jmp start

; Zacatek programu - hlavni program
.org 0x100
start:
    ; Inicializace zasobniku
    ldi r16, 0xFF
    out SPL, r16
    ldi r16, 0x04
    out SPH, r16
    ; Inicializace joysticku
	call init_joy
	; Inicializace displeje
    call init_disp

    ldi r17, 2           ; nastaveni pozice pro vypis stavu

main_loop:               ; hlavni smycka
    call read_joy        ; nacti stav joysticku do r20
    cpi r20, 1           ; podivej se, co je v nem za hodnotu
    brne no_enter        ; neni enter -> preskoc

    ldi r16, 'E'         ; je enter
    jmp show_result
no_enter:
    ldi r16, '0'         ; neni enter

show_result:
    call show_char       ; vypis stav

jmp main_loop

end: jmp end

read_joy:                ; ulozi smer joysticku do registru r20
    push r16             ; uklid r16 a r17
    push r17

joy_reread:
    in r16, PINB         ; nacti hodnotu joysticku 1

    ldi r20, 255         ; chvili cekej 2
joy_wait: dec r20
    brne joy_wait

    in r17, PINB         ; nacti jeste jednou

    andi r16, 0b00010000 ; vymaskuj ostatni bity 3
    andi r17, 0b00010000

    cp r16, r17
    brne joy_reread      ; hodnoty se nerovnaly -> nacti znovu

    ldi r20, 0           ; vychozi hodnota - nic neni aktivni
    cpi r16, 0
    brne joy_no_enter    ; hodnota je inverzni -> neni 0 znamena neni aktivni 4
    ldi r20, 1           ; r20 = 1, kdyz je enter aktivni
joy_no_enter:

   pop r17               ; obnoveni r16 a r17
   pop r16
ret


init_joy:
    ; nastaveni portu E (smer vlevo a vpravo)
    in r17, DDRE         
    andi r17, 0b11110011
    in r16, PORTE
    ori r16, 0b00001100
    out DDRE, r17
    out PORTE, r16
    ldi r16, 0b00000000
    sts DIDR1, r16

    ; nastaveni portu B (smer dolu, nahoru a enter)
    in r17, DDRB
    andi r17, 0b00101111
    in r16, PORTB
    ori r16, 0b11010000
    out DDRB, r17
    out PORTB, r16
ret

