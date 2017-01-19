%{
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

%start Program

%nonassoc DO
%nonassoc THEN
%nonassoc ELSE
%nonassoc EQU NEQ '>' '<' GTE LTE
%left LOGIC_OR LOGIC_AND
%left '+' '-'
%left '*' '/'
%left NEG

%%

Program   : PROGRAM ID ';' DecList '{' SList '}' '.'
          ;

DecList   : Dec DecList
          | Dec
          ;

Dec       : VarDecs
          | FuncDecs
          ;

FuncDecs  : FuncDec FuncDecs
          | FuncDec
          ;

VarDecs   : VarDec VarDecs
          | VarDec
          ;

VarDec    : Type IDDList ';'
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

FuncDec   :  Type ID '(' ArgsList ')' '{' SList '}' ';'
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
          | IF Exp THEN Block
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
          | Case
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

IDD       : IDD '[' Exp ']'
          | ID
          ;

LValue    : ID
          | IDD
          ;

Exp       : IntNumber
          | RealNumber
          | LValue
          | CHARACTER
          | TRUE
          | FALSE
          | Exp Aop Exp
          | Exp Logic Exp
          | '-' Exp
          | STRING
          | '(' Exp ')'
          | Exp IN Range
          | LValue '=' Exp
          | ID '(' ExpList ')'
          ;

Block     : Stmt
          | '{' SList '}'
          ;
%%

void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
}

int main(void) {
	yyparse();
	return 0;
}
