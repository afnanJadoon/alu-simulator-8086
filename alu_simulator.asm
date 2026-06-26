.model small
.stack 200h
.data
    ; --- Operand & Result Storage ---
    num1        DW 0
    num2        DW 0
    result      DW 0
    operation   DB 0
    saved_flags DW 0        ; stores flags right after operation

    ; --- Flag Storage ---
    flag_zf     DB 0
    flag_cf     DB 0
    flag_sf     DB 0
    flag_of     DB 0
    flag_pf     DB 0

    ; --- UI Strings ---
    str_title     DB 'ALU SIMULATOR - 8086 ASSEMBLY',0
    str_subtitle  DB 'Computer Organization & Assembly Language',0
    str_made      DB 'Made by AHA',0
    str_border    DB '께께께께께께께께께께께께께께께께께께께께께께�',0
    str_choose    DB '  Choose Operation:',0
    str_menu1     DB '  [1] ADD    [2] SUB    [3] MUL    [4] DIV',0
    str_menu2     DB '  [5] AND    [6] OR     [7] XOR    [8] NOT',0
    str_menu3     DB '  [9] SHL    [A] SHR    [0] EXIT',0
    str_enter1    DB 'Enter Number 1 (AX): ',0
    str_enter2    DB 'Enter Number 2 (BX): ',0
    str_enter_one DB 'Enter Number  (AX): ',0
    str_num1      DB '  AX = ',0
    str_num2      DB '  BX = ',0
    str_result    DB '  RESULT = ',0
    str_flags     DB '  FLAGS:',0
    str_zf        DB '  ZF=',0
    str_cf        DB '  CF=',0
    str_sf        DB '  SF=',0
    str_of        DB '  OF=',0
    str_pf        DB '  PF=',0
    str_divzero   DB '  !! ERROR: Division by Zero !!',0
    str_exit      DB '  Thank you for using ALU Simulator. Goodbye!',0
    str_press     DB '  Press any key to return to menu...',0
    str_op_add    DB '  Operation: ADD   [ AX + BX ]',0
    str_op_sub    DB '  Operation: SUB   [ AX - BX ]',0
    str_op_mul    DB '  Operation: MUL   [ AX * BX ]',0
    str_op_div    DB '  Operation: DIV   [ AX / BX ]',0
    str_op_and    DB '  Operation: AND   [ AX & BX ]',0
    str_op_or     DB '  Operation: OR    [ AX | BX ]',0
    str_op_xor    DB '  Operation: XOR   [ AX ^ BX ]',0
    str_op_not    DB '  Operation: NOT   [ ~AX ]  (flags unchanged by NOT)',0
    str_op_shl    DB '  Operation: SHL   [ AX << 1 ]',0
    str_op_shr    DB '  Operation: SHR   [ AX >> 1 ]',0

 
.code

 
; MAIN
 
main PROC
    mov ax, @data
    mov ds, ax

    ; Set 80x25 color text mode
    mov ah, 00h
    mov al, 03h
    int 10h

    ; Hide cursor
    mov ah, 01h
    mov cx, 2000h
    int 10h

MAIN_LOOP:
    call DRAW_MAIN_SCREEN
    call GET_OPERATION

    mov al, [operation]
    cmp al, '0'
    je  DO_EXIT

    call PROCESS_OPERATION
    jmp MAIN_LOOP

DO_EXIT:
    call CLEAR_SCREEN
    mov dh, 12
    mov dl, 15
    call SET_CURSOR
    mov bl, 0Ah
    lea si, str_exit
    call PRINT_COLORED
    mov ah, 07h            
    int 21h
    mov ah, 4Ch
    int 21h
main ENDP

 
; DRAW_MAIN_SCREEN
 
