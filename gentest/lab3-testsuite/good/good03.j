.class public good03
.super java/lang/Object

.method public <init>()V
  aload_0
  invokespecial java/lang/Object/<init>()V
  return
.end method

.method public static main([Ljava/lang/String;)V
.limit locals 1
  invokestatic good03/main()I
  pop
  return
.end method

.method public static main()I
  .limit locals 1000
  .limit stack 1000

; int arg = readInt () ;

invokestatic Runtime/readInt()I
istore_0

; int ret = 1 ;

iconst_1
istore_1

; int i = 1 ;

iconst_1
istore_2

; while (i < arg + 1){
;   ret = i * ret ;
;   ++ i ;
;   }

L0:

iconst_1
iload_2
iload_0
iconst_1
iadd
if_icmplt L2
pop
iconst_0
L2:

ifeq L1

; {
;   ret = i * ret ;
;   ++ i ;
;   }


; ret = i * ret ;

iload_2
iload_1
imul
dup
istore_1
pop

; ++ i ;

iload_2
iconst_1
iadd
dup
istore_2
pop
goto L0
L1:


; printInt (ret);

iload_1
invokestatic Runtime/printInt(I)V
iconst_0
pop

; Epilogue
iconst_0
ireturn
.end method
