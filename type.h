#ifndef __TYPE_H__
#define __TYPE_H__

typedef struct Type_tag *Type;

struct Type_tag { 
        enum {
                TYPE_VOID,
                TYPE_INTEGER,
                TYPE_CHAR,
                TYPE_FUNCTION,
                TYPE_ARRAY,
                TYPE_POINTER
        } kind;
};


extern const Type tyINT;
extern const Type tyCHAR;


int equalType (Type type1, Type type2);
void printType (Type type);

#endif