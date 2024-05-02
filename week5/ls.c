#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <sys/stat.h>

#define dprint(expr) printf(#expr " = %lu\n", expr)

int main(int argc, char *argv[]) {
    
    DIR *dp = opendir("/usr/include");
    struct dirent *de = NULL;
    struct stat fstat;

    dprint(sizeof(struct dirent));
    dprint(sizeof(de));
    dprint(sizeof(struct stat));
    dprint(sizeof(fstat));
    
    while ((de = readdir(dp)) != NULL) {
        stat(de->d_name, &fstat);
        
        printf("inode: %lu, st_size: %lu, name: %s\n", de->d_ino, fstat.st_size, de->d_name);
    }

    closedir(dp);
    
    return EXIT_SUCCESS;
}
