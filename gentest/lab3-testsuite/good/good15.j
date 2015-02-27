.class public good15
.super java/lang/Object

.method public <init>()V
  aload_0
  invokespecial java/lang/Object/<init>()V
  return
.end method

.method public static main([Ljava/lang/String;)V
.limit locals 1
  invokestatic good15/main()I
  pop
  return
.end method

.method public static main()I
  .limit locals 1000
  .limit stack 1000

; int i = 1 ;

iconst_1
istore_0

; printInt (i);

iload_0
invokestatic Runtime/printInt(I)V
iconst_0
pop

; true || i ++ != 45 ;

iconst_1
dup
iconst_0
if_icmpne L0
iconst_1
iload_0
dup
iconst_1
iadd
istore_0
bipush 45
if_icmpne L1
pop
iconst_0
L1:

ior
L0:

pop

; printInt (i);

iload_0
invokestatic Runtime/printInt(I)V
iconst_0
pop

; false || i ++ >= 0 ;

iconst_0
dup
iconst_0
if_icmpne L2
iconst_1
iload_0
dup
iconst_1
iadd
istore_0
iconst_0
if_icmpge L3
pop
iconst_0
L3:

ior
L2:

pop

; printInt (i);

iload_0
invokestatic Runtime/printInt(I)V
iconst_0
pop

; true && i ++ < 0 ;

iconst_1
dup
ifeq L4
iconst_1
iload_0
dup
iconst_1
iadd
istore_0
iconst_0
if_icmplt L5
pop
iconst_0
L5:

iand
L4:

pop

; printInt (i);

iload_0
invokestatic Runtime/printInt(I)V
iconst_0
pop

; false && i ++ > 0 ;

iconst_0
dup
ifeq L6
iconst_1
iload_0
dup
iconst_1
iadd
istore_0
iconst_0
if_icmpgt L7
pop
iconst_0
L7:

iand
L6:

pop

; printInt (i);

iload_0
invokestatic Runtime/printInt(I)V
iconst_0
pop

; int j = 0 ;

iconst_0
istore_1

; if (34 < 6 && j < 0){
;   printInt (i);
;   }
; else {
;   printInt (42);
;   }

iconst_1
bipush 34
bipush 6
if_icmplt L9
pop
iconst_0
L9:

dup
ifeq L8
iconst_1
iload_1
iconst_0
if_icmplt L10
pop
iconst_0
L10:

iand
L8:

ifeq L12

; {
;   printInt (i);
;   }


; printInt (i);

iload_0
invokestatic Runtime/printInt(I)V
iconst_0
pop
goto L11
L12:


; {
;   printInt (42);
;   }


; printInt (42);

bipush 42
invokestatic Runtime/printInt(I)V
iconst_0
pop
L11:


; Epilogue
iconst_0
ireturn
.end method
