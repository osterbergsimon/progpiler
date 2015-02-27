.class public good07
.super java/lang/Object

.method public <init>()V
  aload_0
  invokespecial java/lang/Object/<init>()V
  return
.end method

.method public static main([Ljava/lang/String;)V
.limit locals 1
  invokestatic good07/main()I
  pop
  return
.end method

.method public static main()I
  .limit locals 1000
  .limit stack 1000

; int x = readInt () ;

invokestatic Runtime/readInt()I
istore_0

; int d = x / 2 ;

iload_0
iconst_2
idiv
istore_1

; while (d > 1){
;   if (d * (x / d)== x)printInt (d);
;   else {
;     }
;   d -- ;
;   }

L0:

iconst_1
iload_1
iconst_1
if_icmpgt L2
pop
iconst_0
L2:

ifeq L1

; {
;   if (d * (x / d)== x)printInt (d);
;   else {
;     }
;   d -- ;
;   }


; if (d * (x / d)== x)printInt (d);
; else {
;   }

iconst_1
iload_1
iload_0
iload_1
idiv
imul
iload_0
if_icmpeq L3
pop
iconst_0
L3:

ifeq L5

; printInt (d);

iload_1
invokestatic Runtime/printInt(I)V
iconst_0
pop
goto L4
L5:


; {
;   }

L4:


; d -- ;

iload_1
dup
iconst_1
isub
istore_1
pop
goto L0
L1:


; Epilogue
iconst_0
ireturn
.end method
