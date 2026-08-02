/***************************************************************
 *
 *  Copyright (C) 1992-2002, by Dan Mercer. All rights reserved
 *
 *  Program Name : $Source: /Volumes/darwinbuild2/svn-conversions/darwinports/dports/x11/xping/files/xping.c,v $
 *  Version : $Revision: 1.1 $
 *  Date Created : Mon Feb 25 09:55:16 CST 1992
 *  Author : Dan A. Mercer
 *  Last Modified : $Date: 2003/11/24 22:40:07 $
 *  Modified By : $Author: rshaw $ *
 *  Description : Determine if Xserver running on DISPLAY
 ***************************************************************/
#include <stdio.h>
#include <X11/Intrinsic.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <sys/malloc.h>
#include <stdlib.h>
 
#define DEF_ALARM 5
 
char *argname; char *display;
 
void help(msg) char *msg; { char *help_msg; char *t; int l;
 
    t = argname; l = strlen(t); help_msg = (!msg || !strlen(msg))
                                    ? "Determine if Xserver running on DISPLAY"
                                    : msg;
 
    fprintf(stderr,
            "%s\n"
            "%s -[hv] [-d delay ] [display_name]\n" "Options:\n"
            " -h this message.\n"
            " -v output version.\n"
            " -d delay delay time in seconds (default 5)\n"
            " display_name display to check - default $DISPLAY\n",
            help_msg, t,l," ");
    exit(0);
}
 
static int wake_up() {
    printf("%s: Couldn't open display %s\n", argname, display);
    exit(1);
}
 
main (int argc, char **argv) {
    /* *start of main procedure */
    extern char *optarg;
    extern int optind;
    extern int optopt;
    int opt;
    int delay;
    int pipefd[2];
    Display *dpy;
    char *tmpdpy;
    char buf[128];
 
    argname = strrchr(argv[0],'/');
    argname = (argname) ? argname + 1 : argv[0];
    delay = 0;
 
    while ((opt = getopt(argc, argv, ":hvd:")) != EOF) {
        if ('-' == *optarg) {
            fprintf(stderr,"%s: Option -%c requires an argument\n",
                    argname,
                    optopt);
            exit(2);
        }
        switch (opt) {
        case 'h' :
            help("");
            break;
        case 'v' :
            fprintf(stderr, "%s: $Revision: 1.1 $\n", argname);
            break;
        case 'd' :
            delay = atoi(optarg);
            if (!delay) help("Delay time must be non-zero");
            break;
        case ':' :
            fprintf(stderr, "Option -%c requires an argument\n",optopt);
            break;
        case '?' :
            fprintf(stderr, "Unrecognized option: -%c\n",optopt);
            break;
        }
    }
 
    switch (argc - optind) {
    case 0 :
        if (NULL == (display = getenv("DISPLAY")))
            help("No display name provided and $DISPLAY not set");
        break;
    case 1 :
        display = argv[optind];
        break;
    default :
        help ("Too many args");
        break;
    }
 
    if (!strchr(display, ':')) {
        tmpdpy = calloc(1,strlen(display) + 3);
        sprintf(tmpdpy,"%s:0", display);
        display = tmpdpy;
    }
 
    /*
     * set up an internal pipe, piping this executables stderr
     * to it's own stdin so we can capture any error messages */
    pipe (pipefd);

    dup2(pipefd[0],fileno(stdin));
    dup2(pipefd[1],fileno(stderr));
 
    signal(SIGALRM,wake_up);
    alarm((delay) ? delay : DEF_ALARM);
 
    dpy = XOpenDisplay(display);
 
    if (dpy) { XCloseDisplay(dpy);
        printf("%s: Opened display %s\n", argname, display);
        
        exit(0);
    } else {
        fflush(stderr);
        /* shouldn't be necessary */
        while (fgets(buf,sizeof buf,stdin)) {
            fputs(buf,stdout);
            if (strstr(buf, "not authorized")){
                printf("%s: %s: %s", argname, display, buf);
                exit(0);
            }
        }
        
        printf("%s: Couldn't open display %s\n", argname, display);
        exit(1);
    }
}
 
