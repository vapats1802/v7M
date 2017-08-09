
  SECTION .text : CODE(2)
  DATA
  DC8 __FILE__
  ALIGNROM 2
  THUMB

;  these words do not "print" anything, merely assemble formatted strings,
;  usually (and conventionally) in PAD -- although PADx can in fact point
;  to anywhere.

  DATA
_I2X_ DC8 '0123456789ABCDEF'  ; nybble-to-hex digit LUT


  THUMB
i2x$n  ; ( -- )  uint-to-ASCIIz hex via PADx, (implicitly) non-destructive
  mov32 x, hex32$  ; ptr to out$
  adr k, _I2X_    ; ptr to LUT

  mov t, t, ror #28 ; "ROL 4"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov t, t, ror #28 ; "ROL 4"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov t, t, ror #28 ; "ROL 4"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov t, t, ror #28 ; "ROL 4"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov w, #'.'   ; print "."
  strb  w, [x], #1  ; str to PAD, post-inc

  mov t, t, ror #28 ; "ROL 4"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov t, t, ror #28 ; "ROL 4"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov t, t, ror #28 ; "ROL 4"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov t, t, ror #28 ; "ROL 4"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov w, #0   ; print null
  strb  w, [x]    ; str to PAD
  NEXT


h2x$n  ; ( -- )  uint.16-to-ASCIIz hex via PADx, (implicitly) non-destructive
  mov32 x, hex32$  ; ptr to out$
  adr k, _I2X_    ; ptr to LUT

  mov t, t, ror #12 ; "ROL 20"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov t, t, ror #28 ; "ROL 4"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov t, t, ror #28 ; "ROL 4"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov t, t, ror #28 ; "ROL 4"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov w, #0   ; print null
  strb  w, [x]    ; str to PAD
  NEXT


  DATA
G1  DC32  1000000000
M100  DC32  100000000
M10 DC32  10000000
M1  DC32  1000000
K100  DC32  100000
K10 DC32  10000
K1  DC32  1000
C100  DC32  100
Dt10  DC32  10


 NEST u2d$  ; ( u -- )
  DC32  atk,G1,udivmod,addk,30h,bstrk,(num$+0)
  DC32  atk,M100,udivmod,addk,30h,bstrk,(num$+1)
  DC32  atk,M10,udivmod,addk,30h,bstrk,(num$+2)
  DC32  atk,M1,udivmod,addk,30h,bstrk,(num$+3)
  DC32  atk,K100,udivmod,addk,30h,bstrk,(num$+4)
  DC32  atk,K10,udivmod,addk,30h,bstrk,(num$+5)
  DC32  atk,K1,udivmod,addk,30h,bstrk,(num$+6)
  DC32  atk,C100,udivmod,addk,30h,bstrk,(num$+7)
  DC32  atk,Dt10,udivmod,addk,30h,bstrk,(num$+8)
  DC32  addk,30h,bstrk,(num$+9)
  DC32  zero,bstrk,(num$+10)
  DC32  nexit


