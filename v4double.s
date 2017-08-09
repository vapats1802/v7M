
  SECTION .text : CODE(2)
  DATA
  DC8 __FILE__
  ALIGNROM 2
  THUMB


s2d
i2d	; ( n -- dlo, dhi )	int --> double
	str	n, [p, #-4]!
	movs	n, t
	ite	mi
	movmi	t, #-1
	movpl	t, #0
	NEXT


DDUP	MACRO
	str	n, [p, #-4]!
	str	t, [p, #-4]!
	ENDM


ddup	; (x1, x2 -- x1, x2, x1, x2)	overover
	DDUP
	NEXT


DUPDUP	MACRO
	DDUP
	mov	n, t
	ENDM


dupdup	; (x1, x2 -- x1, x2, x2, x2)
	DUPDUP
	NEXT


DNIP	MACRO
	ldr	n, [p, #4]!	; old 4thOS
	add	p, p, #4	; old 5thOS
	ENDM

dnip	; (x1, x2, x3 -- x3)	nipnip
	DNIP
	NEXT


dilk
dlit	; ( -- ilk1, ilk2)		; push d-literal
	DDUP
djamk	; (x1, x2 -- ilk1, ilk2)	; jam d-literal, stomp on TOS and NOS
	ILK	n
	ILK	t
	NEXT


DDROP	MACRO
	ldr	t, [p], #4
	ldr	n, [p], #4
	ENDM

ddrop	; (x -- )
	DDROP
	NEXT


dswap	; ( x1,x2, x3,x4 -- x3,x4, x1,x2 )
	ldr	w, [p]
	str	t, [p]
	mov	t, w
	ldr	x, [p, #4]
	str	n, [p, #4]
	mov	n, x
	NEXT


dover	; (d1, d2 -- d1, d2, d1)
	DDUP
	ldr	t, [p, #8]
	ldr	n, [p, #12]
	NEXT


DDNIP	MACRO
	add	p,p,#8	; old 5thOS is now 3rdOS
	ENDM

ddnip	; ( x1,x2, x3, x4 -- x3, x4 ) 3rdOS and 4thOS disappear
	DDNIP
	NEXT


DNEG	MACRO
	rsbs	n,n,#0
	mov	w, #0
	sbc	t,w,t
	ENDM

dneg	; ( d -- -d )
	DNEG
	NEXT


DABS	MACRO
	teq	t, #0
	ittt	mi
	rsbsmi	n, n, #0
	movmi	w, #0
	sbcmi	t,w,t
	ENDM

dabs     ; ( d -- |d| )		absolute value
	DABS
	NEXT


dat	; ( addr -- dL,dH )	load double via TOS
	DNN
	ldrd	n,t,[t]
	NEXT


datk	; ( -- xL,xH )	load double via ilk
	DDUP
	ILK	x
	ldrd	n,t,[x]
	NEXT



