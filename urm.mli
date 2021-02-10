open Parser

type state

val state_of_registers : int list -> state

val exec : instruction -> state -> state

val dump_registers : state -> unit

val run : program -> state -> state
