#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    char *s = "abc";

    char t[] = "abc";

    s = t;
    
    printf("%s, %s\n", s, t);
    
    printf("s == t evaluates to: %d\n", (s==t));

    printf("strcmp(s,t) evaluates to: %d\n", strcmp(s,t));
    
    return EXIT_SUCCESS;
}
