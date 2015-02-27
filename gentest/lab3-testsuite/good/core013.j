.class public core013
.super java/lang/Object

.method public <init>()V
  aload_0
  invokespecial java/lang/Object/<init>()V
  return
.end method

.method public static main([Ljava/lang/String;)V
.limit locals 1
  invokestatic core013/main()I
  pop
  return
.end method

.method public static main()I
  .limit locals 1000
  .limit stack 1000

; printBool (test (0 - 1)&& test (0)) ;

iconst_0
iconst_1
isub
invokestatic core013/test(I)I
dup
ifeq L0
iconst_0
invokestatic core013/test(I)I
iand
L0:

invokestatic core013/printBool(I)V
pop

; printBool (test (0 - 2)|| test (1)) ;

iconst_0
iconst_2
isub
invokestatic core013/test(I)I
dup
iconst_0
if_icmpne L1
iconst_1
invokestatic core013/test(I)I
ior
L1:

invokestatic core013/printBool(I)V
pop

; printBool (test (3)&& test (0 - 5)&& true);

iconst_3
invokestatic core013/test(I)I
dup
ifeq L3
iconst_0
iconst_5
isub
invokestatic core013/test(I)I
iand
L3:

dup
ifeq L2
iconst_1
iand
L2:

invokestatic core013/printBool(I)V
pop

; printBool (test (3)|| test (0 - 5)&& true);

iconst_3
invokestatic core013/test(I)I
dup
iconst_0
if_icmpne L4
iconst_0
iconst_5
isub
invokestatic core013/test(I)I
dup
ifeq L5
iconst_1
iand
L5:

ior
L4:

invokestatic core013/printBool(I)V
pop

; printBool (true);

iconst_1
invokestatic core013/printBool(I)V
pop

; printBool (false);

iconst_0
invokestatic core013/printBool(I)V
pop

; return 0 ;

iconst_0
ireturn

; Epilogue
iconst_0
ireturn
.end method

.method public static printBool(I)V
  .limit locals 1000
  .limit stack 1000

; if (b){
;   }
; else {
;   }

iload_0
ifeq L7

; {
;   }

goto L6
L7:


; {
;   }

L6:


; Epilogue
return
.end method

.method public static test(I)I
  .limit locals 1000
  .limit stack 1000

; return i > 0 ;

iconst_1
iload_0
iconst_0
if_icmpgt L8
pop
iconst_0
L8:

ireturn

; Epilogue
iconst_0
ireturn
.end method
