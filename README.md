URM is an ocaml implementation of an **U**nlimited **R**egister **M**achine as
described by N.J. Cutland in *Computability: An introduction to recursive
function theory*.

The URM supports four instructions:
- `Z(r)` that zeros out register `r` (i.e. `r := 0`)
- `S(r)` that increments the contents of `r` by 1 (i.e. `r := r + 1`)
- `T(src, dst)` that transfers the value from `src` to `dst` register (i.e.
  `dst := src`)
- `J(m, n, q)` where the program counter is updated to `q` iff `m = n`

In addition to the instructions described above, the URM has a program counter
(starting at 1) and an initial configuration (i.e. the register values that
the machine uses as its starting point).

Consider the example below which evaluates `f(x, y) = 1 if x <= y; 0 otherwise`.
```
cfg := (10, 20)

J(3, 1, 5)
J(3, 2, 8)
S(3)
J(1, 1, 1)
Z(1)
S(1)
J(1, 1, 9)
Z(1)
```

Running this program yields the following results.
```
% ./urm examples/lte.urm 
1
```

## Building

```
% make
```
