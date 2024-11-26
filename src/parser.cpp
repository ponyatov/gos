#include "libc.hpp"
#include "parser.hpp"

void yyerror(const char* msg) {
    fprintf(stderr, "\n\n%s:%s %s [%s]\n\n", yyfile, yylineno, msg, yytext);
    exit(-1);
}
