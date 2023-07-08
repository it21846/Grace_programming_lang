%{
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include "type.h"
#include "symbol.h"
#include "sem.h"

extern int linenumber;
int yylex();
void yyerror(char *msg);

ast p;
%}

%union {
  ast a;
  char c;
  int n;
  Type t;
}

%token<c> T_id
%token<n> T_num
%token<c> T_string
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
%token T_reference "<-"

%type<a> cond expr block stmt l_value 
%type<a> expr_list func_call stmtlst int_const_list 
%type<a> fpar_type func_decl id_list var_def local_def 
%type<a> ret_type data_type type fpar_def fpar_def_list 
%type<a> header local_def_list func_def program

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

program : func_def																								{ p = $$ = $1; }
		    ;																											

func_def : header local_def_list block														{ $$ = ast_funcdef($1,$2,$3); }
         | header block																						{ $$ = ast_funcdef($1,NULL,$2); }
	 	     ;

local_def_list : local_def_list local_def													{ $$ = ast_seq($1,$2); }
							 | local_def																				{ $$ = $1; }
							 ;

header : "fun" T_id '(' fpar_def fpar_def_list ')' ':' ret_type		{ $$ = ast_header($2,$4,$5,$8); }
       | "fun" T_id '(' fpar_def ')' ':' ret_type									{ $$ = ast_header($2,$4,NULL,$7); }
       | "fun" T_id '(' ')' ':' ret_type													{ $$ = ast_header($2,NULL,NULL,$6); }
       ;
       
fpar_def_list : fpar_def_list ';' fpar_def												{ $$ = ast_seq($1,$3); }
							| ';' fpar_def																			{ $$ = $2; }
							;

fpar_def : "ref" T_id id_list ':' fpar_type												{ $$ = ast_fpardef($2,$3,$5); }
		     | T_id id_list ':' fpar_type															{ $$ = ast_fpardef($1,$2,$4); }
		     | "ref" T_id ':' fpar_type																{ $$ = ast_fpardef($2,NULL,$4); }
		     | T_id ':' fpar_type																			{ $$ = ast_fpardef($1,NULL,$3); }
	 	     ;

type : data_type int_const_list																		{ $$ = ast_seq($1,$2); }
     | data_type																									{ $$ = $1; }
     ;

data_type : "int" 																							  { $$ = tyINT; }
		      | "char"																								{ $$ = tyCHAR; }
	  	    ;
	  	    
ret_type : data_type 																							{ $$ = $1; }
		     | "nothing"																							{ $$ = NULL; }
		     ;

local_def : func_def 																							{ $$ = $1; }
		      | func_decl 																						{ $$ = $1; }
		      | var_def																								{ $$ = $1; }
		      ;

var_def : "var" T_id id_list ':' type ';'													{ $$ = ast_vardef($2,$3,$5); }
        | "var" T_id ':' type ';'																	{ $$ = ast_vardef($2,NULL,$4); }
        ;

id_list : id_list ',' T_id																				{ $$ = ast_idlist($1,$3); }
				| ',' T_id																								{ $$ = $2; }
				;

func_decl : header ';'																						{ $$ = ast_funcdecl($1); }
	  	    ;
	  	    
fpar_type : data_type '[' ']' int_const_list											{ $$ = ast_fpartype($1,$4); }
          | data_type int_const_list															{ $$ = ast_fpartype($1,$2); }
          | data_type '[' ']'																			{ $$ = ast_fpartype($1,NULL); }
          | data_type																							{ $$ = ast_fpartype($1,NULL); }
		      ;

int_const_list : int_const_list '[' T_num ']'											{ $$ = ast_intconstlist($1,$3); }
							 | '[' T_num ']'																		{ $$ = ast_intconstlist(NULL,$2); }
							 ;

stmtlst : stmtlst stmt																						{ $$ = ast_seq($1,$2); }
        | stmt																										{ $$ = $1; }
        ;

func_call : T_id  '(' expr expr_list ')'													{ $$ = ast_funccall($1,$3,$4); }
          | T_id  '(' expr ')'																		{ $$ = ast_funccall($1,$3,NULL); }
		      | T_id  '(' ')'																					{ $$ = ast_funccall($1,NULL,NULL); }
		      ;

expr_list : expr_list ',' expr																		{ $$ = ast_exprlist($1,$3); }
					| ',' expr																							{ $$ = ast_exprlist($2); }
					;

l_value : T_id																										{ $$ = ast_id($1); }
				| T_string																								{ $$ = ast_string($1); }
				| T_charconst																							{ $$ = NULL; }
		    | l_value '[' expr ']'																		{ $$ = ast_lvalue($1,$3); }
		    ;

stmt : ';' 																												{ $$ = NULL; }
	   | l_value "<-" expr ';' 																			{ $$ = ast_reference($1,$3); }	
	   | block 																											{ $$ = $1; }
	   | var_def																										{ $$ = $1; }
	   | func_call ';'																							{ $$ = $1; }
	   | "if" cond "then" stmt																			{ $$ = ast_ifstmt($2,$4,NULL); }
	   | "if" cond "then" stmt "else" stmt													{ $$ = ast_ifstmt($2,$4,$6); }
	   | "while" cond "do" stmt																			{ $$ = ast_whilestmt($2,$4); }
	   | "return" expr ';'																					{ $$ = ast_returnstmt($2); }
	   | "return" ';'																								{ $$ = ast_returnstmt(NULL); }
	   ;

block : '{' stmtlst '}'																						{ $$ = ast_block($2); }
      | '{''}'																										{ $$ = ast_block(NULL); }
	    ;

expr : expr '+' expr																							{ $$ = ast_op(PLUS,$1,$3); }
     | expr '-' expr																							{ $$ = ast_op(MINUS,$1,$3); }
     | expr '*' expr																							{ $$ = ast_op(MULT,$1,$3); }
     | expr '/' expr																							{ $$ = ast_op(DIV,$1,$3); }
		 | expr "mod" expr 																						{ $$ = ast_op(MOD,$1,$3); }
     | l_value 																										{ $$ = $1; }
	   | func_call																									{ $$ = $1; }
     | '(' expr ')'																								{ $$ = $2; }
     | T_num																											{ $$ = ast_num(NULL,$1); }
		 | '+' T_num																									{ $$ = ast_num(PLUS,$2); }
		 | '-' T_num																									{ $$ = ast_num(MINUS,$2); }
     ;

cond : '(' cond ')'																								{ $$ = $2; }
	   | "not" cond																									{ $$ = ast_cond(NOT,$2, NULL); }
	   | cond "and" cond																						{ $$ = ast_cond(AND,$1, $3); }
	   | cond "or" cond																							{ $$ = ast_cond(OR,$1, $3); }
	   | expr '=' expr																							{ $$ = ast_cond(EQ,$1,$3); }
     | expr '#' expr																							{ $$ = ast_cond(NEQ,$1,$3); }
	   | expr '<' expr																							{ $$ = ast_cond(LT,$1,$3); }
	   | expr '>' expr																							{ $$ = ast_cond(GT,$1,$3); }
	   | expr "<=" expr																							{ $$ = ast_cond(LEQ,$1,$3); }			
	   | expr ">=" expr																							{ $$ = ast_cond(GEQ,$1,$3); }
	   ;

%%

void yyerror(const char *msg) {
  fprintf(stderr, "line %d: %s\n", linenumber, msg);
  exit(1);
}

int main() {
        int result = yyparse();
        if (result != 0) fprintf(stderr, "Failure.\n");
        initSymbolTable(999);
        openScope();
        ast_sem(p);
        closeScope();
        destroySymbolTable();
        return result;
}
