search1 proc
    ; --- Block: Fetch target search query from user ---
    push offset searchout1
    call printf
    add esp,4

    push offset searcher1
    push offset formatid
    call scanf
    add esp,8

    ; --- Block: Open database file and prepare memory ---
    push offset formatr
    push offset Saxeli
    call fopen
    add esp,8
    mov dword ptr [addres2],eax

    ; Move cursor to the very end of the file (SEEK_END = 2)
    push 2
    push 0
    push dword ptr [addres2]
    call fseek
    add esp,12

    ; Extract the total file size in bytes (Returned in EAX)
    push dword ptr [addres2]
    call ftell
    add esp,4

    ; --- Block: Calculate total number of recorded expressions ---
    mov dword ptr[search_size],eax
    xor edx,edx
    mov ebx,20                          ; Each calculator record is exactly 20 bytes
    div ebx                             ; EAX = Total records, EDX = Remainder
    mov ebx,eax                         ; EBX now acts as our loop record counter limit

    ; Rewind file cursor back to the beginning (SEEK_SET = 0)
    push 0
    push 0
    push dword ptr [addres2]
    call fseek
    add esp,12

    ; Dynamically allocate heap memory based on calculated file size
    push dword ptr[search_size]
    call malloc
    add esp,4
    mov dword ptr[search_ptr],eax       ; Save the extracted heap address pointer

    ; Stream all binary blocks from file directly into allocated RAM
    push dword ptr [addres2]
    push dword ptr[search_size]
    push 1
    push dword ptr[search_ptr]
    call fread
    add esp,16

    ; Safely close file tracking channel
    push dword ptr [addres2]
    call fclose
    add esp,4

    ; Initialize search registers
    mov edi, dword ptr [searcher1]      ; EDI = Target number we are looking for
    xor ecx,ecx                         ; ECX = Element index counter (Steps by 5 DWORDs)

; --- Block: Multi-offset search evaluation loop ---
searching:
    mov edx,dword ptr[search_ptr]       ; Reload volatile dynamic base address pointer
    push ecx                            ; Save index state before stack operations
    
    ; Evaluate current 20-byte block parameters against target query
    cmp edi, dword ptr[edx+4*ecx]      ; Check Operand 1 offset
    je searchaddres
    cmp edi, dword ptr[edx+8+4*ecx]    ; Check Operand 2 offset
    je searchaddres
    cmp edi, dword ptr[edx+12+4*ecx]   ; Check Arithmetic Result offset
    je searchaddres
    
    pop ecx                             ; Restore index context tracking
    dec ebx                             ; Decrement remaining records countdown
    cmp ebx,0
    je end1234                          ; Exit if all records have been evaluated
    add ecx,5                           ; Step forward 20 bytes (5 DWORD blocks)
    jmp searching

; --- Block: Print matched history elements ---
searchaddres:
    dec ebx                             ; Account for current record evaluation step
    
    ; Push current expression block values into stack backwards for printf
    push dword ptr[edx+12+4*ecx]        ; Result
    push dword ptr[edx+8+4*ecx]         ; Operand 2
    push dword ptr[edx+4+4*ecx]         ; Operator char
    push dword ptr[edx+4*ecx]           ; Operand 1
    push offset format
    call printf
    add esp,20                          ; Clear print parameters from stack

    pop ecx                             ; Restore active loop matrix index
    add ecx,5                           ; Advance index to next record block
    cmp ebx,0
    je end1234
    jmp searching

; --- Block: Safe Heap Disposal and Return Routine ---
end1234:
    push dword ptr[search_ptr]          ; Push allocated heap pointer address
    call free                           ; Return dynamic bytes back to the OS Memory Pool
    add esp, 4                          ; Calibrate execution stack context completely
    ret
search1 endp
