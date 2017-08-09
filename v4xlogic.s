
; v4xlogic_a79 ; structures and operators for fuzzy, Kalman, genetic, imprecision

  SECTION .text : CODE(2)
  DATA
  DC8 __FILE__
  ALIGNROM 2
  THUMB


prox	; (n1, n2, n3 -- n1, n2, flag)  true if 3rdOS is within +/- TOS of NOS
	ldr	x, [p]		;
	subs	k, n, x
	it	mi
	rsbmi	k, k, #0
	cmp	k, t
	ite	ls
	movls	t, #-1
	movhi	t, #0
	NEXT


proxk	; (n1, n2 -- n1, n2, flag)  true if TOS is within +/- ilk of NOS
	ILK	w	; +/- tolerance
	subs	k, t, n
	DUP
	it	mi
	rsbmi	k, k, #0
	cmp	k, w
	ite	ls
	movls	t, #-1
	movhi	t, #0
	NEXT


proxkk	; (n -- n, flag)  true if TOS is within +/- ilk2 of ilk1
	DUP
	ILK	w	; prox target
	ILK	x	; +/- tolerance
	subs	k, n, w
	it	mi
	rsbmi	k, k, #0
	cmp	k, x
	ite	ls
	movls	t, #-1
	movhi	t, #0
	NEXT


satk	; ( n -- ssat )	clip/saturate TOS to +/- (+ve)ilk, bipolar
	ILK	w
	movs	k, t
	it	mi
	rsbmi	k, k, #0
	cmp	k, w
	it	le
	ldrle	PC, [i], #4

	movs	t, t
	it	mi
	rsbmi	w, w, #0
	mov	t, w
	NEXT
