
; Cortex-M3/M4/M4F v4th nucleus

  SECTION .text : CONST(2)

BRAND$    DC8 '    '
CryptKeeper DC8 'v4th'
    DC8 '  for ARM Cortex-M3/M4/M4F  0.7 ',cr,lf
    DC8 ' copycenter (c)   oct 2016 ',cr,lf
    DC8 " vic plichota,  antares technical services "
   ALIGNROM 2

maketimestamp
makepad   DC16  0
makeSM
makeSec   DC8 DATE 1
makeMin   DC8 DATE 2
makeHDMY
makeHour  DC8 DATE 3
makeDay   DC8 DATE 4
makeMonth DC8 DATE 5
makeYear  DC8 DATE 6

makeDATE$ DC8 __DATE__
makeTIME$ DC8 __TIME__


  SECTION .text : CODE(2)
  DATA
  DC8 __FILE__
  ALIGNROM 2
  THUMB


eint
  nop
  cpsie i
  NEXT


dint
  nop
  cpsid i
  NEXT


reti
  pop {r4-r11}  ; return from v4th ISR, r0..r3 and r12 are auto-restored by the NVIC.
  bx  LR


Ccall0_0 ; extern void Cproc(void);
  ILK k ; Cproc
  push  {n,t,p,r,i}
  blx k

  pop {n,t,p,r,i}
  NEXT


Ccall2_1 ; ( x1, x2 -- x );  extern untyped Cproc(untyped t, untyped n); return t
  push  {t} ; t will be n, after the Ccall.
  ILK t
  ILK n
  ILK k ; Cproc
  push  {p,r,i}
  blx k

  pop {p,r,i}
  mov t, r0 ; <<<<< dependent on reg assignments!
  pop {n} ; n was t, before the Ccall.
  NEXT


debugNEXT
  ldr.w PC, [i, #4]!  ; "single-step" NEXT.

traceNEXT
  ldr ra,[i]  ; word behind (putative past)
  mov32 x,v4TracePtr
  ldr rb,[i,#4] ; current word (present)
  mov w,x
  ldr x,[x]
  ldr k,[i,#8]  ; word ahead (putative future)
  mov y,x
  stmia x!,{n,t,p,r,i,ra,rb,k}
  bic y,y,#03FCh
  and x,x,#03FCh
  orr x,x,y
  str x,[w]
  ldr.w PC, [i, #4]!  ; "single-step" NEXT.


next  ; = nexit -- use instead of "recode \n\w NEXT"
nexit ; r:( addr -- )
  ldr i, [r], #4  ; restore IP from Rstack;  "semis"
  NEXT


tocode
  orr i, i, #1  ; fudge the inter-op-Thumb LSbit
  mov PC, i


recode  mov x, i    ; deek around IP --> PC chicken/egg quandary
  orr x, x, #1  ; fudge the inter-op-Thumb LSbit
  ldr i, [r], #4  ; restore IP from Rstack
  mov PC, x


nip ; ( x1, x2 -- x2 )  swapdrop
  NIP
  NEXT


drop  ; ( x -- )
  DROP
  NEXT


dropdup ; ( x1, x2 -- x1, x1 )
  DROPDUP
  NEXT


overswap  ; ( x1, x2 -- x1, x1, x2 )
  DNN
  NEXT


dup ; ( x -- x, x )
  DUP
  NEXT


ilk
lit ; ( -- x )
  DUP
jamk  ; ( x -- x' )
  ILK t
  NEXT


tuck  ; ( x1, x2 -- x2, x1, x2 )  swapover
  TUCK
  NEXT


swap  ; ( x1, x2 -- x2, x1 )
  SWAP
  NEXT


over  ; ( x1, x2 -- x1, x2, x1 )
  OVER
  NEXT


over3 ; ( x1, x2, x3 -- x1, x2, x3, x1 )
  OVER3
  NEXT


over4 ; ( x1, x2, x3, x4 -- x1, x2, x3, x4, x1 )
  OVER4
  NEXT


torn  ; ( -- )  >R, non-destructive
  str t, [r, #-4]!
  NEXT


tor ; ( x -- )  >R
  str t, [r, #-4]!
  DROP
  NEXT


rfrom ; ( -- x )  R>
  DUP
  ldr t, [r], #4
  NEXT


rfromn  ; ( -- x )  R>, copy stays on Rstack
  DUP
  ldr t, [r]
  NEXT


rdrop ; R>, drop
  add r, r, #4
  NEXT


#include  "C:\atsvap\ARMv7M\v4th_M4F\v4th\v4monad.s"  ; unary op's
#include  "C:\atsvap\ARMv7M\v4th_M4F\v4th\v4dyad.s" ; dyadic op's
#include  "C:\atsvap\ARMv7M\v4th_M4F\v4th\v4muldiv.s" ; integer mul, div, sqrt
#include  "C:\atsvap\ARMv7M\v4th_M4F\v4th\v4compare.s"  ; comparison/equality tests, max/min
#include  "C:\atsvap\ARMv7M\v4th_M4F\v4th\v4shifts.s" ; shifts, bit-reverse, byte/nybble swaps, etc.
#include  "C:\atsvap\ARMv7M\v4th_M4F\v4th\v4double.s" ; stack primitives for double-cells
#include  "C:\atsvap\ARMv7M\v4th_M4F\v4th\v4memref.s" ; memory reference primitives
#include  "C:\atsvap\ARMv7M\v4th_M4F\v4th\v4flow.s" ; basic program flow-control
#include  "C:\atsvap\ARMv7M\v4th_M4F\v4th\v4doloop.s" ; definite loops
//#include  "v4xflow.a79" ; fancy program flow-control

#include  "C:\atsvap\ARMv7M\v4th_M4F\v4th\v4xlogic.s" ; imprecise op's
//#include  "v4bqals.a79" ; struct's, arrays, etc.
//#include  "v4$bqals.a79"  ; struct's, arrays, etc.
//#include  "v4exotic.a79"  ; weird stuff
//#include  "v4time.s"  ; time, calendar
;#include "C:\atsvap\ARMv7M\v4th_M4F\v4th\v4numcnv.asm" ; numeric conversion & "print" formatting
#include  "C:\atsvap\ARMv7M\v4th_M4F\v4th\v4xlat.asm" ; numeric conversion & "print" formatting
//#include  "v4$tring.a79"  ; "print" formatting

//#include  "v4fonts.a79" ; display fonts
//#include  "v4io.a79"  ; mundane I/O
//#include  "v4comnet.a79"  ; SCI messaging
//#include  "v4flash.a79" ; flash memory op's
//#include  "v4float.a79" ; floating-point primitives
//#include  "v4fmath.a79" ; fancy floating-point
//#include  "v4ij.a79"  ; complex math
//#include  "v4rtos.a79"  ; RTOS kernel
//#include  "v4debug.a79" ; native metacode monitor/debugger
//#include  "v4power.a79" ; power management

