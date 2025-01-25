
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     VAR_GLOBAL = 258,
     DECLARATION = 259,
     INSTRUCTION = 260,
     READ = 261,
     WRITE = 262,
     INTEGER = 263,
     FLOAT = 264,
     CHAR = 265,
     CONST = 266,
     IF = 267,
     ELSE = 268,
     FOR = 269,
     acc_ferm = 270,
     acc_ouvr = 271,
     croch_ouvr = 272,
     croch_ferm = 273,
     parth_ouvr = 274,
     parth_ferm = 275,
     virg = 276,
     point_virg = 277,
     deuxpoints = 278,
     affect = 279,
     minus = 280,
     plus = 281,
     division = 282,
     mul = 283,
     noneg = 284,
     eg = 285,
     infeg = 286,
     supeg = 287,
     sup = 288,
     inf = 289,
     neg = 290,
     or = 291,
     and = 292,
     IDF = 293,
     chaine = 294,
     chiffre_int_signe = 295,
     chiffre_int_non_signe = 296,
     chiffre_float_signe = 297,
     chiffre_float_non_signe = 298
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 16 ".\\syntSem.y"

    int INTEGER;
    float FLOAT;
    char CHAR;
    char* string;



/* Line 1676 of yacc.c  */
#line 104 "syntSem.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


