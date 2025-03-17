%{
/*Lex First Part 
    include C library
    Declaration 
*/
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define LIST strcat(buf,yytext)
#define token(t) {LIST; printf("<%s>\n",t);}
#define tokenInteger(t,i) {LIST; printf("<%s:%d>\n",t,i);}
#define tokenString(t,s) {LIST; printf("<%s:%s>\n",t,s);}
#define tokenReal(t,i) {LIST; printf("<%s:%f >\n",t,i);}

#define MAX_LINE_LENG 256

int linenum = 1;
char buf[MAX_LINE_LENG];

char StringBuff[MAX_LINE_LENG];  

/*     Symbol Table  */
void create();
int lookup();
void insert(char *,int);
void dump();

typedef struct identify{

    
    char id [MAX_LINE_LENG] ;
}identify;

identify SymbolTable[MAX_LINE_LENG];


int TableSize;

%}
/*      Lex First Part       */
/*      Definition      */
/*Name      regular expression      */

/* %x Declare a new State to be discarded */
%x COMMENT
%x StrState

digit       [0-9]
int         [+-]?[1-9]{digit}*|[0]
real_num    {int}"."{digit}*([eE]{int})?
ID          [a-zA-Z][A-Za-z0-9]*
bool true|false

TRUE true
FALSE false
/*      Lex Second Part       */
/*regularExpression(pattern)    action      */
%%
    
"."     {token("'.'");}
","     {token("','");}
":"     {token("':'");}
";"     {token("';'");}
"("     {token("'('");}
")"     {token("')'");}
"["     {token("'['");}
"]"     {token("']'");}
"{"     {token("'{'");}
"}"     {token("'}'");}

"+"     {token("'+'");}
"-"     {token("'-'");}
"*"     {token("'*'");}
"/"     {token("'/'");}
"mod"   {token("'mod'");}
":="    {token("':='");}

"<"     {token("'<'");}
"<="    {token("'<='");}
">="    {token("'>='");}
">"     {token("'>'");}
"="     {token("'='");}
"not="  {token("'not='");}

"and"   {token("'and'");}
"or"    {token("'or'");}
"not"   {token("'not'");}

 /*     boolean     */
 {TRUE}      {tokenString("Boolean","TRUE");}
 {FALSE}     {tokenString("Boolean","FALSE");}

"then"          {token("THEN");}
"array"         {token("ARRAY");}
"begin"         {token("BEGIN");}
"bool"          {token("BOOL");}
"char"          {token("CHAR");}
"const"         {token("CONST");}
"decreasing"    {token("DECREASING");}
"default"       {token("DEFAULT");}
"do"            {token("DO");}
"else"          {token("ELSE");}
"end"           {token("END");}
"exit"          {token("EXIT");}
"for"           {token("FOR");}
"function"      {token("FUNCTION");}
"get"           {token("GET");}
"if"            {token("IF");}
"int"           {token("INT");}
"loop"          {token("LOOP");}
"of"            {token("OF");}
"put"           {token("PUT");}
"procedure"     {token("PROCEDURE");}
"real"          {token("REAL");}
"result"        {token("RESULT");}
"return"        {token("RETURN");}
"skip"          {token("SKIP");}
"string"        {token("STRING");}
"var"           {token("VAR");}
"when"          {token("WHEN");}

 /*  Only one line comment   */

%[^\n]*  {
    LIST;    
}

 /*  More than one line comments  */

"{%" {
        LIST;
        BEGIN (COMMENT);
}

 <COMMENT>"%}" {
        LIST;
        BEGIN (INITIAL);
}

<COMMENT>\n {
        LIST;
        printf("%d: %s",linenum++,buf);
        buf[0] = '\0';
}

<COMMENT>. {
        LIST;
}

 /*   String    */

 /* Start a String    */
\" {

    memset(StringBuff,'\0',MAX_LINE_LENG);
    LIST;
    BEGIN (StrState);
}

<StrState>\"\" {

    //instead of LIST,strcat only one '"'
    strcat(StringBuff,"\"");

    //add next string
    yymore();
}

<StrState>\" {
    tokenString("string",StringBuff);
    StringBuff[0] = '\0';
    BEGIN (INITIAL);
}

<StrState>. {
    LIST;

    //add char with yytext
    strcat(StringBuff, &yytext[yyleng-1]);
}
 
\n {
    LIST;
    printf("%d: %s", linenum, buf);
    linenum++;
    buf[0] = '\0';
}

{ID} {
    tokenString("id",yytext);
    insert(yytext,yyleng);
}


{int} {
    int num;
    sscanf(yytext,"%d",&num);
    tokenInteger("integer",num);
}

{real_num} {
    float num;
    sscanf(yytext,"%f",&num);
    tokenReal("real",num);
}
  

[ \t]*  {
      LIST;}


. {
        LIST;
        printf("%d:%s\n", linenum+1, buf);
        printf("bad character:'%s'\n",yytext);
        exit(-1);
        }


%%

/*      c program       */



void create(){
    TableSize=0;
}

int lookup(char * str,int length){
  
    for(int i=0;i<TableSize;i++){
        if(strncmp(str,SymbolTable[i].id,length)==0){
            return 1;    
        }
    }
    return 0;
}

void insert(char* str,int length){
    
    //no exist
    if(lookup(str,length)==0){  

    strcpy(SymbolTable[TableSize].id, str);
    
    TableSize+=1;
    }
}

void dump(){
    
    printf("Symbol Table:\n");
    for(int i=0;i<=TableSize;i++){
        printf("%s\n",SymbolTable[i].id);
    }
    
}

int yywrap(){
 return 1;
}
int main(int argc, char *argv[]){

if(argc > 0){
                yyin = fopen(argv[1],"r");
        }
        else{
                yyin = stdin;
        }
    create();

    /* To use the generated lexer*/
    yylex();
    printf("%d: %s\n\n",linenum,buf);
    dump();
    return 0;
}
