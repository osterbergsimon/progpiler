all: 
	happy -gca Pargrammar.y
	alex -g Lexgrammar.x
	ghc --make Testgrammar.hs -o Testgrammar

doc: Docgrammar.pdf

Docgrammar.pdf: Docgrammar.tex
	pdflatex Docgrammar.tex

clean: 
	-rm -f *.log *.aux *.hi *.o *.dvi
	-rm -f Docgrammar.ps

distclean: clean
	-rm -f Docgrammar.* Lexgrammar.* Pargrammar.* Layoutgrammar.* Skelgrammar.* Printgrammar.* Testgrammar.* Absgrammar.* Testgrammar ErrM.* SharedString.* ComposOpgrammar.* grammar.dtd XMLgrammar.* Makefile*
	

