#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>


int main(int argc, char* argv[]){
    int fd = open("intFile.bin", O_RDONLY);
    int buff;
    int sum;
    while(read(fd, &buff, sizeof(int))){
        printf("%d\n", buff);
        sum += buff;
    }
    printf("%d\n", sum);
    close(fd);
    return 0;
}
