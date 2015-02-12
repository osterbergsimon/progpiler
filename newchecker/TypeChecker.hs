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
checkStms env ss = foldM_ checkStm env ss

checkStm :: Env -> Stm -> Err Env
checkStm env s = case s of
  SInit t x e -> do
    checkExp env e t
    return $ extendCxt env x t
  SExp e -> env <$ inferExp env e
  SDecls t (x:[])       ->  return $ extendCxt env x t
  SDecls t (id:ids)-> do checkStm env (SDecls t ids)
                         return $ extendCxt env id t
  SBlock stms     -> do checkStms (newBlock env) stms
                        return env                     
  SReturn e       -> env <$ inferExp env e
  SWhile e stm    -> do checkExp env e Type_bool 
                        checkStm env stm
  SIfElse e s1 s2 -> do checkExp env e Type_bool
                        checkStm env s1
                        checkStm env s2
  _ -> fail $ "NYI: checkStm " ++ printTree s


checkExp :: Env -> Exp -> Type -> Err ()
checkExp env e t = do
  t' <- inferExp env e
  unless (t == t') $ fail $
    "expected type " ++ printTree t ++
    " but found type " ++ printTree t' ++
    " when checking expression " ++ printTree e

inferExp :: Env -> Exp -> Err Type
inferExp env e = case e of
  EInt i    -> return Type_int
  EId x     -> lookupVar env x
  EApp f es -> do
    FunType t ts <- lookupDef env f
    unless (length es == length ts) $ fail $
      "incorrect number of arguments to function " ++ printTree f
    t <$ zipWithM_ (checkExp env) es ts
  
  ETrue         -> return Type_bool
  EFalse        -> return Type_bool
  EDouble _      -> return Type_double
  EPostIncr e      -> inferUn [Type_double, Type_int] env e
  EPostDecr e      -> inferUn [Type_double, Type_int] env e
  EPreIncr e       -> inferUn [Type_double, Type_int] env e
  EPreDecr e       -> inferUn [Type_double, Type_int] env e
  EPlus e1 e2     -> 
        inferBin [Type_int, Type_double] env e1 e2
  EMinus e1 e2     -> 
        inferBin [Type_int, Type_double] env e1 e2
  ETimes e1 e2     -> 
        inferBin [Type_int, Type_double] env e1 e2
  EDiv e1 e2     -> 
        inferBin [Type_int, Type_double] env e1 e2
  ELt e1 e2     -> 
        inferBin [Type_int, Type_double] env e1 e2
  EGt e1 e2     -> 
        inferBin [Type_int, Type_double] env e1 e2
  ELtEq e1 e2     -> 
        inferBin [Type_int, Type_double] env e1 e2
  EGtEq e1 e2     -> 
        inferBin [Type_int, Type_double] env e1 e2
  EEq e1 e2     -> 
        inferBin [Type_int, Type_double] env e1 e2
  ENEq e1 e2     -> 
        inferBin [Type_int, Type_double] env e1 e2
  EAnd e1 e2     -> 
        inferBin [Type_bool] env e1 e2
  EOr e1 e2     -> 
        inferBin [Type_bool] env e1 e2
  EAss e1 e2     -> 
        inferBin [Type_int, Type_double, Type_bool] env e1 e2
  
 -- _ -> fail $ "NYI: inferExp " ++ printTree e




inferBin :: [Type] -> Env -> Exp -> Exp -> Err Type
inferBin types env exp1 exp2 = do 
  typ <- inferExp env exp1
  if elem typ types
    then do
      checkExp env exp2 typ
      return typ
    else
      fail $ "wrong type of expression " ++ printTree exp1

inferUn :: [Type] -> Env -> Exp -> Err Type
inferUn types env e = do 
  t <- inferExp env e
  if elem t types
    then return t
  else 
    fail $ "wrong type of expression " ++ printTree e


lookupDef :: Env -> Id -> Err FunType
lookupDef env f = case Map.lookup f (envSig env) of
  Nothing -> fail $ "undefined function " ++ printTree f
  Just t  -> return t

lookupVar :: Env -> Id -> Err Type
lookupVar env x = case catMaybes $ map (Map.lookup x) (envCxt env) of
  []      -> fail $ "unbound variable " ++ printTree x
  (t : _) -> return t

extendSig :: Env -> Def -> Err Env
extendSig env@Env{ envSig = sig } (DFun t f args _ss) = do
  if Map.member f sig then fail $ "duplicate definition of function " ++ printTree f else return env { envSig = Map.insert f ft (envSig env) }
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