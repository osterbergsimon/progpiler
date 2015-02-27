.class public core002
.super java/lang/Object

.method public <init>()V
  aload_0
  invokespecial java/lang/Object/<init>()V
  return
.end method

.method public static main([Ljava/lang/String;)V
.limit locals 1
  invokestatic core002/main()I
  pop
  return
.end method

.method public static main()I
  .limit locals 1000
  .limit stack 1000

; foo () ;

invokestatic core002/foo()V
pop

; return 0 ;

iconst_0
ireturn

; Epilogue
iconst_0
ireturn
.end method

.method public static foo()V
  .limit locals 1000
  .limit stack 1000

; Epilogue
return
.end method