DRAW_MAIN_SCREEN PROC
    call CLEAR_SCREEN

    ; Row 1 - top border cyan
    mov dh, 1
    mov dl, 14
    call SET_CURSOR
    mov bl, 0Bh
    lea si, str_border
    call PRINT_COLORED

    ; Row 2 - title yellow
    mov dh, 2
    mov dl, 22
    call SET_CURSOR
    mov bl, 0Eh
    lea si, str_title
    call PRINT_COLORED

    ; Row 3 - subtitle gray
    mov dh, 3
    mov dl, 16
    call SET_CURSOR
    mov bl, 08h
    lea si, str_subtitle
    call PRINT_COLORED

    ; Row 4 - Made by AHA bright white
    mov dh, 4
    mov dl, 27
    call SET_CURSOR
    mov bl, 0Fh
    lea si, str_made
    call PRINT_COLORED

    ; Row 5 - border cyan
    mov dh, 5
    mov dl, 14
    call SET_CURSOR
    mov bl, 0Bh
    lea si, str_border
    call PRINT_COLORED

    ; Row 7 - choose label white
    mov dh, 7
    mov dl, 14
    call SET_CURSOR
    mov bl, 0Fh
    lea si, str_choose
    call PRINT_COLORED

    ; Row 9 - menu row 1 green
    mov dh, 9
    mov dl, 14
    call SET_CURSOR
    mov bl, 0Ah
    lea si, str_menu1
    call PRINT_COLORED

    ; Row 10 - menu row 2 green
    mov dh, 10
    mov dl, 14
    call SET_CURSOR
    mov bl, 0Ah
    lea si, str_menu2
    call PRINT_COLORED

    ; Row 11 - menu row 3 green (all green, no more red exit)
    mov dh, 11
    mov dl, 14
    call SET_CURSOR
    mov bl, 0Ah
    lea si, str_menu3
    call PRINT_COLORED

    ; Row 13 - bottom border cyan
    mov dh, 13
    mov dl, 14
    call SET_CURSOR
    mov bl, 0Bh
    lea si, str_border
    call PRINT_COLORED

    ; Row 15 - show cursor for input
    mov dh, 15
    mov dl, 14
    call SET_CURSOR
    mov bl, 0Fh

    mov ah, 01h
    mov cx, 0607h
    int 10h

    ret
DRAW_MAIN_SCREEN ENDP

 
; GET_OPERATION - waits for keypress, stores in [operation]
 
GET_OPERATION PROC
    mov ah, 07h            
    int 21h

    ; Convert lowercase to uppercase for A/a
    cmp al, 'a'
    jne GO_STORE
    mov al, 'A'
GO_STORE:
    mov [operation], al

    ; hide cursor
    mov ah, 01h
    mov cx, 2000h
    int 10h
    ret
GET_OPERATION ENDP
                      \
; PROCESS_OPERATION 
 
PROCESS_OPERATION PROC
    mov al, [operation]

    cmp al, '1'
    je  DO_ADD
    cmp al, '2'
    je  DO_SUB
    cmp al, '3'
    je  DO_MUL
    cmp al, '4'
    je  DO_DIV
    cmp al, '5'
    je  DO_AND
    cmp al, '6'
    je  DO_OR
    cmp al, '7'
    je  DO_XOR
    cmp al, '8'
    je  DO_NOT
    cmp al, '9'
    je  DO_SHL
    cmp al, 'A'
    je  DO_SHR
    ret

;   ADD  
DO_ADD:
    call GET_TWO_INPUTS
    mov ax, [num1]
    mov bx, [num2]
    add ax, bx
    mov [result], ax
    pushf
    pop [saved_flags]
    call EXTRACT_FLAGS
    lea si, str_op_add
    call SHOW_RESULT
    ret

;   SUB  
DO_SUB:
    call GET_TWO_INPUTS
    mov ax, [num1]
    mov bx, [num2]
    sub ax, bx
    mov [result], ax
    pushf
    pop [saved_flags]
    call EXTRACT_FLAGS
    lea si, str_op_sub
    call SHOW_RESULT
    ret                                              
    
DO_MUL:
    call GET_TWO_INPUTS
    mov ax, [num1]
    mov bx, [num2]
    mul bx
    mov [result], ax        ; lower 16 bits of product
    pushf
    pop [saved_flags]
    call EXTRACT_FLAGS
    lea si, str_op_mul
    call SHOW_RESULT
    ret

