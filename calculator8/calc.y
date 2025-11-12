%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);

int tempCount=0,labelCount=0;
char *newtemp(){ char *t=malloc(8); sprintf(t,"t%d",tempCount++); return t; }
char *newlabel(){ char *l=malloc(8); sprintf(l,"L%d",labelCount++); return l; }
%}

%union{
  int num;
  char *id;
  char *code;
}

%token <num> NUMBER
%token <id>  ID
%token IF THEN ELSE WHILE
%token ASSIGN LT GT
%token PLUS MINUS MUL DIV
%token LPAREN RPAREN NEWLINE
%left PLUS MINUS
%left MUL DIV
%left LT GT
%type <code> stmt expr cond

%%
program
  : /* empty */
  | program stmt
  ;

stmt
  : ID ASSIGN expr NEWLINE     { printf("%s = %s\n", $1, $3); }

  | IF cond THEN stmt ELSE stmt NEWLINE
      {
        char *l1=newlabel(), *l2=newlabel(), *l3=newlabel();
        printf("if %s goto %s\n", $2, l1);
        printf("goto %s\n", l2);
        printf("%s:\n", l1);
        printf("%s\n", $4);
        printf("goto %s\n", l3);
        printf("%s:\n", l2);
        printf("%s\n", $6);
        printf("%s:\n", l3);
      }

  | WHILE cond stmt NEWLINE
      {
        char *l1=newlabel(), *l2=newlabel();
        printf("%s:\n", l1);
        printf("if %s goto %s_body\n", $2, l1);
        printf("%s_body:\n%s\n", l1, $3);
        printf("goto %s\n", l1);
        printf("%s_end:\n", l2);
      }

  | NEWLINE  /* blank line */
  ;

expr
  : NUMBER                { char *t=newtemp(); printf("%s=%d\n",t,$1); $$=t; }
  | ID                    { $$=$1; }
  | expr PLUS expr        { char *t=newtemp(); printf("%s=%s+%s\n",t,$1,$3); $$=t; }
  | expr MINUS expr       { char *t=newtemp(); printf("%s=%s-%s\n",t,$1,$3); $$=t; }
  | expr MUL expr         { char *t=newtemp(); printf("%s=%s*%s\n",t,$1,$3); $$=t; }
  | expr DIV expr         { char *t=newtemp(); printf("%s=%s/%s\n",t,$1,$3); $$=t; }
  ;

cond
  : expr LT expr          { char *t=newtemp(); printf("%s=%s<%s\n",t,$1,$3); $$=t; }
  | expr GT expr          { char *t=newtemp(); printf("%s=%s>%s\n",t,$1,$3); $$=t; }
  ;
%%

void yyerror(const char *s){ fprintf(stderr,"Error: %s\n",s); }
int main(void){ yyparse(); return 0; }
