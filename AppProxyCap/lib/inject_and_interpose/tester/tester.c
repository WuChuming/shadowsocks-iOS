#include <inject.h>
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char **argv) {
    pid_t pid = atoi(argv[1]);
    printf("pid=%d ", (int) pid);
    fflush(stdout);
    printf("kr=%x\n", (int) inject(pid, argv[2]));
    return 0;
}
