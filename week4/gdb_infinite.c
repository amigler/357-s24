#include <stdio.h>
#include <ctype.h>

int main(int argc, char **argv)
{
    char c;
    printf("Please enter a character: ");
    c = fgetc(stdin);
    while(c != EOF) {
        if(isalnum(c)) {
            printf("%c", c);
        } else {
            c = fgetc(stdin);
        }
    }
    return 1;
 }
