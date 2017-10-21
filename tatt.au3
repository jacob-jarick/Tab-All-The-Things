; *** Start added by AutoIt3Wrapper ***
#include <AutoItConstants.au3>
; *** End added by AutoIt3Wrapper ***
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=tatt_x86.exe
#AutoIt3Wrapper_Outfile_x64=tatt_x64.exe
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GUIConstantsEx.au3>
#include "OnEventFunc.au3"; assuming the udf is in the script dir


#Include <GuiEdit.au3>
#include <file.au3>
#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>
#include <Array.au3>

Opt("GUIOnEventMode", 1)

Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode",1)

Opt("TrayAutoPause", 0); Script will not be paused when clicking the tray icon.
TrayCreateItem("Test1")
TRaySetOnEventA(-1, "TrayIt1")
TrayCreateItem("")
TrayCreateItem("Feature List: OFF")
TrayCreateItem("")

TraySetState()


Global $version = "1.0"
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

local $filemenu, $fileitem, $msg, $exititem, $line, $helpitem, $jPos;

SetOnEventA($GUI_EVENT_CLOSE, "quit")


GUISetState(@SW_SHOW)

Local $count = 0;
while 1
	Sleep(100)
	window_position()
WEnd

Exit

func gui_check()
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case $msg = $addw
			window_info()

		Case $msg = $helpitem
			MsgBox(-1, "Help", "todo... sorry :(")

		Case $msg = $exititem
			Exit
	EndSelect
EndFunc

Func window_info()
	While 1
		If _IsPressed("01") Then
			ExitLoop
		EndIf
	WEnd
	jPos()
	draw_menu()
	;MsgBox(0, "Details", $jPos[0] & "," & $jPos[1] & "," & WinGetHandle("[ACTIVE]"))
EndFunc

Func jPos()
	$jPos = MouseGetPos()
	Sleep(50)
	Local $target = String(WinGetHandle("[ACTIVE]"))
	_ArrayPush($windows, $target)
	Local $aArrayUnique = _ArrayUnique($windows) ; Use default parameters to create a unique array.
	$windows = $aArrayUnique

	Local $aPos = WinGetPos($Form1)
	WinMove(HWnd($target), "", $aPos[0], $aPos[1]+$aPos[3], $aPos[2], $window_h)
EndFunc

Func draw_menu()
	$iMax = UBound($windows)
	GUICtrlDelete($windowmenu)
	$windowmenu = GUICtrlCreateMenu("Windows")
	For $i = 1 to $iMax - 1; subtract 1 from size to prevent an out of bounds error
		$title = WinGetTitle(HWnd($windows[$i]))
		Local $item = GUICtrlCreateMenuItem($title, $windowmenu)
		Local $tmp = $windows[$i]
		SetOnEventA($item, "funcone", $paramByVal, $tmp)
     Next
EndFunc

Func funcone($target)
	MsgBox($MB_SYSTEMMODAL, "target", $target, 10)
	WinActivate(HWnd($target))
EndFunc   ;==>funcone

Func window_position()
	$iMax = UBound($windows)
	If $iMax = 1 Then
		Return
	EndIf

	Local $aPos = WinGetPos($Form1)

	Local $cascade_x = 0
	Local $cascade_y = 0

	For $i = 1 to $iMax - 1;
		;MsgBox($MB_SYSTEMMODAL, "target", $windows[$i], 10)

		Local $xpos = $aPos[0]
		Local $ypos = $aPos[1]+$aPos[3]

		If $cascade = 1 Then
			$xpos += $cascade_x
			$ypos += $cascade_y

			$cascade_x += 40
			$cascade_y += 40
		EndIf

		WinMove(HWnd($windows[$i]), "", $xpos, $ypos, $aPos[2], $window_h)
	Next
EndFunc

Func quit()
	Exit
EndFunc