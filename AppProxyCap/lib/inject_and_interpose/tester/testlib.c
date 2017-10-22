#include <stdio.h>
#include <stdint.h>
#include <interpose.h>

int fake_puts(const char *s) {
    puts("whee");
    puts(s);
    return 0;
}

__attribute__((constructor))
static void hello() {
    fprintf(stderr, "Someone loaded me\n");
    fprintf(stderr, "%d\n", interpose("_puts", fake_puts)); 
}
