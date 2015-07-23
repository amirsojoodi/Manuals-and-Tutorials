bits 64
global main
extern printf

section .text
main:
; function setup
push    rbp
mov     rbp, rsp
sub     rsp, 32
;
lea     rdi, [rel message]
mov     al, 0
call    printf

;print source message
lea     rdi, [rel source]
mov     al, 0
call    printf

;print target message
lea     rdi, [rel target]
mov     al, 0
call    printf



lea rdi, [rel target]
lea rsi, [rel source]
cld

Loop:

lodsb       ;Load byte at address RSI into AL
stosb       ;Store AL at address RDI

cmp  al, 'c'
jne  LoopBack

lodsb       ;Load byte at address RSI into AL
stosb       ;Store AL at address RDI
cmp  al, 'a'
jne  LoopBack

lodsb       ;Load byte at address RSI into AL
stosb       ;Store AL at address RDI
cmp  al, 't'
jne  LoopBack 

sub rdi, 3
mov byte [rdi], 'd'
inc rdi
mov byte [rdi], 'o'
inc rdi
mov byte [rdi], 'g'
inc rdi

LoopBack:
cmp al, 0
jne Loop

;print new version of target
lea     rdi, [rel target]
mov     al, 0
call    printf

; function return
mov     eax, 0
add     rsp, 32
pop     rbp
ret

section .data
message: db      'Project:',0x0D,0x0a,'Author:',0x0D,0x0a,0x0D,0x0a,0

source:  db "The cat chased the bird.",0x0a,0x0D,0
target:  db '0000000000000000000000000000000000000000000',0x0D,0x0a,0

success: db "Success",0
