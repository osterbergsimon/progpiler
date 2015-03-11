grm = CPP
dir = $(grm)
bnfc_output = $(patsubst %,$(dir)/%,Abs.hs ErrM.hs Print.hs Lex.x Par.y Test.hs)
alex_file = $(dir)/Lex
happy_file = $(dir)/Par
test_file = main

#bnfc=/chalmers/sw/sup64/phc/b/binh/bnfc
BNFC_OPTS =
  # --java
  # --profile # DOES NOT WORK
  # --haskell-gadt

.PHONY: build

default : build

build : $(alex_file).hs $(happy_file).hs $(test_file)

main : main.hs Interpreter.hs TypeChecker.hs $(alex_file).hs $(happy_file).hs
	ghc --make main.hs -o main

$(bnfc_output): $(grm).cf
#	-@rm $(bnfc_output)
	bnfc $(BNFC_OPTS) -d $<

$(alex_file).hs: $(alex_file).x
	alex --ghc $<

$(happy_file).hs: $(happy_file).y
	happy --ghc --coerce --array -iGRM.txt $<

.PHONY: clean debug

debug:
	@echo "bnfc_output = $(bnfc_output)"

clean:
	rm -rf CPP
	rm -rf *.o
	rm -fr *.hi
	rm -rf GRM.txt
	rm -rf $(test_file)

# EOF
