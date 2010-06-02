TEST = one mixed

all: native byte

byte: $(TEST:=.byte)

native: $(TEST:=.opt)

%.byte: %.ml
	ocamlc -I +ocamlyices nums.cma ocamlyices.cma $< -o $@

%.opt: %.ml
	ocamlopt -I +ocamlyices nums.cmxa ocamlyices.cmxa $< -o $@

clean:
	rm -rf *.cmi *.cmo *.cmx *.o

distclean mrproper: clean
	rm -rf *.byte *.opt

.PHONY: all native byte clean
