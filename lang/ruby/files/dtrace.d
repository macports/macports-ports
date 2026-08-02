provider ruby {
    probe function__entry(char*, char*, char*, int);
    probe function__return(char*, char*, char*, int);
    probe raise(char*, char*, int);
    probe rescue(char*, int);
    probe line(char*, int);

    /* gc probes */
    probe gc__begin();
    probe gc__end();

    /* Some initial memory type probes */
    probe object__create__start(char*, char*, int);
    probe object__create__done(char*, char*, int);
    probe object__free(char*);

    probe ruby__probe(char*, char*);
};

#pragma D attributes Evolving/Evolving/Common provider ruby provider
#pragma D attributes Private/Private/Common provider ruby module
#pragma D attributes Private/Private/Common provider ruby function
#pragma D attributes Evolving/Evolving/Common provider ruby name
#pragma D attributes Evolving/Evolving/Common provider ruby args
