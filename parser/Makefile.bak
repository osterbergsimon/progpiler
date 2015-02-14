JAVAC = javac
JAVAC_FLAGS = -sourcepath .

JAVA = java
JAVA_FLAGS =

CUP = java_cup.Main
CUPFLAGS = -nopositions -expect 100

JLEX = JLex.Main

all: test

test: absyn grammar/Yylex.class grammar/PrettyPrinter.class grammar/Test.class grammar/ComposVisitor.class grammar/AbstractVisitor.class grammar/FoldVisitor.class grammar/AllVisitor.class grammar/parser.class grammar/sym.class grammar/Test.class

.PHONY: absyn

%.class: %.java
	${JAVAC} ${JAVAC_FLAGS} $^

absyn: grammar/Absyn/Program.java grammar/Absyn/PDefs.java grammar/Absyn/ListDef.java grammar/Absyn/Def.java grammar/Absyn/DFun.java grammar/Absyn/ListArg.java grammar/Absyn/ListStm.java grammar/Absyn/Arg.java grammar/Absyn/ADecl.java grammar/Absyn/Stm.java grammar/Absyn/SExp.java grammar/Absyn/SDecl.java grammar/Absyn/SDecls.java grammar/Absyn/SInit.java grammar/Absyn/SReturn.java grammar/Absyn/SWhile.java grammar/Absyn/SBlock.java grammar/Absyn/SIfElse.java grammar/Absyn/Exp.java grammar/Absyn/EInt.java grammar/Absyn/EDouble.java grammar/Absyn/EString.java grammar/Absyn/ETrue.java grammar/Absyn/EFalse.java grammar/Absyn/EId.java grammar/Absyn/ECall.java grammar/Absyn/EPIncr.java grammar/Absyn/EPDecr.java grammar/Absyn/EIncr.java grammar/Absyn/EDecr.java grammar/Absyn/ENeg.java grammar/Absyn/EMul.java grammar/Absyn/EDiv.java grammar/Absyn/EAdd.java grammar/Absyn/ESub.java grammar/Absyn/ELt.java grammar/Absyn/EGt.java grammar/Absyn/ELEq.java grammar/Absyn/EGEq.java grammar/Absyn/EEq.java grammar/Absyn/ENEq.java grammar/Absyn/EAnd.java grammar/Absyn/EOr.java grammar/Absyn/EAss.java grammar/Absyn/ListExp.java grammar/Absyn/Type.java grammar/Absyn/Tbool.java grammar/Absyn/Tdouble.java grammar/Absyn/Tint.java grammar/Absyn/Tstring.java grammar/Absyn/Tvoid.java grammar/Absyn/ListId.java
	${JAVAC} ${JAVAC_FLAGS} $^

grammar/Yylex.java: grammar/Yylex
	${JAVA} ${JAVA_FLAGS} ${JLEX} grammar/Yylex

grammar/sym.java grammar/parser.java: grammar/grammar.cup
	${JAVA} ${JAVA_FLAGS} ${CUP} ${CUPFLAGS} grammar/grammar.cup
	mv sym.java parser.java grammar/

grammar/Yylex.class: grammar/Yylex.java grammar/sym.java

grammar/sym.class: grammar/sym.java

grammar/parser.class: grammar/parser.java grammar/sym.java

grammar/PrettyPrinter.class: grammar/PrettyPrinter.java

