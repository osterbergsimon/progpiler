module TypeChecker where

import AbsCPP
import PrintCPP
import ErrM



typecheck :: Program -> Err ()
typecheck (Prog stms) = checkStms emptyEnv stms

checkStms :: Env -> [Stm] -> Err ()
checkStms env [] = return ()
checkStms env (st:stms) = do env' <- checkStm env st
                             checkStms env' stms

--checkStm :: Env -> Type -> Stm -> Err en
checkStm :: Env -> Stm -> Err Env
checkStm env s = 
    case s of
      SDecl t x       -> addVar env x t
      SAss x e        -> do t <- lookupVar env x
                            checkExp env e t
                            return env      
      SBlock stms     -> do checkStms (addScope env) stms
                            return env
      SPrint e        -> do inferExp env e
                            return env
      SExp e          -> do inferExp env e 
      						return env
      SInit t x e 	  -> do addVar env x t
      						t <- lookupVar env x
                            checkExp env e t
                            return env 
      SReturn e 	  -> do inferExp env e
      					 	return env 
	  SWhile e stm    -> do checkExp env Type_bool e
	  						checkStm env stm --checkStm env val stm
 	  SIfElse e s1 s2 -> do checkExp env Type_bool e
 	  						checkStms env s1:s2
 	  						return env

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
      ETrue 		-> return Type_bool
      EFalse		-> return Type_bool
      EDouble _      -> return Type_double
 	  EPIncr e 		-> inferUn [Type_double, Type_int] env e
 	  EPDecr e      -> inferUn [Type_double, Type_int] env e
 	  EIncr e       -> inferUn [Type_double, Type_int] env e
 	  EDecr e       -> inferUn [Type_double, Type_int] env e
 	 -- EApp OMGWTFWTHITS 
      EPlus e1 e2     -> 
      	inferBin [Type_int, Type_double, Type_string] env exp1 exp2
	  EMinus e1 e2     -> 
      	inferBin [Type_int, Type_double, Type_string] env exp1 exp2
	  ETimes e1 e2     -> 
      	inferBin [Type_int, Type_double] env exp1 exp2
	  EDiv e1 e2     -> 
      	inferBin [Type_int, Type_double] env exp1 exp2
	  ELt e1 e2     -> 
      	inferBin [Type_int, Type_double, Type_string] env exp1 exp2
	  EGt e1 e2     -> 
      	inferBin [Type_int, Type_double, Type_string] env exp1 exp2
	  ELtEq e1 e2     -> 
      	inferBin [Type_int, Type_double, Type_string] env exp1 exp2
	  EGtWq e1 e2     -> 
      	inferBin [Type_int, Type_double, Type_string] env exp1 exp2
	  EEq e1 e2     -> 
      	inferBin [Type_int, Type_double, Type_string] env exp1 exp2
	  ENEq e1 e2     -> 
      	inferBin [Type_int, Type_double, Type_string] env exp1 exp2
	  EAnd e1 e2     -> 
      	inferBin [Type_bool] env exp1 exp2
	  EOr e1 e2     -> 
      	inferBin [Type_bool] env exp1 exp2
	  EAss e1 e2     -> 
      	inferBin [Type_int, Type_double, Type_string, Type_bool] env exp1 exp2


--type Env = [[(Ident, Type)]]

emptyEnv :: Env
emptyEnv = [[]]

addVar :: Env -> Ident -> Type -> Err Env
addVar (scope:rest) x t = 
    case lookup x scope of
      Nothing -> return (((x,t):scope):rest)
      Just _  -> fail ("Variable " ++ printTree x ++ " already declared.")

lookupVar :: Env -> Ident -> Err Type
lookupVar [] x = fail $ "Unknown variable " ++ printTree x ++ "."
lookupVar (scope:rest) x = case lookup x scope of
                             Nothing -> lookupVar rest x
                             Just t  -> return t
addScope :: Env -> Env
addScope env = []:env


inferBin :: [Type] -> Env -> Exp -> Exp -> Err Type
inferBin types env exp1 exp2 = do
typ <- inferExp env exp1
	if elem typ types
		then
		checkExp env exp2 typ
	else
		fail $ "wrong type of expression " ++ printTree exp1

inferUn :: [Type] -> Env -> Exp -> Err Type
inferUn types env e = do
t <- inferExp env e
	if elem t types
 		then 
 		checkExp env e t
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
Env env)
Env env)
Ident x, Type t)
Definition d)
-}