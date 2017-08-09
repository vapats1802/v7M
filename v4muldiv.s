
  SECTION .text : CODE(2)
  DATA
  DC8 __FILE__
  ALIGNROM 2
  THUMB


mull	; ( n1, n2 -- LSp,MSp )  32*32-->64, signed
	smull	n,t,n,t
	NEXT


umul	; ( u1, u2 -- LSp,MSp)  32*32-->64, un-signed
	umull	n,t,n,t
	NEXT


mulk	; ( x1 -- x2 )  32*32-->32
  ILK w
  mul	t,w,t
	NEXT


udivmod	; ( num, den -- rem, quo )	n32/t32-->32 un-signed
	mov	w,t
	udiv	t,n,t
	mls	n,t,w,n ; (num-(quo*den))
	NEXT


umoddiv	; ( num, den -- quo, rem )	n32/t32-->32 un-signed
	mov	w,n
	udiv	n,n,t
	mls	t,n,t,w ; (num-(quo*den))
	NEXT


smod	; ( n1, n2 -- rem )	n1 / n2 --> 32 signed
	sdiv	w,n,t
	mls	t,w,t,n
	NIP
	NEXT


umod	; ( u1, u2 -- rem )	u1 / u2, un-signed
	udiv	w,n,t
	mls	t,w,t,n
	NIP
	NEXT

umodk	; ( u -- rem )	un-signed
  ILK x
	udiv	w,t,x
	mls	t,w,x,t
	NEXT


squo	; ( n1, n2 -- quo )	32/32-->32, signed
	sdiv	t,n,t
	NIP
	NEXT


uquo	; ( u1, u2 -- uquo )	32/32-->32, unsigned
	udiv	t,n,t
	NIP
	NEXT


isqrt
usqrt	; (u -- usqrt)	integer only
	mov	k, #16
	mov	w, #8000h
	mov	x, #8000h
_sqiter
	mul	ra, w, w
	cmp	t, ra		; LSp.32
	it	lo
	eorlo	w, w, x
	mov	x, x, lsr #1
	eor	w, w, x
	subs	k, k, #1
	bne	_sqiter

	mov	t, w
	NEXT


ifsqrt
uifsqrt	; (u -- usqrt.16:frac.16)	int.frac
	mov	k, #32
	mov	w, #80000000h
	mov	x, #80000000h
_sifter
	umull	rb, ra, w, w
	cmp	t, ra		; MSp.32
	it	lo
	eorlo	w, w, x
	mov	x, x, lsr #1
	eor	w, w, x
	subs	k, k, #1
	bne	_sifter

	mov	t, w
	NEXT


//   >>> file:  v4muldiv.a43
//   v4muldiv_a43;	multiply, divide, modulo, sqrt
//   mul2d	; ( n1, n2 -- LSp,MSp )
//   umul2ud	; ( u1, u2 -- uLSp,uMSp )
//   mulsat	; (n1, n2 -- n'.16)	saturates.16 if (discarded) signed MSproduct
//   umulsat	; (u1, u2 -- u'.16)  saturates.16 if (discarded) unsigned MSproduct >0
//   uxmul	; (ud1, ud2 -- uq)	.32*.32 --> .64, unsigned
//   xmul	; (d1, d2 -- q)		.32*.32 --> .64, signed
//   ifmulsat ; (i.f1, i.f2 -- i.f') 16.16*16.16 --> 16.16, signed, with saturation
//   mul2d	; ( n1, n2 -- MSp, LSp )
//   umul2ud	; ( u1, u2 -- uMSp, uLSp )
//   mulsat	; ( n1, n2 -- n.16 )	saturates.16 if (discarded) signed MSproduct
//   umulsat	; ( u1, u2 -- u.16 ) saturates.16 if (discarded) unsigned MSproduct >0
//   uxmul	; (ud1, ud2 -- uq)	.32*.32 --> .64, unsigned
//   xmul	; (d1, d2 -- q)		.32*.32 --> .64, signed
//   ifmulsat ; (i.f1, i.f2 -- i.f') 16.16*16.16 --> 16.16, signed, with saturation
//   udivmod	; ( u1, u2 -- uquo, urem ) nonsense if u2 > u1, use uxdiv	<<<<<
//   udiv	; ( u1, u2 -- uquo )	; unf
//   modd
//   umod	; ( u1, u2 -- mod )	;
//   divmod	; ( n1, n2 -- quo, urem );
//   div	; ( n1, n2 -- quo )	; unf
//   sqrt	; ( u -- u.frac )
//   ifsqrt	; ( u.frac -- u.frac' )   unsigned int.frac sqrt
//   div2if	; (n1, n2 -- int.frac') signed int.frac division
//   uifdiv	; (u.frac1, u.frac2 -- u.frac') unsigned int.frac division
//   ifdiv	; (int.frac1, int.frac2 -- int.frac') signed int.frac division
//   urec	; (u -- .frac)	unsigned reciprocal	<<<<< wrong nomen
//   rec	; (n -- .frac)	reciprocal	<<<<<  (.frac -- n) ?????
//   uifrec	; (uint.frac -- .frac)	unsigned reciprocal	<<<<< wrong nomen
//   ifrec	; (int.frac -- .frac)	reciprocal
