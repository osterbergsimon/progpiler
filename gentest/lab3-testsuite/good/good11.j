.class public good11
.super java/lang/Object

.method public <init>()V
  aload_0
  invokespecial java/lang/Object/<init>()V
  return
.end method

.method public static main([Ljava/lang/String;)V
.limit locals 1
  invokestatic good11/main()I
  pop
  return
.end method

.method public static main()I
  .limit locals 1000
  .limit stack 1000

; int sum = 0 ;

iconst_0
istore_0

; int num = 0 ;

iconst_0
istore_1

; int x ;


; while ((x = readInt ())!= 0){
;   sum = sum + x ;
;   num ++ ;
;   }

L0:

iconst_1
invokestatic Runtime/readInt()I
dup
istore_2
iconst_0
if_icmpne L2
pop
iconst_0
L2:

ifeq L1

; {
;   sum = sum + x ;
;   num ++ ;
;   }


; sum = sum + x ;

iload_0
iload_2
iadd
dup
istore_0
pop

; num ++ ;

iload_1
dup
iconst_1
iadd
istore_1
pop
goto L0
L1:


; printInt (sum / num);

iload_0
iload_1
idiv
invokestatic Runtime/printInt(I)V
iconst_0
pop

; Epilogue
iconst_0
ireturn
.end method
