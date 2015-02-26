-- | JVM abstract syntax
module JVM where

data Val
  = VInt Integer
  | VDbl Double
  | VStr String
  deriving (Show, Eq)

type Address = Int
type Label = Int
data FunType = FunType String [String]

type JVM = [Instruction]
data CondOp =
    LTH
  | LE
  | GTH
  | GE
  | EQU
  | NE
  | IFEQ
   deriving (Eq)

data Size = Word | DWord
  deriving (Eq)

-- TODO: add more instructions
data Instruction
  = Load Address Size
  | Store Address Size
  | Push Val -- iconst_ / bipush / sipush / ldc
  | Pop Size
  | Dup Size
  | Add Size
  | Div Size
  | Rem Size
  | Mul Size
  | Sub Size
  | Neg Size
  | And Size
  | Or Size
  | Goto Label
  | If CondOp Label Size
  | Return (Maybe Size)
  | Label Label
  | Comment String
  | Raw String -- some raw code
  | Invoke String String [String] String -- class, method, args, return
  | Null
  deriving (Eq)

instance Show Instruction where
  show = showInstruction

showInstruction :: Instruction -> String
showInstruction (Load addr s)
  | addr >= 0 && addr <= 3 = "iload_" ++ show addr
  | otherwise = "iload " ++ show addr
showInstruction (Store addr s) 
  | addr >= 0 && addr <= 3 = "istore_" ++ show addr
  | otherwise = "istore " ++ show addr
showInstruction (Push (VInt i))
  | i == (-1) = "iconst_m1"
  | i >= 0 && i <= 5 = "iconst_" ++ show i
  | abs i < 2^7 = "bipush " ++ show i
  | abs i < 2^15 = "sipush " ++ show i
  | abs i < 2^31 = "ldc " ++ show i
  | otherwise = "Too big integer: " ++ show i
showInstruction (Pop Word) = "pop"
showInstruction (Dup Word) = "dup"
showInstruction (Add Word) = "iadd"
showInstruction (Div Word) = "idiv"
showInstruction (Rem Word) = "irem"
showInstruction (Mul Word) = "imul"
showInstruction (Sub Word) = "isub"
showInstruction (Neg Word) = "ineg"
showInstruction (And Word) = "iand"
showInstruction (Or Word) = "ior"
showInstruction (Goto lbl) = "goto " ++ showLabel lbl
--showInstruction (If l)  = "ifeq " ++ showLabel l
showInstruction (If op lbl Word) = cmd ++ " " ++ showLabel lbl
  where cmd = case op of
          LTH -> "if_icmplt"
          LE -> "if_icmple"
          GTH -> "if_icmpgt"
          GE -> "if_icmpge"
          EQU -> "if_icmpeq" 
          NE -> "if_icmpne"
          IFEQ -> "ifeq"
showInstruction (Return s) = case s of
  Just Word -> "ireturn"
  Nothing -> "return"
showInstruction (Label l) = showLabel l ++":\n"
showInstruction (Comment c) = "; " ++ c
showInstruction (Raw r) = r
showInstruction (Invoke c n a r) = 
  "invokestatic " ++ c ++ "/" ++ n ++ "(" ++ concat a ++ ")" ++ r
showInstruction (Null) = "aconst_null"


showLabel :: Label -> String
showLabel lbl = "L" ++ show lbl