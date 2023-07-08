#include <stdio.h>
#include <stdlib.h>
#include "sem.h"
#include "error.h"
#include "symbol.h"
#include "type.h"

SymbolEntry * lookup(char c) {
  char name[] = " ";
  name[0] = c;
  printf("Lookup %s\n", name);
  return lookupEntry(name, 1);
}

SymbolEntry* insert(char c, Type t) {
    char name[] =  " ";
    name[0] = c;
    printf("Insert %s\n", name);
    return newEntry(name, t);
}

void ast_sem(ast a) {
    if (a == NULL) return;
    switch (a->k) {
    case STRING:
        printf("String()");
        return;
    case HEADER: 
        ast_sem(a->left);
        ast_sem(a->right);
        return;
    case FPARDEF: 
        ast_sem(a->left);
        ast_sem(a->right);
        return;
    case VARDEF: 
        ast_sem(a->left);
        ast_sem(a->right);;
        return;
    case IDLIST: 
        ast_sem(a->left);
        return;
    case FUNCDECL: 
        ast_sem(a->left);
        return;
    case FPARTYPE: 
        ast_sem(a->left);
        ast_sem(a->right);
        return;
    case INTCONSTLIST: 
        ast_sem(a->left);
        return;
    case FUNCCALL: 
        ast_sem(a->left);
        ast_sem(a->right);
        return;
    case EXPRLIST: 
        ast_sem(a->left);
        ast_sem(a->right);
        return;
    case LVALUE: 
        ast_sem(a->left);
        ast_sem(a->right);
        return;
    case REF: 
        ast_sem(a->left);
        ast_sem(a->right);
        return;
    case RETURN: 
        ast_sem(a->left);
        return;
    case BLOCK:
        openScope();
        ast_sem(a->left);
        closeScope();
        return;
    case WHILE:
        ast_sem(a->left);
        if (!equalType(a->left->type, tyINT))
            error("for loop expects an integer number");
        ast_sem(a->right);
        return;
    case IF:
        ast_sem(a->left);
        if (!equalType(a->left->type, tyINT))
            error("if expects a int condition");
        ast_sem(a->right);
        return;
    case ID: 
        SymbolEntry *e = lookup(a->id);
        a->type = e->type;
        return;
    case CONST: 
        a->type = tyINT;
        return;
    case SEQ:
        ast_sem(a->left);
        ast_sem(a->right);
        return;
    case PLUS:
        ast_sem(a->left);
        ast_sem(a->right);
        if (!equalType(a->left->type, tyINT) ||
                !equalType(a->right->type, tyINT))
            error("type mismatch in + operator");
        a->type = tyINT;
        return;
    case MINUS:
        ast_sem(a->left);
        ast_sem(a->right);
        if (!equalType(a->left->type, tyINT) ||
                !equalType(a->right->type, tyINT))
            error("type mismatch in - operator");
        a->type = tyINT;
        return;
    case MULT: 
        ast_sem(a->left);
        ast_sem(a->right);
        if (!equalType(a->left->type, tyINT) ||
                !equalType(a->right->type, tyINT))
            error("type mismatch in * operator");
        a->type = tyINT;
        return;
    case DIV: 
        ast_sem(a->left);
        ast_sem(a->right);
        if (!equalType(a->left->type, tyINT) ||
                !equalType(a->right->type, tyINT))
            error("type mismatch in / operator");
        a->type = tyINT;
        return;
    case MOD: 
        ast_sem(a->left);
        ast_sem(a->right);
        if (!equalType(a->left->type, tyINT) ||
                !equalType(a->right->type, tyINT))
            error("type mismatch in 'mod' operator");
        a->type = tyINT;
        return;
    case NOT: 
        ast_sem(a->left);
        ast_sem(a->right);
        if (!equalType(a->left->type, tyINT) ||
                !equalType(a->right->type, tyINT))
            error("type mismatch in 'not' operator");
        a->type = tyINT;
        return;
    case AND: 
        ast_sem(a->left);
        ast_sem(a->right);
        if (!equalType(a->left->type, tyINT) ||
                !equalType(a->right->type, tyINT))
            error("type mismatch in 'and' operator");
        a->type = tyINT;
        return;
    case OR: 
        ast_sem(a->left);
        ast_sem(a->right);
        if (!equalType(a->left->type, tyINT) ||
                !equalType(a->right->type, tyINT))
            error("type mismatch in 'or' operator");
        a->type = tyINT;
        return;
    case EQ: 
        ast_sem(a->left);
        ast_sem(a->right);
        if (!equalType(a->left->type, tyINT) ||
                !equalType(a->right->type, tyINT))
            error("type mismatch in = operator");
        a->type = tyINT;
        return;
    case NEQ: 
        ast_sem(a->left);
        ast_sem(a->right);
        if (!equalType(a->left->type, tyINT) ||
                !equalType(a->right->type, tyINT))
            error("type mismatch in # operator");
        a->type = tyINT;
        return;
    case LT: 
        ast_sem(a->left);
        ast_sem(a->right);
        if (!equalType(a->left->type, tyINT) ||
                !equalType(a->right->type, tyINT))
            error("type mismatch in < operator");
        a->type = tyINT;
        return;
    case GT: 
        ast_sem(a->left);
        ast_sem(a->right);
        if (!equalType(a->left->type, tyINT) ||
                !equalType(a->right->type, tyINT))
            error("type mismatch in > operator");
        a->type = tyINT;
        return;
    case LEQ: 
        ast_sem(a->left);
        ast_sem(a->right);
        if (!equalType(a->left->type, tyINT) ||
                !equalType(a->right->type, tyINT))
            error("type mismatch in <= operator");
        a->type = tyINT;
        return;
    case GEQ: 
        ast_sem(a->left);
        ast_sem(a->right);
        if (!equalType(a->left->type, tyINT) ||
                !equalType(a->right->type, tyINT))
            error("type mismatch in >= operator");
        a->type = tyINT;
        return;
    }
}