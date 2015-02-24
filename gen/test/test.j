.class public test
.super java/lang/Object

.method public <init>()V
  aload_0
  invokespecial java/lang/Object/<init>()V
  return
.end method

.method public static main([Ljava/lang/String;)V
.limit locals 1
  invokestatic test/main()I
  pop
  return
.end method

.method public static main()I
  .limit locals 1000
  .limit stack 1000

; int x = 0 ;

iconst_0
istore_0

; x ++ ;

iload_0
dup
iconst_1
iadd
istore_0
pop

; printInt (x ++);

iload_0
dup
iconst_1
iadd
istore_0
invokestatic Runtime/printInt(I)V
iconst_0
pop

; return x ;

iload_0
ireturn

; printInt (x ++);

iload_0
dup
iconst_1
iadd
istore_0
invokestatic Runtime/printInt(I)V
iconst_0
pop

; Epilogue
iconst_0
ireturn
.end method
