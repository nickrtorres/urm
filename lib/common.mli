type instruction =
  | I_Zero of int
  | I_Successor of int
  | I_Transfer of int * int
  | I_Jump of int * int * int

type program = instruction list
