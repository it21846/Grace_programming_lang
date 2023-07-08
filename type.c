#include "type.h"
#include <stdio.h>

static struct Type_tag typeConst [] = {
        { TYPE_VOID },
        { TYPE_INTEGER },
        { TYPE_CHAR }
};
const Type tyVOID = &(typeConst[0]);
const Type tyINT  = &(typeConst[1]);
const Type tyCHAR = &(typeConst[2]);

int equalType(Type type1, Type type2) {
  return (type1->kind == type2->kind);
}

void printType (Type type)
{
        if (type == NULL) {
                printf("<undefined>");
                return;
        }
  switch (type->kind) {
  case TYPE_VOID:
          printf("void");
          break;
  case TYPE_INTEGER:
          printf("int");
          break;
  case TYPE_CHAR:
          printf("char");
  default:
          printf("unknown");
          break;
  }
}