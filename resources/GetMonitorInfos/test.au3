
get_w()
Exit

Func get_w()
	$hMonitor = GetMonitorFromPoint(0, 0)

	If $hMonitor <> 0 Then
		Dim $arMonitorInfos[4]
		Dim $info[4]
		If GetMonitorInfos($hMonitor, $arMonitorInfos, $info) Then _
				MsgBox(0, "Monitor-Infos", "x" & @TAB & ": " & $info[0] & @LF & _
				"y" & @TAB & ": " & $info[1] & @LF & _
				"w" & @TAB & ": " & $info[2] & @LF & _
				"h" & @TAB & ": " & $info[3])
	EndIf


EndFunc   ;==>get_w

Func GetMonitorFromPoint($x, $y)
	$hMonitor = DllCall("user32.dll", "hwnd", "MonitorFromPoint", _
			"int", $x, _
			"int", $y, _
			"int", 0x00000000)
	Return $hMonitor[0]
EndFunc   ;==>GetMonitorFromPoint


Func GetMonitorInfos($hMonitor, ByRef $arMonitorInfos, ByRef $info)
	Local $stMONITORINFOEX = DllStructCreate("dword;int[4];int[4];dword;char[" & 32 & "]")
	DllStructSetData($stMONITORINFOEX, 1, DllStructGetSize($stMONITORINFOEX))

	$nResult = DllCall("user32.dll", "int", "GetMonitorInfo", _
			"hwnd", $hMonitor, _
			"ptr", DllStructGetPtr($stMONITORINFOEX))
	If $nResult[0] = 1 Then
		Local $xpos = DllStructGetData($stMONITORINFOEX, 3, 1)
		Local $ypos = DllStructGetData($stMONITORINFOEX, 3, 2)
		Local $w = DllStructGetData($stMONITORINFOEX, 3, 3)
		Local $h = DllStructGetData($stMONITORINFOEX, 3, 4)
		$info[0] = $xpos
		$info[1] = $ypos
		$info[2] = $w
		$info[3] = $h
	EndIf

	Return $nResult[0]
EndFunc   ;==>GetMonitorInfos
