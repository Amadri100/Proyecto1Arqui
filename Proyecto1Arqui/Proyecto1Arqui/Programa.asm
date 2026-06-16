includelib \Windows\System32\kernel32.dll
includelib ucrt.lib
includelib legacy_stdio_definitions.lib

EXTERN printf: PROC
EXTERN scanf: PROC

ExitProcess proto

.data
    labelA  db "Ingrese a: ", 0
    labelP db "Ingrese p: ", 0
    valorA  db "%lld", 0       ;Toma un entero de 64bits
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

algoritmoExtendidoEuclides PROC
;StackFrame
;RSP Return Adress
;RSP + 8 Parametro A
;RSP + 16 Parametro B
;RSP + 24 Valor retornado: arreglo de 2 numeros [MCD, x]

;Registros
    ;RBX = Auxiliar
    ;R15 = Auxiliar
    ;R8 = b0 Guarda el valor original de B
    ;R9 = x1
    ;R10 = x2
    ;R11 = y1
    ;R12 = y2
    ;R13 = x
    ;R14 = y
    ;RAX = cociente division / resultado multiplicacion
    ;RDX = residuo

cmp QWORD PTR [RSP +16], 0 ;IF (B = 0)
je final_casoB_si 
    
casoB_no: 
    mov R8, [RSP + 16] ;b0 <- B
    mov R9,  0 ; x1 <- 0
    mov R10, 1 ; x2 <- 1
    mov R11, 1 ; y1 <- 1
    mov R12, 0 ; y2 <- 0
while_b_le_0:
    cmp QWORD PTR [RSP + 16], 0      ; b > 0
    jng final_while_b_le_0 ; temina si !(b>0)

    mov RAX, [RSP + 8] ; RAX = A
    xor RDX, RDX ; RDX = 0 

    div QWORD PTR [RSP + 16] ; q = RAX, r = RDX

    mov RBX, RAX ; temporalmente mueve q  a RBX
    mov R15, RDX ; mueve r a R15

    mul R9  ; RAX <- q*x1
    
    mov R13, R10 ; x <- x2
    sub R13, RAX ; x <- x2 - q*x1

    mov RAX, RBX ; RAX <- q
    mul R11      ; RAX <- q*y1

    mov R14, R12 ; y <- y2
    sub R14, RAX ; y <- y2 - q*y1

    mov RBX, [RSP + 16]; RBX <- B
    mov [RSP + 8], RBX ; A <- B (Mediante RBX)

    mov R10, R9 ; x2 <- x1
    mov R9, R13 ; x1 <- x

    mov R12, R11; y2 <- x1
    mov R11, R14; y1 <- y

    jmp while_b_le_0
final_while_b_le_0: 
    mov RBX, [RSP + 8] ; RBX <- A
    mov [RSP + 24], RBX; mcd(d) <- A

    mov R14, R12       ; y <- y2

    cmp R10, 0         ;
    jnl if_no          ; 
                       ;Si se cumple x2 < 0 le agrega R8 de una 
    add R10, R8
    if_no:
        mov [RSP + 32], R10
    ret
final_casoB_si:
    mov RBX, [RSP + 8]                  ; RBX <- a
    mov QWORD PTR [RSP + 24], RBX ; d <- a
    mov QWORD PTR [RSP + 32], 1         ; x <- 1
    ret
    

algoritmoExtendidoEuclides ENDP

END