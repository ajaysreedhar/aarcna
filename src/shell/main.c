/**
 * A dummy shell main for testing user space EL0.
 */

#include <stdlib/io.h>

int shell_main(int argc, char** argv) {
    int v = argc + 5;

    print("This is a systemcall from user space.");

    return v;
}