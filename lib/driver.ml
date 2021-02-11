open Lexer
open Urm

let main mode fname =
  try
    let ic = match fname with Some f -> open_in f | None -> stdin in
    let lexbuf = Lexing.from_channel ic in
    let registers, instructions = Parser.program Lexer.token lexbuf in
    let state = state_of_registers registers |> run mode instructions in
    let () = report state |> Printf.printf "%d\n" in
    let () = close_in ic in

    0
  with Lex_error (lnum, token) ->
    let () = Printf.printf "error: line %d: invalid token: %s\n" lnum token in
    1