;   DIV  
DO_DIV:
    call GET_TWO_INPUTS
    mov bx, [num2]
    cmp bx, 0
    je  SHOW_DIV_ZERO
    mov ax, [num1]
    mov dx, 0
    div bx
    mov [result], ax
    pushf
    pop [saved_flags]
    call EXTRACT_FLAGS
    lea si, str_op_div
    call SHOW_RESULT
    ret

SHOW_DIV_ZERO:
    call CLEAR_SCREEN
    mov dh, 12
    mov dl, 14
    call SET_CURSOR
    mov bl, 0Ch
    lea si, str_divzero
    call PRINT_COLORED
    call WAIT_KEY
    ret

;   AND  
DO_AND:
    call GET_TWO_INPUTS
    mov ax, [num1]
    mov bx, [num2]
    and ax, bx
    mov [result], ax
    pushf
    pop [saved_flags]
    call EXTRACT_FLAGS
    lea si, str_op_and
    call SHOW_RESULT
    ret

;   OR  
DO_OR:
    call GET_TWO_INPUTS
    mov ax, [num1]
    mov bx, [num2]
    or  ax, bx
    mov [result], ax
    pushf
    pop [saved_flags]
    call EXTRACT_FLAGS
    lea si, str_op_or
    call SHOW_RESULT
    ret

;   XOR  
DO_XOR:
    call GET_TWO_INPUTS
    mov ax, [num1]
    mov bx, [num2]
    xor ax, bx
    mov [result], ax
    pushf
    pop [saved_flags]
    call EXTRACT_FLAGS
    lea si, str_op_xor
    call SHOW_RESULT
    ret                                                 
    
DO_NOT:
    call GET_ONE_INPUT
    mov ax, [num1]
    not ax
    mov [result], ax
    pushf
    pop [saved_flags]
    call EXTRACT_FLAGS
    lea si, str_op_not
    call SHOW_RESULT
    ret

;   SHL  
DO_SHL:
    call GET_ONE_INPUT
    mov ax, [num1]
    shl ax, 1
    mov [result], ax
    pushf
    pop [saved_flags]
    call EXTRACT_FLAGS
    lea si, str_op_shl
    call SHOW_RESULT
    ret

;   SHR  
DO_SHR:
    call GET_ONE_INPUT
    mov ax, [num1]
    shr ax, 1
    mov [result], ax
    pushf
    pop [saved_flags]
    call EXTRACT_FLAGS
    lea si, str_op_shr
    call SHOW_RESULT
    ret

PROCESS_OPERATION ENDP

 
; GET_TWO_INPUTS
 
GET_TWO_INPUTS PROC
    call CLEAR_SCREEN
    call DRAW_INPUT_HEADER

    mov ah, 01h
    mov cx, 0607h
    int 10h

    mov dh, 7
    mov dl, 14
    call SET_CURSOR
    mov bl, 0Fh
    lea si, str_enter1
    call PRINT_COLORED
    call READ_DECIMAL
    mov [num1], ax

    mov dh, 9
    mov dl, 14
    call SET_CURSOR
    mov bl, 0Fh
    lea si, str_enter2
    call PRINT_COLORED
    call READ_DECIMAL
    mov [num2], ax

    mov ah, 01h                                                                     
    mov cx, 2000h
    int 10h
    ret
GET_TWO_INPUTS ENDP

 
; GET_ONE_INPUT
 
GET_ONE_INPUT PROC
    call CLEAR_SCREEN
    call DRAW_INPUT_HEADER

    mov ah, 01h
    mov cx, 0607h
    int 10h

    mov dh, 7
    mov dl, 14
    call SET_CURSOR
    mov bl, 0Fh
    lea si, str_enter_one
    call PRINT_COLORED
    call READ_DECIMAL
    mov [num1], ax

    mov ah, 01h
    mov cx, 2000h
    int 10h
    ret
GET_ONE_INPUT ENDP

 
; DRAW_INPUT_HEADER 
 
