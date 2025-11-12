%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s){ fprintf(stderr,"Error: %s\n",s); }
%}

%union{
  char *id;
}

%token <id> ID
%token INT FLOAT CHAR RETURN
%token ASSIGN PLUS MINUS MUL DIV
%token SEMI COMMA LPAREN RPAREN LBRACE RBRACE
%token NUMBER

%left PLUS MINUS
%left MUL DIV
%start program

%%
program
  : lines
  ;

lines
  : /* empty */
  | lines line
  ;

line
  : declaration
  | assignment
  | return_stmt
  ;

declaration
  : type varlist SEMI      { printf("Declaration OK\n"); }
  ;

type
  : INT
  | FLOAT
  | CHAR
  ;

varlist
  : ID
  | varlist COMMA ID
  ;

assignment
  : ID ASSIGN expr SEMI    { printf("Assignment OK\n"); }
  ;

return_stmt
  : RETURN expr SEMI       { printf("Return OK\n"); }
  ;

expr
  : NUMBER
  | ID
  | expr PLUS expr
  | expr MINUS expr
  | expr MUL expr
  | expr DIV expr
  | LPAREN expr RPAREN
  ;
%%
int main(void){
  yyparse();
  printf("\nParsing completed successfully.\n");
  return 0;
}
