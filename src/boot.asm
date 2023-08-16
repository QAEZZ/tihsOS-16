;;
;; Following Daedalus Community's Tutorial.
;;
;;
;;
;; STACK NOTES
;; In the stack, there is the top, and the base.
;;  123456789
;; ^top     ^base
;;
;; You can only pop, or push the top of the stack.
;; When popping a value from the stack, we remove
;; it and assign it to a register.
;;
;; This:
;; push 6
;; pop ax
;;
;; has the same effect as:
;; mov ax, 6
;;
;;
;;
;; PRINTING A CHAR TO THE SCREEN
;;
;; You need to switch to teletype mode.
;; You can achieve this by moving `ah`
;; to `0x0e`.
;;
;; To print a character, you need to
;; move `al`, to a character.
;; The character can be plain,
;; hex, or decimal.
;;
;; Here is each for the letter `A`:
;; Char: A
;; Dec.: 65
;; Hex.: 0x41
;;
;; After that, call a BIOS interrupt.
;; There are many different BIOS
;; interrupts. Use 0x10 for this case.
;;
;; For literals, use single quotes `'`,
;; otherwise, use double quotes `"`.`

mov ah, 0x0e
mov al, 't'
int 0x10 ;; the BIOS interrupt

mov ah, 0x0e
mov al, 'i'
int 0x10

mov ah, 0x0e
mov al, 'h'
int 0x10

mov ah, 0x0e
mov al, 's'
int 0x10

mov ah, 0x0e
mov al, 'O'
int 0x10

mov ah, 0x0e
mov al, 'S'
int 0x10

;;
;; PRINTING A STRING TO THE SCREEN
;;
;; Use a label to define a variable.
;; Once again, you have to enter
;; teletype mode (TTY).
;; 
;; To print the label, surround it 
;; with brackets. A label is a
;; pointer to the beginning of the
;; string. You have to dereference
;; it to actually print it. To do
;; this, wrap it in brackets.
;;
;; After that you have to add an
;; offset of `0x7c00`.
;; Why? Because memory addresses
;; aren't counted from 0. IDK why,
;; don't ask me.
;;
;; You can either add it to the
;; label: `mov al, [label + 0x7c00]`
;; or,
;; you can set the origin: `[org 0x7c00]`

[org 0x7c00]

mov ah, 0x0e            ;; enter TTY mode
mov bx, welcomeVariable ;; move the string variable to `bx`

call printString        ;; call the printString function

mov ah, 0x0e            ;; enter TTY mode
mov bx, testVariable
call printString 

jmp $

;; These are essentially functions 

printString:
    mov si, bx          ;; Load bx (pointer to string) into si

printLoop:
    mov al, [si]        ;; Load the character from [si] into al
    cmp al, 0           ;; Check if the character is null (end of string)
    je endPrint         ;; If null, jump to endPrint

    int 0x10            ;; BIOS interrupt to print character
    inc si              ;; Move to the next character
    jmp printLoop       ;; Jump back to printLoop to continue printing

endPrint:
    ret


testVariable:
    db 13,10,13,10,"test", 0

welcomeVariable:
    db 13,10,"Welcome to thisOS!", 0
    ;; `13,10` is a newline

;;
;; SIMPLE BOOT SECTOR SHIT THING
;; (16x REAL)
;; 
;; NOTES:
;; $ means current memory address
;; 
;; The boot sector, string, thingy, whatever,
;; needs to be 512 bytes long.

jmp $

;; times n action - repeats action n times
times 510-($-$$) db 0 ;; repeat `db 0`
;;         ^ current address minus section start = length of previous code section (equals 3)
;;           ($-$$) = 3 | 3+(510-3) = 510 | 510 + 2 (final numbers) = 512 bytes
db 0x55, 0xaa ;; The final two booting numbers, it
              ;; is was the boot loader looks for.
              ;;
              ;; To run:
              ;; Turn the .asm into a .bin (a bootable binary)
              ;; Tools needed are, nasm, qemu, gcc, dd (later)
              ;;
              ;; To create the binary file:
              ;; $ nasm -f bin boot.asm -o boot.bin
              ;;
              ;; To run it:
              ;; $ qemu-system-x86_64 boot.bin
              ;;
              ;; "Booting from Hard Disk..." means it's working.