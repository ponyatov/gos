#include "main.hpp"
#include "libc.hpp"
#include "parser.hpp"

int main(int argc, char *argv[]) {
    arg(0, argv[0]);
    for (int i = 1; i < argc; i++) {  //
        arg(i, argv[i]);
        assert(yyin = fopen(argv[i], "r"));
        fclose(yyin);
    }
}

void arg(int argc, char *argv) {  //
    fprintf(stderr, "argv[%i] = <%s>\n", argc, argv);
}
