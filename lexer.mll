{ 
  open Parser
  exception LexError of string
}

rule token = parse
  [' ' '\t' '\n']        { token lexbuf }
  | ['0' - '9'] * as n   { NUM (int_of_string n) }
  | 'J'                  { JUMP }
  | 'S'                  { SUCCESSOR }
  | 'T'                  { TRANSFER }
  | 'Z'                  { ZERO }
  | '('                  { LPAREN }
  | ')'                  { RPAREN }
  | 'c' 'f' 'g'          { CFG }
  | ':' '='              { BIND }
  | ':'                  { COLON }
  | ','                  { COMMA }
  | eof                  { EOF }
  | _ { raise (LexError ("Unknown character" ^ Lexing.lexeme lexbuf)) }


