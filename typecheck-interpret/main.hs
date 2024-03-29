import System.Environment (getArgs)
import System.Exit (exitFailure)

import CPP.Abs
import CPP.Lex
import CPP.Par
import CPP.ErrM

import TypeChecker
import Interpreter

-- driver

check :: String -> IO ()
check s = do
  case pProgram (myLexer s) of
    Bad err  -> do
      putStrLn "SYNTAX ERROR"
      putStrLn err
      exitFailure
    Ok  tree -> do
      case typecheck tree of
        Bad err -> do
          putStrLn "TYPE ERROR"
          putStrLn err
          exitFailure
        Ok _ -> interpret tree

main :: IO ()
main = do
  args <- getArgs
  case args of
    [file] -> readFile file >>= check
    _      -> do
      putStrLn "Usage: ./main <SourceFile>"
      exitFailure
