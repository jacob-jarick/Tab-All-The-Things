#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=tatt_x86.exe
#AutoIt3Wrapper_Outfile_x64=tatt_x64.exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Add_Constants=n
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; *** Start added by AutoIt3Wrapper ***
#include <AutoItConstants.au3>
; *** End added by AutoIt3Wrapper ***

#include <GUIConstantsEx.au3>
#include "OnEventFunc.au3"; assuming the udf is in the script dir


#include <GuiEdit.au3>
#include <file.au3>
#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <WinAPI.au3>
#include <WinAPIRes.au3>

Global $cursor = @ScriptDir & "\arcoiris 2.cur"

FileInstall("D:\git\tab all the things\Tab-All-The-Things\arcoiris 2.cur", $cursor, 0)

Opt("GUIOnEventMode", 1)

Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1)

Opt("TrayAutoPause", 0); Script will not be paused when clicking the tray icon.
TrayCreateItem("Test1")
TRaySetOnEventA(-1, "TrayIt1")
TrayCreateItem("")
TrayCreateItem("Feature List: OFF")
TrayCreateItem("")

TraySetState()



Global $version = "1.0.1"
Global $Form1 = GUICreate("Tab all the things" & $version, 800, 40, -1, -1, $WS_OVERLAPPEDWINDOW)

Global $filemenu = GUICtrlCreateMenu("File")

Global $addw = GUICtrlCreateMenuItem("Add Window", $filemenu)
SetOnEventA($addw, "window_info")

Local $menuexit = GUICtrlCreateMenuItem("Exit", $filemenu)
SetOnEventA($menuexit, "quit")

Global $windowmenu = GUICtrlCreateMenu("Windows")

Global $cascade = 1


Global $window_h = 600
Global $windows[] = []

WinSetOnTop($Form1, "", $WINDOWS_ONTOP)

Local $filemenu, $fileitem, $msg, $exititem, $line, $helpitem, $jPos;

SetOnEventA($GUI_EVENT_CLOSE, "quit")


GUISetState(@SW_SHOW)

Local $count = 0;
While 1
	Sleep(100)
	window_position()
	window_check()
WEnd

Exit

Func window_check()
	$iMax = UBound($windows)
	Local $need_to_redraw = 0
	For $i = 1 To $iMax - 1; subtract 1 from size to prevent an out of bounds error
		If WinExists(HWnd($windows[$i]), "") = 0 Then
			;MsgBox($MB_SYSTEMMODAL, "Window Deleted", $windows[$i], 5)
			_ArrayDelete($windows, $i)
			$need_to_redraw = 1
		EndIf
	Next

	If $need_to_redraw = 1 Then
		draw_menu()
	EndIf

EndFunc   ;==>window_check

Func window_info()
	Local $hPrev = _WinAPI_CopyCursor(_WinAPI_LoadCursor(0, 32512))
	_WinAPI_SetSystemCursor(_WinAPI_LoadCursorFromFile(@ScriptDir & "\arcoiris 2.cur"), 32512)
	While 1
		If _IsPressed("01") Then
			ExitLoop
		EndIf
	WEnd
	_WinAPI_SetSystemCursor($hPrev, 32512)

	jPos()
	draw_menu()
	;MsgBox(0, "Details", $jPos[0] & "," & $jPos[1] & "," & WinGetHandle("[ACTIVE]"))
EndFunc   ;==>window_info

Func jPos()
	$jPos = MouseGetPos()
	Sleep(50)
	Local $target = String(WinGetHandle("[ACTIVE]"))
	_ArrayPush($windows, $target)
	Local $aArrayUnique = _ArrayUnique($windows) ; Use default parameters to create a unique array.
	$windows = $aArrayUnique

	Local $aPos = WinGetPos($Form1)
	WinMove(HWnd($target), "", $aPos[0], $aPos[1] + $aPos[3], $aPos[2], $window_h)
EndFunc   ;==>jPos

Func draw_menu()
	$iMax = UBound($windows)
	GUICtrlDelete($windowmenu)
	$windowmenu = GUICtrlCreateMenu("Windows")
	For $i = 1 To $iMax - 1; subtract 1 from size to prevent an out of bounds error
		$title = WinGetTitle(HWnd($windows[$i]))
		Local $item = GUICtrlCreateMenuItem($title, $windowmenu)
		Local $tmp = $windows[$i]
		SetOnEventA($item, "funcone", $paramByVal, $tmp)
	Next
EndFunc   ;==>draw_menu

Func funcone($target)
	MsgBox($MB_SYSTEMMODAL, "target", $target, 10)
	WinActivate(HWnd($target))
EndFunc   ;==>funcone

Func window_position()
	$iMax = UBound($windows)
	If $iMax = 1 Then
		Return
	EndIf

	$iFullDesktopWidth = _WinAPI_GetSystemMetrics(78)
	$iFullDesktopHeight = _WinAPI_GetSystemMetrics(79)

	Local $aPos = WinGetPos($Form1)

	Local $cascade_local = $cascade

	Local $cascade_x = 0
	Local $cascade_y = 0

	For $i = 1 To $iMax - 1;
		;MsgBox($MB_SYSTEMMODAL, "target", $windows[$i], 10)

		Local $xpos = $aPos[0]
		Local $ypos = $aPos[1] + $aPos[3]

		If $cascade_local = 1 Then
			$xpos += $cascade_x
			$ypos += $cascade_y

			$cascade_x += 40
			$cascade_y += 40
		EndIf

		$h = $window_h
		If ($ypos + $window_h) > $iFullDesktopHeight Then
			$h = $iFullDesktopHeight - $window_h
			$cascade_local = 0
		EndIf

		WinMove(HWnd($windows[$i]), "", $xpos, $ypos, $aPos[2], $h)
	Next
EndFunc   ;==>window_position

Func quit()
	Exit
EndFunc   ;==>quit
