//adam souhil mohamed imad ayoub
%{
#include <stdio.h>
#include <stdlib.h>
#include"semantique.h"
#include <string.h>
extern int nb_ligne;
extern int colonne;
int yyparse();
int yylex();
int yyerror(char *s);
int typeidf;
float chiffre_idf;

%}
%union{
    int INTEGER;
    float FLOAT;
    char CHAR;
    char* string;
}
%start S



%token VAR_GLOBAL DECLARATION INSTRUCTION 
%token READ WRITE 
%token INTEGER FLOAT CHAR CONST
%token IF ELSE  
%token FOR   
%token acc_ferm acc_ouvr croch_ouvr croch_ferm parth_ouvr parth_ferm  virg point_virg deuxpoints  
%token affect

%left plus minus 
%left mul division
%left inf sup supeg infeg eg noneg 
%left neg 
%left or
%left and


%token <string>IDF chaine
%token <INTEGER> chiffre_int_signe chiffre_int_non_signe
%token <FLOAT> chiffre_float_signe chiffre_float_non_signe 

%type <INTEGER> valeur_const_int
%type <FLOAT> valeur_const_float


//********************************PARTIE DECLARATION********************************************

%%
S: var_global_block  
   declaration_block 
   instruction_block 
    { 
        printf("programme syntaxiquement juste\n"); 
        afficher(); 
    }
;


// Bloc VAR_GLOBAL
var_global_block: 
    VAR_GLOBAL acc_ouvr var_declarations acc_ferm
    {
        printf("Bloc VAR_GLOBAL bien defini.\n");
    }
    | VAR_GLOBAL acc_ouvr acc_ferm   
    {
        printf("Bloc VAR_GLOBAL vide.\n");
    }
;


// Bloc DECLARATION
declaration_block: 
    DECLARATION acc_ouvr var_declarations acc_ferm
    {
        printf("Bloc DECLARATION bien defini.\n");
    }
    | DECLARATION acc_ouvr acc_ferm
    {
        printf("Bloc DECLARATION vide.\n");
    }
;
instruction_block :  
   INSTRUCTION acc_ouvr partieInstruction acc_ferm
    {
        printf("Bloc Instruction bien defini.\n");
    }
    | INSTRUCTION acc_ouvr acc_ferm
    {
        printf("Bloc Instruction vide.\n");
    }
;

var_declarations:
    declaration point_virg
    | var_declarations declaration point_virg
;

// Types de base
type: 
    INTEGER 
    {
        typeidf = 0; // INTEGER type
    }
    | FLOAT 
    {
        typeidf = 1; // FLOAT type
    }
    | CHAR
    {
        typeidf = 2; // CHAR type
    }
;


