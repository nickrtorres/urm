open Urm

let main argv =
  let ic = open_in argv.(1) in
  let lexbuf = Lexing.from_channel ic in
  let registers, instructions = Parser.program Lexer.token lexbuf in
  let state = state_of_registers registers |> run Normal instructions in
  let () = report state |> Printf.printf "%d\n" in
  let () = close_in ic in

  0
