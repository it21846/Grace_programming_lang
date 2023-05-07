%{
#include "parser.tab.h"
%}
%option noyywrap

delim       [\t \n \r \\ \' \" \0]\x{exd}+
ws          {delim}+
l           [A-Za-z]
exd         [0-9a-f]
d           [0-9]

%%

"and"		{return T_and;}
"char"		{return T_char;}
"div"		{return T_div;}
"do"		{return T_do;}
"else"		{return T_else;}
"fun"		{return T_fun;}
"if"		{return T_if;}
"int"		{return T_int;}
"mod"		{return T_mod;}
"not"		{return T_not;}
"nothing"	{return T_nothing;}
"or"		{return T_or;}
"ref"		{return T_ref;}
"return"	{return T_return;}
"then"		{return T_then;}
"var"		{return T_var;}
"while"		{return T_while;}
"="         {return T_eq;}
"+"         {return T_plus;}
"-"         {return T_minus;}
"*"         {return T_mult;}
"("         {return T_lpar;}
")"         {return T_rpar;}
"<="		{return T_leq;}
">="		{return T_geq;}
">"			{return T_gt;}
"<"			{return T_lt;}
"#"			{return T_hash;}
"<>"		{return T_neq;}
"["			{return T_rsqpar;}
"]"			{return T_lsqpar;}
"{"			{return T_rcpar;}
"}"			{return T_lcpar;}
","			{return T_comma;}
";"			{return T_semicol;}
":"			{return T_col;}
"<-"		{return T_reference;}

{l}         {return T_id;}
{d}+        {}

{ws}        {}
\'.*\n      {}

%%
