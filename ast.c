#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include "type.h"

ast ast_make(kind k, char c, int n, char str[SIZE], ast l, ast r, Type t) {
  ast p;
  if ((p = malloc(sizeof(struct node))) == NULL)
    exit(1);
  p->k = k;
  p->id = c;
  p->num = n;
  p->left = l;
  p->right = r;
  p->type = t;
  return p;
}


void ast_destroy(ast a) {
  if (a != NULL) {
    if (a->left != NULL)
      ast_destroy(a->left);

    if (a->right != NULL)
      ast_destroy(a->right);

    free(a);
  }
}

ast ast_id(char c){
  return ast_make(ID, c, 0, NULL, NULL, NULL, NULL);
}
ast ast_const(int n){
  return ast_make(CONST, '\0', n, NULL, NULL, NULL, NULL);
}
ast ast_string(char str[SIZE]){
  return ast_make(STRING, '\0', NULL, str, NULL, NULL, NULL);
}
ast ast_op(kind op, ast l, ast r){
  return ast_make(op, '\0', 0, '\0', l, r, NULL);
}
ast ast_ifstmt(ast cond, ast l, ast r){
  return ast_make(IF, '\0', 0, '\0', l, r, NULL);
}

ast ast_seq(ast l, ast r){
  if (l == NULL) return r;
  return ast_make(SEQ, '\0', 0, '\0', l, r, NULL);
}
ast ast_header(char c, ast l, ast r, ast t){
  return ast_make(HEADER, c, 0, '\0', l, r, t);
}
ast ast_fpardef(char c, ast l, ast r){
  return ast_make(FPARDEF, c, 0, '\0', l, r, NULL);
}
ast ast_vardef(char c, ast l, ast r){
  return ast_make(VARDEF, c, 0, '\0', l, r, NULL);
}
ast ast_idlist(ast l, char c){
  return ast_make(IDLIST, c, 0, '\0', l, NULL, NULL);
}
ast ast_funcdecl(ast e){
  return ast_make(FUNCDECL, '\0', 0, '\0', e, NULL, NULL);
}
ast ast_fpartype(ast l, ast r){
  return ast_make(FPARTYPE, '\0', 0, '\0', l, r, NULL);
}
ast ast_intconstlist(ast l, int n){
  return ast_make(INTCONSTLIST, '\0', n, '\0', l, NULL, NULL);
}
ast ast_funccall(char c,ast l,ast r){
  return ast_make(FUNCCALL, c, 0, '\0', l, r, NULL);
}
ast ast_exprlist(ast l,ast r){
  return ast_make(EXPRLIST, '\0', 0, '\0', l, r, NULL);
}
ast ast_lvalue(ast l,ast r){
  return ast_make(LVALUE, '\0', 0, '\0', l, r, NULL);
}
ast ast_reference(ast l,ast r){
  return ast_make(REF, '\0', 0, '\0', l, r, NULL);
}
ast ast_whilestmt(ast cond,ast r){
  return ast_make(WHILE, '\0', 0, '\0', NULL, r, NULL);
}
ast ast_returnstmt(ast e){
  return ast_make(RETURN, '\0', 0, '\0', e, NULL, NULL);
}
ast ast_block(ast e){
  return ast_make(BLOCK, '\0', 0, '\0', e, NULL, NULL);
}
ast ast_num(kind op, int n){
  return ast_make(op, '\0', 0, '\0', NULL, NULL, NULL);
}
ast ast_cond(kind op, ast l, ast r){
  return ast_make(op, '\0', 0, '\0', l, r, NULL);
}