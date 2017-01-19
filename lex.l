%{
#include "y.tab.h"
%}

DIGIT                                       [0-9]
ALPHA                                       [A-Za-z]
SIGN                                        [\+\-]
NUMBER                                      {DIGIT}+

%%



char                                        return CHAR;
int                                         return INT;
double                                      return DOUBLE;

program                                     return PROGRAM;
bool                                        return BOOL;
for                                         return FOR;
to                                          return TO;
down                                        return DOWN;
while                                       return WHILE;
until                                       return UNTIL;

if                                          return IF;
then                                        return THEN;
else                                        return ELSE;

switch                                      return SWITCH;
case                                        return CASE;
of                                          return OF;
break                                       return BREAK;
repeat                                      return REPEAT;
continue                                    return CONTINUE;
return                                      return RETURN;
write                                       return WRITE;
read                                        return READ;

true                                        return TRUE;
false                                       return FALSE;
in                                          return IN;
end                                         return END;
do                                          return DO;

(_|{ALPHA})({ALPHA}|{DIGIT}|_)*             return ID;

{SIGN}?{NUMBER}                             return IntNumber;
{SIGN}?{NUMBER}*[.]{NUMBER}+                return RealNumber;
{SIGN}?{NUMBER}+[.]{NUMBER}*                return RealNumber;
{SIGN}?{NUMBER}+[eE]{SIGN}?{NUMBER}+        return RealNumber;
\"[^"\n]+\"                                 return STRING;
'[^'\n]'                                    return CHARACTER;

"<="                                        return LTE;
">="                                        return GTE;
"=="                                        return EQU;
"!="                                        return NEQ;
".."                                        return RANGE_DOTS;
"&&"                                        return LOGIC_AND;
"||"                                        return LOGIC_OR;
%%

int yywrap(void){
  return 1;
}
