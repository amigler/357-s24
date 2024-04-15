#include <stdio.h>

int main(int argc, char* argv[]) {

    // declaration automatically provided in stdio.h
    // FILE *stdin;
    
    int c = getc(stdin);
    printf("the char: %c\n", c);
    
}
