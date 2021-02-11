open Parser
module RegisterState = Map.Make (Int)

type state = { pc : int; rs : int RegisterState.t }

type update = U_Zero of int | U_Successor of int | U_Transfer of int * int

type mode = Normal | Trace

let state_of_registers registers =
  let _, rs =
    List.fold_left
      (fun (i, tbl) r -> (i + 1, RegisterState.add i r tbl))
      (1, RegisterState.empty) registers
  in

  { pc = 1; rs }

let fetch_reg state r =
  match RegisterState.find_opt r state.rs with Some v -> v | None -> 0

let exec instruction state =
  let fetch_reg r = fetch_reg state r in

  let update_instr i =
    let set_register r v = { state with rs = RegisterState.add r v state.rs } in
    match i with
    | U_Zero r -> set_register r 0
    | U_Successor r -> set_register r (fetch_reg r + 1)
    | U_Transfer (src, dst) -> set_register dst (fetch_reg src)
  in

  let inc_pc s = { s with pc = s.pc + 1 } in

  match instruction with
  | I_Zero r -> inc_pc (update_instr (U_Zero r))
  | I_Successor r -> inc_pc (update_instr (U_Successor r))
  | I_Transfer (src, dst) -> inc_pc (update_instr (U_Transfer (src, dst)))
  | I_Jump (r1, r2, pc) ->
      let r1 = fetch_reg r1 in
      let r2 = fetch_reg r2 in
      if r1 = r2 then { state with pc } else inc_pc state

let dump_registers s =
  RegisterState.iter (fun k v -> Printf.printf "R%d => %d\n" k v) s.rs

let dbg_i i =
  match i with
  | I_Zero r -> Printf.printf "I_Zero %d\n" r
  | I_Successor r -> Printf.printf "I_Successor %d\n" r
  | I_Transfer (src, dst) -> Printf.printf "I_Transfer %d %d\n" src dst
  | I_Jump (r1, r2, pc) -> Printf.printf "I_Jump %d %d %d\n" r1 r2 pc

let run mode program state =
  let debug = match mode with Trace -> true | Normal -> false in

  (* FIXME: I_Transfer is a no-op to allow indicis to start at 1 *)
  let instructions = Array.of_list ([ I_Transfer (1, 1) ] @ program) in
  let num_instructions = Array.length instructions - 1 in
  let rec run' s =
    if s.pc > num_instructions then s
    else
      let instruction = instructions.(s.pc) in
      let () = if debug then dbg_i instruction else () in
      run' (exec instruction s)
  in

  run' state

let report state = fetch_reg state 1
