%{

    #include <stdio.h>                           //added
    #include <stdlib.h>
    #include <string.h>
    #include "tokens.h"
    #include "y.tab.h"

    int ligne = 1;
    int const_entiere;
    float const_float;
%}

%option noyywrap

IDF [A-Z][a-z0-9]{0,7}
CONST_FLOAT_SIGN \([-+][0-9]+\.[0-9]+\)
CONST_FLOAT_NON_SIGN [0-9]+\.[0-9]+
CONST_ENTIERE_SIGN \([-+][0-9]+\)
CONST_ENTIERE_NON_SIGN [0-9]+
OP_ARTH [+\-*/]
OP_LOGQ (&&|\|\||!)

CHAINE \"[^\"]*\"                           //added

%%

"VAR_GLOBAL"    { printf("MOT-CLE : VAR_GLOBAL\n"); return VAR_GLOBAL; }
"DECLARATION"   { printf("MOT-CLE : DECLARATION\n"); return DECLARATION; }
"INSTRUCTION"   { printf("MOT-CLE : INSTRUCTION\n"); return INSTRUCTION; }
"INTEGER"       { printf("MOT-CLE : INTEGER\n"); return INTEGER; }
"FLOAT"         { printf("MOT-CLE : FLOAT\n"); return FLOAT; }
"CHAR"          { printf("MOT-CLE : CHAR\n"); return CHAR; }
"CONST"         { printf("MOT-CLE : CONST\n"); return CONST; }
"READ"          { printf("MOT-CLE : READ\n"); return READ; }
"WRITE"         { printf("MOT-CLE : WRITE\n"); return WRITE; }
"IF"            { printf("MOT-CLE : IF\n"); return IF; }
"ELSE"          { printf("MOT-CLE : ELSE\n"); return ELSE; }
"FOR"           { printf("MOT-CLE : FOR\n"); return FOR; }

{IDF} {
    printf("IDF : %s\n", yytext);
    yylval.str = strdup(yytext);
    return IDF;
}
{CONST_FLOAT_SIGN} {
    printf("Constante reele signee : %s\n", yytext);
    char* temp = strdup(yytext + 1);  // Skip opening parenthesis
    temp[strlen(temp) - 1] = '\0';     // Remove closing parenthesis
    yylval.fnum = atof(temp);
    free(temp);
    return CONST_FLOAT_SIGN;
}
{CONST_FLOAT_SIGN} { 
    printf("Constante reele signee : %s\n", yytext);
    yylval.fnum = atof(yytext);
    return CONST_FLOAT_NON_SIGN;
}
{CONST_FLOAT_NON_SIGN} {
    printf("Constante reele non signee : %s\n", yytext);
    yylval.fnum = atof(yytext);
    return CONST_FLOAT_NON_SIGN;
}
{CONST_ENTIERE_SIGN} {
    char* temp = strdup(yytext + 1);  // Skip opening parenthesis
    temp[strlen(temp) - 1] = '\0';     // Remove closing parenthesis
    int value = atoi(temp);
    free(temp);
    if (value >= -32768 && value <= 32767) {
        printf("Constante entiere signee : %s\n", yytext);
        yylval.num = value;
        return CONST_ENTIERE_SIGN;
    } else {
        printf("Error at line %d: Integer value out of range [-32768, 32767]\n", ligne);    //convert to french
    }
}
{CONST_ENTIERE_NON_SIGN} {
    int value = atoi(yytext);
    if (value <= 32767) {
        printf("Constante entiere non signee : %s\n", yytext);
        yylval.num = value;
        return CONST_ENTIERE_NON_SIGN;
    } else {
        printf("Error at line %d: Integer value out of range [0, 32767]\n", ligne);
    }
}

{OP_ARTH} { 
    printf("OPERATEUR ARITHMETIQUE : %s\n", yytext);
    yylval.str = strdup(yytext);
    return OP_ARTH;
}
{OP_LOGQ} {
    printf("OPERATEUR LOGIQUE : %s\n", yytext);
    yylval.str = strdup(yytext);
    return OP_LOGQ;
}

">"  { return OP_COMP; }
"<"  { return OP_COMP; }
">=" { return OP_COMP; }
"<=" { return OP_COMP; }
"==" { return OP_COMP; }
"!=" { return OP_COMP; }
"="  { return AFFECT; }

"%%"[^\n]* { /* Ignore comments */ }

{CHAINE} {
    yylval.str = strdup(yytext);
    return CHAINE;
}

[ \t]   { /* Ignore whitespace */ }
\n      { ligne++; }

"{"     { return '{'; }
"}"     { return '}'; }
"("     { return '('; }
")"     { return ')'; }
"["     { return '['; }
"]"     { return ']'; }
","     { return ','; }
";"     { return ';'; }
":"     { return ':'; }

. { printf("Erreur lexicale a la ligne %d, Caractere %s non reconnu\n", ligne, yytext); }

