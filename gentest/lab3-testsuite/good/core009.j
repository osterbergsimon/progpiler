.class public core009
.super java/lang/Object

.method public <init>()V
  aload_0
  invokespecial java/lang/Object/<init>()V
  return
.end method

.method public static main([Ljava/lang/String;)V
.limit locals 1
  invokestatic core009/main()I
  pop
  return
.end method

.method public static main()I
  .limit locals 1000
  .limit stack 1000

; int x = foo () ;

invokestatic core009/foo()I
istore_0

; printInt (x);

iload_0
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

.method public static foo()I
  .limit locals 1000
  .limit stack 1000

; return 10 ;

bipush 10
ireturn

; Epilogue
iconst_0
ireturn
.end method
