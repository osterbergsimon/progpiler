grm = Fun
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

.PHONY: build test

default : build

build : $(alex_file).hs $(happy_file).hs $(test_file)

main : main.hs Interpreter.hs $(alex_file).hs $(happy_file).hs
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
	rm -rf $(dir)
	rm -rf GRM.txt
	rm -rf *.hi
	rm -rf *.o
	rm -rf $(test_file)

# EOF
