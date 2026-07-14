chawera proc
    ; --- Block: Prepare variables and serialize data into buffer ---
    mov eax, dword ptr [num1]
    mov dword ptr [buffer], eax          ; Copy Operand 1 to buffer offset 0
    
    mov eax, dword ptr [nishani1]
    mov dword ptr [buffer+4], eax        ; Copy Operator char to buffer offset 4
    
    mov eax, dword ptr [num2]
    mov dword ptr [buffer+8], eax        ; Copy Operand 2 to buffer offset 8
    
    mov eax, dword ptr [result]
    mov dword ptr [buffer+12], eax       ; Copy Low 32-bits of Result to buffer offset 12
    
    mov eax, dword ptr [result+4]
    mov dword ptr [buffer+16], eax       ; Copy High 32-bits of Result to buffer offset 16

    ; --- Block: Open/Create file stream in Append Binary mode ---
    push offset formata                 ; Mode: "ab" (Append Binary)
    push offset saxeli                  ; Target history file path name
    call fopen
    add esp, 8
    mov dword ptr [addres], eax          ; Save active file stream handle locator

    ; --- Block: Write exact 20-byte binary payload to disk ---
    push dword ptr [addres]             ; File handle pointer
    push 5                              ; Count: 5 data blocks (num1, sign, num2, res_low, res_high)
    push 4                              ; Size: Each block is exactly 4 bytes (DWORD) -> 5 * 4 = 20 bytes total
    push offset buffer                  ; Source buffer address pointer
    call fwrite
    add esp, 16                          ; Re-balance stack trace pointers completely

    ; --- Block: Safely close file channel to prevent memory locking ---
    push dword ptr [addres]
    call fclose
    add esp, 4
    
    ret
chawera endp
