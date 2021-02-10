open Urm

let main () =
  let lexbuf = Lexing.from_channel stdin in
  let registers, instructions = Parser.program Lexer.token lexbuf in
  let state = state_of_registers registers in
  let () = dump_registers (run instructions state Normal) in
  ()

let () = main ()
