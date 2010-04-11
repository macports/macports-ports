/* For putenv(). */
#define _SVID_SOURCE
#define _XOPEN_SOURCE

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>

static const char *const real_exec = "/usr/sbin/chown";

static void printErr()
{
    fprintf(stderr, "\"%s\" wrapper error: %s (code %d)\n",
            real_exec, strerror(errno), errno);
    exit(EXIT_FAILURE);
}

int main(int argc, char *argv[])
{
    int i, j;
    char **new_argv;
    extern char **environ;
    if (argc > 1)
        argc = 1;
    new_argv = malloc(sizeof(*new_argv) * (argc + 3 + 1));
    j = 0;
    new_argv[j++] = "chown";
    new_argv[j++] = "-R";
    for (i = 1; i <= argc; ++i)
        new_argv[j++] = argv[i];
    new_argv[j++] = "@WINEPREFIX@";
    new_argv[j++] = "@ASSETS@";
    execve(real_exec, new_argv, environ);
    printErr();
    return 0;
}
