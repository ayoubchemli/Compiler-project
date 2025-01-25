#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Déclaration de la structure pour la table des symboles
typedef struct element *TS;
typedef struct element {
    char nom[20];
    int type;   //! 0=intgr, 1=float, 2=char
    int nature; //! 0=var, 1=cst
    char value[20];
    TS suivant;
} element;

// Initialisation de la table des symboles
TS TableSymbole = NULL;  // La tête de la liste


//* Vérification de l'existence d'un identifiant dans la table des symboles.
TS Recherche(char n[]) {
    TS p = TableSymbole;
    while (p != NULL && strcmp(p->nom, n) != 0) {
        p = p->suivant;
    }
    return p;
}

//* Insertion d'éléments à la table des symboles.
int insertion(char name[20], int type, int nature) {
    TS nv;
    if (Recherche(name) == NULL) {
        nv = (TS)malloc(sizeof(element));
        nv->type = type;
        nv->nature = nature;
        strcpy(nv->nom, name);
        nv->suivant = TableSymbole;
        TableSymbole = nv;
        return 1;
    } else {
        return 0;
    }
}

//* Affichage de la table des symboles
void afficher() {
    printf("\033[94mLa table des symboles:\033[0m  \n");
    printf("+------------+------------+------------------------------+\n");
    printf("|    \033[94mType\033[0m    |   \033[94mNature\033[0m   |    \033[94mNom de la Variable\033[0m        |\n");
    printf("+------------+------------+------------------------------+\n");

    TS l = TableSymbole;
    while (l != NULL) {
        char *typeStr;
        switch (l->type) {
            case 0: typeStr = "Integer"; break;
            case 1: typeStr = "Float"; break;
            case 2: typeStr = "Char"; break;
            default: typeStr = "Unknown"; break;
        }

        char *natureStr;
        switch (l->nature) {
            case 0: natureStr = "Variable"; break;
            case 1: natureStr = "Constant"; break;
            default: natureStr = "Unknown"; break;
        }

        printf("| %-10s | %-10s | %-28s |\n", typeStr, natureStr, l->nom);
        printf("+------------+------------+------------------------------+\n");

        l = l->suivant;
    }
}

//* Insertion de la valeur de notre variable ou constante
void insererVal(char entite[], char val[]) {
    TS p = Recherche(entite);
    if (p != NULL) {
        strcpy(p->value, val);
    } else {
        printf("\x1b[31mEntite non trouvee dans la table des symboles\x1b[0m\n");

    }
}

//* Récupération de la valeur de la variable (supporte `char`)
int getValue(char entite[]) {
    TS p = Recherche(entite);
    if (p != NULL) {
        if (p->type == 0 || p->type == 1) { // int ou float
            return atoi(p->value);
        } else if (p->type == 2) { // char
            return p->value[0]; // Retourne le caractère sous forme ASCII
        }
    }
    printf("\x1b[31mEntite non trouvee ou type incompatible\x1b[0m\n");
    return -1;
}

//* Retourner le type de la variable
int getType(char entite[]) {
    TS x = Recherche(entite);
    if (x == NULL) return -1;
    return x->type;
}

// Liste intermédiaire pour sauvegarder des entités
typedef struct params_idf {
    char name[13];
    struct params_idf *suivant;
} params_idf;
typedef struct params_idf *TS2;

TS2 list2 = NULL;

//* Insertion dans la liste des paramètres
void insererparam(char n[]) {
    TS2 tete, temp;
    tete = (struct params_idf *)malloc(sizeof(struct params_idf));
    if (list2 == NULL) {
        list2 = tete;
        strcpy(list2->name, n);
        list2->suivant = NULL;
        return;
    }
    temp = list2;
    while (temp->suivant != NULL) {
        temp = temp->suivant;
    }
    temp->suivant = tete;
    strcpy(tete->name, n);
    tete->suivant = NULL;
}


//! --------------- Les Routines -------------------------------------
    //* incompatible type de variables
    int incompatible_type(int type1, int type2){
        if (type1 != type2) { return 0;} // faux : type icompatible
        return 1; // vrai : le mm type
    }
    //partie d'instruction : affectaion 
    //* Variable Non Déclaré     FAIT
    int non_declarer(char name[20]){
        
        TS x= Recherche(name);
        if (x!=NULL){return 1;} //faux : valeur declarer
        else{ return 0;} // vrai : valeur non declarer
    }
  
    int modification_cst(char name[20]){
        TS x= Recherche(name);
        if (x->nature== 1) { 
             
            return 0;// vrai : on modifie une constante
            }
        return 1 ; // faux: c'est une variable
    }
    //*Division par zero
    int division_par_zero(char entite[] ){
        TS x= Recherche(entite);
        if (x->value==0)  { 
            
            return 0; // valeur null
            }
        return 1; // valeur !=du 0
    }