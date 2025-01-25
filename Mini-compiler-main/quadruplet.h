#include <stdio.h>
#include <stdlib.h>
#include <string.h>
///////////////////Qudruplet//////////////////////////////////////////
//Structure d'un quadruplet 



typedef struct Quadruplet
{
	char* code_op; // le code operation 
	char* source1; // Premier operonde 
	char* source2; // Deuxieme operonde 
	char* destination; //La destination
}Quadruplet;

// Variables utilis�es 

Quadruplet QUAD[200]; // Le Quad qui contient les quadruplets g�n�r�s 
int QuadCourant = 1;  // Represente le quad courant 
char QuadCourantC[10]; // utilis�e pour la convertion du quadcourant en string
int tempN= 0; //variable utilis�e pour la generation d'une nouvelle variable temporaire 
char tempC[10]; //variable utilis�e pour les convertion en string

//Fonction de generation d'un quadruplet 
// a=b+c+c

void GenererQuadruplet(char* code_op,char* source1,char* source2,char* destination)
{
	
	QUAD[QuadCourant].code_op=malloc(8);
	sprintf_s(QUAD[QuadCourant].code_op,sizeof(QUAD[QuadCourant].code_op),"%s",code_op);
	QUAD[QuadCourant].source1=malloc(8);
	sprintf_s(QUAD[QuadCourant].source1,sizeof(QUAD[QuadCourant].source1),"%s",source1);
	QUAD[QuadCourant].source2=malloc(8);
	sprintf_s(QUAD[QuadCourant].source2,sizeof(QUAD[QuadCourant].source2),"%s",source2);
	QUAD[QuadCourant].destination=malloc(8);
	sprintf_s(QUAD[QuadCourant].destination,sizeof(QUAD[QuadCourant].destination),"%s",destination);
	 
	QuadCourant++;
     printf("(%s,%s,%s,%s)\n", code_op, source1, source2, destination);
}

float convert_to_float(const char* str) {
    // Check if the string is enclosed in parentheses
    int len = strlen(str);
    if (str[0] == '(' && str[len - 1] == ')') {
        // Create a temporary string without the parentheses
        char temp[len - 1];
        strncpy(temp, str + 1, len - 2);  // Copy the content without parentheses
        temp[len - 2] = '\0';  // Null-terminate the string
        
        // Convert the string to float
        return strtof(temp, NULL);
    }

    // If the string is not enclosed in parentheses, convert it directly to float
    return strtof(str, NULL);
}
int convert_to_int(const char* str) {
    // Check if the string is enclosed in parentheses
    int len = strlen(str);
    if (str[0] == '(' && str[len - 1] == ')') {
        // Create a temporary string without the parentheses
        char temp[len - 1];
        strncpy(temp, str + 1, len - 2);  // Copy the content without parentheses
        temp[len - 2] = '\0';  // Null-terminate the string
        
        // Convert the string to integer
        return strtol(temp, NULL, 10);
    }

    // If the string is not enclosed in parentheses, convert it directly to integer
    return strtol(str, NULL, 10);
}

int labelCounter = 0;

// Function to generate new labels
char* newLabel() {
    char* label = malloc(10);
    sprintf(label, "L%d", labelCounter++);
    return label;
}

void AfficherQuadruplet(int numQuadruplet)
{
	printf("\n%d |     %s    %s    %s     %s",numQuadruplet,QUAD[numQuadruplet].code_op,QUAD[numQuadruplet].source1,QUAD[numQuadruplet].source2,QUAD[numQuadruplet].destination);
	printf("\n----------------------------------------------------------------");
}

//////////////////////////////////////////////////////////////////////////////////////////////
