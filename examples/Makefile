# Copyright (c) 2009-2013, Mickaël Delahaye, http://micdel.fr
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED “AS IS” AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

TEST = one two future

all: native byte

byte: $(TEST:=.byte)

native: $(TEST:=.opt)

%.byte: %.ml
	#ocamlc -I +ocamlyices nums.cma ocamlyices.cma $< -o $@
	ocamlfind ocamlc -package ocamlyices -linkpkg $< -o $@

%.opt: %.ml
	#ocamlopt -I +ocamlyices nums.cmxa ocamlyices.cmxa $< -o $@
	ocamlfind ocamlopt -package ocamlyices -linkpkg $< -o $@

clean:
	$(RM) *.cmi *.cmo *.cmx *.o
	$(RM) *.byte *.opt

.PHONY: all native byte clean distclean mrproper
