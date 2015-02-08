all: 
	happy -gca ParCPP.y
	alex -g LexCPP.x
	ghc --make TestCPP.hs -o TestCPP

doc: DocCPP.pdf

DocCPP.pdf: DocCPP.tex
	pdflatex DocCPP.tex

clean: 
	-rm -f *.log *.aux *.hi *.o *.dvi
	-rm -f DocCPP.ps

distclean: clean
	-rm -f DocCPP.* LexCPP.* ParCPP.* LayoutCPP.* SkelCPP.* PrintCPP.* TestCPP.* AbsCPP.* TestCPP ErrM.* SharedString.* ComposOpCPP.* CPP.dtd XMLCPP.* Makefile*
	

