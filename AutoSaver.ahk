#Requires AutoHotkey v2.0


SoundStart := false
SaveIntervalMinutes := 0.2
SetTimer(CheckGameStart, 1000)

CheckGameStart() {
    if (CheckGame()) {
        ; Debug ToolTip
        ToolTip "CheckGame returned: true"
        Sleep 1000
        ToolTip

        SoundPlay("infocus.mp3")
        SoundStart := true
        SetTimer(PressTheKey, SaveIntervalMinutes * 60000)
        SetTimer(CheckGameStart, 0)
    }
    return
}

CheckGame() {
    if (WinActive("ahk_exe bg3.exe") or WinActive("ahk_exe bg3_dx11.exe")) {
        ; Debug ToolTip
        ToolTip "CheckGame returned: true"
        Sleep 1000
        ToolTip

        return true
    }
    ; Debug ToolTip
    ToolTip "CheckGame returned: false"
    Sleep 1000
    ToolTip
    SetTimer(CheckGameClosed, 1000)
    return false
}

CheckGameClosed() {
    
    if !(WinExist("ahk_exe bg3.exe") or WinExist("ahk_exe bg3_dx11.exe")) {
        ; Debug ToolTip
        ToolTip "CheckGameClosed returned: true"
        Sleep 1000
        ToolTip

        SoundPlay("*16")
        SoundStart := false
        SetTimer(CheckGameStart, 0)
        SetTimer(PressTheKey, 0)
        ExitApp
    }
}

CheckAFK() {
    idleTime := A_TimeIdlePhysical
    if (idleTime > 60000) {
        ; Debug ToolTip
        ToolTip "CheckAFK returned: true"
        Sleep 1000
        ToolTip

        SoundPlay("*16")
        SoundStart := false
        SetTimer(CheckGameStart, 0)
        SetTimer(PressTheKey, 0)
        return true
    }
    ; Debug ToolTip
    ToolTip "CheckAFK returned: false"
    Sleep 1000
    ToolTip

    return false
}

Run "bg3.lnk"

PressTheKey() {
    If (CheckGame()) {
        If (!CheckAFK()) {
            Send("{F5}")
        }
    }
}
return