DRAW_INPUT_HEADER PROC
    mov dh, 1
    mov dl, 14
    call SET_CURSOR
    mov bl, 0Bh
    lea si, str_border
    call PRINT_COLORED

    mov dh, 2
    mov dl, 25
    call SET_CURSOR
    mov bl, 0Eh
    lea si, str_title
    call PRINT_COLORED

    mov dh, 3
    mov dl, 14
    call SET_CURSOR
    mov bl, 0Bh
    lea si, str_border
    call PRINT_COLORED
    ret
DRAW_INPUT_HEADER ENDP

 
SHOW_RESULT PROC
    push si                 ; save operation string pointer

    call CLEAR_SCREEN
    call DRAW_INPUT_HEADER

    ; Operation label - magenta row 5
    pop si
    mov dh, 5
    mov dl, 14
    call SET_CURSOR
    mov bl, 0Dh
    call PRINT_COLORED

    ; AX value - row 7
    mov dh, 7
    mov dl, 14
    call SET_CURSOR
    mov bl, 07h
    lea si, str_num1
    call PRINT_COLORED
    mov ax, [num1]
    call PRINT_DECIMAL

    ; BX value - row 8 (skip for single-input ops: NOT, SHL, SHR)
    mov al, [operation]
    cmp al, '8'
    je  SR_SKIP_BX
    cmp al, '9'
    je  SR_SKIP_BX
    cmp al, 'A'
    je  SR_SKIP_BX

    mov dh, 8
    mov dl, 14
    call SET_CURSOR
    mov bl, 07h
    lea si, str_num2
    call PRINT_COLORED
    mov ax, [num2]
    call PRINT_DECIMAL

SR_SKIP_BX:
    ; Separator row 10
    mov dh, 10
    mov dl, 14
    call SET_CURSOR
    mov bl, 0Bh
    lea si, str_border
    call PRINT_COLORED

    ; RESULT label+value - row 12 yellow
    mov dh, 12
    mov dl, 14
    call SET_CURSOR
    mov bl, 0Eh
    lea si, str_result
    call PRINT_COLORED
    mov ax, [result]
    call PRINT_DECIMAL

    ; FLAGS header - row 14 white
    mov dh, 14
    mov dl, 14
    call SET_CURSOR
    mov bl, 0Fh
    lea si, str_flags
    call PRINT_COLORED

    ; Individual flags - row 16 bright green
    mov dh, 16
    mov dl, 14
    call SET_CURSOR

    mov bl, 0Ah
    lea si, str_zf
    call PRINT_COLORED
    mov al, [flag_zf]
    add al, '0'
    mov ah, 0Eh
    int 10h

    lea si, str_cf
    call PRINT_COLORED
    mov al, [flag_cf]
    add al, '0'
    mov ah, 0Eh
    int 10h

    lea si, str_sf
    call PRINT_COLORED
    mov al, [flag_sf]
    add al, '0'
    mov ah, 0Eh
    int 10h

    lea si, str_of
    call PRINT_COLORED
    mov al, [flag_of]
    add al, '0'
    mov ah, 0Eh
    int 10h

    lea si, str_pf
    call PRINT_COLORED
    mov al, [flag_pf]
    add al, '0'
    mov ah, 0Eh
    int 10h

    ; Bottom border row 18
    mov dh, 18
    mov dl, 14
    call SET_CURSOR
    mov bl, 0Bh
    lea si, str_border
    call PRINT_COLORED

    call WAIT_KEY
    ret                   
SHOW_RESULT ENDP

 
; EXTRACT_FLAGS
 
EXTRACT_FLAGS PROC
    mov bx, [saved_flags]

    ; ZF = bit 6
    mov ax, bx
    mov cl, 6
    shr ax, cl
    and ax, 0001h
    mov [flag_zf], al

    ; CF = bit 0
    mov ax, bx
    and ax, 0001h
    mov [flag_cf], al

    ; SF = bit 7
    mov ax, bx
    mov cl, 7
    shr ax, cl
    and ax, 0001h
    mov [flag_sf], al

    ; OF = bit 11
    mov ax, bx
    mov cl, 11
    shr ax, cl
    and ax, 0001h
    mov [flag_of], al

    ; PF = bit 2
    mov ax, bx
    mov cl, 2
    shr ax, cl
    and ax, 0001h
    mov [flag_pf], al

    ret
