# progpiler

Proof-of-concept of a compiler for C++ written in Haskell. 


# grammar

A grammar for the BNF Converter (http://bnfc.digitalgrammars.com/) for a subset of the operations alllowed in C++. Compliling it with bnfc produces a lexer and a parser for the subset.

# typecheck-interpret

A typechecker for a subset of C++, along with an interpreter that can run the code in question.

# codegen

A code generator for a smaller subset of C++, generating JVM assembly and using jasmin to generate bytecode. Essentially allowing smaller C++ programs to run inside the Java Virtual Machine

# functional-interpreter

Somewhat separate from the other modules. This is an interpreter for a small functional language, handling both call-by-value and call-by-name