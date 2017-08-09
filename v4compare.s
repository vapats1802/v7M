

  SECTION .text : CODE(2)
  DATA
  DC8 __FILE__
  ALIGNROM 2
  THUMB


Q	MACRO
	cmp	t, #-1
	it	ne
	movne	t,#0
	ENDM

qn	; ( -- flag)  qualify flag:  true iff TOS = -1, non-destructive
	DUP
q	; (x -- flag)		qualify flag:  true iff TOS = -1
	Q
  NEXT


// zeq, nott	<<<<< ?????

ZQ	MACRO
	cmp	t, #0
	it	ne
	movne	t, #-1
	ENDM

zqn	; ( -- flag)	make well-formed true (-1) if TOS <> 0, non-destructive
	DUP
zq	; (x -- flag)	make well-formed flag:  true (-1) if TOS <> 0
	ZQ
	NEXT


qdup	; (x -- 0 | x,x)	dup TOS if <> 0
	teq	t, #0
	itt	ne
	strne	n, [p, #-4]!
	movne	n, t
	NEXT


zeqn	; ( x -- x, flag )
	DUP
zeq	; ( x -- flag )
	cmp	t, #0
	ite	eq
	mvneq	t,t
	movne	t,#0
	NEXT

zltn	; ( x -- x, flag )
	DUP
zlt	; ( x -- flag )
	cmp	t, #0
	ite	mi
	movmi	t,#-1
	movpl	t,#0
	NEXT


eq	; ( n1, n2 -- flag )	true if NOS > TOS, destructive
	cmp	t, n
	NIP
	ite	eq
	moveq	t, #-1	; t = n
	movne	t, #0	; t <> n
	NEXT


eqn	; ( -- flag )	true if NOS > TOS, non-destructive
	cmp	t, n
	DUP
	ite	eq
	moveq	t, #-1	; t = n
	movne	t, #0	; t <> n
	NEXT


eqkn	; ( -- flag )	true if TOS = ilk, non-destructive
  DUP
  ILK w
  cmp	t, w
	ite	eq
	moveq	t, #-1	; t = n
	movne	t, #0	; t <> n
	NEXT

eqk	; ( x -- flag )	true if TOS = ilk
  ILK w
  cmp	t, w
	ite	eq
	moveq	t, #-1	; t = n
	movne	t, #0	; t <> n
	NEXT


gt	; ( n1, n2 -- flag )	true if NOS > TOS, destructive
	cmp	t, n
	NIP
	ite	lt
	movlt	t, #-1	; t < n
	movge	t, #0	; t >= n
	NEXT


ge	; ( n1, n2 -- flag )	true if NOS >= TOS, destructive
	cmp	t, n
	NIP
	ite	le
	movle	t, #-1	; t < n
	movgt	t, #0	; t >= n
	NEXT


ltn	; ( n1, n2 -- n1, n2, flag )	true if NOS < TOS, non-destructive
	cmp	t, n
	DUP
	ite	gt
	movgt	t, #-1	; t > n
	movle	t, #0	; t =< n
	NEXT


lt	; ( n1, n2 -- flag )	true if NOS < TOS, destructive
	cmp	t, n
	NIP
	ite	gt
	movgt	t, #-1	; t > n
	movle	t, #0	; t =< n
	NEXT


le	; ( n1, n2 -- flag )	true if NOS <= TOS, destructive
	cmp	t, n
	NIP
	ite	ge
	movge	t, #-1	; t > n
	movlt	t, #0	; t =< n
	NEXT


signn
  DUP
sign  ; ( n -- 1|0|-1 )
nzp	; ( n -- f3 )	f3 = -1, 0, or 1
  mov x,t,asr#31
  rsb y,t,#0
  mov y,y,lsr #31
  orr t,x,y
  NEXT


cmp3  ; ( n1, n2 -- 1|0|-1 );sign
  SUBB
  b sign


;signn
;nzpn	; ( n -- n, f3 )	f3 = -1, 0, or 1
	DNN	; str	n, [p, #-4]!
	movs	n, t		; DUP with cc update
	ite	mi
	movmi	t, #-1
	movpl	t, #1
	it	eq
	moveq	t, #0
	NEXT


isign
qnzp	; ( x, f3 -- [+|0|-]x )   apply f3's sign, or zero
	teq	t, #0
	ite	mi
	rsbmi	t, n, #0
	movpl	t, n
	it	eq
	moveq	t, #0
	NIP
	NEXT


umink ; (n -- n | ilk)  alias: usatk
usatk ; ( x -- usat ) clip/saturate TOS to unsigned ilk, unipolar
  ILK w
  cmp t, w
  it  hi
  movhi t, w
  NEXT


umax
  cmp t, n
  it  hi
  movhi t, n
  DROP
  NEXT


lot	; lesser on top
	cmp	t, n
	ittt	gt
	movgt	w, t
	movgt	t, n
	movgt	n, w
	NEXT


lotfor	; lesser on top, flag on Rstack TRUE iff t>n, ZERO if n>t
	cmp	t, n
	ite	le
	movle	w, #0	; t<n
	movgt	w, #-1	; t>n
	str	w, [r, #-4]!
	ittt	gt
	movgt	w, t
	movgt	t, n
	movgt	n, w
	NEXT


got	; greater on top
	cmp	t, n
	ittt	lt
	movlt	w, t
	movlt	t, n
	movlt	n, w
	NEXT


gotfor	; greater on top, flag on Rstack TRUE iff t>n, ZERO if n>t
	cmp	t, n
	ite	lt
	movlt	w, #0	; t<n
	movge	w, #-1	; t>n
	str	w, [r, #-4]!
	ittt	lt
	movlt	w, t
	movlt	t, n
	movlt	n, w
	NEXT
