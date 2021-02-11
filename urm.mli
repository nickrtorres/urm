open Parser

type state

type mode = Normal | Trace

val state_of_registers : int list -> state

val exec : instruction -> state -> state

val dump_registers : state -> unit

val run : mode -> program -> state -> state

val report : state -> int
