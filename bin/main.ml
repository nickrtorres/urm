open Lib.Driver
open Lib.Urm

let mode = ref Normal

let fname = ref None

let () =
  Arg.parse
    [ ("-d", Arg.Unit (fun () -> mode := Trace), "dump state to stderr") ]
    (fun f -> fname := Some f)
    "usage: urm [-d] fname"

let _ = main !mode !fname |> exit
