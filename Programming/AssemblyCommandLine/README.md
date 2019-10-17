### Assume you have a 64 bit program that calls printf
```
# a.asm
$ nasm -f elf64 -l a.lst  a.asm
$ gcc -m64 -o a a.o
```

### Compile 
```
$ nasm -f elf twoString.asm
```

### Link (64 bit systems require elf_i386 option): 
```
$ ld -m elf_i386 twoString.o -o twoString
$ ./helloworld
```

