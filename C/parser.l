%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}

/* -------- Tokens -------- */
%%
"int"      { return INT; }
"float"    { return FLOAT; }
"char"     { return CHAR; }
"return"   { return RETURN; }

[0-9]+(\.[0-9]+)?      { return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.id = strdup(yytext); return ID; }

"="        { return ASSIGN; }
";"        { return SEMI; }
","        { return COMMA; }
"("        { return LPAREN; }
")"        { return RPAREN; }
"{"        { return LBRACE; }
"}"        { return RBRACE; }
"+"        { return PLUS; }
"-"        { return MINUS; }
"*"        { return MUL; }
"/"        { return DIV; }

[ \t\r\n]  ;        /* ignore whitespace */
.          ;        /* ignore anything else */
%%

int yywrap(void){ return 1; }
