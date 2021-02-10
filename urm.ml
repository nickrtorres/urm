open Parser
module RegisterState = Map.Make (Int)

type state = { pc : int; rs : int RegisterState.t }

type update = U_Zero of int | U_Successor of int | U_Transfer of int * int

let state_of_registers registers =
  let _, rs =
    List.fold_left
      (fun (i, tbl) r -> (i + 1, RegisterState.add i r tbl))
      (0, RegisterState.empty) registers
  in

  { pc = 0; rs }

let exec instruction state =
  let fetch_reg r =
    match RegisterState.find_opt r state.rs with Some v -> v | None -> 0
  in

  let update_instr i =
    let set_register r v = { state with rs = RegisterState.add r v state.rs } in
    match i with
    | U_Zero r -> set_register r 0
    | U_Successor r -> set_register r (fetch_reg r + 1)
    | U_Transfer (src, dst) -> set_register dst (fetch_reg src + 1)
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

let run program state =
  let instructions = Array.of_list program in
  let num_instructions = Array.length instructions - 1 in
  let rec run' s =
    if s.pc > num_instructions then s
    else
      let instruction = instructions.(s.pc) in
      run' (exec instruction s)
  in

  run' state
