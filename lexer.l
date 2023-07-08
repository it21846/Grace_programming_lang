%{
#include "parser.h"
%}
%option noyywrap

delim       [ \t\n\"\0\'\\]
ws          {delim}+
l           [A-Za-z]
word        {l}+
d           [0-9]

/* Universal Character Name */
UCN (\\u[0-9a-fA-F]{4}|\\U[0-9a-fA-F]{8})

charconst  \'([^'\\]|\\['"?\\abfnrtv]|\\[0-7]{1,3}|\\[Xx][0-9a-fA-F]+|{UCN})+\'
string      L?\"([^"\\]|\\['"?\\abfnrtv]|\\[0-7]{1,3}|\\[Xx][0-9a-fA-F]+|{UCN})*\"


%%

"if"      { return T_if; }
"then"    { return T_then; }
"else"    { return T_else; }
"do"      { return T_do; }
"fun"		  {return T_fun;}
"while"		{return T_while;}
"return"	{return T_return;}
"int"		  {return T_int;}
"char"    {return T_char;}
"nothing"	{return T_nothing;}
"ref"		  {return T_ref;}
"var"		  {return T_var;}
"and"		  {return T_and;}
"or"		  {return T_or;}
"not"		  {return T_not;}
"mod"     {return T_mod;}

"<="		  {return T_leq;}
">="		  {return T_geq;}
"<>"		  {return T_neq;}
"<-"		  {return T_reference;}

{ws}      {}

[=+\-\(\)\{\}\[\]*#/:;!.,<>]  {return yytext[0];}

{word}          { return T_id; }
{d}+            { return T_num; }
{charconst}		{return T_charconst;}
{string}        { return T_string; }

\'.*\n          {}
.         {fprintf(stderr, "Illegal character: %c (ASCII: %d)\n",yytext[0], yytext[0]);}

%%
