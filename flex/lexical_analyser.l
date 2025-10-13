%{
#include <stdio.h>
#include <string.h>

int keyword_count = 0, identifier_count = 0, number_count = 0, operator_count = 0, special_count = 0;

// list of keywords
char keywords[][10] = {"if", "else", "while", "int", "float", "return", "for", "char", "double", "void"};

int isKeyword(char *word) {
    for (int i = 0; i < 10; i++) {
        if (strcmp(keywords[i], word) == 0)
            return 1;
    }
    return 0;
}
%}

%%

[ \t\n]+                     ; // ignore whitespaces
"//".*                       ; // ignore single-line comments
"/*"([^*]|\*+[^*/])*\*+"/"   ; // ignore multi-line comments
[0-9]+(\.[0-9]+)?            { printf("NUMBER\t\t: %s\n", yytext); number_count++; }
[a-zA-Z_][a-zA-Z0-9_]*       {
                                if (isKeyword(yytext)) {
                                    printf("KEYWORD\t\t: %s\n", yytext);
                                    keyword_count++;
                                } else {
                                    printf("IDENTIFIER\t: %s\n", yytext);
                                    identifier_count++;
                                }
                             }
[+\-*/%=<>!]+                { printf("OPERATOR\t: %s\n", yytext); operator_count++; }
[{}()\[\];,]                 { printf("SPECIAL SYMBOL\t: %s\n", yytext); special_count++; }

.                            ; // ignore any other character

%%

int main() {
    printf("\n--- Lexical Analyzer Output ---\n\n");
    yylex();

    printf("\nSummary:\n");
    printf("Keywords\t: %d\n", keyword_count);
    printf("Identifiers\t: %d\n", identifier_count);
    printf("Numbers\t\t: %d\n", number_count);
    printf("Operators\t: %d\n", operator_count);
    printf("Special Symbols\t: %d\n", special_count);
    return 0;
}
int yywrap() {
    return 1;
}