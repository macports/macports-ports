/*
https://github.com/q3hardcore/pbzx-golfed
GPLv3
Modified by ryandesign to read from stdin and write to stdout.
*/
#include<stdio.h>
#include<stdlib.h>
#include<lzma.h>
uint64_t p,b,z,x,*n;uint8_t*d,*e;void r(){z=*n;for(x=0;x<8;x++)((char*)n)[x]=((char*)&z)[7-x];}int main(int c,char**v){FILE*i=stdin,*o=stdout;fread(&p,4,1,i);fread(&p,8,1,i);while(fread(&p,8,1,i)){n=&p;r();fread(&b,8,1,i);n=&b;r();d=malloc(b);fread(d,b,1,i);if(p>b){size_t i=0,j=0;e=malloc(p);z=-1;b=lzma_stream_buffer_decode(&z,0,NULL,d,&i,b,e,&j,p);free(d);d=e;}fwrite(d,p,1,o);free(d);}return 0;}
