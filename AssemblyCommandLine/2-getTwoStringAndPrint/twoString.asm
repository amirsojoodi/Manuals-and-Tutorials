    ; Compile with: nasm -f elf helloworld.asm
    ; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 helloworld.o -o helloworld
    ; Run with: ./helloworld

    SECTION .data
    msg     db      'Enter Two Strings: ', 0Ah
    msgLen equ $ - msg

    SECTION .bss
    string1:     resb    255
    string2:     resb    255

    SECTION .text
    global  _start

    _start:

        ;print msg
        mov     edx, msgLen
        mov     ecx, msg
        mov     ebx, 1
        mov     eax, 4
        int     80h

        mov     edx, 255        ; number of bytes to read
        mov     ecx, string1    ; reserved space to store our input (known as a buffer)
        mov     ebx, 0          ; write to the STDIN file
        mov     eax, 3          ; invoke SYS_READ (kernel opcode 3)
        int     80h

        mov     edx, 255        ; number of bytes to read
        mov     ecx, string2    ; reserved space to store our input (known as a buffer)
        mov     ebx, 0          ; write to the STDIN file
        mov     eax, 3          ; invoke SYS_READ (kernel opcode 3)
        int     80h

        mov     edx, 255
        mov     ecx, string1
        mov     ebx, 1
        mov     eax, 4
        int     80h

        mov     edx, 255
        mov     ecx, string2
        mov     ebx, 1
        mov     eax, 4
        int     80h
        mov     ebx, 0      ; return 0 status on exit - 'No Errors'
        mov     eax, 1      ; invoke SYS_EXIT (kernel opcode 1)
        int     80h
