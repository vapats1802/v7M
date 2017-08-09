
  SECTION .text : CODE(2)
  DATA
  DC8 __FILE__
  ALIGNROM 2
  THUMB


wait	; ( delay -- )
	mov	k,t
	DROP
_wait
	subs	k,k,#1
	bne	_wait

	NEXT


waitk	; ( -- )
	ILK	k
_waitk
	subs	k,k,#1
	bne	_waitk

	NEXT


waitn	; ( -- )
	mov	k,t
_waitn
	subs	k,k,#1
	bne	_waitn

	NEXT


doq	; ( u -- )
	str	t, [r, #-4]!	; save count to Rstack
	DROP
	str	i, [r, #-4]!	; mark loop:  save IP to Rstack
	NEXT


doqk
	ILK	k		; get lit iter count
	str	k, [r, #-4]!	; save count to Rstack
	str	i, [r, #-4]!	; mark loop:  save IP to Rstack
	NEXT


undoq	; un-mark doq..loopq
	add	r, r, #8	; flush Rstack iff == 0
	NEXT


doqi	; ( -- n )  get iter count
	DUP
	ldr	t, [r, #4]	; get iter count
	NEXT


leavedoq	;
	mov	k, #1
	str	k, [r, #4]
	NEXT


loopq
	ldr	k, [r, #4]	; get iter count
	adds	k, k, #-1	; decrement
	ittt	ne
	strne	k, [r, #4]	; writeback iff <> 0
	ldrne	i, [r]		; re-up IP iff <> 0
	ldrne	PC, [i, #4]!	; xeq next metacodon iff <> 0

	add	r, r, #8	; flush Rstack iff == 0
	NEXT


do
	str	n, [r, #-4]!	; save limit to Rstack
	str	t, [r, #-4]!	; save start index to Rstack
	DDROP
	str	i, [r, #-4]!	; mark loop:  save IP to Rstack
	NEXT


dokk
	ILK	k		; get lit limit
	str	k, [r, #-4]!	; save limit to Rstack
	ILK	k		; get lit start index
	str	k, [r, #-4]!	; save start index to Rstack
	str	i, [r, #-4]!	; mark loop:  save IP to Rstack
	NEXT


undo	; un-mark do..loop
	add	r, r, #12	; flush Rstack iff == 0
	NEXT


doi	; ( -- n )  get iter count
	DUP
	ldr	t, [r, #4]	; get loop index
	NEXT


leavedo
	ldr	w, [r, #8]	; get loop limit
	add	w, w, #-1	; decrement
	str	w, [r, #4]	; write back to index
	NEXT


loop
	ldr	k, [r, #4]	; get loop index
	adds	k, k, #1	; increment
	ldr	w, [r, #8]	; get loop limit
	cmp	w, k
	ittt	ne
	strne	k, [r, #4]	; writeback iff <> 0
	ldrne	i, [r]		; re-up IP iff <> 0
	ldrne	PC, [i, #4]!	; xeq next metacodon iff <> 0

	add	r, r, #12	; flush Rstack iff == 0
	NEXT


ploop	; ( inc -- )
	ldr	k, [r, #4]	; get loop index
	adds	k, k, t		; increment
	DROP
	ldr	w, [r, #8]	; get loop limit
	cmp	w, k
	ittt	ne
	strne	k, [r, #4]	; writeback iff <> 0
	ldrne	i, [r]		; re-up IP iff <> 0
	ldrne	PC, [i, #4]!	; xeq next metacodon iff <> 0

	add	r, r, #12	; flush Rstack iff == 0
	NEXT


ploopk
	ldr	k, [r, #4]	; get loop index
	ILK	w		; get lit increment
	adds	k, k, w		; increment
	ldr	w, [r, #8]	; get loop limit
	cmp	w, k
	ittt	ne
	strne	k, [r, #4]	; writeback iff <> 0
	ldrne	i, [r]		; re-up IP iff <> 0
	ldrne	PC, [i, #4]!	; xeq next metacodon iff <> 0

	add	r, r, #12	; flush Rstack iff == 0
	NEXT


doxkkk	; limit.ilk, inc.ilk, start.ilk
	ILK	k		; get lit limit
	str	k, [r, #-4]!	; save limit to Rstack
	ILK	k		; get lit increment
	str	k, [r, #-4]!	; save inc to Rstack
	ILK	k	; get lit start index
	str	k, [r, #-4]!	; save start index to Rstack
	str	i, [r, #-4]!	; mark loop:  save IP to Rstack
	NEXT


undox	; un-mark dox..loopx
	add	r, r, #16	; flush Rstack iff == 0
	NEXT


doxi	; ( -- n )  get iter count
	DUP
	ldr	t, [r, #4]	; get loop index
	NEXT


leavedox
	ldr	w, [r, #8]	; get loop inc
	ldr	x, [r, #12]	; get loop limit
	sub	x, x, w
	str	x, [r, #4]	; jam index
	NEXT


loopx
	ldr	k, [r, #4]	; get loop index
	ldr	w, [r, #8]	; get loop inc
	ldr	x, [r, #12]	; get loop limit
	add	k, k, w		; increment
	cmp	x, k
	ittt	ne
	strne	k, [r, #4]	; writeback iff <> 0
	ldrne	i, [r]		; re-up IP iff <> 0
	ldrne	PC, [i, #4]!	; xeq next metacodon iff <> 0

	add	r, r, #16	; flush Rstack iff == 0
	NEXT
