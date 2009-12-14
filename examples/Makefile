all: native bytecode

native: one.opt

bytecode: one

one: one.ml
	ocamlc -I +ocamlyices nums.cma ocamlyices.cma one.ml -o one

one.opt: one.ml
	ocamlopt -I +ocamlyices nums.cmxa ocamlyices.cmxa one.ml -o one.opt

clean:
	rm -rf *.cm[ixo] *.o

mrproper: clean
	rm -rf one one.opt

.PHONY: all native bytecode clean
