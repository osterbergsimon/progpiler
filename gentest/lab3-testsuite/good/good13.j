.class public good13
.super java/lang/Object

.method public <init>()V
  aload_0
  invokespecial java/lang/Object/<init>()V
  return
.end method

.method public static main([Ljava/lang/String;)V
.limit locals 1
  invokestatic good13/main()I
  pop
  return
.end method

.method public static main()I
  .limit locals 1000
  .limit stack 1000

; int n, i ;


; n = readInt () ;

invokestatic Runtime/readInt()I
dup
istore_0
pop

; i = 2 ;

iconst_2
dup
istore_1
pop

; while (i <= n){
;   bool iPrime = true ;
;   int j = 2 ;
;   while (j * j <= i && iPrime){
;     if (i / j * j == i){
;       iPrime = false ;
;       }
;     else {
;       }
;     j ++ ;
;     }
;   if (iPrime && n / i * i == n){
;     printInt (i);
;     n = n / i ;
;     }
;   else {
;     i ++ ;
;     }
;   }

L0:

iconst_1
iload_1
iload_0
if_icmple L2
pop
iconst_0
L2:

ifeq L1

; {
;   bool iPrime = true ;
;   int j = 2 ;
;   while (j * j <= i && iPrime){
;     if (i / j * j == i){
;       iPrime = false ;
;       }
;     else {
;       }
;     j ++ ;
;     }
;   if (iPrime && n / i * i == n){
;     printInt (i);
;     n = n / i ;
;     }
;   else {
;     i ++ ;
;     }
;   }


; bool iPrime = true ;

iconst_1
istore_2

; int j = 2 ;

iconst_2
istore_3

; while (j * j <= i && iPrime){
;   if (i / j * j == i){
;     iPrime = false ;
;     }
;   else {
;     }
;   j ++ ;
;   }

L3:

iconst_1
iload_3
iload_3
imul
iload_1
if_icmple L6
pop
iconst_0
L6:

dup
ifeq L5
iload_2
iand
L5:

ifeq L4

; {
;   if (i / j * j == i){
;     iPrime = false ;
;     }
;   else {
;     }
;   j ++ ;
;   }


; if (i / j * j == i){
;   iPrime = false ;
;   }
; else {
;   }

iconst_1
iload_1
iload_3
idiv
iload_3
imul
iload_1
if_icmpeq L7
pop
iconst_0
L7:

ifeq L9

; {
;   iPrime = false ;
;   }


; iPrime = false ;

iconst_0
dup
istore_2
pop
goto L8
L9:


; {
;   }

L8:


; j ++ ;

iload_3
dup
iconst_1
iadd
istore_3
pop
goto L3
L4:


; if (iPrime && n / i * i == n){
;   printInt (i);
;   n = n / i ;
;   }
; else {
;   i ++ ;
;   }

iload_2
dup
ifeq L10
iconst_1
iload_0
iload_1
idiv
iload_1
imul
iload_0
if_icmpeq L11
pop
iconst_0
L11:

iand
L10:

ifeq L13

; {
;   printInt (i);
;   n = n / i ;
;   }


; printInt (i);

iload_1
invokestatic Runtime/printInt(I)V
iconst_0
pop

; n = n / i ;

iload_0
iload_1
idiv
dup
istore_0
pop
goto L12
L13:


; {
;   i ++ ;
;   }


; i ++ ;

iload_1
dup
iconst_1
iadd
istore_1
pop
L12:

goto L0
L1:


; return 0 ;

iconst_0
ireturn

; Epilogue
iconst_0
ireturn
.end method
