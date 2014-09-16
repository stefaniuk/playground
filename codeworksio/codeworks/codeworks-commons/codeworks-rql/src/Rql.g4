grammar Rql;

// TODO: https://github.com/cmhulett/ANTLR-java-calculator

// FIXME: Not every parameter is a type of VALUE

/*------------------------------------------------------------------------------
 * PARSER RULES
 *----------------------------------------------------------------------------*/

query
    : cond
    | cond (','|';') order
    | cond (','|';') range
    | cond (','|';') order (','|';') range
    ;

cond
    : op                                # CondOp
    | '(' cond ')'                      # Group
    | 'and' '(' cond (',' cond)+ ')'    # And
    | cond ('&'|'&&') cond              # And
    | 'or' '(' cond (',' cond)+ ')'     # Or
    | cond ('|'|'||') cond              # Or
    ;

op
    : eq
    | ne
    | gt
    | ge
    | lt
    | le
    | in
    ;

eq
    : 'eq' '(' IDENTIFIER ',' VALUE ')'
    | IDENTIFIER '==' VALUE
    | IDENTIFIER '=' VALUE
    ;
ne
    : 'ne' '(' IDENTIFIER ',' VALUE ')'
    | IDENTIFIER '!=' VALUE
    ;
gt
    : 'gt' '(' IDENTIFIER ',' VALUE ')'
    | IDENTIFIER '=gt=' VALUE
    | IDENTIFIER '>' VALUE
    ;
ge
    : 'ge' '(' IDENTIFIER ',' VALUE ')'
    | IDENTIFIER '=ge=' VALUE
    | IDENTIFIER '>=' VALUE
    ;
lt
    : 'lt' '(' IDENTIFIER ',' VALUE ')'
    | IDENTIFIER '=lt=' VALUE
    | IDENTIFIER '<' VALUE
    ;
le
    : 'le' '(' IDENTIFIER ',' VALUE ')'
    | IDENTIFIER '=le=' VALUE
    | IDENTIFIER '<=' VALUE
    ;
in
    : 'in' '(' IDENTIFIER ',' VALUE (',' VALUE)+ ')'
    | IDENTIFIER '==' VALUE (',' VALUE)+
    | IDENTIFIER '=' VALUE (',' VALUE)+
    ;

order
    : 'sort' '(' (SIGN)? IDENTIFIER (',' (SIGN)? IDENTIFIER)* ')'
    | 'sort' '(' IDENTIFIER (SIGN)? (',' IDENTIFIER (SIGN)?)* ')'
    | (SIGN)? IDENTIFIER (',' (SIGN)? IDENTIFIER)*
    | IDENTIFIER (SIGN | 'desc' | 'asc')? (',' IDENTIFIER (SIGN | 'desc' | 'asc')?)*
    ;

range
    : VALUE
    | VALUE ',' VALUE
    | 'limit' '(' VALUE ')'
    | 'limit' '(' VALUE ',' VALUE ')'
    | 'page' '(' VALUE ',' VALUE ')'
    ;

/*------------------------------------------------------------------------------
 * LEXER RULES
 *----------------------------------------------------------------------------*/

IDENTIFIER
    : [a-zA-Z_] [a-zA-Z_0-9]*
    ;

VALUE
    : STRING
    | NUMBER
    | BOOLEAN
    | NULL
    ;

SIGN
    : '-'
    | '+'
    ;

fragment STRING
    : '"' ('*'|'%')? (~[*%"\r\n])* ('*'|'%')? '"'
    | '\'' ('*'|'%')? (~[*%'\r\n])* ('*'|'%')? '\''
    ;

fragment NUMBER
    : (SIGN)? INTEGER
    | (SIGN)? FLOAT
    ;

fragment INTEGER
    : [0-9]+
    ;

fragment FLOAT
    : [0-9]+ '.' [0-9]* 
    | '.' [0-9]+
    ;

fragment BOOLEAN
    : 'false'
    | 'true'
    ;

fragment NULL
    : 'null'
    ;

WS
    : [ \t]+ -> skip
    ;
