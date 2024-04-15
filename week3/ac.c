#include <stdio.h>

// ac.c - count the number of 'a' characters in a file / stdin
// (notably, missing error handling)
int main(int argc, char *argv[]) {
    // getchar() 

    int total = 0;
    
    int c = getchar();
    while (c != EOF) {
        if (c == 'a') {
            total++;
        }
        c = getchar();
    }

    printf("%i\n", total);
}
