grm = CPP
dir = $(grm)
bnfc_output = $(patsubst %,$(dir)/%,Abs.hs ErrM.hs Print.hs Lex.x Par.y Test.hs)
alex_file = $(dir)/Lex
happy_file = $(dir)/Par
test_file = lab3

bnfc=/chalmers/sw/sup64/phc/b/binh/bnfc
BNFC_OPTS =
  # --java
  # --profile # DOES NOT WORK
  # --haskell-gadt

.PHONY: build test

default : test

build : $(alex_file).hs $(happy_file).hs $(test_file)

lab3 : lab3.hs TypeChecker.hs JVM.hs CodeGen.hs $(alex_file).hs $(happy_file).hs
	ghc --make lab3.hs -o lab3

test : $(test_file) Runtime.class
	./$(test_file) test/test.cc
	(cd test && cat test.j && java -cp ..:. test)

%.class : %.java
	javac $<

$(bnfc_output): $(grm).cf
#	-@rm $(bnfc_output)
	$(bnfc) $(BNFC_OPTS) -d $<

$(alex_file).hs: $(alex_file).x
	alex --ghc $<

$(happy_file).hs: $(happy_file).y
	happy --ghc --coerce --array -iGRM.txt $<

.PHONY: clean debug

debug:
	@echo "bnfc_output = $(bnfc_output)"

clean:
	rm -rf bnfc

# EOF
