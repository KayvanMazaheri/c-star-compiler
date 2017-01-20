# c-star-compiler
Final project for compilers course at Isfahan University of Technology

# توضیحات پروژه
تلاش های انجام شده برای پیاده سازی این پروژه به چند فاز تفکیک می‌شود
## آماده سازی
ابتدا باید ایرادات و نواقص صورت سوال برطرف می‌شد  
برای این منظور با مطالعه‌ی گرامر داده شده و همچنین با توجه به بحث های انجام شده در گروه و با فرض برقرار بودن قواعد مشابه زبان‌های دیگر برنامه نویسی، گرامر اصلاح شده ای تهیه شد  
سپس با توجه به مطالبی که در کلاس آموخته شد، تلاشی برطرف کردن ایرادات و ابهامات زبان (از جمله رفع موارد بازگشتی چپ) انجام گرفت

## توصیف قواعد لغوی (Flex)
### `lex.l`
مرحله‌ی اول برای پیاده سازی یک کامپایلر، ایجاد یک تحلیل‌گر لغوی است  
با توجه به کلید‌واژه های تعریف شده در این گرامر و همینطور با توجه به ساختار های شناخته شده (مانند اعداد صحیح یا اعشاری) ، با کمک گرفتن از *عبارت‌های منظم* ، *توکن* های زبان را مشخص میکنیم 
```
lex.l:

...

true                                        return TRUE;
false                                       return FALSE;
in                                          return IN;
end                                         return END;
do                                          return DO;

(_|{ALPHA})({ALPHA}|{DIGIT}|_)*             return ID;

{SIGN}?{NUMBER}                             return IntNumber;
{SIGN}?{NUMBER}*[.]{NUMBER}+                return RealNumber;
{SIGN}?{NUMBER}+[.]{NUMBER}*                return RealNumber;

...

```

برای جلوگیری از تداخل و اشتباه شدن بعضی از توکن ها با یکدیگر، برای آنها نام های خاص انتخاب می‌کنیم
```
>=        GTE (Greater Than or Equal)
<=        LTE (Less Than or Equal)
==        EQU (Equals)
!=        NEQ (Not EQual)
&&        LOGIC_AND
||        LOGIC_OR
..        RANGE_DOTS

```

## توصیف قواعد نحوی (Yacc)
### `syntax.y`
مرحله‌ی بعدی، توصیف نحو زبان است  
در این مرحله بر اساس قواعد اشتقاق، نحو این زبان را توصیف خواهیم کرد
برای این منظور ابتدا باید *توکن* ها را معرفی کنیم  
این توکن ها در اصل عناصر *پایانه*‌ی گرامر ما هستند
```
...

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

...
```
همین طور باید عنصر غیر پایانه ای که اشتقاق جملات زبان از آن آغاز می‌شود را هم مشخص کنیم
```
%start Program
```
همچنین با توجه به صورت سوال، برای عملگر های اولویت تعیین می‌کنیم  
عملگر هایی که در خطوط پایین تر آمده اند، اولویت بالاتری خواهند داشت
```
%right '='
%left LOGIC_OR
%left LOGIC_AND
%left EQU NEQ
%left '>' '<' GTE LTE
%left '+' '-'
%left '*' '/' '%'
%left NEG
%left '[' ']'
```

با توجه به گرامر تصحیح شده‌ی به دست آمده در فاز اول (آماده سازی) شروع به نوشتن قواعد اشتقاق می‌کنیم  
هر کلمه‌ای که به عنوان توکن معرفی نشده باشد، یک عنصر *غیر پایانه* محسوب خواهد شد.  
```
...

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

...

```

با دستور زیر گرامر توصیف شده را برای وجود تداخل بررسی می‌کنیم
```bash
yacc -v syntax.y
```
مشاهده می‌کنیم که تعدادی تداخل در این توصیف یافت شده است  
با کمک در نظر گرفتن اولویت ها و همچنین تغییر قوانین گرامر، این تداخل ها را رفع می‌کنیم  
یک نمونه از تغییرات گرامر برای رفع تداخل به شکل زیر است
```
VarDec    : VAR Type IDDList ';'
FuncDec   : DEF Type ID '(' ArgsList ')' '{' SList '}' ';'
```
که با اضافه کردن دو عنصر پایانه‌ی جدید به گرامر حل شده است  

  
 قبل از شروع مرحله‌ی بعد باید تمام تداخل ها رفع شوند
 
## مرحله نهایی
 
 خروجی های ساخته شده‌ی هر ابزار را می‌سازیم و سپس با ادغام آنها به خواسته‌ی خود می‌رسیم
 
 ```bash
 yacc -d syntax.y                          # -d generates the .h file that is gonna be used in lex.l
                                           # yacc will generate y.tab.h and y.tab.c
 flex lex.l                                # flex will generate lex.yy.c
 
 gcc lex.yy.c y.tab.c -o parser.out        # compiles and generates parser.out executable
 
 ./parser.out < source.c* 
 ```
