%define parse.lac none
%define parse.error verbose

%{
	#include <stdio.h>
	int yylex(void);
	int yyerror(const char *s);
	extern int lex_error;
	int test = 1;
%}

%union {
	int ival;
	double dval;
	char *string;
}

%token HEADER
%token INT FLOAT DOUBLE CHAR VOID STRUCT
%token <string> VAR
%token <ival> NINT
%token <dval> NREAL
%token <string> STRING
%token <string> CHARL
%token IF FOR DO WHILE RETURN PRINTF
%nonassoc REDUCE
%nonassoc ELSE
%left ','
%right '=' MUL_ASG DIV_ASG MOD_ASG ADD_ASG SUB_ASG
           AND_ASG OR_ASG XOR_ASG LEFSFT_ASG RIGSFT_ASG
%left OR
%left AND
%left '|'
%left '^'
%left '&'
%left EQ NEQ
%left LEQ '<' '>' GEQ
%left LEFT_SHIFT RIGHT_SHIFT
%left '+' '-'
%left '*' '/' '%'
%nonassoc UPLUS UMINUS
%right '!' '~'
%left INC DEC '.'

%%

program : decl_list
        | header_list decl_list
        ;

header_list : HEADER
            | header_list HEADER
            ;

decl_list : declaration
          | decl_list declaration
          ;

declaration : struct
            | function
            ;

struct : STRUCT VAR '{' struct_args '}' ';'
       ;

struct_args :
            | struct_args type struct_arg ';'
            ;

struct_arg : VAR
           | struct_arg ',' VAR
           ;

function : function_type VAR '(' function_args ')' closed_statement
         ;

function_type :
	      | VOID
	      | type
	      ;

function_args :
              | VOID
              | arguments
              ;

arguments : type VAR
          | arguments ',' type VAR
          ;

type : INT
     | FLOAT
     | DOUBLE
     | CHAR
     ;

closed_statement : '{' '}'
                 | '{' statements '}'
                 ;

statements : statement
           | statements statement
           ;

statement : definition
          | expression_stmt
          | if_cond
          | for
          | while
          | do_while
          | return
          | printf
          | closed_statement
          ;

definition : type def_list ';'
           | STRUCT VAR struct_def_list ';'
           ;

def_list : def_item
         | def_list ',' def_item
         ;

def_item : VAR
         | VAR '=' expr
         ;

struct_def_list : VAR
                | struct_def_list ',' VAR
                ;

expression_stmt : ';'
                | expression ';'
                ;

expression : expr
           | VAR '=' expr
           | VAR MUL_ASG expr
           | VAR DIV_ASG expr
           | VAR MOD_ASG expr
           | VAR ADD_ASG expr
           | VAR SUB_ASG expr
           | VAR LEFSFT_ASG expr
           | VAR RIGSFT_ASG expr
           | VAR AND_ASG expr
           | VAR OR_ASG expr
           | VAR XOR_ASG expr
           ;

expr : expr '+' expr
     | expr '-' expr
     | expr '*' expr
     | expr '/' expr
     | expr '%' expr
     | expr AND expr
     | expr OR expr
     | expr EQ expr
     | expr NEQ expr
     | expr LEQ expr
     | expr GEQ expr
     | expr '<' expr
     | expr '>' expr
     | expr '&' expr
     | expr '|' expr
     | expr '^' expr
     | expr LEFT_SHIFT expr
     | expr RIGHT_SHIFT expr
     | expr INC
     | expr DEC
     | '!' expr
     | INC expr %prec '!'
     | DEC expr %prec '!'
     | '-' expr %prec UMINUS
     | '+' expr %prec UPLUS
     | '(' expr ')'
     | id
     ;

id : VAR
   | VAR '.' VAR
   | NINT
   | NREAL
   | CHARL
   ;

if_cond : IF '(' expression ')' statement %prec REDUCE
        | IF '(' expression ')' statement ELSE statement
        ;

for : FOR '(' expression_stmt expression_stmt ')' statement
    | FOR '(' expression_stmt expression_stmt expression ')' statement
    ;

while : WHILE '(' expression ')' statement
      ;

do_while : DO statement WHILE '(' expression ')' ';'
         ;

return : RETURN expression_stmt
       ;

printf : PRINTF '(' STRING ')' ';'
       | PRINTF '(' STRING ',' print_expr ')' ';'
       ;

print_expr : expression
           | print_expr ',' expression
           ;

%%

int main()
{
	yyparse();
	if(lex_error > 0)
		printf("Found %d lexical errors. Parsing Failed.\n", lex_error);
	else if(test)
		printf("Parsing Successful.\n");
  else
    printf("Parsing Failed.\n");
	return 0;
}

int yyerror(const char *msg)
{
	extern int yylineno;
	printf("Line: %d\nError: %s\n", yylineno, msg);
	test = 0;
	return(0);
}
