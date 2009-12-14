OCAML_LIB_DIR=$(shell ocamlc -where)
OCAMLYICES_LIB_DIR=$(OCAML_LIB_DIR)/ocamlyices

OUTPUT_OCAML_LIBRARY=ocamlyices
OUTPUT_OCAML_LIBRARY_BYTECODE=$(OUTPUT_OCAML_LIBRARY).cma
OUTPUT_OCAML_LIBRARY_NATIVE=$(OUTPUT_OCAML_LIBRARY).cmxa
OUTPUT_C_LIBRARY=libocamlyices.a

GENERATED_LIBRARY_FOR_CMXA=$(OUTPUT_OCAML_LIBRARY_NATIVE:.cmxa=.a)

OCAMLLIB=/usr/lib/ocaml

ifdef STATIC
PARTIAL_LINKING_LIBS=camlidl yices
PARTIAL_LINKING_LIB_DIRS=$(OCAMLLIB) /usr/lib /usr/local/lib
CMALIBS=stdc++ gmp
else
#$(shell echo Use dynamic yices)
PARTIAL_LINKING_LIBS=camlidl
PARTIAL_LINKING_LIB_DIRS=$(OCAMLLIB) /usr/lib /usr/local/lib
CMALIBS=yices stdc++ gmp
endif

CAMLIDL_SOURCE=yices.idl
CAMLIDL_GENERATED_ML=$(CAMLIDL_SOURCE:.idl=.ml)
CAMLIDL_GENERATED_MLI=$(CAMLIDL_SOURCE:.idl=.mli)
CAMLIDL_GENERATED_STUBS=$(CAMLIDL_SOURCE:.idl=_stubs.c)
CAMLIDL_GENERATED_FILES=$(CAMLIDL_GENERATED_ML) $(CAMLIDL_GENERATED_MLI) $(CAMLIDL_GENERATED_STUBS)

# Tools
CAMLIDL=camlidl
OCAMLC=ocamlc
OCAMLOPT=ocamlopt
CC=gcc
CFLAGS=-O2
AR=ar
RANLIB=ranlib
MKDIR=mkdir

all: bytecode native

bytecode: $(OUTPUT_OCAML_LIBRARY_BYTECODE)
native: $(OUTPUT_OCAML_LIBRARY_NATIVE)

$(CAMLIDL_GENERATED_FILES): $(CAMLIDL_SOURCE)
	$(CAMLIDL) $<

$(CAMLIDL_GENERATED_ML:.ml=.cmo): $(CAMLIDL_GENERATED_MLI:.mli=.cmi)
$(CAMLIDL_GENERATED_ML:.ml=.cmx): $(CAMLIDL_GENERATED_MLI:.mli=.cmi)

%.cmi: %.mli
	$(OCAMLC) -c $< -o $@

%.cmo: %.ml
	$(OCAMLC) -c $< -o $@
%.cmx: %.ml
	$(OCAMLOPT) -c $< -o $@

# Partial linking for efficiency
$(OUTPUT_C_LIBRARY:lib%.a=%.o): $(CAMLIDL_GENERATED_STUBS:.c=.o) yices_extra.o
	$(LD) -r $^ $(PARTIAL_LINKING_LIB_DIRS:%=-L'%') $(PARTIAL_LINKING_LIBS:%=-l%) -o $@

$(OUTPUT_C_LIBRARY): $(OUTPUT_C_LIBRARY:lib%.a=%.o)
	$(AR) cr $@ $<
	$(RANLIB) $@

$(OUTPUT_OCAML_LIBRARY_BYTECODE): $(CAMLIDL_GENERATED_ML:.ml=.cmo) $(OUTPUT_C_LIBRARY)
	$(OCAMLC) -a -custom -o $@ $< -cclib -l$(OUTPUT_C_LIBRARY:lib%.a=%) $(CMALIBS:%=-cclib -l%)
	
$(OUTPUT_OCAML_LIBRARY_NATIVE): $(CAMLIDL_GENERATED_ML:.ml=.cmx) $(OUTPUT_C_LIBRARY)
	$(OCAMLOPT) -a -o $@ -cclib -l$(OUTPUT_C_LIBRARY:lib%.a=%) $< $(CMALIBS:%=-cclib -l%)

clean:
	$(RM) *.cm[aoix] *.cmxa  *.[ao]  $(CAMLIDL_GENERATED_FILES)

install:
	mkdir -p '$(OCAMLYICES_LIB_DIR)'
	cp '$(CAMLIDL_GENERATED_MLI:.mli=.cmi)' '$(OUTPUT_C_LIBRARY)' '$(GENERATED_LIBRARY_FOR_CMXA)' '$(OUTPUT_OCAML_LIBRARY_BYTECODE)' '$(OUTPUT_OCAML_LIBRARY_NATIVE)' '$(OCAMLYICES_LIB_DIR)/'

.PHONY: clean dist all install
