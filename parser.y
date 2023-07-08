%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(char *msg);

%}

%token T_id
%token T_num
%token T_string
%token T_charconst
%token T_if "if"
%token T_then "then"
%token T_else "else"
%token T_do "do"
%token T_fun "fun"
%token T_return "return"
%token T_while "while"
%token T_char "char"
%token T_int "int"
%token T_nothing "nothing"
%token T_ref "ref"
%token T_var "var"
%token T_mod "mod"

%token T_not "not"
%token T_and "and"
%token T_or  "or"
%token T_leq "<="
%token T_geq ">="
%token T_neq "<>"
%token T_reference "<-"

%expect 1
%left ';' 
%right "not"
%left '*' '/' '#' "mod"
%left '+' '-'
%left '<' '>' "<=" ">="
%left "<>" '='
%left "and"
%left "or"
%left "<-"
%left ','

%start program
%%

program : func_def
		    ;

func_def : header local_def_list block
         | header block
	 	     ;

local_def_list : local_def_list local_def
							 | local_def
							 ;

header : "fun" T_id '(' fpar_def fpar_def_list ')' ':' ret_type
       | "fun" T_id '(' fpar_def ')' ':' ret_type
       | "fun" T_id '(' ')' ':' ret_type
       ;
       
fpar_def_list : fpar_def_list ';' fpar_def
							| ';' fpar_def
							;

fpar_def : "ref" T_id id_list ':' fpar_type
		     | T_id id_list ':' fpar_type
		     | "ref" T_id ':' fpar_type
		     | T_id ':' fpar_type
	 	     ;

type : data_type int_const_list
     | data_type
     ;

data_type : "int" 
		      | "char"
	  	    ;
	  	    
ret_type : data_type 
		     | "nothing"
		     ;

local_def : func_def 
		      | func_decl 
		      | var_def
		      ;

var_def : "var" T_id id_list ':' type ';'
        | "var" T_id ':' type ';'
        ;

id_list : id_list ',' T_id
				| ',' T_id
				;

func_decl : header ';'
	  	    ;
	  	    
fpar_type : data_type '[' ']' int_const_list
          | data_type int_const_list
          | data_type '[' ']'
          | data_type
		      ;

int_const_list : int_const_list '[' T_num ']'
							 | '[' T_num ']'
							 ;

stmtlst : stmtlst stmt
        | stmt
        ;

func_call : T_id  '(' expr expr_list ')'
          | T_id  '(' expr ')'
		      | T_id  '(' ')'
		      ;

expr_list : expr_list ',' expr
					| ',' expr
					;

l_value : T_id
				| T_string
				| T_charconst
		    | l_value '[' expr ']'
		    ;

stmt : ';' 
	   | l_value "<-" expr ';' 
	   | block 
	   | var_def
	   | func_call ';'
	   | "if" cond "then" stmt
	   | "if" cond "then" stmt "else" stmt
	   | "while" cond "do" stmt
	   | "return" expr ';'
	   | "return" ';'
	   ;

block : '{' stmtlst '}'
      | '{''}'
	    ;

expr : expr '+' expr
     | expr '-' expr
     | expr '*' expr
     | expr '/' expr
		 | expr "mod" expr 
     | l_value 
	   | func_call
     | '(' expr ')'
     | T_num
		 | '+' T_num
		 | '-' T_num
     ;

cond : '(' cond ')'
	   | "not" cond
	   | cond "and" cond
	   | cond "or" cond
	   | expr '=' expr
     | expr '#' expr
	   | expr '<' expr
	   | expr '>' expr
	   | expr "<=" expr
	   | expr ">=" expr
	   | expr "<>" expr
	   ;

%%

void yyerror(char *msg) {
  fprintf(stderr, "%s\n", msg);
  exit(1);
}

int main() {
  int result = yyparse();
  if (result == 0) 
    printf("Success.\n");
  else
    printf("Failure.\n");

  return result;
}
