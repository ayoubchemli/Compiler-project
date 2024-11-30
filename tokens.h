#ifndef TOKENS_H
#define TOKENS_H

// Structure for symbol table entries
typedef enum {
    TYPE_INTEGER,
    TYPE_FLOAT,
    TYPE_CHAR,
    TYPE_ARRAY,
    TYPE_CONST
} DataType;

typedef struct {
    char name[9];          // 8 chars max + null terminator
    DataType type;         
    int isConstant;
    union {
        int intValue;
        float floatValue;
        char charValue;
        struct {
            DataType elementType;
            int size;
        } array;
    } value;
    int scope;            // 0 for global, 1 for local
    int line;             // Line where declared
    int initialized;      // Flag for initialization status
} SymbolEntry;

// Symbol Table functions
void initSymbolTable();
int insertSymbol(char* name, DataType type, int isConstant, int scope, int line);
SymbolEntry* lookupSymbol(char* name);
void printSymbolTable();
int checkDuplicate(char* name, int scope);

// External variables
extern int ligne;
extern char* yytext;
extern int yylex();
extern SymbolEntry symbolTable[1000];  // Assuming max 1000 symbols
extern int symbolCount;

#endif