#include <unistd.h>

/* copy input to output */
int main(int argc, char* argv[])
{
    char buf[10];
    int n;
    while ((n = read(STDIN_FILENO, buf, 10)) > 0) {
        write(STDOUT_FILENO, buf, n);
    }
    return 0;
}
