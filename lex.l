%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define MAX_LINE_LENG 256
#define LIST strcat(buf,yytext)
#define token(t) {LIST; printf("<%s>\n",t);}
#define tokenInteger(t,i) {LIST; printf("<%s: %d >\n",t,i);}
#define tokenReal(t,i) {LIST; printf("<%s: %f >\n",t,i);}
#define tokenString(t,s) {LIST; printf("<%s: %s >\n",t,s);}
int linenum = 1;
char buf[MAX_LINE_LENG];
char StringBuff[MAX_LINE_LENG];  /* store string buffer*/
char SymbolTable [MAX_LINE_LENG][MAX_LINE_LENG];  /* symbol table */
int TableSize;

 /*     function     */
void create();
int lookup();
void insert(char *,int);
void dump();

%}

%x StrState
%x COMMENT

digit       [0-9]
int         [+-]?[1-9]{digit}*|[0]
real_num    {int}"."{digit}*([eE]{int})?

bool        true|false
ID          [a-zA-Z][A-Za-z0-9]*

 /*     comment     */

Lcomment \{
Rcomment \} 

 /*     keyword     */
THEN        [tT][hH][eE][nN]
AND         [aA][nN][dD]
BEGIN       [Bb][eE][gG][iI][nN]
BOOLEAN     [bB][Oo][oO][lL][eE][aA][nN]
BREAK       [bB][rR][eE][aA][kK]
CHARACTER   [cC][hH][aA][rR][aA][cC][tT][eE][rR]
CASE        [cC][aA][sS][eE]
CONTINUE    [cC][oO][nN][tT][iI][nN][uU][eE]
CONSTANT    [cC][oO][nN][sS][tT][Aa][nN][tT]
DECLARE     [dD][eE][cC][lL][aA][rR][eE]
DO          [dD][oO]
ELSE        [eE][lL][sS][eE]
END         [eE][nN][dD]
EXIT        [eE][xX][iI][tT]
FALSE       [fF][aA][lL][sS][eE]
FLOAT       [fF][lL][oO][aA][tT]
FOR         [fF][oO][rR]
IF          [iI][fF]
IN          [iI][nN]
INTEGER     [iI][nN][tT][eE][gG][eE][rR]
LOOP        [lL][oO][oO][pP]
NOT         [nN][oO][tT]
OR          [oO][rR]
PRINT       [pP][rR][iI][nN][tT]
PRINTLN     [pP][rR][iI][nN][tT][lL][nN]
PROCEDURE   [pP][rR][oO][cC][eE][dD][uU][rR][eE]
PROGRAM     [pP][rR][oO][gG][rR][aA][mM]
RETURN      [rR][eE][tT][uU][rR][nN]
STRING      [sS][tT][iI][nN][gG]
TRUE        [tT][rR][uU][eE]
WHILE       [wW][hW][iI][lL][eE]
VOID        [vV][oO][iI][dD]

%% 
","         {token("','");}
":"         {token("':'");}
";"         {token("';'");}
"."         {token("'.'");}
"("         {token("'('");}
")"         {token("')'");}
"["         {token("'['");}
"]"         {token("']'");}
"+"         {token("'+'");}
"-"         {token("'-'");}
"*"         {token("'*'");}
"/"         {token("'/'");}
"%"         {token("'%'");}
"!"         {token("'!'");}
"++"        {token("'++'");}
"--"        {token("'--'");}
">"         {token("'>'");}
"<"         {token("'<'");}
"=="        {token("'=='");}
">="        {token("'>='");}
"<="        {token("'<='");}
"!="        {token("'!='");}
":="        {token("':='");}
"+="        {token("'+='");}
"-="        {token("'-='");}
"*="        {token("'*='");}
"/="        {token("'/='");}
"&&"        {token("'&&'");}
"||"        {token("'||'");}

 /*     operator     */
{AND}       {token("\"and\"");}
{OR}        {token("\"or\"");}
{NOT}       {token("\"not\"");}

 /*     boolean     */
 {TRUE}      {tokenString("Boolean","TRUE");}
 {FALSE}     {tokenString("Boolean","FALSE");}

{THEN}      {token("THEN");}
{BEGIN}     {token("BEGIN");}
{BOOLEAN}   {token("BOOLEAN");}
{BREAK}     {token("BREAK");}
{CHARACTER} {token("CHARACTER");}
{CASE}      {token("CASE");}
{CONTINUE}  {token("CONTINUE");}
{CONSTANT}  {token("CONSTANT");}
{DECLARE}   {token("DECLARE");}
{DO}        {token("DO");}
{ELSE}      {token("ELSE");}
{END}       {token("END");}
{EXIT}      {token("EXIT");}
{FLOAT}     {token("FLOAT");}
{FOR}       {token("FOR");}
{IF}        {token("IF");}
{IN}        {token("IN");}
{INTEGER}   {token("INTEGER");}
{LOOP}      {token("LOOP");}
{PRINT}     {token("PRINT");}
{PRINTLN}   {token("PRINTLN");}
{PROCEDURE} {token("PROCEDURE");}
{PROGRAM}   {token("PROGRAM");}
{RETURN}    {token("RETURN");}
{STRING}    {token("STRING");}
{WHILE}     {token("WHILE");}
{VOID}      {token("VOID");}

 /*       single comment      */
--[^\n]*  {
    LIST;
}
 /*---------------------------*/

 /*     multiple comments     */

{Lcomment} {
        LIST;
        BEGIN (COMMENT);
}

<COMMENT>{Rcomment} {
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
 /*---------------------------*/

 /*       string handle       */
\" {
    memset(StringBuff,'\0',sizeof(char)*MAX_LINE_LENG);
    LIST;
    BEGIN (StrState);
}

<StrState>\"\" {
    strcat(StringBuff,"\"");
    yymore();
}

<StrState>\" {
    tokenString("string",StringBuff);
    StringBuff[0] = '\0';
    BEGIN (INITIAL);
}

<StrState>. {
    LIST;
    strcat(StringBuff, &yytext[yyleng-1]);
}
 /*---------------------------*/
\n|\r\n {
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

[ \t]* {
    LIST;
}

. {
LIST;
printf("%d:%s\n", linenum, buf);
printf("bad character:'%s'\n",yytext);
exit(-1);
}

%%
void create(){
    TableSize=-1;
}

int lookup(char * str,int length){
    int i;
    for(i=0;i<=TableSize;i++){
        if(!strncmp(str,SymbolTable[i],length)){
            return i;    
        }
    }
    return -1;
}

void insert(char* str,int length){
    int i;
    if(lookup(str,length)==-1){
        TableSize += 1;
        for(i=0;i<length;i++){
            SymbolTable[TableSize][i] = str[i];
        }
        SymbolTable[TableSize][i] = '\0';
    }
}

void dump(){
    int i = 0;
    printf("Symbol Table:\n");
    for(i=0;i<=TableSize;i++){
        printf("%s\n",SymbolTable[i]);
    }
}

int yywrap(void){
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
    yylex();
    printf("%d: %s\n\n",linenum,buf);
    dump();
    return 0;
}