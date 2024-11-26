/// @file
#pragma once

#include "libc.hpp"

/// @defgroup parser parser
/// @{

extern int yylex();   ///<
extern FILE *yyin;    ///<
extern int yylineno;  ///<
extern char *yytext;  ///<
extern char *yyfile;  ///<
extern int yyparse();
extern void yyerror(const char *msg);
#include "gos.parser.hpp"

/// @}
