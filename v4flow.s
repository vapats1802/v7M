
  SECTION .text : CODE(2)
  DATA
  DC8 __FILE__
  ALIGNROM 2
  THUMB


nopp	NEXT


STOP	MACRO
	b	.
	ENDM

stop	STOP


delay ; ( delay -- )
  adds  t,t, #-1
  bne delay
  DROP
  NEXT


delayk
  ILK k
_delayk
  adds  k,k, #-1
  bne _delayk
  NEXT


begin	; r:( -- addr )
	str	i, [r, #-4]!
	NEXT


unNEST
unbegin	; r:( addr -- )	un-mark:  rfrom,drop
	add	r, r, #4
	NEXT


repeat	; r:( -- )
again	; r:( -- )
	ldr	i, [r]
	NEXT


until	; ( x -- )
	cmp	t, #0
	DROP
	ite	eq
	ldreq	i, [r]		; r:( -- )
	addne	r, r, #4	; r:( addr -- )
	NEXT


untiln	; ( -- )
	cmp	t, #0
	ite	eq
	ldreq	i, [r]		; r:( -- )
	addne	r, r, #4	; r:( addr -- )
	NEXT


zuntil	; ( x -- )		; loop if TOS true <> 0; "not until"
	teq	t, #0
	ite	ne
	ldrne	i, [r]
	addeq	r, r, #4
	DROP
	NEXT


zuntiln	; ( x -- x )		; loop if TOS true <> 0, non-destructive
	teq	t, #0
	ite	ne
	ldrne	i, [r]
	addeq	r, r, #4
	NEXT


while	; ( x --)	xeq following, else branch to ilk
	teq	t, #0
	DROP
	ittte	eq
	addeq	r, r, #4	; un-mark Rstack if false = 0
	ldreq	i, [i, #4]		; zbr
	ldreq	PC, [i]	; conditional NEXT if false = 0

	addne	i, i, #4	; else bump IP past "zbr" ilk
	NEXT


whilen	; ( -- )	xeq following, else branch to ilk, non-destructive
	teq	t, #0
	ittte	eq
	addeq	r, r, #4	; un-mark Rstack if false = 0
	ldreq	i, [i, #4]		; zbr
	ldreq	PC, [i]	; cond'l NEXT if false = 0

	addne	i, i, #4	; else bump IP past "zbr" ilk
	NEXT


zwhile	; ( x --)	xeq following, else branch to ilk
	teq	t, #0
	DROP
	ittte	ne
	addne	r, r, #4	; un-mark Rstack if true <> 0
	ldrne	i, [i, #4]		; tbr
	ldrne	PC, [i]	; cond'l NEXT if true <> 0

	addeq	i, i, #4	; else bump IP past "tbr" ilk
	NEXT


zwhilen	; ( -- )	xeq following, else branch to ilk, non-destructive
	teq	t, #0
	ittte	ne
	addne	r, r, #4	; un-mark Rstack if true <> 0
	ldrne	i, [i, #4]		; tbr
	ldrne	PC, [i]	; cond'l NEXT if true <> 0

	addeq	i, i, #4	; else bump IP past "tbr" ilk
	NEXT


br
	ldr	i,[i,#4]   	; branch to ilk
  ldr PC,[i]


zbr	; ( x -- )		branch to ilk if TOS = 0
	teq	t, #0
	DROP
	itte   eq
  ldreq	i, [i,#4]
	ldreq	PC, [i]

	addne	i, i, #4	; else bump IP
	NEXT


zbrn	; ( -- )		branch to ilk if TOS = 0, non-destructive
	teq	t, #0
	itte   eq
  ldreq	i, [i,#4]
	ldreq	PC, [i]

	addne	i, i, #4	; else bump IP
	NEXT


tbr	; ( x -- )		branch to ilk if TOS <> 0
	teq	t, #0
	DROP
	itte   ne
  ldrne	i, [i,#4]
	ldrne	PC, [i]

	addeq	i, i, #4	; else bump IP
	NEXT


tbrn	; ( -- )		branch to ilk if TOS <> 0, non-destructive
	teq	t, #0
	itte   ne
  ldrne	i, [i,#4]
	ldrne	PC, [i]

	addeq	i, i, #4	; else bump IP
	NEXT


nbr	; ( n -- )		branch to ilk if TOS < 0
	teq	t, #0
	DROP
	itte   mi
  ldrmi	i, [i,#4]
	ldrmi	PC, [i]

	addpl	i, i, #4	; else bump IP
	NEXT


nbrn	; ( -- )		branch to ilk if TOS < 0, non-destructive
	teq	t, #0
	itte   mi
  ldrmi	i, [i,#4]
	ldrmi	PC, [i]

	addpl	i, i, #4	; else bump IP
	NEXT


pbr	; ( n -- )		branch to ilk if TOS >= 0
	teq	t, #0
	DROP
	itte   pl
  ldrpl	i, [i,#4]
	ldrpl	PC, [i]

	addmi	i, i, #4	; else bump IP
	NEXT


pbrn	; ( -- )		branch to ilk if TOS >= 0, non-destructive
	teq	t, #0
	itte   pl
  ldrpl	i, [i,#4]
	ldrpl	PC, [i]

	addmi	i, i, #4	; else bump IP
	NEXT


br3k	; ( n -- )	3-way branch;  <0.ilk, =0.ilk, >0.ilk
	teq	t, #0
	DROP		; the following sequence is critical!
	it      mi
  ldrmi	i, [i, #4]
	it      pl
  ldrpl	i, [i, #12]
  it      eq
  ldreq	i, [i, #8]
	NEXT


br3kn	; ( -- )	3-way branch, non-destructive;  <0.ilk, =0.ilk, >0.ilk
	teq	t, #0	; the following sequence is critical!
	it      mi
  ldrmi	i, [i, #4]
	it      pl
  ldrpl	i, [i, #12]
	it      eq
  ldreq	i, [i, #8]
	NEXT


brlutk	; ( n -- )  *branch_table.ilk;  LUT-based multi-branch
	ILK	x
	ldr	i, [x, t, lsl #2]	; base + index * 4 bytes.8
	DROP
	NEXT


brlutkn	; ( -- )  *branch_table.ilk;  LUT-based multi-branch, non-destructive
	ILK	x
	ldr	i, [x, t, lsl #2]	; base + index * 4 bytes.8
	NEXT


casek	; (index -- )  *case_table.ilk
  ILK x
	mov	w, t
	DROP
	ldr	PC, [x, w, lsl #2]	; base + index * 4 bytes.8

