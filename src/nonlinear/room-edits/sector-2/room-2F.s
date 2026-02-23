; Puyo Palace

; Change lower door to not be an event based door anymore
.org Sector2Doors + 6Eh * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_OpenHatch
.endarea