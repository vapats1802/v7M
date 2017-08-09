
  SECTION .text : CODE(2)
  DATA
  DC8 __FILE__
  ALIGNROM 2
  THUMB


zero	; ( -- 0 )
	DUP
jamzero	; ( x -- 0 )
	mov	t,#0
	NEXT


true	; ( -- -1 )
	DUP
jamtrue	; ( x -- -1 )
	mov	t,#-1
	NEXT


one	; ( -- 0 )
	DUP
jamone	; ( x -- 0 )
	mov	t,#1
	NEXT


clz	clz	t,t
	NEXT


nott	; ( x -- ~x )
	mvn	t,t
	NEXT


negg	; ( x -- ~x )
	neg	t,t
	NEXT


qneg  ; ( x, f -- +/-x )
  teq t, #0
  ite ne
  rsbne t, n, #0
  moveq t, n
  NIP
  NEXT


abs
	teq	t, #0
	it   mi
  rsbmi	t, t, #0
	NEXT


oneplus
inc1
inc	; ( i -- i+1 )
	adds	t,#1
	NEXT

inc2	; ( i -- i+4 )
	adds	t,#2
	NEXT

inc4	; ( i -- i+4 )
	adds	t,#4
	NEXT


dec1
dec	; ( i -- i-1 )
	subs	t,#1
	NEXT

