.class public good05
.super java/lang/Object

.method public <init>()V
  aload_0
  invokespecial java/lang/Object/<init>()V
  return
.end method

.method public static main([Ljava/lang/String;)V
.limit locals 1
  invokestatic good05/main()I
  pop
  return
.end method

.method public static main()I
  .limit locals 1000
  .limit stack 1000

; int lo, hi, mx ;


; lo = 1 ;

iconst_1
dup
istore_0
pop

; hi = lo ;

iload_0
dup
istore_1
pop

; mx = readInt () ;

invokestatic Runtime/readInt()I
dup
istore_2
pop

; printInt (lo);

iload_0
invokestatic Runtime/printInt(I)V
iconst_0
pop

; while (hi < mx){
;   printInt (hi);
;   hi = lo + hi ;
;   lo = hi - lo ;
;   }

L0:

iconst_1
iload_1
iload_2
if_icmplt L2
pop
iconst_0
L2:

ifeq L1

; {
;   printInt (hi);
;   hi = lo + hi ;
;   lo = hi - lo ;
;   }


; printInt (hi);

iload_1
invokestatic Runtime/printInt(I)V
iconst_0
pop

; hi = lo + hi ;

iload_0
iload_1
iadd
dup
istore_1
pop

; lo = hi - lo ;

iload_1
iload_0
isub
dup
istore_0
pop
goto L0
L1:


; Epilogue
iconst_0
ireturn
.end method
