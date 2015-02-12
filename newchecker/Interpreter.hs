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

exec :: Env -> Stm -> IO Env
exec env s = case s of
  SInit t x e -> do
    (v, env') <- eval env e
    return $ extendCxt env' x v
  SExp e -> do
    (v, env') <- eval env e
    return env'
  _ -> do
    putStrLn $ "NYI: exec " ++ printTree s
    return env

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
                          return ((v1 + v2), env'')
  EMinus e1 e2      -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return (v1 - v2, env'')
  ETimes e1 e2      -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return (v1 * v2, env'')
  EDiv e1 e2        -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return (v1 `div` v2, env'')
  ELt e1 e2         -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return ((compLt v1 v2), env'')
  EGt e1 e2         -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return (v1 > v2, env'')
  ELtEq e1 e2       -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return (v1 <= v2, env'')
  EGtEq e1 e2       -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return (v1 >= v2, env'')
  EEq e1 e2         -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return (v1 == v2, env'')
  ENEq e1 e2        -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return (v1 /= v2, env'')
  EAnd e1 e2        -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return (v1 && v2, env'')
  EOr e1 e2         -> do (v1,env') <- eval env e1
                          (v2,env'') <- eval env' e2
                          return (v1 || v2, env'')
  EAss e1@(EId x) e2 -> do (v1,env') <- eval env e1
                           (v2,env'') <- eval env' e2
                           let env''' = setVar env'' x v2
                           return (v2, env''')
  _ -> do
    putStrLn $ "NYI: eval " ++ printTree e
    return (VVoid, env)


invoke :: Env -> Id -> [Val] -> IO Val
invoke env f vs = case f of
  Id "printInt" -> do
    mapM_ (putStrLn . prettyVal) vs
    return VVoid
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


lookupDef :: Env -> Id -> Def
lookupDef env f = Map.findWithDefault err f (envSig env)
  where err = error $ "undefined function " ++ printTree f

lookupVar :: Env -> Id -> Val
lookupVar env x = case catMaybes $ map (Map.lookup x) (envCxt env) of
  []      -> error $ "unbound variable " ++ printTree x
  (v : _) -> v

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

newBlock :: Env -> Env
newBlock env = env { envCxt = Map.empty : (envCxt env) }

exitBlock :: Env -> Env
exitBlock env@Env { envCxt = b : bs } = env { envCxt = bs }

emptyEnv :: Env
emptyEnv = Env { envSig = Map.empty, envCxt = [Map.empty] }

prettyVal :: Val -> String
prettyVal v = case v of
  VInt i      -> show i
  VDouble d   -> show d
  VBool True  -> "true"
  VBool False -> "false"
  VVoid       -> "void"
  VUndefined  -> "undefined"

incr :: Val -> Val
incr v = case v of
  VInt i -> VInt $ i + 1
  VDouble d -> VDouble $ d + 1
  v -> error $ "cannot increment value " ++ prettyVal v

decr :: Val -> Val
decr v = case v of
  VInt i -> VInt $ i - 1
  VDouble d -> VDouble $ d - 1
  v -> error $ "cannot increment value " ++ prettyVal v

compLt :: Val -> Val -> Val
compLt a b = case a of
  VInt a -> case b of
    VInt b ->
      if a < b
        then return a
      else return b
          

boolToV :: Bool -> Val
boolToV b = return VBool b