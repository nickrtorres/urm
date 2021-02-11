%{
%}

%token JUMP SUCCESSOR TRANSFER ZERO LPAREN RPAREN COLON COMMA CFG BIND EOF
%token <int> NUM
%start program
%type  <int list * Common.instruction list> program

%%
program              : cfg instruction_list                         { ($1, $2) }
  ;

cfg                  : CFG BIND LPAREN registers RPAREN             { $4 }
  ;

registers            : NUM COMMA registers                          { $1 :: $3 }
                     | NUM                                          { $1 :: [] }
  ;

instruction_list     : instruction instruction_list                 { $1 :: $2 } 
                     | EOF                                          { [] } 
  ;

instruction          : JUMP LPAREN NUM COMMA NUM COMMA NUM RPAREN   { I_Jump($3, $5, $7) }
                     | SUCCESSOR LPAREN NUM RPAREN                  { I_Successor($3)    }
                     | TRANSFER LPAREN NUM COMMA NUM RPAREN         { I_Transfer($3, $5) }
                     | ZERO LPAREN NUM RPAREN                       { I_Zero($3)         }
  ;
%%
