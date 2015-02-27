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
  , signatures :: Signatures
  , contexts   :: Contexts
  , labels     :: Int
  , code       :: [JVM.Instruction]
  }

type Contexts = [VarContext]

-- | Variables in scope (symbol table)
data VarContext = VarContext
  { vars :: Map Id JVM.Address
  , next :: JVM.Address
  }

-- | Functions signatures
type Signatures = Map Id JVM.FunType


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
newBlock = do
  env@Env { contexts = c } <- get
  case c of
    [] -> modify $ updateContexts $ (emptyContext :)
    c -> do 
         let vc1@VarContext{ vars = v, next = n} = head c
         let vc2 = VarContext{ vars = Map.empty, next = n } 
         modify $ updateContexts $ (vc2 :)


exitBlock :: CodeGen ()
exitBlock = modify $ updateContexts $ tail

extendContext :: Id -> Type -> CodeGen ()
extendContext x _t = modify $ updateContexts $ \ (b : bs) ->
  b { vars = Map.insert x (next b) (vars b)
    , next = next b + 1 
    } : bs

extendSig :: Def -> CodeGen ()
extendSig (DFun t f@(Id name) args stms) = do
  let types = map (\ (ADecl t x) -> typeAlias t) args
  let t' = typeAlias t
  let sig = (JVM.FunType t' types)
  modify $ updateSignatures $ \ s -> Map.insert f sig s

lookupVar :: Id -> CodeGen JVM.Address
lookupVar x = do
  bs <- gets contexts
  case catMaybes $ map (Map.lookup x . vars) bs of
    []      -> error $ "unbound var " ++ printTree x
    (a : _) -> return a

lookupFun :: Id -> CodeGen (String, [String])
lookupFun fid = do
  sigs <- gets signatures
  case Map.lookup fid sigs of 
    Nothing -> error $ "undefined function " ++ printTree fid
    Just (JVM.FunType t at) -> return (t, at)

-- * Environment

emptyEnv :: Env
emptyEnv = Env
  { className  = ""
  , signatures = Map.empty
  , contexts   = []
  , labels     = 0
  , code       = []
  }

updateContexts :: (Contexts -> Contexts) -> Env -> Env
updateContexts f env = env { contexts = f (contexts env) }

updateSignatures :: (Signatures -> Signatures) -> Env -> Env
updateSignatures f env = env { signatures = f (signatures env) }

updateCode :: ([JVM.Instruction] -> [JVM.Instruction]) -> Env -> Env
updateCode f env = env { code = f (code env) }

updateLabels :: (Int -> Int) -> Env -> Env
updateLabels f env = env { labels = f (labels env) } 

updateClassName :: (String -> String) -> Env -> Env
updateClassName f env = env { className = f (className env) }

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
    jcode  = reverse $ code $ compileProgram filename prg `execState` emptyEnv
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

compileProgram :: FilePath -> Program -> CodeGen ()
compileProgram filename (PDefs defs) = do
  modify $ updateClassName $ \ s -> filename
  mapM_ extendSig defs
  mapM_ compileDef defs

compileDef :: Def -> CodeGen ()
compileDef (DFun t f@(Id name) args ss) = do

  let argTypes = concatMap (\ (ADecl t x) -> typeAlias t) args
  blank
  raw $ ".method public static " ++ name ++ "(" ++ argTypes ++ ")" ++ typeAlias t
  raw $ "  .limit locals 1000" -- TODO
  raw $ "  .limit stack 1000"  -- TODO

  newBlock

  mapM_ (\ (ADecl t x) -> extendContext x t) args

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

  raw $ ".end method"

compileDecl :: Type -> Id -> CodeGen ()
compileDecl t id = do
      extendContext id t
      a <- lookupVar id
      emit $ JVM.Null
      emit $ JVM.Store a JVM.Word

compileStm :: Stm -> CodeGen ()
compileStm s = do
  blank
  comment $ rmvNL $ printTree s
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

    SDecls t ids -> do
      mapM_ (\ x -> extendContext x t) ids

    SWhile e s -> do
      test <- makeLabel 
      end <- makeLabel
      emit $ JVM.Label test
      compileExp e
      emit $ JVM.If JVM.IFEQ end JVM.Word
      compileStm s
      emit $ JVM.Goto test
      emit $ JVM.Label end

    SBlock ss -> do
      newBlock
      mapM_ compileStm ss
      exitBlock

    SIfElse e e1 e2 -> do
      compileExp e
      true <- makeLabel
      false <- makeLabel
      emit $ JVM.If JVM.IFEQ false JVM.Word
      compileStm e1
      emit $ JVM.Goto true
      emit $ JVM.Label false
      compileStm e2
      emit $ JVM.Label true

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

  EApp (Id "readInt") args -> do
    mapM_ compileExp args
    emit $ JVM.Invoke "Runtime" "readInt" [""] "I"

  EApp (Id f) args -> do
    mapM_ compileExp args
    cls <- gets className
    (t, at) <- lookupFun (Id f) 
    emit $ JVM.Invoke cls f at t
 
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

  ELt e1 e2 -> do
    emit $ JVM.Push (JVM.VInt 1)
    compileExp e1
    compileExp e2
    true <- makeLabel
    emit $ JVM.If JVM.LTH true JVM.Word
    emit $ JVM.Pop JVM.Word
    emit $ JVM.Push (JVM.VInt 0)
    emit $ JVM.Label true

  EGt e1 e2 -> do
    emit $ JVM.Push (JVM.VInt 1)
    compileExp e1
    compileExp e2
    true <- makeLabel
    emit $ JVM.If JVM.GTH true JVM.Word
    emit $ JVM.Pop JVM.Word
    emit $ JVM.Push (JVM.VInt 0)
    emit $ JVM.Label true

  ELtEq e1 e2 -> do
    emit $ JVM.Push (JVM.VInt 1)
    compileExp e1
    compileExp e2
    true <- makeLabel
    emit $ JVM.If JVM.LE true JVM.Word
    emit $ JVM.Pop JVM.Word
    emit $ JVM.Push (JVM.VInt 0)
    emit $ JVM.Label true

  EGtEq e1 e2 -> do
    emit $ JVM.Push (JVM.VInt 1)
    compileExp e1
    compileExp e2
    true <- makeLabel
    emit $ JVM.If JVM.GE true JVM.Word
    emit $ JVM.Pop JVM.Word
    emit $ JVM.Push (JVM.VInt 0)
    emit $ JVM.Label true

  EEq e1 e2 -> do
    emit $ JVM.Push (JVM.VInt 1)
    compileExp e1
    compileExp e2
    true <- makeLabel
    emit $ JVM.If JVM.EQU true JVM.Word
    emit $ JVM.Pop JVM.Word
    emit $ JVM.Push (JVM.VInt 0)
    emit $ JVM.Label true

  ENEq e1 e2 -> do
    emit $ JVM.Push (JVM.VInt 1)
    compileExp e1
    compileExp e2
    true <- makeLabel
    emit $ JVM.If JVM.NE true JVM.Word
    emit $ JVM.Pop JVM.Word
    emit $ JVM.Push (JVM.VInt 0)
    emit $ JVM.Label true

  EAnd e1 e2     -> do
    lazyfalse <- makeLabel
    compileExp e1
    emit $ JVM.Dup JVM.Word
    emit $ JVM.If JVM.IFEQ lazyfalse JVM.Word
    compileExp e2
    emit $ JVM.And JVM.Word
    emit $ JVM.Label lazyfalse

  EOr e1 e2     ->  do
    lazytrue <- makeLabel
    compileExp e1
    emit $ JVM.Dup JVM.Word
    emit $ JVM.Push (JVM.VInt 0)
    emit $ JVM.If JVM.NE lazytrue JVM.Word
    compileExp e2
    emit $ JVM.Or JVM.Word
    emit $ JVM.Label lazytrue  

  EAss e@(EId x) e2     ->  do
    compileExp e2
    emit $ JVM.Dup JVM.Word
    a <- lookupVar x
    emit $ JVM.Store a JVM.Word

-- | Get the Jasmin type alias for a type
typeAlias :: Type -> String
typeAlias t = case t of
  Type_int    -> "I"
  Type_double -> "D"
  Type_bool   -> "I"
  Type_void   -> "V"

rmvNL :: String -> String
rmvNL ['\n'] = ['\n']
rmvNL ('\n':cs) = '\n': ';': ' ' : rmvNL cs
rmvNL (c:cs) = c : rmvNL cs  

makeLabel :: CodeGen Int
makeLabel = do
  lbls <- gets labels
  modify $ updateLabels $ \ l -> l + 1
  return lbls