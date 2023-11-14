#Requires AutoHotkey v2.0


global SoundPlayed := false
SaveIntervalMinutes := 0.2

Run "bg3.lnk"
Sleep 10000
SetTimer(CheckGameStart, 1000)
SetTimer(CheckGameClosed, 1000)

CheckGameStart() {
    if (CheckGame()) {
        ; Debug ToolTip
        ;ToolTip "CheckGame returned: true"
        ;Sleep 1000
        ;ToolTip
        SetTimer(PressTheKey, SaveIntervalMinutes * 60000)
        SetTimer(CheckGameStart, 0)
    }
    return
}

CheckGame() {
    global SoundPlayed
    if (WinActive("ahk_exe bg3.exe") or WinActive("ahk_exe bg3_dx11.exe")) {
        ; Debug ToolTip
        ;ToolTip "CheckGame returned: true"
        ;Sleep 1000
        ;ToolTip
        if(!(SoundPlayed)){
            SoundPlay("infocus.mp3")
            SoundPlayed := true
        }
        return true
    }
    ; Debug ToolTip
    ;ToolTip "CheckGame returned: false"
    ;Sleep 1000
    ;ToolTip
    if(SoundPlayed){
        SoundPlay("*16")
        SoundPlayed := false
    }
    return false
}

CheckGameClosed() {
    
    if !(WinExist("ahk_exe bg3.exe") or WinExist("ahk_exe bg3_dx11.exe")) {
        ; Debug ToolTip
        ;ToolTip "CheckGameClosed returned: true"
        ;Sleep 1000
        ;ToolTip

        SoundPlay("*16")

        SetTimer(CheckGameStart, 0)
        SetTimer(PressTheKey, 0)
        ExitApp
    }
}

CheckAFK() {
    global SoundPlayed
    idleTime := A_TimeIdlePhysical
    if (idleTime > 60000) {
        ; Debug ToolTip
        ;ToolTip "CheckAFK returned: true"
        ;Sleep 1000
        ;ToolTip
        if(SoundPlayed){
            SoundPlay("*16")
            SoundPlayed := false
        }
        SetTimer(CheckGameStart, 0)
        SetTimer(PressTheKey, 0)
        return true
    }
    ; Debug ToolTip
    ;ToolTip "CheckAFK returned: false"
    ;Sleep 1000
    ;ToolTip

    return false
}



PressTheKey() {
    If (CheckGame()) {
        If (!CheckAFK()) {
            Send("{F5}")
        }
    }
}
return