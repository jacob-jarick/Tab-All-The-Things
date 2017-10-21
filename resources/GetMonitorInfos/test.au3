
get_w()
Exit

Func get_w()
	$hMonitor = GetMonitorFromPoint(0, 0)

	If $hMonitor <> 0 Then
		Dim $arMonitorInfos[4]
		If GetMonitorInfos($hMonitor, $arMonitorInfos) Then _
				MsgBox(0, "Monitor-Infos", "Rect-Monitor" & @TAB & ": " & $arMonitorInfos[0] & @LF & _
				"Rect-Workarea" & @TAB & ": " & $arMonitorInfos[1] & @LF & _
				"PrimaryMonitor?" & @TAB & ": " & $arMonitorInfos[2] & @LF & _
				"Devicename" & @TAB & ": " & $arMonitorInfos[3])
	EndIf


EndFunc   ;==>get_w

Func GetMonitorFromPoint($x, $y)
	$hMonitor = DllCall("user32.dll", "hwnd", "MonitorFromPoint", _
			"int", $x, _
			"int", $y, _
			"int", 0x00000000)
	Return $hMonitor[0]
EndFunc   ;==>GetMonitorFromPoint


Func GetMonitorInfos($hMonitor, ByRef $arMonitorInfos)
	Local $stMONITORINFOEX = DllStructCreate("dword;int[4];int[4];dword;char[" & 32 & "]")
	DllStructSetData($stMONITORINFOEX, 1, DllStructGetSize($stMONITORINFOEX))

	$nResult = DllCall("user32.dll", "int", "GetMonitorInfo", _
			"hwnd", $hMonitor, _
			"ptr", DllStructGetPtr($stMONITORINFOEX))
	If $nResult[0] = 1 Then
		$arMonitorInfos[0] = DllStructGetData($stMONITORINFOEX, 2, 1) & ";" & _
				DllStructGetData($stMONITORINFOEX, 2, 2) & ";" & _
				DllStructGetData($stMONITORINFOEX, 2, 3) & ";" & _
				DllStructGetData($stMONITORINFOEX, 2, 4)
		$arMonitorInfos[1] = DllStructGetData($stMONITORINFOEX, 3, 1) & ";" & _
				DllStructGetData($stMONITORINFOEX, 3, 2) & ";" & _
				DllStructGetData($stMONITORINFOEX, 3, 3) & ";" & _
				DllStructGetData($stMONITORINFOEX, 3, 4)
		$arMonitorInfos[2] = DllStructGetData($stMONITORINFOEX, 4)
		$arMonitorInfos[3] = DllStructGetData($stMONITORINFOEX, 5)
	EndIf

	Return $nResult[0]
EndFunc   ;==>GetMonitorInfos
