#include <stdio.h>
#include "mylib.h"

int main(int argc, char **argv) { 

    printf("%s: %d args\n", argv[0], argc);
    printf("do_something: %d\n", do_something(argc)); 

    return 0; 
}
