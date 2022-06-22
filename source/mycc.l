%option noyywrap yylineno

%{
	#include <string.h>
	#include "mycc.tab.h"
	int lex_error = 0;
	int lexical_error(void);
%}

Var				[_a-zA-Z][_a-zA-Z0-9]*
VarInvalid			[0-9][_0-9a-zA-Z]+
Int				[0-9]+
Real				[0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?
String				\"(\\(.|\n)|[^\n\\"])*\"
Char				\'([^\'\\]|[\\]n|[\\]t|[\\]\'|[\\][\\])\'
CharInvalid			\'[\'\\]\'|\'(..+)\'
Header				"#include"([ ]+)?((<(\\.|[^>])+>)|(\"(\\.|[^"])+\"))
SingleLineComment		\/\/.*
MultiLineComment		"/*"(.|\n)*?"*/"
Whitespace			[ \t\r\n]+
Marks				[}{(),;]
Operators			[\^|&~.!<=>+\-*\/%]

%%

{MultiLineComment}		|

{SingleLineComment}		|

{Whitespace}			;

{Header}			{return HEADER;}

int				{return INT;}

float				{return FLOAT;}

double				{return DOUBLE;}

char				{return CHAR;}

void				{return VOID;}

struct				{return STRUCT;}

if				{return IF;}

else				{return ELSE;}

for				{return FOR;}

do				{return DO;}

while				{return WHILE;}

return				{return RETURN;}

printf				{return PRINTF;}

{Var}				{yylval.string=strdup(yytext); return VAR;}

{Int}				{yylval.ival=atoi(yytext); return NINT;}

{Real}				{yylval.dval=atof(yytext); return NREAL;}

{String}			{yylval.string=strdup(yytext); return STRING;}

{Char}				{yylval.string=strdup(yytext); return CHARL;}

{Marks}				|

{Operators}			{return *yytext;}

"+="				{return ADD_ASG;}

"-="				{return SUB_ASG;}

"*="				{return MUL_ASG;}

"/="				{return DIV_ASG;}

"%="				{return MOD_ASG;}

"&="				{return AND_ASG;}

"|="				{return OR_ASG;}

"^="				{return XOR_ASG;}

"<<="				{return LEFSFT_ASG;}

">>="				{return RIGSFT_ASG;}

"<<"				{LEFT_SHIFT;}

">>"				{RIGHT_SHIFT;}

"<="				{return LEQ;}

">="				{return GEQ;}

"=="				{return EQ;}

"!="				{return NEQ;}

"&&"				{return AND;}

"||"				{return OR;}

"++"				{return INC;}

"--"				{return DEC;}

{VarInvalid}			|

{CharInvalid}			|

.				{lexical_error();}

%%

int lexical_error(void)
{
	printf("Line: %d\nError: Invalid token '%s'\n", yylineno, yytext);
	++lex_error;
	return(0);
}
