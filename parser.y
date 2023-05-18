%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char *msg);

%}

%token T_id
%token T_num

%token T_and "and"
%token T_char "char"
%token T_div "div"
%token T_do "do"
%token T_else "else"
%token T_fun "fun"
%token T_if "if"
%token T_int "int"
%token T_mod "mod"
%token T_not "not"
%token T_nothing "nothing"
%token T_or "or"
%token T_ref "ref"
%token T_return "return"
%token T_then "then"
%token T_var "var"
%token T_while "while"
%token T_leq "<="
%token T_geq ">="
%token T_neq "<>"
%token T_reference "<-"
%token T_eq "="
%token T_plus "+"  
%token T_minus "-"         
%token T_mult "*"         
%token T_lpar "("          
%token T_rpar ")"
%token T_gt ">"		
%token T_lt "<"			
%token T_hash "#"			
%token T_rsqpar "["			
%token T_lsqpar "]"			
%token T_rcpar "{"			
%token T_lcpar "}"			
%token T_comma ","			
%token T_semicol ";"			
%token T_col ":"			


%left ","
%left "<-"
%left "or"
%left "and"
%left "<>" "="
%left "<" ">" "<=" ">="
%left "+" "-"
%left "*" "div" "mod"
%right "not"
%left ";"

%start program

%%

program : func_def
		;

local_def_list : local_def_list local_def
			   | local_def
			   ;

func_def : header local_def_list block
	 	 ;

fpar_def_list : fpar_def_list ";" fpar_def
			  | fpar_def
			  ;
	 
header : "fun" T_id "(" fpar_def_list ")" ":" ret_type
	   | "fun" T_id "(" ")" ":" ret_type
       ;

id_list : id_list "," T_id
		| T_id
		;

fpar_def : "ref" id_list ":" fpar_type
		 | id_list ":" fpar_type
	 	 ;

data_type : "int" 
		  | "char"
	  	  ;      

int_const_list : int_const_list "[" int_const "]"
			   | "[" int_const "]"
			   ;

type : data_type int_const_list
     ;

ret_type : data_type 
		 | "nothing"
		 ;

fpar_type : data_type "[" "]" int_const_list
		  | data_type int_const_list
		  ;

local_def : func_def 
		  | func_decl 
		  | var_def
		  ;

var_def : "var" id_list ":" type ";"
        ;

func_decl : header ";"
	  	  ;

stmt : ";" 
	 | l_value "<-" expr ";" 
	 | block 
	 | func_call ";"
	 | "if" cond "then" stmt
	 | "if" cond "then" stmt_withelse "else" stmt
	 | "while" cond "do" stmt
	 | "return" expr ";"
	 | "return" ";"
	 ;

stmt_withelse : "if" cond "then" stmt_withelse "else" stmt_withelse
			  ;

stmt_list : stmt_list stmt
		  | stmt
		  ;

block : "{" stmt_list "}"
	  | "{""}"
	  ;

expr_list : expr_list "," expr
		  | expr
		  ;

func_call : T_id "(" expr_list ")"
		  | T_id "("")"
		  ;

l_value : T_id 
		| string_literal 
		| l_value "[" expr "]"
		;

prefix_expr : "+" expr
			| "-" expr
			;

arithmetic_expr : expr "+" expr
				| expr "-" expr
				| expr "*" expr
				| expr "div" expr
				| expr "mod" expr
				;

expr : int_const 
	 | char_const
	 | l_value 
	 | func_call 
	 | "(" expr ")"
	 | prefix_expr 
	 | arithmetic_expr
	 ;

logical_cond : cond "and" cond
			 | cond "or" cond
			 ;

arithmetic_cond : expr "=" expr
				| expr "#" expr
				| expr "<" expr
				| expr ">" expr
				| expr "<=" expr
				| expr ">=" expr
				| expr "<>" expr
				;

cond : "(" cond ")"
	 | "not" cond
	 | logical_cond
	 | arithmetic_cond
	 ;

int_const : "int"
		  ;

string_literal : string_literal char_const
			   | char_const
			   ;

char_const : "char"
		   ;

%%

int main() {

    int result = yyparse();
    
	if (result == 0) 
		printf("Success.\n");
    else
		printf("Failure.\n");

	return result;
}
