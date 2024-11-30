%{
#include "tokens.h"
#include <stdio.h>
#include <stdlib.h>

extern int ligne;
int currentScope = 0;  // 0 for global, 1 for local
DataType currentType;  // To store the current type being processed
int inLoop = 0;       // Track if we're inside a loop
int errors = 0;       // Error counter

int yylex();
void yyerror(char *s);
%}

%union {
    char* str;
    int num;
    float fnum;
    char chr;
}

%token <str> IDF
%token <num> CONST_ENTIERE_SIGN CONST_ENTIERE_NON_SIGN
%token <fnum> CONST_FLOAT_SIGN CONST_FLOAT_NON_SIGN

%token VAR_GLOBAL DECLARATION INSTRUCTION
%token INTEGER FLOAT CHAR CONST
%token READ WRITE IF ELSE FOR
%token SEPARATEUR
%token OP_ARTH OP_LOGQ OP_COMP
%token AFFECT
%token CHAINE

/* Operator precedence and associativity */
%left OP_LOGQ
%left OP_COMP
%left '+' '-'
%left '*' '/'
%right '!'



%%

programme: VAR_GLOBAL { currentScope = 0; } bloc_global 
          DECLARATION { currentScope = 1; } bloc_declaration 
          INSTRUCTION bloc_instruction
        ;

bloc_global: '{' declarations_globales '}'
           | '{' '}'
           ;

bloc_declaration: '{' declarations '}'
                | '{' '}'
                ;

bloc_instruction: '{' instructions '}'
                | '{' '}'
                ;

declarations_globales: declaration_globale
                    | declarations_globales declaration_globale
                    ;

declaration_globale: type liste_idf ';'
                  | declaration_constante
                  | declaration_tableau
                  ;

declarations: declaration
           | declarations declaration
           ;

declaration: type liste_idf ';'
          | declaration_constante
          | declaration_tableau
          ;

declaration_constante: CONST type IDF AFFECT valeur ';' {
    SymbolEntry* entry = lookupSymbol($3);
    if (entry == NULL) {
        insertSymbol($3, currentType, 1, currentScope, ligne);
        entry = lookupSymbol($3);
        entry->initialized = 1;
    } else {
        yyerror("Symbol already declared");
    }
}
;

declaration_tableau: type IDF '[' CONST_ENTIERE_NON_SIGN ']' ';' {
    if ($4 <= 0) {
        yyerror("Array size must be positive");
    } else {
        SymbolEntry* entry = lookupSymbol($2);
        if (entry == NULL) {
            insertSymbol($2, TYPE_ARRAY, 0, currentScope, ligne);
            entry = lookupSymbol($2);
            entry->value.array.elementType = currentType;
            entry->value.array.size = $4;
        } else {
            yyerror("Symbol already declared");
        }
    }
}
;

type: INTEGER { currentType = TYPE_INTEGER; }
    | FLOAT { currentType = TYPE_FLOAT; }
    | CHAR { currentType = TYPE_CHAR; }
    ;

liste_idf: IDF {
    if (!insertSymbol($1, currentType, 0, currentScope, ligne)) {
        yyerror("Symbol declaration failed");
    }
}
| liste_idf ',' IDF {
    if (!insertSymbol($3, currentType, 0, currentScope, ligne)) {
        yyerror("Symbol declaration failed");
    }
}
;

instructions: instruction
           | instructions instruction
           ;

instruction: affectation
          | condition
          | boucle
          | entree_sortie
          ;

affectation: IDF AFFECT expression ';' {
    SymbolEntry* entry = lookupSymbol($1);
    if (entry == NULL) {
        yyerror("Undefined symbol");
    } else if (entry->isConstant) {
        yyerror("Cannot modify a constant");
    } else {
        entry->initialized = 1;
    }
}
| IDF '[' expression ']' AFFECT expression ';' {
    SymbolEntry* entry = lookupSymbol($1);
    if (entry == NULL) {
        yyerror("Undefined array");
    } else if (entry->type != TYPE_ARRAY) {
        yyerror("Symbol is not an array");
    }
}
;

condition: IF '(' expression_logique ')' bloc_instruction
         | IF '(' expression_logique ')' bloc_instruction ELSE bloc_instruction
         ;

boucle: FOR '(' init_for ':' step_for ':' condition_for ')' {
    inLoop++;
} bloc_instruction {
    inLoop--;
}
;

init_for: IDF AFFECT expression {
    SymbolEntry* entry = lookupSymbol($1);
    if (entry == NULL) {
        yyerror("Undefined loop variable");
    }
}
;

step_for: expression
        ;

condition_for: expression
             ;

entree_sortie: READ '(' IDF ')' ';' {
    SymbolEntry* entry = lookupSymbol($3);
    if (entry == NULL) {
        yyerror("Undefined symbol in READ");
    } else {
        entry->initialized = 1;
    }
}
| WRITE '(' write_args ')' ';'
;

write_args: expression
         | write_args ',' expression
         ;


expression: terme
         | expression OP_ARTH terme
         | '(' expression ')'
         ;

terme: facteur
     | terme OP_ARTH facteur
     ;


facteur: IDF {
    SymbolEntry* entry = lookupSymbol($1);
    if (entry == NULL) {
        yyerror("Undefined symbol");
    } else if (!entry->initialized) {
        yyerror("Using uninitialized variable");
    }
}
| CONST_ENTIERE_SIGN
| CONST_ENTIERE_NON_SIGN
| CONST_FLOAT_SIGN
| CONST_FLOAT_NON_SIGN
| IDF '[' expression ']' {
    SymbolEntry* entry = lookupSymbol($1);
    if (entry == NULL) {
        yyerror("Undefined array");
    } else if (entry->type != TYPE_ARRAY) {
        yyerror("Symbol is not an array");
    }
}
;

expression_logique: expression_comp
                 | '(' expression_logique OP_LOGQ expression_logique ')'
                 | '!' expression_logique
                 ;

expression_comp: expression OP_COMP expression
               ;
               
valeur: CONST_ENTIERE_SIGN
      | CONST_ENTIERE_NON_SIGN
      | CONST_FLOAT_SIGN
      | CONST_FLOAT_NON_SIGN
      ;

%%

void yyerror(char *s) {
    fprintf(stderr, "Error at line %d: %s\n", ligne, s);
    errors++;
}

int main(int argc, char **argv) {
    initSymbolTable();
    
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Error opening file");
            return 1;
        }
    }
    
    int result = yyparse();
    
    if (errors == 0) {
        printf("\nParsing completed successfully!\n");
        printSymbolTable();
    } else {
        printf("\nParsing completed with %d errors\n", errors);
    }
    
    if (yyin != stdin) {
        fclose(yyin);
    }
    
    return result;
}