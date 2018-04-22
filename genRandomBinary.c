#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

int main(int argc, char* argv[]){
    char* arg = argv[1];
    int numVals = atoi(arg);
    char* fileName;
    FILE* fp;
    int i, val;

    /* If argument list is empty, print 20 values by default */
    if(argc == 2){
        fileName = argv[1];
        fp = fopen(fileName, "wb");
        for(i = 0; i < 20; i++){
            val = rand()%9999;
            fwrite(&val, sizeof(int), 1, fp);
        }
    }

    else if(argc == 3){
        fileName = argv[2];
        fp = fopen(fileName, "wb");
        for(i = 0; i < numVals; i++){
            val = rand()%9999;
            fwrite(&val, sizeof(int), 1, fp);
        }
    }

    fclose(fp);
    return 0;
}