// Déclarations
declaration:
    // Variable simple
    type liste_idf
    {
        while (list2 != NULL) {
            if (non_declarer(list2->name) == 0) {
                insertion(list2->name, typeidf, 0); // Insert into symbol table
            } else {
                printf("Erreur Semantique: Double declaration de %s dans la ligne %d et la colonne %d\n",
                       list2->name, nb_ligne, colonne);
            }
            list2 = list2->suivant;
        }
    }
    // Constantes
    | CONST type IDF affect valeur_const_int
    {
        if (non_declarer($3) == 0 && incompatible_type(typeidf,0) == 1  ) {
            insertion($3, typeidf, 1); // Insert constant into symbol table
            char temp[12];
            sprintf(temp, "%d", $5);
            GenererQuadruplet("=", temp, "", $3);
        } else if (non_declarer($3)==1) {
            printf("Erreur Semantique: Double declaration de constante %s dans la ligne %d et la colonne %d\n",
                   $3, nb_ligne, colonne);
        }
        else {
            printf("Erreur Semantique: Incompatiblite du type de constante %s dans la ligne %d et la colonne %d\n", $3, nb_ligne, colonne);
        }
    }
    | CONST type IDF affect valeur_const_float
    {
        if (non_declarer($3) == 0 && incompatible_type(typeidf,1) == 1 ) {
            insertion($3, typeidf, 1); // Insert constant into symbol table
            char temp[12];
            sprintf(temp, "%f", $5);
            GenererQuadruplet("=", temp, "", $3);
        } else if (non_declarer($3)==1) {
            printf("Erreur Semantique: Double declaration de constante %s dans la ligne %d et la colonne %d\n",
                   $3, nb_ligne, colonne);
        }
        else {
            printf("Erreur Semantique: Incompatiblite du type de constante %s dans la ligne %d et la colonne %d\n", $3, nb_ligne, colonne);
        }
    }
    | CONST type IDF affect chaine
    {
        if (non_declarer($3) == 0 && incompatible_type(typeidf,2) == 1 && strlen($5)-2 == 1   ) {
            insertion($3, typeidf, 1); // Insert constant into symbol table
            GenererQuadruplet("=", $5, "", $3);
        } else if (non_declarer($3)==1) {
            printf("Erreur Semantique: Double declaration de constante %s dans la ligne %d et la colonne %d\n",
                   $3, nb_ligne, colonne);
        }
        else if (incompatible_type(typeidf,2) == 0){
            printf("Erreur Semantique: Incompatiblite du type de constante %s dans la ligne %d et la colonne %d\n", $3, nb_ligne, colonne);
        }
        else {
            printf("Erreur Semantique: faut declarer un tableau de char   %s dans la ligne %d et la colonne %d\n", $3, nb_ligne, colonne);
        }
    }
    | CONST type IDF croch_ouvr chiffre_int_non_signe croch_ferm affect chaine
    {
        if (non_declarer($3) == 0 && incompatible_type(typeidf,2) == 1 && $5>0 && strlen($8)-2 <= $5     ) {
            insertion($3, typeidf, 1); // Insert constant into symbol table
            GenererQuadruplet("=", $8, "", $3);
        } else if (non_declarer($3)==1) {
            printf("Erreur Semantique: Double declaration de constante %s dans la ligne %d et la colonne %d\n",
                   $3, nb_ligne, colonne);
        }
        else if (incompatible_type(typeidf,2) == 0){
            printf("Erreur Semantique: Incompatiblite du type de constante %s dans la ligne %d et la colonne %d\n", $3, nb_ligne, colonne);
        }
        else if ($5<=0) {
           printf("Erreur Semantique : La taille du tableau doit etre positive dans la ligne %d et la colonne %d\n", nb_ligne, colonne);
        }
        else {
             printf("Erreur Semantique: il faut verifier la taille de la chaine avec la valeur entre []  dans la ligne %d et la colonne %d\n", nb_ligne, colonne);
        }
    }
    // tableau 
    | type IDF croch_ouvr taille croch_ferm
    {
            if (non_declarer($2) == 0) {
                insertion($2, typeidf, 0); // Insert array into symbol table
            } else {
                printf("Erreur Semantique: Double declaration du tableau %s dans la ligne %d et la colonne %d\n",
                       $2, nb_ligne, colonne);
            }
    }
    //
;

// Liste d'identificateurs séparés par virgule
liste_idf:
    IDF
    {
        if (non_declarer($1) == 0) {
            insererparam($1); // Insert identifier
        } else {
            printf("Erreur Semantique: Double declaration de %s dans la ligne %d et la colonne %d\n",
                   $1, nb_ligne, colonne);
        }
    }
    | liste_idf virg IDF
    {
        if (non_declarer($3) == 0) {
            insererparam($3); // Insert additional identifier
        } else {
            printf("Erreur Semantique: Double declaration de %s dans la ligne %d et la colonne %d\n",
                   $3, nb_ligne, colonne);
        }
    }
;

// Valeurs constantes
valeur_const_int:
    chiffre_int_non_signe 
    | chiffre_int_signe
    ;    // Entre parenthèses pour les signés
valeur_const_float:
| chiffre_float_non_signe
    | chiffre_float_signe 
;

// Taille du tableau (doit être positive)
taille: 
    chiffre_int_non_signe {
        if ($1 <= 0) {
            yyerror("La taille du tableau doit être positive");
        }
    }
;



partieInstruction: inst partieInstruction 
    | inst
;
inst : affectation point_virg
    | conditionIF 
    | boucle 
    | entreeSortie point_virg
;


