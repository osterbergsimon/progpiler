module TypeChecker where

import CPP.Abs
import CPP.Print
import CPP.ErrM

import Control.Monad
import Control.Monad.State

import Data.Functor
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Maybe

-- | Environment
data Env = Env
  { envSig :: Sig
  , envCxt :: Cxt
  }

-- | Function signature
type Sig = Map Id FunType

-- | Context of local variables
type Cxt = [Block]

type Block = Map Id Type

-- | Function type
data FunType = FunType Type [Type]

typecheck :: Program -> Err ()
typecheck (PDefs defs) = do
  let env0 = Env
       { envSig = Map.fromList [(Id "printInt", FunType Type_void [Type_int])]
       , envCxt = []
       }
  env <- foldM extendSig env0 defs
  mapM_ (checkDef env) defs

checkDef :: Env -> Def -> Err ()
checkDef env (DFun t f args ss) = do
  let env' = foldl (\ env (ADecl t x) -> extendCxt env x t) (newBlock env) args
  checkStms env' ss

checkStms :: Env -> [Stm] -> Err ()
checkStms env ss = evalStateT (mapM_ checkStm ss) env

checkStm :: Stm -> StateT Env Err ()
checkStm s = case s of
  SInit t x e -> do
    env <- get
    checkExp e t
    put $ extendCxt env x t
  SExp    e -> void $ inferExp e
  SReturn e -> void $ inferExp e -- TODO check whether return type is correct
  _ -> fail $ "NYI: checkStm " ++ printTree s

checkExp :: Exp -> Type -> StateT Env Err ()
checkExp e t = do
  t' <- inferExp e
  unless (t == t') $ fail $
    "expected type " ++ printTree t ++
    " but found type " ++ printTree t' ++
    " when checking expression " ++ printTree e

inferExp :: Exp -> StateT Env Err Type
inferExp e = case e of
  EInt i    -> return Type_int
  EId x     -> lookupVar x

  EApp f es -> do
    FunType t ts <- lookupDef f
    unless (length es == length ts) $ fail $
      "incorrect number of arguments to function " ++ printTree f
    t <$ zipWithM_ checkExp es ts

  EPostIncr e@(EId x) -> do
    t <- inferExp e
    unless (t `elem` [Type_int, Type_double]) $ fail $
      "expected numberic type, but found " ++ printTree t ++
      " when checking " ++ printTree e
    return t

  _ -> fail $ "NYI: inferExp " ++ printTree e


lookupDef :: Id -> StateT Env Err FunType
lookupDef f = do
  env <- get
  case Map.lookup f (envSig env) of
    Nothing -> fail $ "undefined function " ++ printTree f
    Just t  -> return t

lookupVar :: Id -> StateT Env Err Type
lookupVar x = do
  env <- get
  case catMaybes $ map (Map.lookup x) (envCxt env) of
    []      -> fail $ "unbound variable " ++ printTree x
    (t : _) -> return t

extendSig :: Env -> Def -> Err Env
extendSig env@Env{ envSig = sig } (DFun t f args _ss) = do
  if Map.member f sig then fail $ "duplicate definition of function " ++ printTree f else return $ env { envSig = Map.insert f ft (envSig env) }
  where ft = FunType t $ map (\ (ADecl t _x) -> t) args

-- | Add new variable with type.
extendCxt :: Env -> Id -> Type -> Env
extendCxt env@Env{ envCxt = b : bs } x t = env { envCxt = Map.insert x t b : bs }

newBlock :: Env -> Env
newBlock env = env { envCxt = Map.empty : envCxt env }

exitBlock :: Env -> Env
exitBlock env@Env { envCxt = b : bs } = env { envCxt = bs }

emptyEnv :: Env
emptyEnv = Env { envSig = Map.empty, envCxt = [Map.empty] }
