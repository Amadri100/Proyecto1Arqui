includelib \Windows\System32\kernel32.dll
ExitProcess proto


.data

.code
main PROC
    terminar_programa:
            sub rsp, 28h
            mov ecx, 0          ; exit code
            call ExitProcess
main ENDP
END 