EXTRACT_FLAGS ENDP

 
; READ_DECIMAL
 
READ_DECIMAL PROC
    push bx
    push cx
    push dx

    mov bx, 0
    mov cx, 10

RD_LOOP:
    mov ah, 01h
    int 21h

    cmp al, 0Dh             ; Enter
    je  RD_DONE
    cmp al, 08h             ; Backspace
    je  RD_BACK
    cmp al, '0'
    jl  RD_LOOP
    cmp al, '9'
    jg  RD_LOOP

    sub al, '0'
    mov ah, 0
    push ax
    mov ax, bx
    mul cx
    mov bx, ax
    pop ax
    add bx, ax
    jmp RD_LOOP

RD_BACK:
    cmp bx, 0
    je  RD_LOOP
    mov ax, bx
    mov dx, 0
    div cx
    mov bx, ax
    ; visual backspace
    mov ah, 0Eh
    mov al, 08h
    int 10h
    mov al, ' '
    int 10h
    mov al, 08h
    int 10h
    jmp RD_LOOP

RD_DONE:
    mov ax, bx
    pop dx
    pop cx
    pop bx
    ret
READ_DECIMAL ENDP

 
; PRINT_DECIMAL
 
PRINT_DECIMAL PROC
    push ax
    push bx
    push cx
    push dx

    mov bx, 10
    mov cx, 0

    ; check sign
    test ax, 8000h
    jz  PD_POSITIVE
    push ax
    mov ah, 0Eh
    mov al, '-'
    int 10h
    pop ax
    neg ax

PD_POSITIVE:
    cmp ax, 0
    jne PD_SPLIT
    mov ah, 0Eh
    mov al, '0'
    int 10h
    jmp PD_DONE

PD_SPLIT:
    cmp ax, 0
    je  PD_PRINT
    mov dx, 0
    div bx
    push dx
    inc cx
    jmp PD_SPLIT

PD_PRINT:
    cmp cx, 0
    je  PD_DONE
    pop dx
    mov ah, 0Eh
    mov al, dl
    add al, '0'
    int 10h
    dec cx
    jmp PD_PRINT

PD_DONE:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
PRINT_DECIMAL ENDP

 
; PRINT_COLORED
 
PRINT_COLORED PROC
    push ax
    push bx
    push cx
    push dx

PCL:
    mov al, [si]
    cmp al, 0
    je  PC_END
    mov ah, 09h
    mov bh, 0
    mov cx, 1
    int 10h
    ; get cursor, advance col
    mov ah, 03h
    mov bh, 0
    int 10h
    inc dl
    mov ah, 02h
    int 10h
    inc si
    jmp PCL

PC_END:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
PRINT_COLORED ENDP

 
; SET_CURSOR  DH=row, DL=col
 
SET_CURSOR PROC
    mov ah, 02h
    mov bh, 0
    int 10h
    ret
SET_CURSOR ENDP

 
; CLEAR_SCREEN - blue background fill
 
CLEAR_SCREEN PROC
    push ax
    push bx
    push cx
    push dx
    mov ah, 06h
    mov al, 0
    mov bh, 17h            
    mov cx, 0000h
    mov dx, 184Fh
    int 10h
    mov dh, 0
    mov dl, 0
    call SET_CURSOR
    pop dx
    pop cx
    pop bx
    pop ax
    ret
CLEAR_SCREEN ENDP

 
; WAIT_KEY
 
WAIT_KEY PROC
    mov dh, 21
    mov dl, 14
    call SET_CURSOR
    mov bl, 08h
    lea si, str_press
    call PRINT_COLORED
    mov ah, 07h             ; 
    int 21h
    ret
WAIT_KEY ENDP

END main