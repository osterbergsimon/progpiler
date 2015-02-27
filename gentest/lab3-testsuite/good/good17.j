.class public good17
.super java/lang/Object

.method public <init>()V
  aload_0
  invokespecial java/lang/Object/<init>()V
  return
.end method

.method public static main([Ljava/lang/String;)V
.limit locals 1
  invokestatic good17/main()I
  pop
  return
.end method

.method public static main()I
  .limit locals 1000
  .limit stack 1000

; int x ;


; x = 6 ;

bipush 6
dup
istore_0
pop

; int y ;


; y = x + 7 ;

iload_0
bipush 7
iadd
dup
istore_1
pop

; printInt (y);

iload_1
invokestatic Runtime/printInt(I)V
iconst_0
pop

; {
;   int y ;
;   y = 4 ;
;   printInt (y);
;   x = y ;
;   printInt (x);
;   }


; int y ;


; y = 4 ;

iconst_4
dup
istore_2
pop

; printInt (y);

iload_2
invokestatic Runtime/printInt(I)V
iconst_0
pop

; x = y ;

iload_2
dup
istore_0
pop

; printInt (x);

iload_0
invokestatic Runtime/printInt(I)V
iconst_0
pop

; printInt (x);

iload_0
invokestatic Runtime/printInt(I)V
iconst_0
pop

; printInt (y);

iload_1
invokestatic Runtime/printInt(I)V
iconst_0
pop

; Epilogue
iconst_0
ireturn
.end method
