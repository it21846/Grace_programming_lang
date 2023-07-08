#ifndef AST_H
#define AST_H

#include "symbol.h"

#define SIZE 50

typedef enum {
  IF, SEQ, STRING, HEADER, FPARDEF, VARDEF,
  IDLIST, FUNCDECL, FPARTYPE, INTCONSTLIST,
  FUNCCALL, EXPRLIST, LVALUE, REF, WHILE,
  RETURN, BLOCK, FUNCDEF,
  ID, CONST, PLUS, MINUS, MULT, DIV, MOD,
  NOT, AND, OR, EQ, NEQ, LT, GT, LEQ, GEQ
} kind;

typedef struct node {
  kind k;
  char id;
  int num;
  char str[SIZE];
  struct node *left, *right;
  Type type;
} *ast;

ast ast_id(char c);
ast ast_const(int n);
ast ast_string(char s[SIZE]);
ast ast_op(kind op, ast l, ast r);
ast ast_ifstmt(ast cond, ast l, ast r);

ast ast_seq(ast l, ast r);
ast ast_header(char c, ast l, ast r, ast t);
ast ast_fpardef(char c, ast l, ast r);
ast ast_vardef(char c, ast l, ast r);
ast ast_idlist(ast l, char c);
ast ast_funcdecl(ast e);
ast ast_fpartype(ast l, ast r);
ast ast_intconstlist(ast l, int n);
ast ast_funccall(char c,ast l,ast r);
ast ast_exprlist(ast l,ast r);
ast ast_lvalue(ast l,ast r);
ast ast_reference(ast l,ast r);
ast ast_whilestmt(ast cond,ast r);
ast ast_returnstmt(ast e);
ast ast_block(ast e);
ast ast_num(kind op, int n);
ast ast_cond(kind op, ast l, ast r);


void destroy_ast(ast a);

#endif 