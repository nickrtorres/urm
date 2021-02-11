{ 
  open Parser
  exception Lex_error of int * string
}

rule token = parse
  ['\n']                 { Lexing.new_line lexbuf; token lexbuf }
  | [' ']                { token lexbuf }
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
  | _ { raise (Lex_error (lexbuf.lex_curr_p.pos_lnum, Lexing.lexeme lexbuf)) }
