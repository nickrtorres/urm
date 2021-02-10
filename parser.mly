%{
type instruction =
  | I_Zero of int
  | I_Successor of int
  | I_Transfer of int * int
  | I_Jump of int * int * int

type program = instruction list

type registers = int list
%}

%token JUMP SUCCESSOR TRANSFER ZERO LPAREN RPAREN COLON COMMA CFG BIND EOF
%token <int> NUM
%start program
%type  <registers * program> program

%%
program              : cfg instruction_list                         { ($1, $2) }
  ;

cfg                  : CFG BIND LPAREN registers RPAREN             { $4 }
  ;

registers            : NUM COMMA registers                          { $1 :: $3 }
                     | NUM                                          { $1 :: [] }
  ;

instruction_list     : EOF                                          { [] }
                     | instruction instruction_list                 { $1 :: $2 }
  ;

instruction          : JUMP LPAREN NUM COMMA NUM COMMA NUM RPAREN   { I_Jump($3, $5, $7) }
                     | SUCCESSOR LPAREN NUM RPAREN                  { I_Successor($3)    }
                     | TRANSFER LPAREN NUM COMMA NUM RPAREN         { I_Transfer($3, $5) }
                     | ZERO LPAREN NUM RPAREN                       { I_Zero($3)         }
  ;
%%
