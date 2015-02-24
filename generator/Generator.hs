-- Simon Österberg (890826-4818) & Denise Glansholm (921019-3141)
-- NOTE: Fails test core101.cc which is OK according to Andreas Abel in the mailing list


module TypeChecker where

import CPP.Abs
import CPP.Print
import CPP.ErrM

import Control.Monad

import Data.Functor
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Maybe

-- | Environment
data Env = Env {
vars :: [Map Ident Int],
maxvar :: Int,
code :: [Instruction]
}




--  data Env = Env
--  { envSig :: Sig
--  , envCxt :: Cxt
--  }

---- | Function signature
--type Sig = Map Id FunType

---- | Context of local variables
--type Cxt = [Block]

--type Block = Map Id Type

---- | Function type
--data FunType = FunType Type [Type]



--Accepting built in IO functions
compile :: Program -> Err ()
typecheck (PDefs defs) = do
  let env0 = Env
       { envSig = Map.fromList [(Id "printInt", FunType Type_void [Type_int]),
                                (Id "printDouble", FunType Type_void [Type_double]),
                                (Id "readInt", FunType Type_int []),
                                (Id "readDouble", FunType Type_double [])]
       , envCxt = []
       }
  env <- foldM extendSig env0 defs
  mapM_ (checkDef env) defs


-- Compile a single statement and update environment
compileStm :: Stm -> CodeGen ()
checkStm env t s = case s of
  SInit t x e -> do
    extendContext x t
    a <- lookupVar x
    compileExp e
    emit $ JVM.Store a JVM.Word
  SExp e -> do
    compileExp e
    emit $ JVM.Pop JVM.Word
  SDecls t ids-> do
    
  SBlock stms     -> do                 
  SReturn e       ->  do 
  SWhile e stm    -> do 
  SIfElse e s1 s2 -> do 




-- Compile a single expression
compileExp :: Exp -> State Exp ()
compileExp env e = case e of
  EInt i    -> do
    emit $ JVM.Push $ JVM.Int i
  ETrue         -> 
  EFalse        -> 
  EDouble _      -> 
  EId x     -> do
    a <- lookupVar x
    emit $ JVM.Load a JVM.Word
  EApp f es -> do
    FunType t ts <- 
  EPostIncr e@(EId x)     -> do
    a <- lookupVar x
    compileExp e
    emit $ JVM.Dup JVM.Word
    emit $ JVM.Push $ JVM.VInt 1
    emit $ JVM.Add JVM.Word
    emit $ JVM.Store a JVM.Word
  EPostDecr e@(EId x)     -> do
    a <- lookupVar x
    compileExp e
    emit $ JVM.Dup JVM.Word
    emit $ JVM.Push $ JVM.VInt 1
    emit $ JVM.Sub JVM.Word
    emit $ JVM.Store a JVM.Word
  EPreIncr e@(EId x)       -> do
    a <- lookupVar x
    compileExp e
    emit $ JVM.Push $ JVM.VInt 1
    emit $ JVM.Add JVM.Word
    emit $ JVM.Dup JVM.Word
    emit $ JVM.Store a JVM.Word
  EPreDecr e@(EId x)      -> do
    a <- lookupVar x
    compileExp e
    emit $ JVM.Push $ JVM.VInt 1
    emit $ JVM.Sub JVM.Word
    emit $ JVM.Dup JVM.Word
    emit $ JVM.Store a JVM.Word 
  EPlus e1 e2     -> do
    compileExp e1
    compileExp e2
    emit $ JVM.Add JVM.Word
  EMinus e1 e2     ->  do
    compileExp e1
    compileExp e2
    emit $ JVM.Sub JVM.Word
  ETimes e1 e2     ->  do
    compileExp e1
    compileExp e2
    emit $ JVM.Mul JVM.Word
  EDiv e1 e2     ->  do
    compileExp e1
    compileExp e2
    emit $ JVM.Div JVM.Word
  ELt e1 e2     -> do
    compileExp e1
    compileExp e2
    emit $ JVM.Sub JVM.Word
    emit $ JVM.LTH JVM.Word
  EGt e1 e2 -> do
    compileExp e1
    compileExp e2
    emit $ JVM.Sub JVM.Word
    emit $ JVM.GTH JVM.Word
  ELtEq e1 e2 -> do
    compileExp e1
    compileExp e2
    emit $ JVM.Sub JVM.Word
    emit $ JVM.LE JVM.Word
  EGtEq e1 e2 -> do
    compileExp e1
    compileExp e2
    emit $ JVM.Sub JVM.Word
    emit $ JVM.GE JVM.Word
  EEq e1 e2 -> do
    compileExp e1
    compileExp e2
    emit $ JVM.Sub JVM.Word
    emit $ JVM.EQU JVM.Word
  ENEq e1 e2 -> do
    compileExp e1
    compileExp e2 
    emit $ JVM.Sub JVM.Word
    emit $ JVM.NE JVM.Word
  EAnd e1 e2     -> do
    compileExp e1
    compileExp e2
    emit $ JVM.And JVM.Word 
  EOr e1 e2     ->  do
    compileExp e1
    compileExp e2
    emit $ JVM.Or JVM.Word  
  EAss e@(EId x) e2     ->  do
    compileExp e
    compileExp e2
    a <- lookupVar x
    emit $ JVM.Store a JVM.Word    

 
 

-- Check if function is in scope
lookupDef :: Env -> Id -> Err FunType
lookupDef env f = case Map.lookup f (envSig env) of
  Nothing -> fail $ "undefined function " ++ printTree f
  Just t  -> return t

-- Check if variable is in scope
lookupVar :: Env -> Id -> Err Type
lookupVar env x = case catMaybes $ map (Map.lookup x) (envCxt env) of
  []      -> fail $ "unbound variable " ++ printTree x
  (t : _) -> return t

-- Add function signature to scope
extendSig :: Env -> Def -> Err Env
extendSig env@Env{ envSig = sig } (DFun t f args _ss) = do
  if Map.member f sig then fail $ "duplicate definition of function " ++ printTree f 
    else return env { envSig = Map.insert f ft (envSig env) }
  where ft = FunType t $ map (\ (ADecl t _x) -> t) args

-- | Add new variable with type.
extendCxt :: Env -> Id -> Type -> Err Env
extendCxt env@Env{ envCxt = b : bs } x t = do
  if Map.member x b then fail $ "variable " ++ printTree x ++ " is already declared" 
  else return env { envCxt = Map.insert x t b : bs }

-- Create a new block in the environment
newBlock :: Env -> Env
newBlock env = env { envCxt = Map.empty : envCxt env }

-- Exit the block, forgetting changes
exitBlock :: Env -> Env
exitBlock env@Env { envCxt = b : bs } = env { envCxt = bs }

-- Creates a new, empty environment
emptyEnv :: Env
emptyEnv = Env { envSig = Map.empty, envCxt = [Map.empty] }


emit :: Instruction -> State Env ()
emit i c = modify (\s -> s{code = i : code s})


{-
    Exp annotExp (Env env, Exp exp) =
      typ := inferExp env exp
      return typed<typ>(exp)

Then we can generate code as follows:

    // addition  
    compile typed<typ>(exp1 + exp2) =
      compile exp1
      compile exp2
      if typ == int
        emit iadd
      else
        emit dadd
-}