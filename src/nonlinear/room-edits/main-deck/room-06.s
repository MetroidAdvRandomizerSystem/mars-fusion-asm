; Main Deck - Docking Bay Climb
; remove event-based transitions to wrecked Silo Access
.org MainDeckDoors + 0Dh * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_NoHatch
.endarea

.org MainDeckDoors + 0Fh * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea
