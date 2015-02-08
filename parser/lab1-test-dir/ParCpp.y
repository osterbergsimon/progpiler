-- This Happy file was machine-generated by the BNF converter
{
{-# OPTIONS_GHC -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
module ParCpp where
import AbsCpp
import LexCpp
import ErrM

}

%name pProgram Program
%name pListDef ListDef
%name pDef Def
%name pListArg ListArg
%name pListStm ListStm
%name pArg Arg
%name pStm Stm
%name pExp16 Exp16
%name pExp15 Exp15
%name pExp14 Exp14
%name pExp13 Exp13
%name pExp12 Exp12
%name pExp11 Exp11
%name pExp10 Exp10
%name pExp9 Exp9
%name pExp8 Exp8
%name pExp4 Exp4
%name pExp3 Exp3
%name pExp2 Exp2
%name pExp1 Exp1
%name pExp Exp
%name pExp5 Exp5
%name pExp6 Exp6
%name pExp7 Exp7
%name pExp17 Exp17
%name pListExp ListExp
%name pType Type
%name pListType ListType
%name pListId ListId

-- no lexer declaration
%monad { Err } { thenM } { returnM }
%tokentype { Token }

%token 
 '!' { PT _ (TS _ 1) }
 '!=' { PT _ (TS _ 2) }
 '%' { PT _ (TS _ 3) }
 '&&' { PT _ (TS _ 4) }
 '(' { PT _ (TS _ 5) }
 ')' { PT _ (TS _ 6) }
 '*' { PT _ (TS _ 7) }
 '+' { PT _ (TS _ 8) }
 '++' { PT _ (TS _ 9) }
 '+=' { PT _ (TS _ 10) }
 ',' { PT _ (TS _ 11) }
 '-' { PT _ (TS _ 12) }
 '--' { PT _ (TS _ 13) }
 '-=' { PT _ (TS _ 14) }
 '->' { PT _ (TS _ 15) }
 '.' { PT _ (TS _ 16) }
 '/' { PT _ (TS _ 17) }
 ':' { PT _ (TS _ 18) }
 '::' { PT _ (TS _ 19) }
 ';' { PT _ (TS _ 20) }
 '<' { PT _ (TS _ 21) }
 '<<' { PT _ (TS _ 22) }
 '<=' { PT _ (TS _ 23) }
 '=' { PT _ (TS _ 24) }
 '==' { PT _ (TS _ 25) }
 '>' { PT _ (TS _ 26) }
 '>=' { PT _ (TS _ 27) }
 '>>' { PT _ (TS _ 28) }
 '?' { PT _ (TS _ 29) }
 '[' { PT _ (TS _ 30) }
 ']' { PT _ (TS _ 31) }
 'bool' { PT _ (TS _ 32) }
 'do' { PT _ (TS _ 33) }
 'double' { PT _ (TS _ 34) }
 'else' { PT _ (TS _ 35) }
 'false' { PT _ (TS _ 36) }
 'for' { PT _ (TS _ 37) }
 'if' { PT _ (TS _ 38) }
 'int' { PT _ (TS _ 39) }
 'return' { PT _ (TS _ 40) }
 'string' { PT _ (TS _ 41) }
 'struct' { PT _ (TS _ 42) }
 'throw' { PT _ (TS _ 43) }
 'true' { PT _ (TS _ 44) }
 'typedef' { PT _ (TS _ 45) }
 'void' { PT _ (TS _ 46) }
 'while' { PT _ (TS _ 47) }
 '{' { PT _ (TS _ 48) }
 '||' { PT _ (TS _ 49) }
 '}' { PT _ (TS _ 50) }

L_integ  { PT _ (TI $$) }
L_doubl  { PT _ (TD $$) }
L_quoted { PT _ (TL $$) }
L_Id { PT _ (T_Id _) }
L_err    { _ }


%%

Integer :: { Integer } : L_integ  { (read ( $1)) :: Integer }
Double  :: { Double }  : L_doubl  { (read ( $1)) :: Double }
String  :: { String }  : L_quoted {  $1 }
Id    :: { Id} : L_Id { Id (mkPosToken $1)}

Program :: { Program }
Program : ListDef { PDefs (reverse $1) } 


ListDef :: { [Def] }
ListDef : {- empty -} { [] } 
  | ListDef Def { flip (:) $1 $2 }


Def :: { Def }
Def : Type Id '(' ListArg ')' '{' ListStm '}' { DFun $1 $2 $4 (reverse $7) } 


ListArg :: { [Arg] }
ListArg : {- empty -} { [] } 
  | Arg { (:[]) $1 }
  | Arg ',' ListArg { (:) $1 $3 }


ListStm :: { [Stm] }
ListStm : {- empty -} { [] } 
  | ListStm Stm { flip (:) $1 $2 }


Arg :: { Arg }
Arg : Type Id { ADecl $1 $2 } 


Stm :: { Stm }
Stm : Exp ';' { SExp $1 } 
  | Type Id ';' { SDecl $1 $2 }
  | Type Id ',' ListId ';' { SDecls $1 $2 $4 }
  | Type Id '=' Exp ';' { SInit $1 $2 $4 }
  | 'return' Exp ';' { SReturn $2 }
  | 'return' ';' { SReturnVoid }
  | 'while' '(' Exp ')' Stm { SWhile $3 $5 }
  | 'do' Stm ';' 'while' '(' Exp ')' { SDoWhile $2 $6 }
  | '{' ListStm '}' { SBlock (reverse $2) }
  | 'if' '(' Exp ')' Stm { SIf $3 $5 }
  | 'if' '(' Exp ')' Stm 'else' Stm { SIfElse $3 $5 $7 }
  | 'for' '(' Exp ';' Exp ';' Exp ')' Stm { SFor $3 $5 $7 $9 }
  | 'typedef' Exp Id { STypedef $2 $3 }
  | 'struct' Id '{' ListStm '}' ';' { SStruct $2 (reverse $4) }


Exp16 :: { Exp }
Exp16 : Integer { EInt $1 } 
  | Double { EDouble $1 }
  | String { EString $1 }
  | 'true' { ETrue }
  | 'false' { EFalse }
  | Id { EId $1 }
  | Exp17 { $1 }
  | Id '<' ListType '>' { ETempi $1 $3 }
  | Exp17 '::' Exp17 { QC $1 $3 }


Exp15 :: { Exp }
Exp15 : Id '(' ListExp ')' { ECall $1 $3 } 
  | Id '[' Exp ']' { EInd $1 $3 }
  | Exp16 { $1 }


Exp14 :: { Exp }
Exp14 : Exp15 '++' { EPIncr $1 } 
  | Exp15 '--' { EPDecr $1 }
  | Exp15 '.' Exp14 { EPStr1 $1 $3 }
  | Exp15 '->' Exp14 { EPStr2 $1 $3 }
  | Exp15 { $1 }


Exp13 :: { Exp }
Exp13 : '++' Exp14 { EIncr $2 } 
  | '--' Exp14 { EDecr $2 }
  | '!' Exp14 { ENeg $2 }
  | Exp14 { $1 }


Exp12 :: { Exp }
Exp12 : Exp12 '*' Exp13 { EMul $1 $3 } 
  | Exp12 '/' Exp13 { EDiv $1 $3 }
  | Exp12 '%' Exp13 { ERem $1 $3 }
  | Exp13 { $1 }


Exp11 :: { Exp }
Exp11 : Exp11 '+' Exp12 { EAdd $1 $3 } 
  | Exp11 '-' Exp12 { ESub $1 $3 }
  | Exp12 { $1 }


Exp10 :: { Exp }
Exp10 : Exp10 '<<' Exp11 { ELef $1 $3 } 
  | Exp10 '>>' Exp11 { ERig $1 $3 }
  | Exp11 { $1 }


Exp9 :: { Exp }
Exp9 : Exp10 '<' Exp10 { ELt $1 $3 } 
  | Exp10 '>' Exp10 { EGt $1 $3 }
  | Exp10 '<=' Exp10 { ELEq $1 $3 }
  | Exp10 '>=' Exp10 { EGEq $1 $3 }
  | Exp10 { $1 }


Exp8 :: { Exp }
Exp8 : Exp9 '==' Exp9 { EEq $1 $3 } 
  | Exp9 '!=' Exp9 { ENEq $1 $3 }
  | Exp9 { $1 }


Exp4 :: { Exp }
Exp4 : Exp4 '&&' Exp5 { EAnd $1 $3 } 
  | Exp5 { $1 }


Exp3 :: { Exp }
Exp3 : Exp3 '||' Exp4 { EOr $1 $3 } 
  | Exp4 { $1 }


Exp2 :: { Exp }
Exp2 : Exp3 '=' Exp2 { EAss $1 $3 } 
  | Exp3 '+=' Exp2 { EPAss $1 $3 }
  | Exp3 '-=' Exp2 { ENAss $1 $3 }
  | Exp3 '?' Exp2 ':' Exp2 { ECon $1 $3 $5 }
  | Exp3 { $1 }


Exp1 :: { Exp }
Exp1 : 'throw' Exp2 { EExc $2 } 
  | Exp2 { $1 }


Exp :: { Exp }
Exp : Exp1 { $1 } 


Exp5 :: { Exp }
Exp5 : Exp6 { $1 } 


Exp6 :: { Exp }
Exp6 : Exp7 { $1 } 


Exp7 :: { Exp }
Exp7 : Exp8 { $1 } 


Exp17 :: { Exp }
Exp17 : '(' Exp ')' { $2 } 


ListExp :: { [Exp] }
ListExp : {- empty -} { [] } 
  | Exp { (:[]) $1 }
  | Exp ',' ListExp { (:) $1 $3 }


Type :: { Type }
Type : 'bool' { Type_bool } 
  | 'int' { Type_int }
  | 'double' { Type_double }
  | 'void' { Type_void }
  | 'string' { Type_string }


ListType :: { [Type] }
ListType : Type { (:[]) $1 } 
  | Type ',' ListType { (:) $1 $3 }


ListId :: { [Id] }
ListId : Id { (:[]) $1 } 
  | Id ',' ListId { (:) $1 $3 }



{

returnM :: a -> Err a
returnM = return

thenM :: Err a -> (a -> Err b) -> Err b
thenM = (>>=)

happyError :: [Token] -> Err a
happyError ts =
  Bad $ "syntax error at " ++ tokenPos ts ++ 
  case ts of
    [] -> []
    [Err _] -> " due to lexer error"
    _ -> " before " ++ unwords (map (id . prToken) (take 4 ts))

myLexer = tokens
}

