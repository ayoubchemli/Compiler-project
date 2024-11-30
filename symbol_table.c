#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "tokens.h"

SymbolEntry symbolTable[1000];
int symbolCount = 0;

void initSymbolTable() {
    symbolCount = 0;
}

int checkDuplicate(char* name, int scope) {
    for(int i = 0; i < symbolCount; i++) {
        if(strcmp(symbolTable[i].name, name) == 0 && symbolTable[i].scope == scope) {
            return 1; // Duplicate found
        }
    }
    return 0; // No duplicate
}

int insertSymbol(char* name, DataType type, int isConstant, int scope, int line) {
    // Check if identifier follows the rules (starts with uppercase, max 8 chars)
    if(strlen(name) > 8 || !isupper(name[0])) {
        printf("Error at line %d: Invalid identifier '%s'\n", line, name);
        return 0;
    }

    // Check for duplicates in the same scope
    if(checkDuplicate(name, scope)) {
        printf("Error at line %d: Symbol '%s' already declared in this scope\n", line, name);
        return 0;
    }

    // Insert new symbol
    if(symbolCount < 1000) {
        strcpy(symbolTable[symbolCount].name, name);
        symbolTable[symbolCount].type = type;
        symbolTable[symbolCount].isConstant = isConstant;
        symbolTable[symbolCount].scope = scope;
        symbolTable[symbolCount].line = line;
        symbolTable[symbolCount].initialized = 0;
        symbolCount++;
        return 1;
    }

    printf("Error: Symbol table full\n");
    return 0;
}

SymbolEntry* lookupSymbol(char* name) {
    for(int i = symbolCount - 1; i >= 0; i--) {
        if(strcmp(symbolTable[i].name, name) == 0) {
            return &symbolTable[i];
        }
    }
    return NULL;
}

void printSymbolTable() {
    printf("\n=== Symbol Table ===\n");
    printf("Name\tType\tScope\tConst\tInit\tLine\n");
    printf("----------------------------------------\n");
    
    for(int i = 0; i < symbolCount; i++) {
        char* typeStr;
        switch(symbolTable[i].type) {
            case TYPE_INTEGER: typeStr = "INT"; break;
            case TYPE_FLOAT: typeStr = "FLOAT"; break;
            case TYPE_CHAR: typeStr = "CHAR"; break;
            case TYPE_ARRAY: typeStr = "ARRAY"; break;
            case TYPE_CONST: typeStr = "CONST"; break;
            default: typeStr = "UNKNOWN";
        }
        
        printf("%s\t%s\t%s\t%s\t%s\t%d\n",
            symbolTable[i].name,
            typeStr,
            symbolTable[i].scope == 0 ? "GLOBAL" : "LOCAL",
            symbolTable[i].isConstant ? "YES" : "NO",
            symbolTable[i].initialized ? "YES" : "NO",
            symbolTable[i].line
        );
    }
    printf("----------------------------------------\n");
}