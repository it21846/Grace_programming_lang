.PHONY: ubas


grace: lexer.c parser.c
	$(CC) $^ -o $@

lexer.c: lexer.l parser.h
	flex -o lexer.c lexer.l

parser.c parser.h: parser.y
	bison -H -o parser.c parser.y

clean:
	rm -f *.o ubas

distclean: clean
	rm -f ubas lexer.c parser.c parser.h grace
