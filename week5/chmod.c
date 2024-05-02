#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>

// update chmod-link.c

int main(int argc, char *argv[]) {
    struct stat statbuf;
    
    if (stat("foo", &statbuf) < 0) {
        printf("stat error for foo");
    }

    /*  turn off group-read on file "foo" */
    if (chmod("foo", statbuf.st_mode & ~S_IRGRP) < 0) {
        printf("chmod error for foo");
    }
    
    /* set absolute mode to "rw-r--r--" on file bar */
    if (chmod("bar", S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH) < 0) {
        printf("chmod error for bar");
    }

    printf("S_IRUSR = %d\n", S_IRUSR);
    
    if (chmod("foo", 0664) < 0) {
        printf("chmod error for foo");
    }
    
    return EXIT_SUCCESS;
}
