#NoEnv
#NoTrayIcon
SendMode Input
SetWorkingDir %A_ScriptDir%

; Bind Ctrl+Alt+V to run the PowerShell script silently
^!v::
Run, powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File "%USERPROFILE%\.local\bin\auto_paste_img.ps1", , Hide
return
