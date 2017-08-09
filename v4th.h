
#define n r0  // next (2nd) on Pstack, cached on-chip
#define t r1  // top of Pstack, cached on-chip
#define w r2  // scratch
#define x r3  // scratch;  usually a pointer
#define y r4  // scratch
#define p r5  // Pstack pointerinterpreter pointer
#define r r6  // Rstack pointer
#define i r7  // interpreter pointer
#define ra  r10 // scratch
#define rb  r11 // scratch
#define k r12 // scratch;  usually a count


; misc. handy equates

maxint  EQU 07FFFFFFFh
minint  EQU 080000000h
bel EQU 7
bs  EQU 8
ht  EQU 9
lf  EQU 0Ah
vt  EQU 0Bh
ff  EQU 0Ch
cr  EQU 0Dh
esc EQU 1Bh
nl  EQU 0A0Dh ; little-endian


NEXT  MACRO
 IF  v4DBT
  b debugNEXT
 ELSE
  ldr.w PC, [i, #4]!  ; pre-inc for Cortex-M
 ENDIF
  ENDM


NEST  MACRO colondef
  SECTION .text : CODE(2)
  ALIGNROM 2    ; 32-bit alignment is essential
  THUMB
  PUBLIC  colondef
colondef
  str.w i, [r, #-4]!  ; save IP to Rstack
  mov.w i, PC
  NEXT
  DATA
  ENDM


NEXIT MACRO
  ldr i, [r], #4  ; restore IP from Rstack
  NEXT
  ENDM


v4thISR MACRO ISRname
 ALIGNROM 2   ; 32-bit alignment is essential
  THUMB
  PUBLIC  ISRname
ISRname
  push  {r4-r11}  ; r0..r3 and r12 are auto-stacked by the NVIC.
  mov.n i, PC
  NEXT
  DATA
  ENDM


RE4TH MACRO
  mov i, PC   ; no adjustment needed for pipeline
  NEXT      ; begin metacode xeq'n
  ENDM


TO4TH MACRO
  str.w i, [r, #-4]!  ; save IP to Rstack
  mov.w i, PC
  NEXT
  ENDM


NIP MACRO
  ldr n, [p], #4
  ENDM


DROP  MACRO
  mov t, n
  NIP
  ENDM


DROPDUP MACRO
  mov n, t
  ENDM


DNN MACRO
; ( x1, x2 -- x1, x1, x2 )  overswap; push NOS only
  str n, [p, #-4]!
  ENDM


DUP MACRO
  DNN
  mov n, t
  ENDM


ILK MACRO reg
; *generalized* v4th InLineKonstant
  ldr reg, [i, #4]! ; pre-inc IP
  ENDM


TUCK  MACRO
  str t, [p, #-4]!
  ENDM


SWAP  MACRO
  mov w, t
  mov t, n
  mov n, w
  ENDM


OVER  MACRO
  DNN
  mov w, n
  mov n, t
  mov t, w
  ENDM


OVER3 MACRO
  ldr w, [p]
  DNN
  mov n, t
  mov t, w
  ENDM


OVER4 MACRO
  ldr w, [p, #4]
  DNN
  mov n, t
  mov t, w
  ENDM

