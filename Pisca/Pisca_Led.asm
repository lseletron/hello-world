st7/
;* ----------------------------  (c) 2008 Soniclear  ------------------------ */
;******************************************************************************/
;* Include file provided with ST7 assembler describing the registers mapping. */
	.NOLIST
	#include "ST7FLITEUS5.INC"
	.LIST
	
	
	WORDS								;define following addresses as long
	segment byte at 80-BF 'ram0'

.temp 		DS.B 1			;define 1 byte para a variável temp
											;esta variável está localizada no endereço 80h
.temp2 		DS.B 1			;define 1 byte para a variável temp2
											;esta variável está localizada no endereço 81h
.tempo 		DS.B 1			;define 1 byte para a variável tempo
											;esta variável está localizada no endereço 82h
	WORDS
	segment byte at FC00-FFDF 'rom'
	
main

;Configure PTA3 as general purpose output.
	ld A,	#$55
	ld MUXCR0,A
	ld A,	#$AA
	ld MUXCR1,A
;Configures port A0/1/2/3/4 as output and A5 as input.
	ld A,#%00011111
	ld PADDR,A
;Configures inputs as floating and output as open drain
	clr A									; A=00h
	ld PAOR,A

;******************************************************************************/
;*										Aqui começa o código do programa												*/
;******************************************************************************/

principal
		;desvia para teclapres se o bit 5 estiver em 0
		btjf PADR,#5,teclapres
		ld A,	#$51
		ld tempo,A
		jp continua
teclapres
		ld A,	#$26
		ld tempo,A
continua
		bres PADR,#0
		call atraso
		bset PADR,#0
		call atraso
		jra principal
		
;******************************************************************************/
;* A sub-rotina de atraso abaixo irá fazer com que a CPU gaste um certo tempo */
;* de forma que o led permaneça aceso ou apagado durante este período					*/
;******************************************************************************/
atraso
		ld A,tempo			;Copia o tempo desejado para temp2
		ld temp2,A
		clr A
loop1
		ld A,	#$32
		ld temp,A
		dec temp2 ;dec temp2
		jrne loop2
		
		ret
loop2
		dec A						;decrementa A até que o mesmo chegue a zero
		jrne loop2
		jrf loop2				;gasta 3 ciclos
		jrf loop2				;gasta 3 ciclos
		nop							;gasta 1 ciclo
		nop							;gasta 1 ciclo
		ld A,	#$32			; ************* ADD
		dec temp				;decrementa temp e retorna para loop2 até que
		jrne loop2			;temp = 0
		
		jra loop1
		
;******************************************************************************/

;+----------------------------------------------------------------------------+
;|	INTERRUPT SUB-ROUTINES SECTION																						|
;+----------------------------------------------------------------------------+
	interrupt NonHandledInterrupt
NonHandledInterrupt
;In order to detect unexpected events during development,
;it is recommended to set a breakpoint on the following instruction
	iret		;Returns from interrupts

;+----------------------------------------------------------------------------+
;| INTERRUPT VECTORS MAPPING																									|
;+----------------------------------------------------------------------------+

	segment byte at FFE0-FFFF 'vectors'

								DC.W	NonHandledInterrupt ;FFE0-FFE1h
								DC.W	NonHandledInterrupt ;FFE2-FFE3h
								DC.W	NonHandledInterrupt ;FFE4-FFE5h
								DC.W	NonHandledInterrupt ;FFE6-FFE7h
								DC.W	NonHandledInterrupt ;FFE8-FFE9h
								DC.W	NonHandledInterrupt ;FFEA-FFEBh
								DC.W	NonHandledInterrupt ;FFEC-FFEDh
								DC.W	NonHandledInterrupt ;FFEE-FFEFh
								DC.W	NonHandledInterrupt ;FFF0-FFF1h
								DC.W	NonHandledInterrupt ;FFF2-FFF3h
								DC.W	NonHandledInterrupt ;FFF4-FFF5h
								DC.W	NonHandledInterrupt ;FFF6-FFF7h
								DC.W	NonHandledInterrupt ;FFF8-FFF9h
								DC.W	NonHandledInterrupt ;FFFA-FFFBh
								DC.W	NonHandledInterrupt ;FFFC-FFFDh
								DC.W	main								;FFFE-FFFFh

 END
 