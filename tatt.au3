#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=tatt_x86.exe
#AutoIt3Wrapper_Outfile_x64=tatt_x64.exe
#AutoIt3Wrapper_Compression=4
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

Global $version = "1.0.8"

Global $cascade = 1
Global $window_h = 600
Global $window_h_min = 200
Global $window_w_min = 400

Global $windows[] = []
Global $parent_h = 60

Global $cursor = @ScriptDir & "\arcoiris 2.cur"
FileInstall("D:\git\tab all the things\Tab-All-The-Things\arcoiris 2.cur", $cursor, 0)

Opt("GUIOnEventMode", 1)
Opt("TrayOnEventMode", 1)

Opt("TrayAutoPause", 0); Script will not be paused when clicking the tray icon.
TraySetState()

Global $Form1 = GUICreate("Tab all the things" & $version, 800, $parent_h, -1, -1, $WS_OVERLAPPEDWINDOW)

Global $filemenu = GUICtrlCreateMenu("File")
Global $addw = GUICtrlCreateMenuItem("Add Window", $filemenu)
SetOnEventA($addw, "window_info")

Local $menuexit = GUICtrlCreateMenuItem("Exit", $filemenu)
SetOnEventA($menuexit, "quit")

Global $windowmenu = GUICtrlCreateMenu("Windows")

WinSetOnTop($Form1, "", $WINDOWS_ONTOP)

Local $filemenu, $fileitem, $msg, $exititem, $line, $helpitem, $jPos;

SetOnEventA($GUI_EVENT_CLOSE, "quit")

GUISetState(@SW_SHOW)

While 1
	Sleep(100)
	window_position()
	window_check()
	parent_check_pos()
WEnd

Exit

Func parent_check_pos()
	Local $aPos = WinGetPos($Form1)
	Local $x = $aPos[0]
	Local $y = $aPos[1]
	Local $w = $aPos[2]
	Local $iFullDesktopWidth = _WinAPI_GetSystemMetrics(78)
	Local $iFullDesktopHeight = _WinAPI_GetSystemMetrics(79)

	If ($x + $w) > $iFullDesktopWidth Then
		$x = $iFullDesktopWidth - $w
	EndIf
	If $x < 0 Then
		$x = 0
	EndIf

	If ($y + $parent_h) > $iFullDesktopHeight Then
		$y = $iFullDesktopHeight - $parent_h
	EndIf
	If $y < 0 Then
		$y = 0
	EndIf

	WinMove($Form1, "", $x, $y, $w, $parent_h)
EndFunc   ;==>parent_check_pos

Func window_check()
	$iMax = UBound($windows)
	If $iMax = 1 Then
		Return
	EndIf

	Local $need_to_redraw = 0
	Local $array_copy = $windows

	For $i = 1 To $iMax - 1
		If WinExists(HWnd($windows[$i]), "") = 0 Then
			;MsgBox($MB_SYSTEMMODAL, "Window Deleted", $windows[$i], 5)
			_ArrayDelete($array_copy, $i)
			$need_to_redraw = 1
		EndIf

		Local $iState = WinGetState(HWnd($windows[$i]))
		If BitAND($iState, 16) Then
			WinSetState(HWnd($windows[$i]), "", @SW_RESTORE)
		EndIf

	Next

	If $need_to_redraw = 1 Then
		$windows = $array_copy
		draw_menu()
		window_position()
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
		SetOnEventA($item, "raise", $paramByVal, $tmp)
	Next
EndFunc   ;==>draw_menu

Func raise($target)
	MsgBox($MB_SYSTEMMODAL, "target", $target, 10)
	WinActivate(HWnd($target))
EndFunc   ;==>raise

Func window_position()
	$iMax = UBound($windows)
	If $iMax = 1 Then
		Return
	EndIf

	Local $iFullDesktopWidth = _WinAPI_GetSystemMetrics(78)
	Local $iFullDesktopHeight = _WinAPI_GetSystemMetrics(79)
	Local $aPos = WinGetPos($Form1)
	Local $cascade_local = $cascade
	Local $cascade_x = 0
	Local $cascade_y = 0
	Local $cascade_x_inc = 33
	Local $cascade_y_inc = 33

	Local $window_w = $aPos[2]

	For $i = 1 To $iMax - 1;
		Local $xpos = $aPos[0]
		Local $ypos = $aPos[1] + $aPos[3]

		If $cascade_local = 1 Then
			$xpos += $cascade_x
			$ypos += $cascade_y
			$cascade_x += $cascade_x_inc
			$cascade_y += $cascade_y_inc
		EndIf

		$h = $window_h
		If ($ypos + $h) > $iFullDesktopHeight Then
			$h = $iFullDesktopHeight - $ypos
			If $h < $window_h_min Then
				$cascade_y_inc = 0
			EndIf
		EndIf

		$w = $window_w
		If ($xpos + $w) > $iFullDesktopWidth Then
			$w = $iFullDesktopWidth - $xpos
			If $w < $window_w_min Then
				$cascade_x_inc = 0
			EndIf
		EndIf

		WinMove(HWnd($windows[$i]), "", $xpos, $ypos, $w, $h)
	Next
EndFunc   ;==>window_position

Func quit()
	Exit
EndFunc   ;==>quit
