?#SingleInstance, Force
#NoEnv
SetBatchLines, -1

#Include Gdip_All.ahk
CoordMode Mouse, Screen
gdip := New GDIP()
pToken := gdip.Startup()

global magWinSide := 256, winName, winX, winY, winW, winH
global srcPrintFrame, destPrintFrame, destFullFrame

InputBox, winName,, Please Enter The Window Title
if ErrorLevel
	PnCfgMainGuiClose()

CZoom_init()
;CZoom_activate()

CZoom_init()
{	
	CZoom_getSrcFullWin()
	CZoom_getPnCfgMainWin()
		
	
}



getSelXY(){
	CZoom_activate(x, y)
	Sleep 1000
	CZoom_activate(, , x, y)
}


CZoom_activate(ByRef selX:=0, ByRef selY:=0, ByRef rectX:=0, ByRef rectY:=0)
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
		
		gdip.StretchBlt(destPrintFrame, 0, 0, magWinSide, magWinSide, destFullFrame, curX, curY, zSide, zSide, 0xCC0020)
		
		crshDIBS := gdip.CreateDIBSection(magWinSide, magWinSide)
		crshRegObj := gdip.SelectObject(destPrintFrame, crshDIBS)
		destGpxDCP := gdip.GraphicsFromHDC(destPrintFrame)
		pen1 := gdip.CreatePen(0x660000ff, 10)
		
		gdip.DrawLine(destGpxDCP, pen1, 0, magWinSide/2, magWinSide, magWinSide/2)
		gdip.DrawLine(destGpxDCP, pen1, magWinSide/2, 0, magWinSide/2, magWinSide)		
		
		if rectX && rectY{
			gdip.StretchBlt(destFullFrame, 0, 0, winW, winH, srcPrintFrame, 0, 0, winW, winH, 0xCC0020)
			
			rectDIBS := gdip.CreateDIBSection(winW, winH)
			rectRegObj := gdip.SelectObject(winW, winH)
			rectGpxDCP := gdip.GraphicsFromHDC(destFullFrame)
			pen2 := gdip.CreatePen(0x660000ff, 1)
			gdip.DrawRectangle(rectGpxDCP, pen2, rectX, rectY, x-rectX, y-rectY)
		}
		
		
		if GetKeyState("LButton", "D")
		{
			selX := x
			selY := y
			break
		}
	}
}

CZoom_getSrcFullWin(){
	WinGet, prnSrcID, ID, % winName
	WinGetPos, winX, winY, winW, winH, % winName
	
	Gui, PnCfgSrc: -Border -Caption +hwndpnCfgSrcID	
	Gui, PnCfgSrc: Show , % "w" winW " h" winH " x" 0 " y" 0, PaneConfigSource
	
	srcPrintFrame := gdip.GetDC(prnSrcID)
	destFullFrame := gdip.GetDC(pnCfgSrcID)
	
	gdip.StretchBlt(destFullFrame, 0, 0, winW, winH, srcPrintFrame, 0, 0, winW, winH, 0xCC0020)
}

CZoom_getPnCfgMainWin(){
	Gui, PnCfgMain: +AlwaysOnTop +hwndpnCfgMainID
	Gui, PnCfgMain: Show, % "x" 0 " y" 0 " w" magWinSide " h" magWinSide + 400, PaneConfigMain
	
	Gui, PnCfgMain: Add, Button, % "y+" magWinSide " ggetSelXY Default ", OK 	
	
	destPrintFrame := gdip.GetDC(pnCfgMainID)
}

PnCfgMainGuiClose()
{
	
	gdip.Shutdown(pToken)
	ExitApp
}


