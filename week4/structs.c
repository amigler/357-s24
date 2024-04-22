#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    struct s {
        int i;
        char c, c2;
        int i2;
        void *cp;
    };

    struct s s1 = { 123, 'a', 'b', 456 };
    struct s *sp = &s1;

    struct s s2 = s1;  // full copy

    void *vp = &s1;
    printf("vp =  %p\n", vp);
    vp++;
    printf("vp =  %p\n", vp);

    vp += sizeof(struct s);
    
    
    s1.c = 'x';

    printf("s1.c = %c\n", s1.c);
    printf("s2.c = %c\n", s2.c);
    
    s1.cp = &s1.c;
    
    printf("sizeof(int) = %lu\n", sizeof(int));
    printf("sizeof(char) = %lu\n", sizeof(char));
    printf("sizeof(struct s) = %lu\n", sizeof(struct s));

    printf("&s1 = %p\n", &s1);
    printf("&s1.i = %p\n", &(s1.i));
    printf("&s1.c2 = %p\n", &(s1.c2));

    printf("sp->c = %c\n", sp->c);

    
    union int_float_or_string_or_long {
        int ival;
        float fval;
        char *sval;
        long long ll;
        char c;
    };

    typedef union int_float_or_string_or_long var;
    
    var a,b,c;

    var vars[200];

    printf("sizeof(var) = %lu\n", sizeof(var));
    printf("sizeof(vars) = %lu\n", sizeof(vars));


    
    return EXIT_SUCCESS;
}