clean: 
	rm -f grammar/Absyn/*.class grammar/*.class
	rm -f .dvi grammar.aux grammar.log grammar.ps  *.class

distclean: vclean

vclean: 
	 rm -f grammar/Absyn/Program.java grammar/Absyn/PDefs.java grammar/Absyn/ListDef.java grammar/Absyn/Def.java grammar/Absyn/DFun.java grammar/Absyn/ListArg.java grammar/Absyn/ListStm.java grammar/Absyn/Arg.java grammar/Absyn/ADecl.java grammar/Absyn/Stm.java grammar/Absyn/SExp.java grammar/Absyn/SDecl.java grammar/Absyn/SDecls.java grammar/Absyn/SInit.java grammar/Absyn/SReturn.java grammar/Absyn/SWhile.java grammar/Absyn/SBlock.java grammar/Absyn/SIfElse.java grammar/Absyn/Exp.java grammar/Absyn/EInt.java grammar/Absyn/EDouble.java grammar/Absyn/EString.java grammar/Absyn/ETrue.java grammar/Absyn/EFalse.java grammar/Absyn/EId.java grammar/Absyn/ECall.java grammar/Absyn/EPIncr.java grammar/Absyn/EPDecr.java grammar/Absyn/EIncr.java grammar/Absyn/EDecr.java grammar/Absyn/ENeg.java grammar/Absyn/EMul.java grammar/Absyn/EDiv.java grammar/Absyn/EAdd.java grammar/Absyn/ESub.java grammar/Absyn/ELt.java grammar/Absyn/EGt.java grammar/Absyn/ELEq.java grammar/Absyn/EGEq.java grammar/Absyn/EEq.java grammar/Absyn/ENEq.java grammar/Absyn/EAnd.java grammar/Absyn/EOr.java grammar/Absyn/EAss.java grammar/Absyn/ListExp.java grammar/Absyn/Type.java grammar/Absyn/Tbool.java grammar/Absyn/Tdouble.java grammar/Absyn/Tint.java grammar/Absyn/Tstring.java grammar/Absyn/Tvoid.java grammar/Absyn/ListId.java grammar/Absyn/Program.class grammar/Absyn/PDefs.class grammar/Absyn/ListDef.class grammar/Absyn/Def.class grammar/Absyn/DFun.class grammar/Absyn/ListArg.class grammar/Absyn/ListStm.class grammar/Absyn/Arg.class grammar/Absyn/ADecl.class grammar/Absyn/Stm.class grammar/Absyn/SExp.class grammar/Absyn/SDecl.class grammar/Absyn/SDecls.class grammar/Absyn/SInit.class grammar/Absyn/SReturn.class grammar/Absyn/SWhile.class grammar/Absyn/SBlock.class grammar/Absyn/SIfElse.class grammar/Absyn/Exp.class grammar/Absyn/EInt.class grammar/Absyn/EDouble.class grammar/Absyn/EString.class grammar/Absyn/ETrue.class grammar/Absyn/EFalse.class grammar/Absyn/EId.class grammar/Absyn/ECall.class grammar/Absyn/EPIncr.class grammar/Absyn/EPDecr.class grammar/Absyn/EIncr.class grammar/Absyn/EDecr.class grammar/Absyn/ENeg.class grammar/Absyn/EMul.class grammar/Absyn/EDiv.class grammar/Absyn/EAdd.class grammar/Absyn/ESub.class grammar/Absyn/ELt.class grammar/Absyn/EGt.class grammar/Absyn/ELEq.class grammar/Absyn/EGEq.class grammar/Absyn/EEq.class grammar/Absyn/ENEq.class grammar/Absyn/EAnd.class grammar/Absyn/EOr.class grammar/Absyn/EAss.class grammar/Absyn/ListExp.class grammar/Absyn/Type.class grammar/Absyn/Tbool.class grammar/Absyn/Tdouble.class grammar/Absyn/Tint.class grammar/Absyn/Tstring.class grammar/Absyn/Tvoid.class grammar/Absyn/ListId.class
	 rm -f grammar/Absyn/*.class
	 rmdir grammar/Absyn/
	 rm -f grammar.tex grammar.dvi grammar.aux grammar.log grammar.ps 
	 rm -f grammar/Yylex grammar/grammar.cup grammar/Yylex.java grammar/VisitSkel.java grammar/ComposVisitor.java grammar/AbstractVisitor.java grammar/FoldVisitor.java grammar/AllVisitor.java grammar/PrettyPrinter.java grammar/Skeleton.java grammar/Test.java grammar/sym.java grammar/parser.java grammar/*.class
	rm -f Makefile
	rmdir -p grammar/

