%{
#include "parser.tab.h"
%}

%%

"true"      { return TRUE; }
"false"     { return FALSE; }

"&&"        { return AND; }
"\|\|"      { return OR; }
"!"         { return NOT; }

"("         { return '('; }
")"         { return ')'; }

[ \t\n]+    { /* skip whitespace */ }

.           { /* ignore invalid chars */ }

%%

int yywrap() { return 1; }
