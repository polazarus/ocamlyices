all: native byte

byte: one.byte

native: one.opt

one.byte: one.ml
	ocamlc -I +ocamlyices nums.cma ocamlyices.cma one.ml -o one.byte

one.opt: one.ml
	ocamlopt -I +ocamlyices nums.cmxa ocamlyices.cmxa one.ml -o one.opt

clean:
	rm -rf *.cmi *.cmo *.cmx *.o

distclean mrproper: clean
	rm -rf *.byte *.opt

.PHONY: all native byte clean
