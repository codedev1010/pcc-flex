%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char *s);
%}

%token NUMBER
%token PLUS MINUS MUL DIV LPAREN RPAREN

%left PLUS MINUS
%left MUL DIV
%right UMINUS

%%
input:
    /* empty */
    | input line
    ;

line:
    expr ';'   { printf("Result = %d\n", $1); }
expr:
      NUMBER
    | expr PLUS expr   { $$ = $1 + $3; }
    | expr MINUS expr  { $$ = $1 - $3; }
    | expr MUL expr    { $$ = $1 * $3; }
    | expr DIV expr    { 
                          if ($3 == 0) {
                              yyerror("Division by zero!");
                              $$ = 0;
                          } else {
                              $$ = $1 / $3;
                          }
                       }
    | LPAREN expr RPAREN { $$ = $2; }
    | MINUS expr %prec UMINUS { $$ = -$2; }
    ;
%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Enter expressions:\n");
    yyparse();
    return 0;
}