affectation : IDF affect valeur_const_float {
    if(non_declarer($1)==0){
        printf("Erreur Semantique: Non Declaree de %s dans la ligne %d et la colonne %d \n",$1,nb_ligne,colonne);
    }else{
    if(modification_cst($1)==0){
            printf("Erreur Semantique: Modification d'une constante de %s dans la ligne %d et la colonne %d \n",$1,nb_ligne,colonne);
    }
    else {
        if(incompatible_type(getType($1),1) == 0){
            printf("Erreur Semantique: Incompatible Type de %s  dans la ligne %d et la colonne %d \n",$1,nb_ligne,colonne);
        } else {
            char temp[12];
            sprintf(temp, "%f", $3);
            GenererQuadruplet("=", temp, "", $1);
        }
    }
    } 
};
| IDF affect valeur_const_int {
    if(non_declarer($1)==0){
        printf("Erreur Semantique: Non Declaree de %s dans la ligne %d et la colonne %d \n",$1,nb_ligne,colonne);
    }else{
    if(modification_cst($1)==0){
            printf("Erreur Semantique: Modification d'une constante de %s dans la ligne %d et la colonne %d \n",$1,nb_ligne,colonne);
    }
    else {
        if(incompatible_type(getType($1),0) == 0){
            printf("Erreur Semantique: Incompatible Type de %s  dans la ligne %d et la colonne %d \n",$1,nb_ligne,colonne);
        } else {
            char temp[12];
            sprintf(temp, "%d", $3);
            GenererQuadruplet("=", temp, "", $1);
        }
    }
    } 
}
| IDF affect IDF {
      if(non_declarer($1)==0 || non_declarer($3)==0){
        printf("Erreur Semantique: Non Declaree de %s dans la ligne %d et la colonne %d \n",$1,nb_ligne,colonne);
    }else{
    if(modification_cst($1)==0){
            printf("Erreur Semantique: Modification d'une constante de %s dans la ligne %d et la colonne %d \n",$1,nb_ligne,colonne);
    }else{
        if(incompatible_type(getType($1), getType($3)) == 0){
            printf("Erreur Semantique: Incompatible Type de %s et %s dans la ligne %d et la colonne %d \n",$1,$3,nb_ligne,colonne);
            
        } else {
            GenererQuadruplet("=", $3, "", $1);
        } 
    }
    }    
}
| IDF affect chaine 
 {
    if(non_declarer($1)==0){
        printf("Erreur Semantique: Non Declaree de %s dans la ligne %d et la colonne %d \n",$1,nb_ligne,colonne);
    }else{
    if(modification_cst($1)==0){
            printf("Erreur Semantique: Modification d'une constante de %s dans la ligne %d et la colonne %d \n",$1,nb_ligne,colonne);
    }
    else {
        if(incompatible_type(getType($1),2) == 0){
            printf("Erreur Semantique: Incompatible Type de %s  dans la ligne %d et la colonne %d \n",$1,nb_ligne,colonne);
        } else {
            GenererQuadruplet("=", $3, "", $1);
        }
    }
    }
 }
| IDF affect expression
;


expression: terme
         | expression plus terme
         | expression minus terme
         
;
terme: facteur
     | terme mul facteur
     | terme division facteur 
;
facteur: IDF {
             if(non_declarer($1)==0) {
                 printf("Erreur Semantique: Variable Non Declaree %s dans la ligne %d et la colonne %d \n", $1, nb_ligne, colonne);
                }
            }
       | valeur_const_float 
       | valeur_const_int
       | parth_ouvr expression parth_ferm
;


conditionIF: IF parth_ouvr condition parth_ferm acc_ouvr partieInstruction acc_ferm ELSE acc_ouvr partieInstruction acc_ferm
           | IF parth_ouvr condition parth_ferm acc_ouvr partieInstruction acc_ferm
;



condition: parth_ouvr condition and condition parth_ferm //(Var1 > 0 & Var2 < 0)
        | parth_ouvr condition or condition parth_ferm
        | parth_ouvr neg condition parth_ferm // (( ! ))
        | expression inf expression
        | expression sup expression
        | expression eg expression
        | expression noneg expression
        | expression infeg expression
        | expression supeg expression
;



boucle: FOR parth_ouvr 
        IDF affect expression 
        deuxpoints expression deuxpoints 
        IDF parth_ferm
        acc_ouvr partieInstruction acc_ferm 
        {
            if(non_declarer($3)==0) {
                printf("Erreur Semantique: Variable de boucle Non Declaree %s dans la ligne %d et la colonne %d \n", $3, nb_ligne, colonne);
            }
            if(non_declarer($9)==0) {
                printf("Erreur Semantique: Variable de boucle Non Declaree %s dans la ligne %d et la colonne %d \n", $9, nb_ligne, colonne);
            }
            if(incompatible_type(getType($3), 0) == 0 || incompatible_type(getType($9), 0) == 0) {
                printf("Erreur Semantique: Variables de boucle doivent etre de type INTEGER\n");
            }
        }
;

entreeSortie: READ parth_ouvr IDF parth_ferm 
                    {
                        if(non_declarer($3)==0) {
                            printf("Erreur Semantique: Variable Non Declaree %s dans la ligne %d et la colonne %d \n", $3, nb_ligne, colonne);
                        }
                        if (Recherche($3)->nature ==1) {
                            printf("Erreur Semantique : Read constant ! ");
                        }
                    }
           | WRITE parth_ouvr write_content parth_ferm
;

write_content: chaine
             | chaine virg IDF {
                 if(non_declarer($3)==0) {
                     printf("Erreur Semantique: Variable Non Declaree %s dans la ligne %d et la colonne %d \n", $3, nb_ligne, colonne);
                 }
             }
             | chaine virg IDF virg chaine {
                 if(non_declarer($3)==0) {
                     printf("Erreur Semantique: Variable Non Declaree %s dans la ligne %d et la colonne %d \n", $3, nb_ligne, colonne);
                 }
             }
;
%%
int yyerror(char* msg)
{printf("Erreur Syntaxique a la ligne %d et colonne %d: \n",nb_ligne,colonne);
return 0;
}

int main()  {   

yyparse(); 

return 0;  
}