grammar Grammar;

prog
    : ID '=' INT
    ;

ID
    : [a-z]+
    ;

INT
    : [0-9]+
    ;

WS
    : [ \t\r\n]+ -> skip
    ;
