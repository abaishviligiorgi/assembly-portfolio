.686
.model flat, stdcall
option casemap:none

; Include necessary libraries for linker compilation
includelib gdi32.lib
includelib msvcrt.lib
includelib ucrt.lib
includelib legacy_stdio_definitions.lib
includelib user32.lib

; Declare Standard C Library external routines
extern printf: proc
extern scanf: proc
extern gets:proc
extern fopen: proc
extern fclose: proc
extern fwrite: proc
extern fread: proc
extern remove: proc
extern strlen: proc
extern rename: proc
extern fseek: proc
extern ftell: proc
extern malloc: proc
extern free: proc

.data
    ; --- Terminal UI / Header Block ---
    tavsarti      db 9, 9, 9, 9, 9, "CALCULATOR PROJECT V:1.3", 10, \
                     9, 9, 9, 9, 9, "Author: Giorgi Abaishvili", 10, \
                     9, 9, 9, 9, 9, "CTCS ACADEMY - Portfolio Piece", 10, \
                     9, 9, 9, 9, 9, "------------------------------", 10, 0 
                     
    ; --- IO Format Configuration Strings ---
    input1        db "%9d %c %9d", 0           ; Scanf standard syntax: Decimal-Char-Decimal
    output1       db 9, 9, 9, 9, 9, "Result: %lld , Remainder: %d", 10 , 0
    outputminus   db 9, 9, 9, 9, 9, "Result: %lld , Remainder: %d", 10 , 0
    searchout     db "Enter search number: ", 0
    
    ; --- Interactive User Interface Menu ---
    output        db 10, 9, 9, 9, 9, 9, "===== OPERATION MENU =====", 10 \
                  db 9, 9, 9, 9, 9, "1. Add: +", 10 \
                  db 9, 9, 9, 9, 9, "2. Sub: -", 10 \
                  db 9, 9, 9, 9, 9, "3. Mul: *", 10 \
                  db 9, 9, 9, 9, 9, "4. Div: /", 10 \
                  db 9, 9, 9, 9, 9, "5. Factorial: f0", 10 \
                  db 9, 9, 9, 9, 9, "6. Exit: 0e0", 10 \
                  db 9, 9, 9, 9, 9, "7. Enter search code '0s0': ", 10 \
                  db 9, 9, 9, 9, 9, "------------------------------", 10, 10, 0 

    result2       db "-",0
    
    ; --- 32-bit Arithmetic Operands ---
    num1          dd 0                         ; Stores first integer input
    num2          dd 0                         ; Stores second integer input
    nishani1      db 0                         ; Stores char operator state token
    
    ; --- 64-bit Result Buffers ---
    result        dq 0                         ; Main 64-bit computation quadword payload
    result1       dd 0                         ; Stores active division remainder chunk

    ; --- Persistence Layer / File Engine Parameters ---
    Saxeli        db "shedegebi.txt",0         ; Harddrive destination path signature
    Formata       db "ab",0                    ; Append Binary streaming mode
    formatr       db "rb",0                    ; Read Binary streaming mode
    formatw       db "wb",0                    ; Write Binary streaming mode
    Format        db "%d%c%d=%d",10,0          ; Logging text structure pattern
    
    ; --- Search Cache Allocations ---
    Buffer        db 100 dup(0)                ; Static storage array template allocation
    Addres        dd 0                         ; Primary operation file handle pointer
    buffer2       db 100 dup(0)                ; Legacy cache tracker
    addres2       dd 0                         ; Dynamic file lookup stream context
    searcher1     dd 0                         ; Container holding search query value
    searchout1    db "Enter search number: ",0 ; Display query prompt context
    formatid      db "%d", 0                   ; Scanf integer parsing formatting
    search_size   dd 0                         ; Retained system dynamic record width byte length
    search_ptr    dd 0                         ; Extracted allocated dynamic heap index track address

.code
; Integrate decentralized modular code components securely
include math.asm
include write.asm
include searcher.asm

main proc
    ; --- Function Execution Prologue ---
    push ebp
    mov ebp, esp
    sub esp, 20

    ; Print greeting terminal application banner
    push offset tavsarti
    call printf
    add esp, 4

calculator:
    ; Display main interactive operational operation menu
    push offset output
    call printf
    add esp, 4

    ; Securely stream operands and instruction routing char state token from interface
    push offset num2
    push offset nishani1
    push offset num1
    push offset input1
    call scanf
    add esp, 16

    ; Extract transaction command flag directly into AL registry
    mov al, byte ptr [nishani1]

shedareba:
    cmp al, "s"
    je search
    cmp al, "e"
    je end1
    cmp al, "f"
    je factorial1
    cmp al, "+"
    je mimateba1
    cmp al, "-"
    je gamokleba1
    cmp al, "*"
    je gamravleba1
    cmp al, "/"
    je gayofa1

mimateba1:
    call mimateba
    jmp validation_sign_check

gamokleba1:
    call gamokleba
    jmp validation_sign_check

gamravleba1:
    call gamravleba
    jmp validation_sign_check

gayofa1:
    call gayofa
    jmp validation_sign_check

factorial1:
    call factorial
    ; Fall through directly into evaluation block since factorial remains positive

validation_sign_check:
    ; Evaluate arithmetic quadword result signature flags before console tracking output
    cmp dword ptr [result], 0
    jl minusbechdva
    cmp dword ptr [result+4], 0
    jl minusbechdva
    jmp bechdva

bechdva:
    call chawera                            ; Log current calculation block to file system
    push dword ptr [result1]                ; Push division remainder element
    push dword ptr [result+4]               ; Push product quadword upper half segment
    push dword ptr [result]                 ; Push product quadword lower half segment
    push offset output1
    call printf
    add esp, 16
    jmp calculator

minusbechdva:
    call chawera                            ; Log signed calculation block to file system
    push dword ptr [result1]
    push dword ptr [result+4]
    push dword ptr [result]
    push offset outputminus
    call printf
    add esp, 16
    jmp calculator

search:
    call search1                            ; Activate low level file scanner logic block
    jmp calculator

end1:
    ; --- Function Execution Epilogue ---
    mov esp, ebp
    pop ebp
    ret
main endp

end main
