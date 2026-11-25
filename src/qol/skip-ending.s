; Skips the ending cutscene with Samus's monologue.

; In EndingSubroutine, change setting gSubGameMode from BSL crashing to case 3 instead of case 2
.org 08094EDCh
    mov     r0, #3
