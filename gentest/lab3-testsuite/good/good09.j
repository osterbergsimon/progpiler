.class public good09
.super java/lang/Object

.method public <init>()V
  aload_0
  invokespecial java/lang/Object/<init>()V
  return
.end method

.method public static main([Ljava/lang/String;)V
.limit locals 1
  invokestatic good09/main()I
  pop
  return
.end method

.method public static main()I
  .limit locals 1000
  .limit stack 1000

; int i = readInt () ;

invokestatic Runtime/readInt()I
istore_0

; printInt (i);

iload_0
invokestatic Runtime/printInt(I)V
iconst_0
pop

; printInt (i ++);

iload_0
dup
iconst_1
iadd
istore_0
invokestatic Runtime/printInt(I)V
iconst_0
pop

; printInt (i);

iload_0
invokestatic Runtime/printInt(I)V
iconst_0
pop

; printInt (++ i);

iload_0
iconst_1
iadd
dup
istore_0
invokestatic Runtime/printInt(I)V
iconst_0
pop

; printInt (i);

iload_0
invokestatic Runtime/printInt(I)V
iconst_0
pop

; Epilogue
iconst_0
ireturn
.end method
