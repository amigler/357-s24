#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    int         i;
    char        **ptr;
    extern char **environ;

    // echo command line arguments
    for (i = 0; i < argc; i++) {
        printf("argv[%d]: %s\n", i, argv[i]);
    }

    // echo environment variables
    for (ptr = environ; *ptr != 0; ptr++) {
        printf("%s\n", *ptr);
    }
    
    exit(0);
}