;ui2d$
;u2d10$  ; ( -- )  uint-to-ASCII decimal via PAD10x, (implicitly) non-destructive
;  NEST
;  DC32  ilk,(PAD10 + 15),zero,bstrrn
;  DC32  strk,PAD10x
;
;  DC32  dup
;
;  DC32  doqk,10
;  DC32  div10ascii
;  DC32  pstrkk,-1,PAD10x
;  DC32  atk,PAD10x,bstr
;  DC32  brk
;  DC32  loopq
;
;  DC32  drop,nexit
;
;
;div10ascii  ; ( u -- quo/10, ASCIIremmod10 )
;  NEST
;  DC32  brk
;  DC32  ilk,10,udivmod
;  DC32  swap,addk,30h
;  DC32  nexit
;
;
;dd2 ; ( n -- )
;  NEST
;  DC32  u2d10$,drop
;  DC32  atk,PAD10x,addk,8,mov$
;  DC32  nexit
;
;
;dd4 ; ( n -- )
;  NEST
;  DC32  u2d10$,drop
;  DC32  atk,PAD10x,addk,6,mov$
;  DC32  nexit
;
;
;i2d$  ; ( -- )  int-to-ASCII decimal via PADx,  (implicitly) non-destructive
;  NEST
;  DC32  dup,pbrn, _idp
;
;  DC32  negg,chark,"-"
;_idp
;  DC32  u2d10$,drop
;  DC32  elz
;  DC32  atk,PAD10x,mov$
;  DC32  nexit
;
;
;elz ; eat leading zeros (or commas) in PAD10
;  NEST
;  DC32  atk,PAD10x
;
;  DC32  begin
;  DC32  dup,ubat
;  DC32  dup,eqk,"0",swap,eqk,",",or, while, _eoz
;  DC32  inc,repeat
;_eoz
;  DC32  dup,ubat,eqk,0,zbr,_nlz ; else:  it's a digit (not a null)
;  DC32  dec     ; if:  leave a single "0" if null
;_nlz
;  DC32  strk,PAD10x     ; point to trimmed string
;  DC32  nexit
;
;
;i2fd$ ; ( -- )  int-to-fancy-decimal via PADx,  (implicitly) non-destructive
;  NEST
;  DC32  dup,pbrn, _ifdp
;
;  DC32  negg,chark,"-"
;_ifdp
;  DC32  u2d10$,drop
;  DC32  d10c
;  DC32  elz
;  DC32  atk,PAD10x,mov$
;  DC32  nexit
;
;
;PAD10xp DC32  PAD10x
;cd10c DC32  (PAD10 + 2)
;dd10c DC32  (PAD10 + 5)
;
;d10c  ; ( -- )  add commas to int decimal string in PAD10
;  ldr w, PAD10xp
;  ldr x, dd10c
;  ldr y, cd10c
;  str y, [w]
;  mov k, #','
;
;  ldrb  w, [x], #1
;  strb  w, [y], #1
;  strb  k, [y], #1
;
;  ldrb  w, [x], #1
;  strb  w, [y], #1
;  ldrb  w, [x], #1
;  strb  w, [y], #1
;  ldrb  w, [x], #1
;  strb  w, [y], #1
;  strb  k, [y], #1
;
;  ldrb  w, [x], #1
;  strb  w, [y], #1
;  ldrb  w, [x], #1
;  strb  w, [y], #1
;  ldrb  w, [x], #1
;  strb  w, [y], #1
;  strb  k, [y], #1
;  NEXT
;
;
;idc ; ( -- )  add comma to int decimal string in PAD
;  mov &PADx, A
;  mov A, B
;  dec A   ; *src$
;  inc B   ; *dst$
;  mov B, &PADx
;  mov.b #0, 0(B)
;  dec B
;  mov.b @A, 0(B)
;  dec A
;  dec B
;  mov.b @A, 0(B)
;  dec A
;  dec B
;  mov.b @A, 0(B)
;  dec A
;  dec B
;  mov.b #',', 0(B)
;  next


lzk ; ( -- )  strip leading zeros from decimal string in PAD, ilk digits
;  mov &PADx, A
;  mov @i+, X
;  sub X, A
;  mov A, B    ; *dst$
;  clr K
;
;_ilz  cmp.b #'0', 0(A)
;  jeq _il0
;  cmp.b #',', 0(A)
;  jne _ils
;
;_il0  dec K
;  inc A
;  jmp _ilz
;
;_ils  tst K
;  jz  _ilx
;
;  add X, K
;_ild  jnz _ilk    ; ? all zeros?
;
;  inc B
;  jmp _ilf
;
;_ilk  mov.b @A+, 0(B)
;  inc B
;  dec K
;  jnz _ild
;
;_ilf  mov.b #0, 0(B)
;  mov B, &PADx
;_ilx  next
;
;
;
;i2d$f ; ( -- )  fancy decimal string format for int
;  nest
;  DW  i2d$,idc,lzk,6,nexit


ddk
;uddk
;  DUP
;  ldr t, [i], #4
;  NEST
;  DC32  dup,atk,PADx,addd,strkn,PADx
;  DC32  ilk,0,over,bstr
;  DC32  addk,-1,tor
;  DC32  div10ascii,rfromn,dup,addk,-1,jamr,bstr
;  DC32  rdrop,drop,nexit
;