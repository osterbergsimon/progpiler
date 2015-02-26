import System.IO
import System.FilePath.Posix
import System.Environment
import System.Exit
import System.Process

import Control.Monad.Reader

import CPP.Abs
import CPP.Lex
import CPP.Par
import CPP.ErrM

import TypeChecker
import CodeGen

check :: FilePath -> String -> IO ()
check file s = case pProgram (myLexer s) of
  Bad err  -> do
    putStrLn "SYNTAX ERROR"
    putStrLn err
    exitFailure
  Ok tree -> do
    case typecheck tree of
      Bad err -> do
        putStrLn "TYPE ERROR"
        putStrLn err
        exitFailure
      Ok () -> do
        -- hPutStrLn stderr $ show annTree
        let name   = takeBaseName file
        let jasmin = codeGen name tree
        let dir    = takeDirectory file
        let jfile  = replaceExtension file "j"
        writeFile jfile jasmin

        -- Convert jasmin to JVM
        -- Pipe stdout to stderr, otherwise the "Generated xxx.class" upsets test suite
        pHandle <- runProcess
                   "java" -- executable
                   ["-jar", "jasmin.jar", "-d", dir, jfile] -- arguments
                   Nothing -- working directory
                   Nothing -- environment
                   Nothing -- input handle
                   (Just stderr) -- output handle
                   Nothing -- error handle
        exitCode <- waitForProcess pHandle
        case exitCode of
          ExitSuccess -> do
            hPutStrLn stderr "OK"
            exitSuccess
          ExitFailure i -> do
            putStrLn "JASMIN CONVERSION ERROR"
            exitWith exitCode

main :: IO ()
main = do
  args <- getArgs
  case args of
    [file] -> readFile file >>= check file
    _      -> do
      putStrLn "Usage: lab3 <SourceFile>"
      exitFailure
