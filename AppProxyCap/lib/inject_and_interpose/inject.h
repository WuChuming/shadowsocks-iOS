#include <unistd.h>
#include <mach/kern_return.h>

kern_return_t inject(pid_t pid, const char *path);

// The behavior is synchronous: when it returns, constructors have
// already been called.

// Bugs: Will fail, crash the target process, or even crash this process if the target task is weird.
