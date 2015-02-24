module CodeGen where

import Control.Monad.State

import Data.Map (Map)
import qualified Data.Map as Map
import Data.Maybe

import CPP.Abs
import CPP.Lex
import CPP.Par
import CPP.Print

import qualified JVM

-- * Data types and monad

-- | Environment (handled by state monad)
data Env = Env
  { className  :: String
  , contexts   :: Contexts
  , code       :: [JVM.Instruction]
  }

type Contexts = [VarContext]

-- | Variables in scope (symbol table)
data VarContext = VarContext
  { vars :: Map Id JVM.Address
  , next :: JVM.Address
  }

type CodeGen = State Env

-- * Service functions

emit :: JVM.Instruction -> CodeGen ()
emit i = modify $ updateCode $ (i :)


comment :: String -> CodeGen ()
comment = emit . JVM.Comment

raw :: String -> CodeGen ()
raw = emit . JVM.Raw

blank :: CodeGen ()
blank = raw ""

newBlock :: CodeGen ()
newBlock = modify $ updateContexts $ (emptyContext :)

exitBlock :: CodeGen ()
exitBlock = modify $ updateContexts $ tail

extendContext :: Id -> Type -> CodeGen ()
extendContext x _t = modify $ updateContexts $ \ (b : bs) ->
  b { vars = Map.insert x (next b) (vars b)
    , next = next b + 1  -- TODO double
    } : bs

lookupVar :: Id -> CodeGen JVM.Address
lookupVar x = do
  bs <- gets contexts
  case catMaybes $ map (Map.lookup x . vars) bs of
    []      -> error $ "unbound var " ++ printTree x
    (a : _) -> return a


-- * Environment

emptyEnv :: Env
emptyEnv = Env
  { className  = ""
  , contexts   = []
  , code       = []
  }

updateContexts :: (Contexts -> Contexts) -> Env -> Env
updateContexts f env = env { contexts = f (contexts env) }

updateCode :: ([JVM.Instruction] -> [JVM.Instruction]) -> Env -> Env
updateCode f env = env { code = f (code env) }

-- * Contexts

emptyContext :: VarContext
emptyContext = VarContext
  { vars = Map.empty
  , next = 0
  }

-- * Code generator

codeGen :: FilePath -> Program -> String
codeGen filename prg = header ++ unlines (map JVM.showInstruction jcode)
  where
    jcode  = reverse $ code $ compileProgram prg `execState` emptyEnv
    header = unlines
      [ ".class public " ++ filename
      , ".super java/lang/Object"
      , ""
      , ".method public <init>()V"
      , "  aload_0"
      , "  invokespecial java/lang/Object/<init>()V"
      , "  return"
      , ".end method"
      , ""
      , ".method public static main([Ljava/lang/String;)V"
      , ".limit locals 1"
      , "  invokestatic "++filename++"/main()I"
      , "  pop"
      , "  return"
      , ".end method"
      ]

compileProgram :: Program -> CodeGen ()
compileProgram (PDefs defs) = mapM_ compileDef defs

compileDef :: Def -> CodeGen ()
compileDef (DFun t f@(Id name) args ss) = do

  let argTypes = concatMap (\ (ADecl t x) -> typeAlias t) args
  blank
  raw $ ".method public static " ++ name ++ "(" ++ argTypes ++ ")" ++ typeAlias t
  raw $ "  .limit locals 1000" -- TODO
  raw $ "  .limit stack 1000"  -- TODO

  newBlock

  mapM_ compileStm ss

  exitBlock

  -- Emit final return statement
  blank
  comment $ "Epilogue"
  case t of
    Type_void -> emit $ JVM.Return Nothing
    _         -> do
      emit $ JVM.Push   $ JVM.VInt 0
      emit $ JVM.Return $ Just JVM.Word
      -- TODO double

  raw $ ".end method"

compileStm :: Stm -> CodeGen ()
compileStm s = do
  blank
  comment $ printTree s
  case s of
    SInit t x e -> do
      extendContext x t
      a <- lookupVar x
      compileExp e
      emit $ JVM.Store a JVM.Word

    SExp e -> do
      compileExp e
      emit $ JVM.Pop JVM.Word

    SReturn e -> do
      compileExp e
      emit $ JVM.Return $ Just JVM.Word

    --SDecls t ids-> do

    
    --SBlock stms     -> do                 
    --SWhile e stm    -> do 
    --SIfElse e s1 s2 -> do 

    _ -> comment "TODO"

compileExp :: Exp -> CodeGen ()
compileExp e = case e of

  EInt i -> do
    emit $ JVM.Push $ JVM.VInt i

  EId x -> do
    a <- lookupVar x
    emit $ JVM.Load a JVM.Word

  EApp (Id "printInt") args -> do
    mapM_ compileExp args
    emit $ JVM.Invoke "Runtime" "printInt" ["I"] "V"
    emit $ JVM.Push $ JVM.VInt 0
  EApp (Id id) args -> do
    mapM_ compileExp args
    emit $ JVM.Invoke "" id args "" 
 
  ETrue         -> emit $ JVM.Push $ JVM.VInt 1
  EFalse        -> emit $ JVM.Push $ JVM.VInt 0
  
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
 {- ELt e1 e2     -> do
    compileExp e1
    compileExp e2
    emit $ JVM.Sub JVM.Word
    
  EGt e1 e2 -> do
    compileExp e1
    compileExp e2
    emit $ JVM.Sub JVM.Word
    
  ELtEq e1 e2 -> do
    compileExp e1
    compileExp e2
    emit $ JVM.Sub JVM.Word
    
  EGtEq e1 e2 -> do
    compileExp e1
    compileExp e2
    emit $ JVM.Sub JVM.Word
    
  EEq e1 e2 -> do
    compileExp e1
    compileExp e2
    emit $ JVM.Sub JVM.Word
    
  ENEq e1 e2 -> do
    compileExp e1
    compileExp e2 
    emit $ JVM.Sub JVM.Word -}
    
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

  _ -> comment "TODO"

-- | Get the Jasmin type alias for a type
typeAlias :: Type -> String
typeAlias t = case t of
  Type_int    -> "I"
  Type_double -> "D"
  Type_bool   -> "I"
  Type_void   -> "V"
