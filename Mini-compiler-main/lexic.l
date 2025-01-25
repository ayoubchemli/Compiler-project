%{
    #include <stdio.h>
    #include<string.h>
    #include "syntSem.tab.h"
    #include "quadruplet.h"
    extern YYSTYPE yyval;
    int nb_ligne=1;
    int colonne=0;

    int const_entiere;
    float const_float;

%}

%option noyywrap

IDF [A-Z][a-z0-9]{0,7}
chiffre_int_signe \([-+][0-9]+\)
chiffre_int_non_signe [0-9]+
chiffre_float_signe \([-+][0-9]+\.[0-9]+\)
chiffre_float_non_signe [0-9]+\.[0-9]+
chaine \"([^\"\\]|\\.)*\"


%%




VAR_GLOBAL           {  colonne=colonne+ yyleng; return VAR_GLOBAL;  }
DECLARATION          {  colonne=colonne+ yyleng; return DECLARATION; }
INSTRUCTION          {  colonne=colonne+ yyleng; return INSTRUCTION; }
INTEGER              {  colonne=colonne+ yyleng; return INTEGER;  }
FLOAT                {  colonne=colonne+ yyleng; return FLOAT;  }
CHAR                 {  colonne=colonne+ yyleng; return CHAR; }
CONST                {  colonne=colonne+ yyleng; return CONST;  }
READ                 {  colonne=colonne+ yyleng; return READ; }
WRITE                {  colonne=colonne+ yyleng; return WRITE; }
IF                   {  colonne=colonne+ yyleng; return IF; }
ELSE                 {  colonne=colonne+ yyleng; return ELSE; }
FOR                  {  colonne=colonne+ yyleng; return FOR; }


{IDF}                {if (yyleng<= 8) {yylval.string=strdup(yytext); return IDF;} else {printf("erreur lexical: longeur de l'IDF est plus que 8 caracteres\n");}} 

{chaine}  { yylval.string=strdup(yytext); return chaine; }
{chiffre_int_signe} {yylval.INTEGER=convert_to_int(yytext);  if((yylval.INTEGER>= -32768)&&(yylval.INTEGER<=32767)) {colonne=colonne+yyleng;  return chiffre_int_signe; } 
                                                     else {printf("Erreur Lexical: le nombre est superieure a 32767 ou inferieur a -32767 a la ligne %d colonne %d\n", nb_ligne,colonne);}}


{chiffre_int_non_signe} {yylval.INTEGER=convert_to_int(yytext);  if(yylval.INTEGER<=32767) {colonne=colonne+yyleng;  return chiffre_int_non_signe; } 
                                                        else {printf("Erreur Lexical: le nombre est superieure a 32767 ou inferieur a -32767 a la ligne %d colonne %d\n", nb_ligne,colonne);}}

{chiffre_float_signe} { colonne=colonne+yyleng; yylval.FLOAT=convert_to_float(yytext); return chiffre_float_signe; }

{chiffre_float_non_signe} { colonne=colonne+yyleng; yylval.FLOAT=convert_to_float(yytext); return chiffre_float_non_signe; }


                       


"%%"[^\n]*           { colonne=0;}
[ \t]+               { colonne++;}
\n                   { colonne=0; nb_ligne++; }

"||"                  { colonne++; return or; }
"&"                  { colonne++; return and; }
"!"                  { colonne++; return neg; }

"+"                  { colonne++; return plus; }
"-"                  { colonne++; return minus; }
"*"                  { colonne++; return mul; }
"/"                  { colonne++; return division; }

"="                  { colonne++; return affect; }
"{"                  { colonne++; return acc_ouvr;  }
"}"                  { colonne++; return acc_ferm;  }
";"                  { colonne++; return point_virg; }
","                  { colonne++; return virg; }
":"                  { colonne++; return deuxpoints; }
"("                  { colonne++; return parth_ouvr; }
")"                  { colonne++; return parth_ferm; }
"["                  { colonne++; return croch_ouvr; }
"]"                  { colonne++; return croch_ferm; }




">"                  {  colonne=colonne+ yyleng; return sup; }
"<"                  {  colonne=colonne+ yyleng; return inf; }
">="                 {  colonne=colonne+ yyleng; return supeg; }
"<="                 {  colonne=colonne+ yyleng; return infeg; }
"=="                 {  colonne=colonne+ yyleng; return eg; }
"!="                 {  colonne=colonne+ yyleng; return noneg; }
.                    {printf ("Erreur lexical, a ligne %d colonne %d: entitee %s non reconnu" ,nb_ligne,colonne,yytext);}

%%
