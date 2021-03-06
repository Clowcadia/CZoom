#SingleInstance, Force
#NoEnv
;#Include <Gdip_All>
;#Include <CUtil>
;#Include Gdip_All.ahk
SetBatchLines, -1
CoordMode Mouse, Screen
pToken := Gdip_Startup()

global magWinSide := 256, winName, winX, winY, winW, winH
global srcPrintFrame, destPrintFrame, destFullFrame

InputBox, winName,, Please Enter The Window Title
if ErrorLevel
	PnCfgMainGuiClose()

init()

init()
{	
	getSrcFullWin()
	getPnCfgMainWin()
		
	
}

getSelXY(){
	activate(x, y)
	Sleep 1000
	activate(, , x, y)
}

activate(ByRef selX:=0, ByRef selY:=0, ByRef rectX:=0, ByRef rectY:=0)
{
	zoom := 16
	zSide := magWinSide / zoom
	
	Loop
	{
		MouseGetPos, x, y
		If (x=x_old) && (y=y_old)
			Continue
		x_old:=x, y_old:=y
		
		curX := x - zSide/2
		curY := y - zSide/2
		
		StretchBlt(destPrintFrame, 0, 0, magWinSide, magWinSide, destFullFrame, curX, curY, zSide, zSide, 0xCC0020)
		
		crshDIBS := CreateDIBSection(magWinSide, magWinSide)
		crshRegObj := SelectObject(destPrintFrame, crshDIBS)
		destGpxDCP := Gdip_GraphicsFromHDC(destPrintFrame)
		pen1 := Gdip_CreatePen(0x660000ff, 10)
		
		Gdip_DrawLine(destGpxDCP, pen1, 0, magWinSide/2, magWinSide, magWinSide/2)
		Gdip_DrawLine(destGpxDCP, pen1, magWinSide/2, 0, magWinSide/2, magWinSide)		
		
		if rectX && rectY{
			StretchBlt(destFullFrame, 0, 0, winW, winH, srcPrintFrame, 0, 0, winW, winH, 0xCC0020)
			
			rectDIBS := CreateDIBSection(winW, winH)
			rectRegObj := SelectObject(winW, winH)
			rectGpxDCP := Gdip_GraphicsFromHDC(destFullFrame)
			pen2 := Gdip_CreatePen(0x660000ff, 1)
			Gdip_DrawRectangle(rectGpxDCP, pen2, rectX, rectY, x-rectX, y-rectY)
		}
		
		
		if C_KeyWait("x", "D")
		{
			selX := x
			selY := y
			break
		}
	}
}

getSrcFullWin(){
	WinGet, prnSrcID, ID, % winName
	WinGetPos, winX, winY, winW, winH, % winName
	
	Gui, PnCfgSrc: -Border -Caption +hwndpnCfgSrcID	
	Gui, PnCfgSrc: Show , % "w" winW " h" winH " x" 0 " y" 0, PaneConfigSource
	
	srcPrintFrame := GetDC(prnSrcID)
	destFullFrame := GetDC(pnCfgSrcID)
	
	StretchBlt(destFullFrame, 0, 0, winW, winH, srcPrintFrame, 0, 0, winW, winH, 0xCC0020)
}

getPnCfgMainWin(){
	Gui, PnCfgMain: +AlwaysOnTop +hwndpnCfgMainID
	Gui, PnCfgMain: Show, % "x" 0 " y" 0 " w" magWinSide " h" magWinSide + 400, PaneConfigMain
	
	Gui, PnCfgMain: Add, Button, % "y+" magWinSide " ggetSelXY Default ", OK 	
	
	destPrintFrame := GetDC(pnCfgMainID)
}

PnCfgMainGuiClose()
{
	
	Gdip_Shutdown(pToken)
	ExitApp
}


