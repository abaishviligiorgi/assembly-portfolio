mimateba proc
    mov eax, dword ptr [num1]          ; Load Operand 1 into EAX register
    add eax, dword ptr [num2]          ; Add Operand 2 to EAX (EAX = EAX + num2)
    cdq                                ; Sign-extend 32-bit EAX into 64-bit EDX:EAX quadword
    mov dword ptr [result+4],edx       ; Store the High 32-bits of the signed sum
    mov dword ptr [result],eax         ; Store the Low 32-bits of the signed sum
    ret
mimateba endp

gamokleba proc
    mov eax, dword ptr [num1]          ; Load Operand 1 into EAX register
    sub eax, dword ptr [num2]          ; Subtract Operand 2 from EAX (EAX = EAX - num2)
    cdq                                ; Sign-extend 32-bit EAX into 64-bit EDX:EAX quadword
    mov dword ptr [result+4],edx       ; Store the High 32-bits of the signed difference
    mov dword ptr [result],eax         ; Store the Low 32-bits of the signed difference
    ret
gamokleba endp

gamravleba proc
    mov eax, dword ptr [num1]          ; Load Operand 1 into EAX register
    imul dword ptr [num2]              ; Signed multiply EAX by num2 (Product goes to EDX:EAX)
    cdq                                ; Safely handle and sign-extend multiplication register state
    mov dword ptr [result+4],edx       ; Store the High 32-bits of the multiplication product
    mov dword ptr [result],eax         ; Store the Low 32-bits of the multiplication product
    ret
gamravleba endp

gayofa proc
    mov eax, dword ptr [num1]          ; Load Dividend (num1) into EAX register
    cdq                                ; Sign-extend EAX into EDX:EAX before division (Critical x86 step)
    idiv dword ptr [num2]              ; Signed divide EDX:EAX by num2 (Quotient in EAX, Remainder in EDX)
    mov dword ptr [result1],edx        ; Store the 32-bit division remainder into memory
    mov dword ptr [result],eax         ; Store the 32-bit division quotient into low result memory
    cdq                                ; Sign-extend the quotient into EDX:EAX to build a clean 64-bit output
    mov dword ptr [result+4], edx      ; Store the High 32-bits of the final quotient
    ret
gayofa endp

factorial proc
    mov eax,1                          ; Initialize Factorial product accumulator to 1
    mov ecx, dword ptr [num1]          ; Load the target factorial bound argument into ECX
loop1:
    imul ecx                           ; Multiply current accumulator (EAX) by ECX
    dec ecx                            ; Decrement counter loop index (ECX = ECX - 1)
    cmp ecx,0                          ; Compare index counter with terminal zero threshold
    jne loop1                          ; Repeat calculation loop if ECX is Not Zero
    cdq                                ; Sign-extend final 32-bit product into 64-bit EDX:EAX quadword
    mov dword ptr [result+4],edx       ; Store High 32-bits of the factorial product
    mov dword ptr [result],eax         ; Store Low 32-bits of the factorial product
    ret
factorial endp
