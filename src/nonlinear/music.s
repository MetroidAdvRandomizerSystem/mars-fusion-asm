; Overrides vanilla music behavior. Guts functionality for most sub-event
; specific songs.

.autoregion
    .align 2
.func Music_VariableFade
    push    { lr }
    mov     r0, #10
    ldr     r1, =03004E58h
    ldrb    r1, [r1]
    cmp     r1, #4
    bne     @@call_fade
    mov     r0, #30
@@call_fade:
    bl      Music_FadeOut
    pop     { pc }
    .pool
.endfunc
.endautoregion

.org Music_CheckSet + 2Ah
; Check currently playing slot for the desired track
.area 16h, 0
    mov     r0, MusicInfo_SlotSelect
    ldrb    r0, [r5, r0]
    lsl     r0, #1
    add     r0, MusicInfo_Slot1Track
    ldrh    r0, [r5, r0]
    cmp     r0, r4
    beq     080034DAh
    bl      Music_VariableFade
    strh    r6, [r5, MusicInfo_SlotSelect]
.endarea

.org 080715ACh
.area 44h
; Reorder function such that default music is set after calling UpdateSubEvent
.func SetRoomMusic
    push    { r4-r5, lr }
    ldr     r2, =GameMode
    ldrh    r2, [r2]
    cmp     r2, #GameMode_Demo
    beq     @@return
    lsl     r4, r0, #18h
    lsr     r4, #18h - 2
    lsl     r5, r1, #18h
    lsr     r5, #18h
    ldr     r2, =DestinationRoom
    strb    r5, [r2]
    mov     r0, #21h
    bl      UpdateSubEvent
    cmp     r0, #1
    beq     @@return
    ldr     r1, =0879B8BCh
    ldr     r1, [r1, r4]
    lsl     r0, r5, #4
    sub     r0, r5
    lsl     r0, #2
    add     r1, r0
    ldrh    r0, [r1, #3Ah]
    bl      Music_CheckSet
@@return:
    pop     { r4-r5, pc }
    .pool
.endfunc
.endarea

.org 08070180h
.region 142Ch, 0
.func UpdateSubEvent
    push    { r4-r6, lr }
    mov     r4, r0
    ldr     r1, =CurrArea
    ldrb    r5, [r1]
    cmp     r5, Area_NOC
    bls     @@checkTrigger
    pop     { r4-r6, pc }
@@checkTrigger:
    sub     r0, #21h
    cmp     r0, #1
    bhi     @@skipAreaSwitch
    ldr     r1, =DestinationRoom
    ldrb    r6, [r1]
    mov     r0, #Event_EscapeSequence
    bl      CheckEvent
    cmp     r0, #01
    beq     @@skipAreaSwitch
    mov     r0, #Event_GoMode
    bl      CheckEvent
    cmp     r0, #01
    beq     @@goModeMusic
    b       @@areaSwitch
@@skipAreaSwitch:
    b       @@areaSwitchDone
@@goModeMusic:
; Checks if in Observation Deck to play pre-SAX ambience
    cmp     r5, Area_MainDeck
    bne     @@areaSwitch
    cmp     r6, #0Dh ; operations room
    beq     @@preSaxMusic
    cmp     r6, #52h ; operations room
    beq     @@preSaxMusic
    cmp     r6, #27h ; operations deck data room
    beq     @@preSaxMusic
    cmp     r6, #20h ; operations deck nav room
    beq     @@preSaxMusic
    cmp     r6, #51h ; operations deck recharge room
    beq     @@preSaxMusic
    cmp     r6, #2Ch ; operations deck save room
    beq     @@preSaxMusic
    cmp     r6, #3Ch ; elevator to crew quarters
    beq     @@preSaxMusic
    b       @@finalMission
@@preSaxMusic:
    mov     r0, #Event_SaxDefeated
    bl      CheckEvent
    cmp     r0, #01
    beq     @@areaSwitch
    mov     r0, MusicTrack_SaxHiding
    mov     r1, MusicType_BossAmbience
    b       @@playMusic
; Checks if player has charge and missiles to signal true go mode
@@finalMission:
    bl      CheckTrueGoMode
    cmp     r0, #1
    bne     @@areaSwitch
    mov     r0, MusicTrack_FinalMission
    mov     r1, MusicType_MainDeck
    b       @@playMusic
@@areaSwitch:
    ldr     r2, =MiscProgress
    add     r1, =@@areaBranchTable
    ldrb    r0, [r1, r5]
    lsl     r0, #1
@@branch:
    add     pc, r0
    .align 4
@@areaBranchTable:
    .db     (@@case_MainDeck - @@branch - 4) >> 1
    .db     (@@case_SRX - @@branch - 4) >> 1
    .db     (@@case_TRO - @@branch - 4) >> 1
    .db     (@@case_PYR - @@branch - 4) >> 1
    .db     (@@case_AQA - @@branch - 4) >> 1
    .db     (@@case_ARC - @@branch - 4) >> 1
    .db     (@@case_NOC - @@branch - 4) >> 1
.if ((@@case_NOC - @@branch - 4) >> 1) >= (1 << 8)
    .error "Branch table overflowed"
.endif
    .align 2
@@case_MainDeck:
    ; arachnus fight room
    cmp     r6, #26h
    bne     @@case_MainDeck_check36
    ldr     r0, [r2, MiscProgress_MajorLocations]
    lsr     r0, MajorLocation_Arachnus + 1
    bcs     @@case_MainDeck_default
    ldr     r1, =MusicInfo + MusicInfo_Type
    ldrb    r0, [r1]
    cmp     r0, MusicType_BossAmbience
    beq     @@case_MainDeck_break
    mov     r0, MusicTrack_PreBossAmbience
    mov     r1, MusicType_BossAmbience
    mov     r2, #60
    b       @@tryPlay
@@case_MainDeck_check36:
    cmp     r6, #36h
    bne     @@case_MainDeck_check4D
    ldrh    r0, [r2, MiscProgress_StoryFlags]
    lsr     r0, StoryFlag_AuxiliaryPower + 1
    bcs     @@case_MainDeck_default
    mov     r0, MusicTrack_DataRoom
    mov     r1, #MusicType_Transient
    mov     r2, #10
    b       @@tryPlay
@@case_MainDeck_check4D:
@@case_MainDeck_check52:
    ; operations room
    cmp     r6, #52h
    bne     @@case_MainDeck_check54
    ldr     r1, =CurrEvent
    ldrb    r0, [r1]
    cmp     r0, #Event_SaxFight
    bgt     @@case_MainDeck_break
    b       @@case_MainDeck_default
@@case_MainDeck_check54:
    ; arachus fight side room
    cmp     r6, #54h
    bne     @@case_MainDeck_check56
    ldr     r0, [r2, MiscProgress_MajorLocations]
    lsr     r0, MajorLocation_Arachnus + 1
    bcs     @@case_MainDeck_default
    b       @@case_MainDeck_break
@@case_MainDeck_check56:
    ; yakuza fight room
    cmp     r6, #56h
    bne     @@case_MainDeck_default
    ldr     r0, [r2, MiscProgress_MajorLocations]
    lsr     r0, MajorLocation_Yakuza + 1
    bcs     @@case_MainDeck_default
    mov     r0, MusicTrack_PreBossAmbience
    mov     r1, MusicType_Transient
    mov     r2, #50
    b       @@tryPlay
@@case_MainDeck_default:
    b       @@case_areaSwitch_default
@@case_MainDeck_break:
    b       @@areaSwitchDone
@@case_SRX:
    ; charge core-x fight room
    cmp     r6, #28h
    bne     @@case_SRX_check1B
    ldr     r0, [r2, MiscProgress_MajorLocations]
    lsr     r0, MajorLocation_ChargeCoreX + 1
    bcs     @@case_MainDeck_default
    mov     r0, MusicTrack_PreBossAmbience
    mov     r1, MusicType_BossAmbience
    mov     r2, #60
    b       @@tryPlay
@@case_SRX_check1B:
    ; ridley fight room
    cmp     r6, #1Bh
    bne     @@case_MainDeck_default
    ldr     r0, [r2, MiscProgress_MajorLocations]
    lsr     r0, MajorLocation_Ridley + 1
    bcs     @@case_MainDeck_default
    mov     r0, MusicTrack_PreBossAmbience
    mov     r1, MusicType_BossAmbience
    mov     r2, #60
    b       @@tryPlay
@@case_TRO:
    ; zazabi fight room
    cmp     r6, #12h
    bne     @@case_TRO_check16
    ldr     r0, [r2, MiscProgress_MajorLocations]
    lsr     r0, MajorLocation_Zazabi + 1
    bcs     @@case_MainDeck_default
    mov     r0, MusicTrack_PreBossAmbience
    mov     r1, MusicType_BossAmbience
    mov     r2, #60
    b       @@tryPlay
@@case_TRO_check16:
    ; nettori fight room
    cmp     r6, #16h
    bne     @@case_areaSwitch_default
    ldr     r0, [r2, MiscProgress_MajorLocations]
    lsr     r0, MajorLocation_Nettori + 1
    bcs     @@case_areaSwitch_default
    mov     r0, MusicTrack_Nettori
    mov     r1, MusicType_BossMusic
    mov     r2, #50
    b       @@tryPlay
@@case_PYR:
    ; box fight room
    cmp     r6, #17h
    bne     @@case_PYR_check19
    ldrh    r0, [r2, MiscProgress_StoryFlags]
    lsr     r0, StoryFlag_BoxDefeated + 1
    bcs     @@case_areaSwitch_default
    ldr     r0, [r2, MiscProgress_MajorLocations]
    lsr     r0, MajorLocation_XBox + 1
    bcs     @@case_areaSwitch_default
    mov     r0, MusicTrack_PreBossAmbience
    mov     r1, MusicType_BossAmbience
    mov     r2, #60
    b       @@tryPlay
@@case_PYR_check19:
    cmp     r6, #19h
    bne     @@case_areaSwitch_default
    ldr     r0, [r2, MiscProgress_MajorLocations]
    lsr     r0, MajorLocation_WideCoreX + 1
    bcs     @@case_areaSwitch_default
    mov     r0, MusicTrack_PreBossAmbience
    mov     r1, MusicType_BossAmbience
    mov     r2, #60
    b       @@tryPlay
@@case_AQA:
    cmp     r6, #0Ah
    bne     @@case_AQA_check1F
    ldr     r0, [r2, MiscProgress_MajorLocations]
    lsr     r0, MajorLocation_Serris + 1
    bcs     @@case_areaSwitch_default
    b       @@areaSwitchDone
@@case_AQA_check1F:
    ; serris tank
    cmp     r6, #1Fh
    bne     @@case_AQA_check2A
    ldr     r0, [r2, MiscProgress_MajorLocations]
    lsr     r0, MajorLocation_Serris + 1
    bcs     @@case_areaSwitch_default
    ldr     r1, =MusicInfo + MusicInfo_Type
    ldrb    r0, [r1]
    cmp     r0, MusicType_AQA1
    beq     @@areaSwitchDone
    mov     r0, MusicTrack_EnvironmentalDisquiet
    mov     r1, MusicType_AQA1
    mov     r2, #60
    b       @@tryPlay
@@case_AQA_check2A:
    ; serris fight room
    cmp     r6, #2Ah
    bne     @@case_areaSwitch_default
    ldr     r0, [r2, MiscProgress_MajorLocations]
    lsr     r0, MajorLocation_Serris + 1
    bcs     @@case_areaSwitch_default
    mov     r0, MusicTrack_PreBossAmbience
    mov     r1, MusicType_BossAmbience
    mov     r2, #40
    b       @@tryPlay
@@case_ARC:
    ; nightmare fight room
    cmp     r6, #14h
    bne     @@case_areaSwitch_default
    ldr     r0, [r2, MiscProgress_MajorLocations]
    lsr     r0, MajorLocation_Nightmare + 1
    bcs     @@case_areaSwitch_default
    mov     r0, MusicTrack_PreBossAmbience
    mov     r1, MusicType_BossAmbience
    mov     r2, #50
    b       @@tryPlay
@@case_NOC:
    ; mega core-x eyedoor room
    cmp     r6, #0Ch
    bne     @@case_NOC_check0D
    ldr     r0, [r2, MiscProgress_MajorLocations]
    lsr     r0, MajorLocation_MegaCoreX + 1
    bcs     @@case_areaSwitch_default
    ldr     r1, =MusicInfo + MusicInfo_Type
    ldrb    r0, [r1]
    cmp     r0, MusicType_BossAmbience
    beq     @@areaSwitchDone
    mov     r0, MusicTrack_PreBossAmbience
    mov     r1, MusicType_BossAmbience
    mov     r2, #60
    b       @@tryPlay
@@case_NOC_check0D:
    ; mega core-x fight room
    cmp     r6, #0Dh
    bne     @@case_NOC_check10
    ldr     r0, [r2, MiscProgress_MajorLocations]
    lsr     r0, MajorLocation_MegaCoreX + 1
    bcs     @@case_areaSwitch_default
    ldr     r1, =MusicInfo + MusicInfo_Type
    ldrb    r0, [r1]
    cmp     r0, MusicType_BossAmbience
    beq     @@areaSwitchDone
    mov     r0, MusicTrack_PreBossAmbience
    mov     r1, MusicType_BossAmbience
    mov     r2, #60
    b       @@tryPlay
@@case_NOC_check10:
    ; xbox fight room
    cmp     r6, #10h
    bne     @@case_NOC_check19
    ldr     r0, [r2, MiscProgress_MajorLocations]
    lsr     r0, MajorLocation_XBox + 1
    bcs     @@case_areaSwitch_default
    mov     r0, MusicTrack_Box
    mov     r1, MusicType_BossMusic
    mov     r2, #20
    b       @@tryPlay
@@case_NOC_check19:
    ; NOC data room
    cmp     r6, #19h
    bne     @@case_areaSwitch_default
    ldr     r0, [r2, MiscProgress_MajorLocations]
    lsr     r0, MajorLocation_MegaCoreX + 1
    bcs     @@case_areaSwitch_default
    ldrh    r0, [r2, MiscProgress_StoryFlags]
    lsr     r0, StoryFlag_NocDataDestroyed + 1
    bcs     @@areaSwitchDone
    cmp     r4, #22h
    bne     @@areaSwitchDone
@@case_areaSwitch_default:
    ldr     r1, =MusicInfo + MusicInfo_Type
    ldr     r2, =GameMode
    ldrh    r2, [r2]
    cmp     r2, #GameMode_Demo
    beq     @@areaSwitchDone
    mov     r0, MusicType_Transient
    strb    r0, [r1]
@@areaSwitchDone:
    ldr     r1, =CurrSubEvent
    ldrh    r0, [r1]
@@subeventSwitch:
    cmp     r0, #00h    ; Adam intro started
    beq     @@case_00
    cmp     r0, #01h    ; Adam intro finished
    beq     @@case_01
    cmp     r0, #6Bh    ; Auxiliary power active
    beq     @@case_6B
    cmp     r0, #9Ah    ; Escape sequence started
    beq     @@case_9A
    cmp     r0, #9Bh    ; Escape sequence
    beq     @@case_9B
    b       @@return_false
@@case_00:
    ; start first briefing music and increment subevent
    ldrb    r2, [r1, PrevSubEvent - CurrSubEvent]
    cmp     r2, #0FFh
    bne     @@return_false
    strb    r0, [r1, PrevSubEvent - CurrSubEvent]
    add     r0, #1
    strb    r0, [r1]
    mov     r0, MusicTrack_Briefing
    mov     r1, MusicType_MainDeck
    b       @@playMusic
@@case_01:
    ; start main deck music and increment subevent
    cmp     r4, #3
    bne     @@return_false
    strb    r0, [r1, PrevSubEvent - CurrSubEvent]
    add     r0, #1
    strb    r0, [r1]
    mov     r0, MusicTrack_BSLAmbience
    mov     r1, MusicType_Transient
    b       @@playMusic
@@case_6B:
    cmp     r4, #0Bh
    bne     @@return_false
    mov     r0, MusicTrack_ObservationDeck
    mov     r1, #MusicType_Misc
    b       @@playMusic
@@case_9A:
    strb    r0, [r1, PrevSubEvent - CurrSubEvent]
    add     r0, #1
    strb    r0, [r1]
    b       @@return_true
@@case_9B:
    ; escape sequence omega encounter
    cmp     r5, Area_MainDeck
    bne     @@return_true
    cmp     r6, #3Fh
    bne     @@return_true
    bl      08072B4Ch
    mov     r0, MusicTrack_EnvironmentalShock
    mov     r1, MusicType_BossMusic
    mov     r2, #0
    b       @@tryPlay
@@tryPlay:
    cmp     r4, #21h
    beq     @@fadeOut
    cmp     r4, #22h
    beq     @@playMusic
    b       @@return_false
@@fadeOut:
    mov     r0, r2
    bl      Music_FadeOut
    b       @@return_true
@@playMusic:
    bl      Music_Play
@@return_true:
    mov     r0, #1
    pop     { r4-r6, pc }
@@return_false:
    mov     r0, #0
    pop     { r4-r6, pc }
    .pool
.endfunc
.endregion

.org 0803A170h
; Wide Core-X boss music
.area 2Ch
    push    { lr }
    ldr     r2, =CurrentSprite
    ldrh    r0, [r2, Sprite_Status]
    ldr     r1, =#8020h
    orr     r0, r1
    strh    r0, [r2, Sprite_Status]
    mov     r0, #2Ch
    strh    r0, [r2, Sprite_XParasiteTimer]
    add     r2, #20h
    mov     r0, #46h
    strb    r0, [r2, Sprite_Pose - 20h]
    mov     r0, #0
    strb    r0, [r2, Sprite_SamusCollision - 20h]
    mov     r0, MusicTrack_BeamCoreX
    mov     r1, MusicType_BossMusic
    bl      Music_Play
    pop     { pc }
    .pool
.endarea

.org 0802DBC4h
; Wide Core-X defeated music
.area 5Ch
    push    { lr }
    ldr     r2, =CurrentSprite
    mov     r3, r2
    add     r3, #20h
    mov     r0, #5Dh
    strb    r0, [r3, Sprite_Pose - 20h]
    mov     r0, #0Ch
    strb    r0, [r3, Sprite_SamusCollision - 20h]
    mov     r1, #0
    strh    r1, [r2, Sprite_Health]
    ldr     r0, =0300007Ah
    ldrb    r0, [r0]
    lsl     r0, #20h - 2
    lsr     r0, #20h - 2
    strb    r0, [r3, Sprite_BgPriority - 20h]
    mov     r0, #4
    strb    r0, [r3, Sprite_DrawOrder - 20h]
    strb    r1, [r3, Sprite_PaletteRow - 20h]
    strb    r1, [r3, Sprite_Work1 - 20h]
    strb    r1, [r3, Sprite_Work2 - 20h]
    mov     r0, #1
    strb    r0, [r3, Sprite_Work3 - 20h]
    strb    r0, [r3, Sprite_Work4 - 20h]
    strb    r0, [r3, Sprite_IgnoreSamusCollisionTimer - 20h]
    bl      08025270h
    ldr     r0, =CurrentSprite
    ldrb    r0, [r0, Sprite_Id]
    cmp     r0, #SpriteId_WideCoreXNucleus
    bne     @@return
    mov     r0, MusicTrack_PreBossAmbience
    mov     r1, MusicType_BossAmbience
    bl      Music_Play
@@return:
    pop     { pc }
    .pool
.endarea

; Remove subevent 0 music handling from dialogue handling
.org 08079ED4h
    nop :: nop :: nop :: nop

; change default music in certain rooms

.org MainDeckLevels + 07h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck station entrance
.org MainDeckLevels + 08h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck recharge room
.org MainDeckLevels + 09h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck navigation room east
.org MainDeckLevels + 0Ah * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck crew quarters east
.org MainDeckLevels + 0Bh * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck habitation save room
.org MainDeckLevels + 0Ch * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck crew quarters west
.org MainDeckLevels + 0Eh * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck maintenance corridor
.org MainDeckLevels + 0Fh * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck habitation deck entrance
.org MainDeckLevels + 10h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck navigation room west
.org MainDeckLevels + 12h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck central hub
.org MainDeckLevels + 14h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck western hub
.org MainDeckLevels + 15h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck eastern hub
.org MainDeckLevels + 16h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck habitation maintenance
.org MainDeckLevels + 17h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck quarantine access
.org MainDeckLevels + 21h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck save room
.org MainDeckLevels + 23h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck maintenance shaft
.org MainDeckLevels + 24h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck maintenance crossing
.org MainDeckLevels + 25h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck crew quarters save room
.org MainDeckLevels + 26h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck arachnus arena
.org MainDeckLevels + 28h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck main elevator
.org MainDeckLevels + 2Ah * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck main elevator access
.org MainDeckLevels + 2Dh * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck maintenance storage
.org MainDeckLevels + 2Eh * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck sub-zero containment
.org MainDeckLevels + 2Fh * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck spitter speedway
.org MainDeckLevels + 39h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck habitation storage
.org MainDeckLevels + 3Dh * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck elevator to operations deck
.org MainDeckLevels + 45h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck habitation deck
.org MainDeckLevels + 46h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck hornoad hallway
.org MainDeckLevels + 47h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck quarantine bay
.org MainDeckLevels + 48h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck western hub cache
.org MainDeckLevels + 49h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck main elevator
.org MainDeckLevels + 4Bh * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck elevator to habitation deck
.org MainDeckLevels + 4Ch * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck elevator to central hub
.org MainDeckLevels + 54h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_MainDeck     ; main deck the attic

.org MainDeckLevels + 0Dh * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_ObservationDeck     ; main deck operations deck
.org MainDeckLevels + 20h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_ObservationDeck     ; main deck operations deck navigation room
.org MainDeckLevels + 27h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_ObservationDeck     ; main deck operations deck data room
.org MainDeckLevels + 2Ch * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_ObservationDeck     ; main deck operations deck save room
.org MainDeckLevels + 36h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_ObservationDeck     ; main deck auxiliary power station
.org MainDeckLevels + 3Ch * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_ObservationDeck     ; main deck elevator to crew quarters
.org MainDeckLevels + 51h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_ObservationDeck     ; main deck operations deck recharge room
.org MainDeckLevels + 52h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_ObservationDeck     ; main deck operations room

.org Sector1Levels + 12h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_Tourian     ; sector 1 tourian shaft east
.org Sector1Levels + 13h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_Tourian     ; sector 1 tourian save room east
.org Sector1Levels + 15h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_Tourian     ; sector 1 tourian central hub
.org Sector1Levels + 16h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_Tourian     ; sector 1 golden pirate crossing
.org Sector1Levels + 17h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_Tourian     ; sector 1 tourian hub west
.org Sector1Levels + 18h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_Tourian     ; sector 1 tourian save room west
.org Sector1Levels + 19h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_Tourian     ; sector 1 genesis habitation
.org Sector1Levels + 1Ah * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_Tourian     ; sector 1 ridley arena access
.org Sector1Levels + 1Bh * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_Tourian     ; sector 1 ridley arena
.org Sector1Levels + 1Ch * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_Tourian     ; sector 1 tourian central checkpoint
.org Sector1Levels + 1Dh * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_Tourian     ; sector 1 ripper maze access
.org Sector1Levels + 1Eh * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_Tourian     ; sector 1 ripper maze
.org Sector1Levels + 24h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_Tourian     ; sector 1 tourian entrance
.org Sector1Levels + 33h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_Tourian     ; sector 1 animorphs
.org Sector1Levels + 34h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_Tourian     ; sector 1 animorphs cache

.org Sector2Levels + 36h * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_Sector2     ; sector 2 crumble city

.org Sector4Levels + 2Dh * LevelMeta_Size + LevelMeta_Music
    .dh     MusicTrack_Sector4     ; sector 4 diffusion connection access
