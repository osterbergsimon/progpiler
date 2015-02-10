module TypeChecker where

import AbsCPP
import PrintCPP
import ErrM
import Data.Map (Map)
import qualified Data.Map as Map


typecheck :: Program -> Err ()
typecheck (PDefs defs) = checkDefs emptyEnv defs



--BEHÖVER SPARA UNDAN ENV I ANDRA FALL OCKSÅ?

checkDefs :: Env -> [Def] -> Err ()
checkDefs env [] = return ()
checkDefs env (d:defs) = do env' <- checkDef env d
                            checkDefs env' defs


checkArg :: Env -> Arg -> Err Env
checkArg env a =
    case a of 
        ADecl t x -> do updateVar env x t
                        return env


checkArgs :: Env -> [Arg] -> Err ()
checkArgs env [] = return ()
checkArgs env (a:args) = do env' <- checkArg env a
                            checkArgs env' args


checkDef :: Env -> Def -> Err Env
checkDef env d = do
        env' <- addScope env
        case d of
            DFun t x args [] -> do  checkArgs env' args
                                    return env'
            DFun t x args ((SReturn e):_) -> do checkExp env' e t
                                                checkArgs env' args           
                                                return env'
            DFun t x args stms -> do checkStms env' stms
                                     checkArgs env' args
                                     return env'


checkStms :: Env -> [Stm] -> Err ()
checkStms env [] = return ()
checkStms env (st:stms) = do env' <- checkStm env st
                             checkStms env' stms

--checkStm :: Env -> Type -> Stm -> Err en
checkStm :: Env -> Stm -> Err Env
checkStm env s = 
    case s of
      SDecls t (x:[])       -> updateVar env x t
      --ADecl t x       -> updateVar env x t
      SDecls t (id:ids)-> do updateVar env id t
                             checkStm env (SDecls t ids)
     -- SAss x e        -> do t <- lookupVar env x
     --                       checkExp env e t
     --                       return env      
      SBlock stms     -> do checkStms (addScope env) stms
                            return env
      SExp e          -> do inferExp env e 
                            --return env
      SInit t x e     -> do updateVar env x t
                            t' <- lookupVar env x
                            checkExp env e t'
                            --return env 
      SReturn e       -> do inferExp env e
                            --return env 
      SWhile e stm    -> do checkExp env e Type_bool 
                            checkStm env stm --checkStm env val stm
      SIfElse e s1 s2 -> do checkExp env e Type_bool
                            checkStm env s1
                            checkStm env s2


checkExp :: Env -> Exp -> Type -> Err ()
checkExp env e t = 
    do t' <- inferExp env e
       if t' /= t 
         then fail (printTree e ++ " has type " ++ printTree t'
                    ++ " expected " ++ printTree t)
         else return ()

inferExp :: Env -> Exp -> Err Type
inferExp env e = 
    case e of
      EId x         -> lookupVar env x
      EInt _         -> return Type_int
      ETrue         -> return Type_bool
      EFalse        -> return Type_bool
      EDouble _      -> return Type_double
      EPIncr e      -> inferUn [Type_double, Type_int] env e
      EPDecr e      -> inferUn [Type_double, Type_int] env e
      EIncr e       -> inferUn [Type_double, Type_int] env e
      EDecr e       -> inferUn [Type_double, Type_int] env e
      EApp x (e:[])   -> inferExp env e
      EApp x (e:rest) -> do inferExp env e
                            inferExp env (EApp x rest)
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

--updateVar (sig,(scope:rest)) x t = 
--type Env = [[(Ident, Type)]]

emptyEnv :: Env
emptyEnv = (Map.empty,[Map.empty])


updateFun :: Env -> Id -> ([Type],Type) -> Err Env
updateFun (sig,con) x t =
--updateFun env x t = do con <- snd env
--                       sig <- fst env    
                       case Map.lookup x sig of
                            Nothing -> return ((Map.insert x t sig),con)
                            Just _  -> fail ("Function " ++ printTree x ++ " already declared.")

updateVar :: Env -> Id -> Type -> Err Env
updateVar (sig,(scope:rest)) x t = 
                       case Map.lookup x scope of
                            Nothing -> return (sig,(Map.insert x t scope:rest))
                            Just _  -> fail ("Variable " ++ printTree x ++ " already declared.")


lookupVar :: Env -> Id -> Err Type
lookupVar (sig,[]) x = fail $ "Unknown variable " ++ printTree x ++ "."
lookupVar (sig,(scope:rest)) x =
                     case Map.lookup x scope of
                             Nothing -> lookupVar (sig,rest) x
                             Just t  -> return t

lookupFun :: Env -> Id -> Err ([Type],Type)
lookupFun (sig,con) x   =
    case Map.lookup x sig of
        Nothing -> fail $ "Unknown Function " ++ printTree x ++ "."
        Just t  -> return t

addScope :: Env -> Err Env
addScope (sig,con) = (sig,(Map.empty:con))


inferBin :: [Type] -> Env -> Exp -> Exp -> Err Type
inferBin types env exp1 exp2 = do typ <- inferExp env exp1
                                  if elem typ types
                                    then do
                                            checkExp env exp2 typ
                                            return typ
                                  else
                                        fail $ "wrong type of expression " ++ printTree exp1

inferUn :: [Type] -> Env -> Exp -> Err Type
inferUn types env e = do t <- inferExp env e
                         if elem t types
                             then do
                                    checkExp env e t
                                    return t
                         else 
                             fail $ "wrong type of expression " ++ printTree e




type Env = (Sig,[Context]) -- functions and context stack
type Sig = Map Id ([Type],Type) -- function type signature
type Context = Map Id Type -- variables with their types




{-
Type infer (Env env, Exp e)
Void check (Env env, Type t, Exp e)
Void check (Env env, Statements t)
Void check (Env env, Definition d)
Void check (Program p)
Type look (Ident x, Env env)
FunType look (Ident x, Env env)
Env extend (Env env, Ident x, Type t)
Env extend (Env env, Definition d)
Env push (Env env)
Env pop (Env env)
Env empty ()
-}