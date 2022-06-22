NAME = mycc

CC = gcc
CFLAGS = -g
LEX = flex
LEXFLAGS = -i
YACC = bison
YACCFLAGS = -dtv

all: ${NAME}

${NAME}: ${NAME}.tab.c lex.yy.c
	${CC} ${NAME}.tab.c lex.yy.c -o ${NAME}

lex.yy.c: ${NAME}.l ${NAME}.tab.h
	${LEX} ${LEXFLAGS} ${NAME}.l

${NAME}.tab.c: ${NAME}.y
	${YACC} ${YACCFLAGS} ${NAME}.y

clean:
	rm -f lex.yy.c lex.yy.o ${NAME} ${NAME}.tab.c ${NAME}.tab.h ${NAME}.output
	rm -f ${NAME}.tab.o
