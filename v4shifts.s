
  SECTION .text : CODE(2)
  DATA
  DC8 __FILE__
  ALIGNROM 2
  THUMB


asrn	;  ( x, n -- x' )	shift right by n bits, sign-extended
	mov	n, n, asr t
	DROP
	NEXT


lsrn	;  ( x, n -- x' )	shift NOS left by TOS bits, zero-filled
	mov	n, n, lsr t
	DROP
	NEXT


lsln
sln	;  ( x, n -- x' )	shift NOS left by TOS bits, zero-filled
	mov	n, n, lsl t
	DROP
	NEXT


lslk
slk	;  ( x -- x' )		shift left by ilk bits, zero-filled
	ILK	w
	mov	t, t, lsl w
	NEXT


lsrk	;  ( x -- x' )		shift right by ilk bits, zero-extended
	ILK	w
	mov	t, t, lsr w
	NEXT


asrk	;  ( x -- x' )		shift right by ilk bits, sign-extended
	ILK	w
	mov	t, t, asr w
	NEXT


rork	;  ( x -- x' )		shift right by ilk bits, sign-extended
	ILK	w
	mov	t, t, ror w
	NEXT


SL1	MACRO
	mov	t, t, lsl #1
	ENDM

x2
twostar
lsl1
sl1	;  ( x -- x' )		shift left by 1 bit, LSb=0
	SL1
	NEXT


x4
sl2
	mov	t, t, lsl #2
	NEXT


sl16	mov	t, t, lsl #16
	NEXT


twoslash; = asr1
asr1	;  ( x -- x' )		shift right by 1 bit, sign-extended
	mov	t, t, asr #1
	NEXT


lsr1	;  ( x -- x' )		shift right by 1 bit, sign-extended
	mov	t, t, lsr #1
	NEXT


ror8	;  ( x -- x' )		rotate right by 8 bits
	mov	t, t, ror #8
	NEXT


rol8	;  ( x -- x' )		rotate left by 8 bits
	mov	t, t, ror #24
	NEXT


xlsr16nip	; ( x1, x2 -- x' )
	mov	t, t, lsl #16
	orr	t, t, n, lsr #16
	NIP
	NEXT


xlsr8nip	; ( x1, x2 -- x' )
	mov	t, t, lsl #24
	orr	t, t, n, lsr #8
	NIP
	NEXT


dlsr1
xlsr1	; ( d -- d' )	;
	movs	t, t, lsr #1
	movs	n, n, rrx
	NEXT


dasr1
xasr1	; ( d -- d' )	;
	movs	t, t, asr #1
	movs	n, n, rrx
	NEXT


dsl1
xsl1	; ( d -- d' )	;
	mov	t, t, lsl #1
	movs	n, n, lsl #1
	adc	t, t, #0
	NEXT


bitrev	; (x -- x')		bit-reverse TOS
	rbit	t,t
	NEXT

	ldr	k, =32
	ldr	w, =0
_bitrev	movs	t, t, rrx
	adc	w, w, #0
	subs	k, k, #1
	itt	ne
	movne	w, w, lsl #1
	bne	_bitrev

	mov	t, w
	NEXT


  ALIGNROM 2
  DATA
CRC32POLY
  DC32  01DB704C1h
;	DC32	04C11DB7h	; 1DB704C1h

  THUMB
CRC32gen	; (x -- x')		; CRC32 m-seq generator
	movs	t, t, lsl #1	; "ROL #1";  MSb --> carry
	adc	t, t, #0	; LSb <-- carry
	itt	cs
	ldrcs	w, (CRC32POLY-1)	; load polynomial if carry=1
	eorcs	t, t, w			; apply polynomial if carry=1
	NEXT


HPSAgen	; (x -- x')	; HPSA m-seq generator
	mov	w, #0
	movs	x, t, lsl #17
	adc	w, w, #0
	movs	x, t, lsl #21
	adc	w, w, #0
	movs	x, t, lsl #24
	adc	w, w, #0
	movs	x, t, lsl #26
	adc	w, w, #0
	movs	t, t, lsl #1
	movs	w, w, rrx
	adc	t, t, #0
	NEXT
