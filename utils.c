#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *msg) {
  fprintf(stderr, "%s\n", msg);
  exit(1);
}