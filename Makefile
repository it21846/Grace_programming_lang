.PHONY: ubas


grace: lex.yy.c parser.tab.c utils.c
	gcc lex.yy.c parser.tab.c utils.c -o grace

lex.yy.c: lexer.l parser.tab.h
	flex -o lex.yy.c lexer.l

parser.tab.c parser.tab.h: parser.y
	bison -H -o parser.tab.c parser.y

clean:
	rm -f *.o ubas

distclean: clean
	rm -f ubas lex.yy.c parser.tab.c parser.tab.h grace
