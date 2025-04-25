%{
#include "parser.tab.h"
#include <string.h> 
%}

digit      [0-9]+
ws         [ \t]+
variable   [a-zA-Z]+[0-9]*

%%

"draw"              return DRAW;
"set"               return SET;
"line"              return LINE;
"circle"            return CIRCLE;
"triangle"          return TRIANGLE;
"color"             return COLOR;
"=>"                return ASSIGN;
"--".*              return COMMENT;
"+"                 return PLUS;
"-"                 return MINUS;
"/"                 return DIVIDE;
"^"                 return POWER;
"if"                return IF;
"else"              return ELSE;
">"                 return BIGGER;
"<"                 return SMALLER;
"=="                return ISEQUAL;
\n                  return EOL;

{variable}          { yylval.string = strdup(yytext); return VARIABLE; }
{digit}             { yylval.num = atoi(yytext); return NUMBER; }
{ws}                ;

.                   return yytext[0];

%%

int yywrap() {
    return 1;
}

