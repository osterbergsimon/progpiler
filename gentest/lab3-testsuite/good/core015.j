.class public core015
.super java/lang/Object

.method public <init>()V
  aload_0
  invokespecial java/lang/Object/<init>()V
  return
.end method

.method public static main([Ljava/lang/String;)V
.limit locals 1
  invokestatic core015/main()I
  pop
  return
.end method

.method public static main()I
  .limit locals 1000
  .limit stack 1000

; printInt (ev (17)) ;

bipush 17
invokestatic core015/ev(I)I
invokestatic Runtime/printInt(I)V
iconst_0
pop

; return 0 ;

iconst_0
ireturn

; Epilogue
iconst_0
ireturn
.end method

.method public static ev(I)I
  .limit locals 1000
  .limit stack 1000

; int e ;


; if (y > 0)e = ev (y - 2);
; else if (y < 0)e = 0 ;
; else e = 1 ;

iconst_1
iload_0
iconst_0
if_icmpgt L0
pop
iconst_0
L0:

ifeq L2

; e = ev (y - 2);

iload_0
iconst_2
isub
invokestatic core015/ev(I)I
dup
istore_1
pop
goto L1
L2:


; if (y < 0)e = 0 ;
; else e = 1 ;

iconst_1
iload_0
iconst_0
if_icmplt L3
pop
iconst_0
L3:

ifeq L5

; e = 0 ;

iconst_0
dup
istore_1
pop
goto L4
L5:


; e = 1 ;

iconst_1
dup
istore_1
pop
L4:

L1:


; return e ;

iload_1
ireturn

; Epilogue
iconst_0
ireturn
.end method
