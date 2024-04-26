#include <stdio.h>

void kerblam(int *p) {
    *p = 0;
}

void explode() {
    kerblam(NULL);
}

void kaboom() {
    explode();
}

int main(void) {
    kaboom();

    return 0;
}
