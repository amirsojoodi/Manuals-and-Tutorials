# 1
# Assume you have a 64 bit program that calls printf
# a.asm
nasm -f elf64 -l a.lst  a.asm
gcc -m64 -o a a.o


