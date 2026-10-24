; Sets the default speaker mode to Stereo

.org DefaultStereoFlagPointer
.area 4
    .dw     DefaultStereoFlag
.endarea

.org 0809E8BAh
; Modifying OAM setup in FileSelectInit()
.area 4
    bl      @FileSelectInitHighjack_SetupOam
.endarea

.org 0809E8DEh
; Highjacks FileSelectInit(), enables stereo automatically
.area 4
    bl      @FileSelectInitHighjack_CheckEnableStereo
.endarea

.org 0809F670h
; Highjacks FileSelectSetupOam()
.area 4
    bl      @FileSelectSetupOamHighjack
.endarea

.autoregion
DefaultStereoFlag:
    .db     00

    .align 2
@FileSelectInitHighjack_SetupOam:
    mov     r1, #66h                ; Default x-position of selected speaker type cursor
    ldr     r0, =DefaultStereoFlag
    ldrb    r0, [r0]
    cmp     r0, #01
    bne     @@mono
    mov     r1, #0AAh               ; Modified x-position of selected speaker type cursor when switching to stereo
@@mono:
    mov     r0, #09h                ; OAM type used with the FileSelectSetupOam() function following this highjack
    bx      lr
    .pool

@FileSelectSetupOamHighjack:
    ; do not destroy r0, it contains the dest address for storing OAM Frame Pointers
    push    { r4 }
    ldr     r1, =087407E0h          ; Pointer to OAM Data for displaying the GBA as active speaker
    ldr     r4, =DefaultStereoFlag
    ldrb    r4, [r4]
    cmp     r4, #1
    bne     @@mono
    add     r1, #10h                ; Pointer to OAM Data for displaying headphones as active speaker
@@mono:
    str     r1, [r0]
    pop     { r4 }
    bx      lr
    .pool

@FileSelectInitHighjack_CheckEnableStereo:
    push    { lr }
    ldr     r1, =DefaultStereoFlag
    ldrb    r1, [r1]
    cmp     r1, #1
    bne     @@return
    ldr     r0, =NonGameplayRam + NonGameplayRam_FileSelect_OamData \
                + (FileSelectOam_Len * 15h) ; slot 15h
    strb    r1, [r0, #FileSelectOam_Stage]
    add     r0, #FileSelectOam_Len          ; slot 16h
    strb    r1, [r0, #FileSelectOam_Stage]
    mov     r0, #02000000h >> 12h
    lsl     r0, #12h

    ; the below takes 1 argument in r0, this function is not labeled in the
    ; disassembly project. It is related to setup of stereo audio output, but
    ; it is not clear from the disassembly project what the input value
    ; translates to.
    bl      080024ECh
@@return:
    bl      FileSelectDrawAllOam
    pop     { r0 }
    bx      r0
    .pool
.endautoregion
