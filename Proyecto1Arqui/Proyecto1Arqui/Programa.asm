includelib \Windows\System32\kernel32.dll
includelib ucrt.lib
includelib legacy_stdio_definitions.lib

EXTERN printf: PROC
EXTERN scanf: PROC

ExitProcess proto

.data
    labelA  db "Ingrese a: ", 0
    labelP db "Ingrese p: ", 0
    valorA  db "%lld", 0
    valorP  db "%lld", 0
    labelResultado db "a = %lld, p = %lld", 10, 0
    a dq ?
    p dq ?

.code
main PROC
    sub RSP, 28h ; reservar espacio en la pila 

    sub RSP, 10h ; reservar espacio para alinear la pila a 16 bytes

    call leerEntrada ; llama a la función para leer los valores

    mov RAX, [RSP]      ; a
    mov RCX, [RSP+8]    ; p

    lea RCX, labelResultado
    mov RDX, [RSP]      ; a
    mov R8,  [RSP+8]    ; p
    call printf

    add RSP, 10h        ; limpiar slots

    mov ECX, 0          ; cédigo de éxito
    call ExitProcess
main ENDP

leerEntrada PROC
    push RBX            ; preservar RBX, RSP-8
    sub RSP, 20h       

    lea RBX, [RSP+30h]  ; guardar dirección de a en RBX

    lea RCX, labelA
    call printf

    lea RCX, valorA
    mov RDX, RBX        ; dirección a
    call scanf

    lea RCX, labelP
    call printf

    lea RCX, ValorP
    lea RDX, [RBX+8]    ; dirección p (8 bytes después de a)
    call scanf

    add RSP, 20h
    pop RBX
    ret
leerEntrada ENDP

END