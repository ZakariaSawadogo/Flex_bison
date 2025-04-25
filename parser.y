%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
extern int yylex();
int yyerror(const char *s);

typedef struct {
    char *name;
    int value;
} Variable;

int var_count = 0;
Variable symbol_table[100];

int get_variable_value(const char *name) {
    for (int i = 0; i < var_count; ++i) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return symbol_table[i].value;
        }
    }
    fprintf(stderr, "Undefined variable: %s\n", name);
    exit(1);
}


void set_variable_value(const char *name, int value) {
    for (int i = 0; i < var_count; ++i) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            symbol_table[i].value = value;
            return;
        }
    }
    symbol_table[var_count].name = strdup(name);
    symbol_table[var_count].value = value;
    var_count++;
}

%}

%union {
    int num;
    char *string;
    bool boolean;

}

%token DRAW SET ASSIGN 
%token LINE CIRCLE TRIANGLE
%token COLOR
%token <string> VARIABLE 
%token <num> NUMBER
%type <num> exp
%type <boolean> boolean
%token COMMENT
%token PLUS MINUS DIVIDE POWER
%token IF ELSE
%token BIGGER SMALLER ISEQUAL
%token EOL

%%

line:
    sentences
    ;

sentences:
    
    | sentences sentence optional_EOL
    ;

optional_EOL:
      
    | EOL
    ;

sentence:
      DRAW LINE exp exp exp exp               { printf("Draw line from (%d,%d) to (%d,%d)\n", $3, $4, $5, $6); }
    | DRAW CIRCLE exp exp exp                 { printf("Draw circle at (%d,%d) with radius %d\n", $3, $4, $5); }
    | DRAW TRIANGLE exp exp exp exp           { printf("Draw triangle at (%d,%d) with side %d and height %d\n", $3, $4, $5, $6)}
    | SET COLOR exp exp exp                   { printf("Set color to RGB(%d, %d, %d)\n", $3, $4, $5); }
    | VARIABLE ASSIGN exp                     { set_variable_value($1, $3); }
    | IF boolean sentence                     { if ($2); else return }
    | IF boolean sentence ELSE sentence       { if ($2) $3; else $5; }
    | COMMENT
    ;

boolean:
      exp BIGGER exp  { $$ = ($1 > $3); }
    | exp SMALLER exp { $$ = ($1 < $3); }
    | exp ISEQUAL exp { $$ = ($1 == $3); }
exp:
    NUMBER
  | VARIABLE { $$ = get_variable_value($1); }
  | exp PLUS exp { $$ = $1 + $3; }
  | exp MINUS exp { $$ = $1 - $3; }
  | exp DIVIDE exp { $$ = $1 / $3; }
  | exp POWER exp { $$ = pow($1, $3); }
  ;


%%

int main() {
    return yyparse();
}

int yyerror(const char *s) {
    fprintf(stderr, "Error: line: %s\n", s);
    return 1;
}
