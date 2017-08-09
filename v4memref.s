
  SECTION .text : CODE(2)
  DATA
  DC8 __FILE__
  ALIGNROM 2
  THUMB


atn
  DUP
fetch
at	; ( addr -- x )
	ldr	t, [t]
	NEXT

atk	; ( x1 -- x1, x2 )
	DUP
	ILK	t
	ldr	t, [t]
	NEXT

hatn
  DUP
hat	; ( addr -- x )
	ldrh	t, [t]
	NEXT

hatk	; ( x1 -- x1, x2 )
	DUP
	ILK	t
	ldrh	t, [t]
	NEXT

cfetch
bat	; ( addr -- x )
	ldrb	t, [t]
	NEXT

batn	; ( addr -- addr, x )
  DUP
	ldrb	t, [t]
	NEXT

batk	; ( x1 -- x1, x2 )
	DUP
	ILK	t
	ldrb	t, [t]
	NEXT


store
stor	; ( x, addr -- )
	str	n, [t]
	ldmia	p!, {n,t}		; 3 clocks, more portable
//	ldrd	t, n, [p], #8		; 3 clocks, less portable
	NEXT

strk	; ( x -- )
	ILK	x
	str	t, [x]
	DROP
	NEXT

strkn	; ( -- )
	ILK	x
	str	t, [x]
	NEXT

strkk	; ( -- )	data_ilk1, addr_ilk2
	ILK	w
	ILK	x
	str	w, [x]
	NEXT

strr	; ( addr, x -- )	store TOS via NOS
	str	t, [n]
	DDROP
	NEXT

strrn	; ( addr, x -- addr )	store TOS via NOS. non-destructive
	str	t, [n]
	DROP
	NEXT


hstr	; ( addr, x -- addr )	store TOS via NOS. non-destructive
	strh	n, [t]
	DDROP
	NEXT

hstrrn	; ( addr, x -- addr )	store TOS via NOS. non-destructive
	strh	t, [n]
	DROP
	NEXT


bstrnn	; ( byte, addr -- byte, addr )	store NOS.8 via TOS
	strb	n, [t]
	NEXT

bstrn	; ( byte, addr -- byte )	store NOS.8 via TOS
	strb	n, [t]
	DROP
	NEXT

bstr	; ( byte, addr -- )	store TOS.8 via NOS
	strb	n, [t]
	DDROP
	NEXT

bstrk	; ( x -- )
	ILK	x
	strb	t, [x]
	DROP
	NEXT

bstrkn	; ( x -- )
	ILK	x
	strb	t, [x]
	NEXT

bstrkk	; ( -- )	data_ilk1, addr_ilk2
	ILK	w
	ILK	x
	strb	w, [x]
	NEXT


bstrr	; ( addr, byte -- )	store TOS.8 via NOS
	strb	t, [n]
	DDROP
	NEXT


movkk	; ( -- )		move [src.ilk1] to [dst.ilk2]
	ILK	w
	ILK	x
	ldr	w, [w]
	str	w, [x]
	NEXT


atpk	; ( x -- x' )	add ilk:[addr] to TOS, conjugate of '+!'
  ILK x
	ldr	w, [x]
	add	t, t, w
	NEXT


pstr	; ( x, addr -- )	add TOS to [addr]	'+!'
	ldr	w, [t]
	add	n, n, w
	str	n, [t]
	DDROP
	NEXT

pstrkn	; ( -- )		add TOS to ilk@
	ILK	x
	ldr	w, [x]
	add	w, w, t
	str	w, [x]
	NEXT

pstrkk	; ( -- )		add ilk1 to ilk2@
	ILK	y
	ILK	x
	ldr	w, [x]
	add	w, w, y
	str	w, [x]
	NEXT


rmwkkk
rmwamd	; ( -- )	addr_ilk1,  mask_ilk2,  bitdata_ilk3
	ILK	x
	ILK	y
	ILK	k
	ldr	w, [x]
	bic	w, w, y
	and	k, k, y
	orr	w, w, k
	str	w, [x]
	NEXT


swapmem	; ( ptr1, ptr2 -- )
	ldr	w, [t]
	ldr	x, [n]
	str	x, [t]
	str	w, [n]
	DDROP
	NEXT


lut	; ( LUTbase, index -- x )  *LUT.ilk
	ldr	t, [n, t, lsl #2]	; base + index * 4 bytes.8
  NIP
  NEXT

lutk	; (index -- x)	ref nth entry of word.32 LUT based @ ilk
	ILK	x			; get ilk LUT base@, bump IP
	ldr	t, [x, t, lsl #2]	; base + index * 4 bytes.8
	NEXT


camk	; (tag -- x)	*search_table.ilk	content-addressed memory
	ILK	x		; get ilk list@, bump IP
_scam
	ldr	w, [x], #8	; get tag from list, [x] now = next tag
	cmp	t, w
	itt	eq
	ldreq	t, [x, #-4]	; get CAM entry from list if match
	ldreq	PC, [i], #4	; cond'l NEXT if match found

	teq	w, #0
	it	eq
	ldreq	PC, [i], #4	; cond'l NEXT if tag=0 (search aborted)

	b	_scam		; and loop again

