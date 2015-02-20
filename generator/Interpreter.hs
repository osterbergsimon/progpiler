module Interpreter where

import CPP.Abs
import CPP.Print
import CPP.ErrM

import Control.Monad

import Data.Map (Map)
import qualified Data.Map as Map
import Data.Maybe

-- | Values
data Val
  = VInt Integer
  | VDouble Double
  | VBool Bool
  | VVoid
  | VUndefined

-- | Environment
data Env = Env
  { envSig :: Sig
  , envCxt :: Cxt
  }

-- | Function signature
type Sig = Map Id Def

-- | Context of local variables
type Cxt = [Block]

type Block = Map Id Val


interpret :: Program -> IO ()
interpret (PDefs defs) = do
  -- Build initial environment with all function definitions.
  let env = foldl extendSig emptyEnv defs
  let DFun _t _f _args ss = lookupDef env (Id "main")
  foldM_ exec env ss

-- Execute statements
exec :: Env -> Stm -> IO Env
exec env s = case s of
  SInit t x e -> do
    (v, env') <- eval env e
    return $ extendCxt env' x v
  SExp e -> do
    (v, env') <- eval env e
    return env'
  SDecls t ids -> do
    let env' = foldl (\ env x -> extendCxt env x VUndefined) env ids
    return $ env'
  SReturn e -> do
    (v,env') <- eval env e
    return $ (exitBlock env')
 
  SWhile e stm -> do
    (v',env') <- eval env e
    case v' of
      VBool True -> do 
        env'' <- exec env' stm
        exec env'' (SWhile e stm)
      VBool False -> return env
      _ -> error $ printTree e ++ "not a value of type bool" 
 
  SBlock stms -> do let env' = newBlock env
                    env'' <- foldM exec env' stms
                    return $ exitBlock env''
  SIfElse e s1 s2 -> do
    (v,env') <- eval env e
    case v of
      VBool True -> do env'' <- exec env' s1
                       return env''
      VBool False -> do env'' <- exec env' s2
                        return env''


  _ -> do
    putStrLn $ "NYI: exec " ++ printTree s
    return env

--Evaluate expressions
eval :: Env -> Exp -> IO (Val, Env)
eval env e = case e of
  EInt i -> return (VInt i, env)
  ETrue         -> return (VBool True, env)
  EFalse        -> return (VBool False, env)
  EDouble d      -> return (VDouble d, env)
  EId x  -> return (lookupVar env x, env)
  EApp f es -> do
    (vs, env') <- loop env es
    v <- invoke env' f vs
    return (v, env')
    where
      loop env [] = return ([], env)
      loop env (e : es) = do
        (v , env' ) <- eval env e
        (vs, env'') <- loop env' es
        return (v : vs, env'')
  EPostIncr e@(EId x) -> do
    (v, env') <- eval env e
    let env'' = setVar env' x (incr v)
    return (v, env'')

  EPostDecr e@(EId x) -> do
    (v, env') <- eval env e
    let env'' = setVar env' x (decr v)
    return (v, env'')

  EPreIncr e@(EId x)  -> do
    (v, env') <- eval env e
    let v' = incr v
    let env'' = setVar env' x v'
    return (v', env'')
  
  EPreDecr e@(EId x)  -> do
    (v, env') <- eval env e
    let v' = decr v
    let env'' = setVar env' x v'
    return (v', env'')

  EPlus e1 e2       -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return ((v1 `add` v2), env'')
  EMinus e1 e2      -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return (v1 `sub` v2, env'')
  ETimes e1 e2      -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return (v1 `mul` v2, env'')
  EDiv e1 e2        -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return (v1 `divi` v2, env'')
  ELt e1 e2         -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return ( v1 `lt` v2, env'')
  EGt e1 e2         -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return (v1 `gt` v2, env'')
  ELtEq e1 e2       -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return (v1 `lteq` v2, env'')
  EGtEq e1 e2       -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return (v1 `gteq` v2, env'')
  EEq e1 e2         -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return (v1 `eq` v2, env'')
  ENEq e1 e2        -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return (v1 `neq` v2, env'')
  EAnd e1 e2        -> do (v1,env') <- eval env e1
                          case v1 of
                            (VBool False) -> return $ (VBool False, env')
                            (VBool True) -> do
                              (v2,env'') <- eval env' e2
                              return (v1 `andV` v2, env'')
  EOr e1 e2         -> do (v1,env') <- eval env e1
                          case v1 of
                            (VBool True) -> return $ (VBool True, env')
                            (VBool False) -> do
                              (v2,env'') <- eval env' e2
                              return (v1 `orV` v2, env'')
  EAss e1@(EId x) e2 -> do (v1,env') <- eval env e1
                           (v2,env'') <- eval env' e2
                           let env''' = setVar env'' x v2
                           return (v2, env''')
  _ -> do
    putStrLn $ "NYI: eval " ++ printTree e
    return (VVoid, env)


--Invoke functions
invoke :: Env -> Id -> [Val] -> IO Val
invoke env f vs = case f of
  Id "printInt" -> do
    mapM_ (putStrLn . prettyVal) vs
    return VVoid
  Id "printDouble" -> do
    mapM_ (putStrLn . prettyVal) vs
    return VVoid  
  Id "readInt" -> do
    s <- getLine
    let i = read s :: Integer
    return $ VInt i
  Id "readDouble" -> do
    s <- getLine
    let d = read s :: Double
    return $ VDouble d
  _ -> do
    let DFun _t _f args ss = lookupDef env f
    let xvs = zip (map (\ (ADecl _t x) -> x) args) vs
    let env' = foldl (\ env (x,v)  -> extendCxt env x v) (newBlock env) xvs
    let ss' = init ss
    let s   = last ss
    env'' <- foldM exec env' ss'
    case s of
      SReturn e -> do
        (v, _) <- eval env'' e
        return v
      s         -> do
        exec env'' s
        return VVoid


-- Check if function is in scope
lookupDef :: Env -> Id -> Def
lookupDef env f = Map.findWithDefault err f (envSig env)
  where err = error $ "undefined function " ++ printTree f

-- Check if variable is in scope
lookupVar :: Env -> Id -> Val
lookupVar env x = case catMaybes $ map (Map.lookup x) (envCxt env) of
  []      -> error $ "unbound variable " ++ printTree x
  (v : _) -> v

-- Add function signature to scope
extendSig :: Env -> Def -> Env
extendSig env def@(DFun _t f _args _ss) = env { envSig = Map.insert f def (envSig env) }

-- | Add new variable with initial value.
extendCxt :: Env -> Id -> Val -> Env
extendCxt env@Env{ envCxt = b : bs } x v = env { envCxt = Map.insert x v b : bs }

-- | Change value of an existing variable.
setVar :: Env -> Id -> Val -> Env
setVar env@Env{ envCxt = bs } x v = env { envCxt = loop bs } where
  loop []       = error $ "unbound variable " ++ printTree x
  loop (b : bs) = case Map.lookup x b of
    Nothing -> b : loop bs
    Just{}  -> Map.insert x v b : bs

-- Create a new block in the environment
newBlock :: Env -> Env
newBlock env = env { envCxt = Map.empty : (envCxt env) }


-- Exit the block, forgetting changes
exitBlock :: Env -> Env
exitBlock env@Env { envCxt = b : bs } = env { envCxt = bs }

-- Creates a new, empty environment
emptyEnv :: Env
emptyEnv = Env { envSig = Map.empty, envCxt = [Map.empty] }


-- Creates a "pretty" string of values 
prettyVal :: Val -> String
prettyVal v = case v of
  VInt i      -> show i
  VDouble d   -> show d
  VBool True  -> "true"
  VBool False -> "false"
  VVoid       -> "void"
  VUndefined  -> "undefined"

-- Handles i++ and ++i
incr :: Val -> Val
incr v = case v of
  VInt i -> VInt $ i + 1
  VDouble d -> VDouble $ d + 1
  v -> error $ "cannot increment value " ++ prettyVal v

-- Handles i-- and --i
decr :: Val -> Val
decr v = case v of
  VInt i -> VInt $ i - 1
  VDouble d -> VDouble $ d - 1
  v -> error $ "cannot increment value " ++ prettyVal v

-- Handles addition
add :: Val -> Val -> Val
add (VInt v1) (VInt v2) = VInt $ (v1+v2)
add (VDouble v1) (VDouble v2) = VDouble $ (v1+v2)
add a b = error $ "mismatch in types between" ++ prettyVal a ++ "and" ++ prettyVal b

-- Handles subtraction
sub :: Val -> Val -> Val
sub (VInt v1) (VInt v2) = VInt $ (v1-v2)
sub (VDouble v1) (VDouble v2) = VDouble $ (v1-v2)
sub a b = error $ "mismatch in types between" ++ prettyVal a ++ "and" ++ prettyVal b

-- Handles division
divi :: Val -> Val -> Val
divi (VInt v1) (VInt v2) = VInt $ (v1 `div` v2)
divi (VDouble v1) (VDouble v2) = VDouble $ (v1/v2)
divi a b = error $ "mismatch in types between" ++ prettyVal a ++ "and" ++ prettyVal b

-- Handles multiplication
mul :: Val -> Val -> Val
mul (VInt v1) (VInt v2) = VInt $ (v1*v2)
mul (VDouble v1) (VDouble v2) = VDouble $ (v1*v2)
mul a b = error $ "mismatch in types between" ++ prettyVal a ++ "and" ++ prettyVal b

-- Handles comparison: greater than
gt :: Val -> Val -> Val
gt (VInt v1) (VInt v2) = VBool $ (v1>v2)
gt (VDouble v1) (VDouble v2) = VBool $ (v1>v2)
gt (VBool v1) (VBool v2) = VBool $ (v1>v2)
gt a b = error $ "mismatch in types between" ++ prettyVal a ++ "and" ++ prettyVal b

-- Handles comparison: lesser than
lt :: Val -> Val -> Val
lt (VInt v1) (VInt v2) = VBool $ (v1<v2)
lt (VDouble v1) (VDouble v2) = VBool $ (v1<v2)
lt (VBool v1) (VBool v2) = VBool $ (v1<v2)
lt a b = error $ "mismatch in types between" ++ prettyVal a ++ "and" ++ prettyVal b

-- Handles comparison: greater or equal
gteq :: Val -> Val -> Val
gteq (VInt v1) (VInt v2) = VBool $ (v1>=v2)
gteq (VDouble v1) (VDouble v2) = VBool $ (v1>=v2)
gteq (VBool v1) (VBool v2) = VBool $ (v1>=v2)
gteq a b = error $ "mismatch in types between" ++ prettyVal a ++ "and" ++ prettyVal b

-- Handles comparison: lesser or equal
lteq :: Val -> Val -> Val
lteq (VInt v1) (VInt v2) = VBool $ (v1<=v2)
lteq (VDouble v1) (VDouble v2) = VBool $ (v1<=v2)
lteq (VBool v1) (VBool v2) = VBool $ (v1<=v2)
lteq a b = error $ "mismatch in types between" ++ prettyVal a ++ "and" ++ prettyVal b

-- Handles comparison: equality
eq :: Val -> Val -> Val
eq (VInt v1) (VInt v2) = VBool $ (v1==v2)
eq (VDouble v1) (VDouble v2) = VBool $ (v1==v2)
eq (VBool v1) (VBool v2) = VBool $ (v1==v2)
eq a b = error $ "mismatch in types between" ++ prettyVal a ++ "and" ++ prettyVal b

-- Handles comparison: not equal
neq :: Val -> Val -> Val
neq (VInt v1) (VInt v2) = VBool $ (v1/=v2)
neq (VDouble v1) (VDouble v2) = VBool $ (v1/=v2)
neq (VBool v1) (VBool v2) = VBool $ (v1/=v2)
neq a b = error $ "mismatch in types between" ++ prettyVal a ++ "and" ++ prettyVal b

-- Handles comparison: &&
andV :: Val -> Val -> Val
andV (VBool False) _ = VBool False
andV (VBool v1) (VBool v2) = VBool $ (v1 && v2)
andV a b = error $ "mismatch in types between" ++ prettyVal a ++ "and" ++ prettyVal b

-- Handles comparison: ||
orV :: Val -> Val -> Val
orV (VBool True) _ = VBool True
orV (VBool v1) (VBool v2) = VBool $ (v1 || v2)
orV a b = error $ "mismatch in types between" ++ prettyVal a ++ "and" ++ prettyVal b

