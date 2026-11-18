; Hijack code when loading pause screen
.org 0807B90Eh
    bl @LoadRoomName

.codeautoregion
    .align 2
; Load the current room name. The lines we are hijacking are:
; ldr     r2, [r7]
; mov     r1, #0FFh
; r7 is a pointer to the text to show for the Objective/Room Name message box.
; Loading the desired pointer to r7, then running the original lines will get
; the room name text to be loaded

.func @LoadRoomName
    push    { r0 }
    ldr     r2, =RoomNames
    ldr     r0, =CurrArea
    ldrb    r0, [r0]
    lsl     r0, #2
    ldr     r0, [r2, r0] ; Address of Area Name Table
    ldr     r2, =CurrRoom
    ldrb    r2, [r2]
    lsl     r2, #2
    ldr     r7, [r0, r2]
    pop     { r0 }
    ; Original Lines
    ldr     r2, [r7]
    mov     r1, #0FFh
    ; Return to hijacked location
    bx      lr

.endfunc
@UnknownRoom:
    .string  "Room name not provided"
.pool
.endautoregion

.org RoomNamesPointer
.area 04h
    .dw     RoomNames
.endarea

.dataautoregion
.align 4
RoomNames:
    .dw     Names_MainDeck
    .dw     Names_Sector1
    .dw     Names_Sector2
    .dw     Names_Sector3
    .dw     Names_Sector4
    .dw     Names_Sector5
    .dw     Names_Sector6
.endautoregion

.dataautoregion
    .align 4
Names_MainDeck:
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom
.endautoregion

.dataautoregion
    .align 4
Names_Sector1:
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom
.endautoregion

.dataautoregion
    .align 4
Names_Sector2:
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom
.endautoregion

.dataautoregion
    .align 4
Names_Sector3:
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom
.endautoregion

.dataautoregion
    .align 4
Names_Sector4:
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
.endautoregion

.dataautoregion
    .align 4
Names_Sector5:
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
.endautoregion

.dataautoregion
    .align 4
Names_Sector6:
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom, @UnknownRoom, @UnknownRoom, @UnknownRoom
    .dw     @UnknownRoom
.endautoregion
