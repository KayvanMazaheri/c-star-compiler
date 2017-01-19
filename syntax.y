%{
  extern int yylineno;
  extern char* yytext;

	int yylex(void);
	void yyerror(char *msg);
%}

%token CHAR
%token INT
%token DOUBLE
%token PROGRAM
%token BOOL
%token FOR
%token TO
%token DOWN
%token WHILE
%token IF
%token THEN
%token ELSE
%token SWITCH
%token CASE
%token OF
%token BREAK
%token REPEAT
%token CONTINUE
%token RETURN
%token WRITE
%token READ
%token TRUE
%token FALSE
%token IN
%token END
%token ID
%token IntNumber
%token RealNumber
%token STRING
%token CHARACTER
%token LTE
%token GTE
%token EQU
%token NEQ
%token RANGE_DOTS
%token LOGIC_AND
%token LOGIC_OR
%token UNTIL
%token DO

%token VAR
%token DEF

%start Program

%nonassoc IFX
%nonassoc ELSE
%nonassoc IN
%nonassoc RANGE_DOTS

%right '='
%left LOGIC_OR
%left LOGIC_AND
%left EQU NEQ
%left '>' '<' GTE LTE
%left '+' '-'
%left '*' '/' '%'
%left NEG
%left '[' ']'

%%

Program   : PROGRAM ID ';' DecList '{' SList '}' '.'
          ;

DecList   : Dec DecList
          |
          ;

Dec       : VarDecs
          | FuncDecs
          ;

FuncDecs  : FuncDec FuncDecs
          | FuncDec END
          ;

VarDecs   : VarDec VarDecs
          | VarDec END
          ;

VarDec    : VAR Type IDDList ';'
          ;

Type      : INT
          | DOUBLE
          | BOOL
          | CHAR
          ;

IDDim     : ID
          | IDDim '[' IntNumber ']'
          ;

IDDList   : IDDim ',' IDDList
          : IDDim
          ;

IDList    : ID ',' IDList
          | ID
          ;

FuncDec   : DEF Type ID '(' ArgsList ')' '{' SList '}' ';'
          ;

ArgsList  : ArgList
          |
          ;

ArgList   : Arg ';' ArgList
          | Arg
          ;

Arg       : Type IDList
          ;

SList     : Stmt ';' SList
          |
          ;

Stmt      : Exp
          | VarDecs
          | FOR LValue '=' Exp '(' TO
          | DOWN TO ')' Exp DO Block
          | WHILE Exp DO Block
          | IF Exp THEN Block %prec IFX
          | IF Exp THEN Block ELSE Block
          | SWITCH Exp OF '{' Cases '}'
          | BREAK
          | REPEAT Block UNTIL Exp
          | CONTINUE
          | RETURN Exp
          | WRITE ExpPlus
          | READ '(' LValue ')'
          ;

Range     : Exp RANGE_DOTS Exp
          ;

Cases     : Case Cases '.'
          | Case END
          ;

Case      : CASE Exp ':' Block
          | CASE Range ':' Block
          ;

Logic     : LOGIC_AND
          | LOGIC_OR
          | '<'
          | '>'
          | GTE
          | LTE
          | EQU
          | NEQ
          ;

Aop       : '+'
          | '-'
          | '*'
          | '/'
          | '%'
          ;

ExpList   : ExpPlus
          |
          ;

ExpPlus   : Exp ',' ExpPlus
          | Exp
          ;

IDD       : ID IDDRight
          ;

IDDRight  : '[' Exp ']' IDDRight
          |
          ;

LValue    : ID IDDRight
          ;

AopLogic  : Aop
          | Logic
          ;

Exp       : ExpRight
          | Exp '+' Exp
          | Exp '-' Exp
          | Exp '*' Exp
          | Exp '/' Exp
          | Exp '%' Exp
          | Exp LOGIC_AND Exp
          | Exp LOGIC_OR Exp
          | Exp '<' Exp
          | Exp '>' Exp
          | Exp GTE Exp
          | Exp LTE Exp
          | Exp EQU Exp
          | Exp NEQ Exp
          | Exp IN Range
          ;

ExpRight  : IntNumber
          | RealNumber
          | LValue
          | CHARACTER
          | STRING
          | TRUE
          | FALSE
          | '-' Exp %prec NEG
          | LValue '=' Exp
          | '(' Exp ')'
          | '(' ID '(' ExpList ')' ')'
          ;

Block     : Stmt
          | '{' SList '}'
          ;
%%

void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
	fprintf(stderr, "%s\n", yytext);
}

int main(void) {
	yyparse();
	return 0;
}
