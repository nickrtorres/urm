.POSIX:

OFLAGS =  -w A -warn-error A

urm: main.ml

main.ml: urm.ml lexer.ml
	ocamlc $(OFLAGS) parser.ml lexer.ml urm.ml main.ml -o urm

urm.ml: urm.cmi
	ocamlc -c $(OFLAGS) $@

urm.cmi: urm.mli
	ocamlc -c $(OFLAGS) $<

urm.mli: parser.ml

lexer.ml: lexer.mll
	ocamllex $<
	ocamlc -c lexer.ml

parser.ml: parser.mly
	ocamlyacc $<
	# FIXME: not sure why the mli won't compile atm
	rm -f parser.mli
	ocamlc -c $@

clean:
	rm -f lexer.ml lexer.cmi lexer.cmo
	rm -f main.cmi main.cmo
	rm -f parser.mli parser.ml parser.cmi parser.cmo
	rm -f urm.cmi urm.cmo
	rm -f urm
