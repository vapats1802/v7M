
  SECTION .text : CODE(2)
  DATA
  DC8 __FILE__
  ALIGNROM 2
  THUMB


plus
addd	; ( n1, n2 -- n3 )
	add	t,n
	NIP
	NEXT


addk
	ILK	w
	add	t,w
	NEXT


SUBB	MACRO
	sub	t, n, t
	NIP
	ENDM

subb
	SUBB
	NEXT


SUBR	MACRO
	rsb	t, n, t
	NIP
	ENDM

subr
	SUBR
	NEXT


subk
	ILK	w
	sub	t,t,w
	NEXT


mul32	mul	t,n,t
	NIP
	NEXT


andd	; ( x1,x2 -- x )
	ands	t,n
	NIP
	NEXT


andk	; ( x -- x' )
	ILK	w
	ands	t,w
	NEXT


or	; ( x1,x2 -- x )
	orrs	t,n
	NIP
	NEXT


bisk
ork	; ( x -- x' )
	ILK	w
	orrs	t,w
	NEXT


biskk:	; ( -- )	mask, addr
	ILK	w
	ILK	x
	ldr	y, [x]
	orr	y, y, w
	str	y, [x]
	NEXT


xorr:	; ( x1,x2 -- x )
	eors	t,n
	NIP
	NEXT


xork:	; ( x -- x' )
	ILK	w
	eors	t,w
	NEXT


bicc:	; ( x,mask -- x' )
	bics	n,t
	DROP
	NEXT


bick:	; ( x -- x' )
	ILK	w
	bics	t,w
	NEXT


bickk:	; ( -- )	mask, addr
	ILK	w
	ILK	x
	ldr	y, [x]
	bic	y, y, w
	str	y, [x]
	NEXT
