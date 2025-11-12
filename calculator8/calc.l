%{
#include "calc.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%
"if"        { return IF; }
"then"      { return THEN; }
"else"      { return ELSE; }
"while"     { return WHILE; }

[0-9]+                { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9]*  { yylval.id  = strdup(yytext); return ID; }

"<"       { return LT; }
">"       { return GT; }
"="       { return ASSIGN; }
"("       { return LPAREN; }
")"       { return RPAREN; }
"+"       { return PLUS; }
"-"       { return MINUS; }
"*"       { return MUL; }
"/"       { return DIV; }

[ \t\r]   ;             /* ignore spaces/tabs/carriage returns   */
\n        { return NEWLINE; }  /* newline ends a statement        */
.         ;             /* ignore stray characters               */
%%

int yywrap(void){ return 1; }
