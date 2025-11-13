%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char *s) { printf("Error: %s\n", s); }

%}

%token TRUE FALSE
%token AND OR NOT

%left OR
%left AND
%right NOT

%%

input:
    expr { printf("Result = %d\n", $1); }
    ;

expr:
      TRUE       { $$ = 1; }
    | FALSE      { $$ = 0; }
    | expr AND expr   { $$ = ($1 && $3); }
    | expr OR expr    { $$ = ($1 || $3); }
    | NOT expr        { $$ = (!$2); }
    | '(' expr ')'    { $$ = $2; }
    ;

%%

int main() {
    printf("Reading from input.txt...\n");
    yyparse();
    return 0;
}
