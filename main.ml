open Parser
open Printf
open Urm

let _dbg_print_instr i =
  match i with
  | I_Zero r -> printf "I_Zero %d\n" r
  | I_Successor r -> printf "I_Successor %d\n" r
  | I_Transfer (src, dst) -> printf "I_Transfer %d %d\n" src dst
  | I_Jump (r1, r2, pc) -> printf "I_Jump %d %d %d\n" r1 r2 pc

let main () =
  let lexbuf = Lexing.from_channel stdin in
  let instructions = Parser.program Lexer.token lexbuf in
  let state = state_of_registers [] in
  let () = dump_registers (run instructions state) in
  ()

let () = main ()
