%{
#include <stdio.h>
%}

KEYWORD     (SELECT|FROM|WHERE|INSERT|INTO|VALUES|UPDATE|SET|DELETE|CREATE|TABLE|DROP)
IDENTIFIER  [a-zA-Z_][a-zA-Z0-9_]*
NUMBER      [0-9]+
OPERATOR    (\+|\-|\*|\/|=|<|>|<=|>=|!=|AND|OR)
STRING      \'[^\']*\'
PUNCTUATION       [;,()]

%%

{KEYWORD}       { printf("Keyword\t\t: %s\n", yytext); }
{IDENTIFIER}    { printf("Identifier\t: %s\n", yytext); }
{NUMBER}        { printf("Number\t\t: %s\n", yytext); }
{OPERATOR}      { printf("Operator\t: %s\n", yytext); }
{STRING}        { printf("String\t\t: %s\n", yytext); }
{PUNCT}         { printf("Punctuation\t: %s\n", yytext); }
[\n\t ]+        ;   /* ignore whitespace */
.               { printf("Unknown\t\t: %s\n", yytext); }

%%

int main() {
    printf("=== SQL Tokenizer ===\n");
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}
