#SingleInstance, Force
#NoEnv
SetBatchLines, -1

#Include Gdip_All.ahk 
CoordMode Mouse, Screen
pToken := Gdip_Startup()

global magWinSide := 256, winName, winX, winY, winW, winH
global srcPrintFrame, destPrintFrame, destFullFrame
global zoomAct := 1

InputBox, winName,, Please Enter The Window Title
winSetup()
;activate()
;a::activate()

winSetup()
{	
	WinGet, prnSrcID, ID, % winName
	WinGetPos, winX, winY, winW, winH, % winName
	
	Gui, PnCfgMain: +AlwaysOnTop 
	
	Gui, PnCfgMain: Show, % "x" 0 " y" 0 " w" magWinSide " h" magWinSide + 400, PaneConfigMain
		
	Gui, PnCfgMain: Add, Button, % "y+" magWinSide " gactivate Default ", OK 

	WinGet, pnCfgMainID, ID, PaneConfigMain
	
	WinGet pnCfgMainID, ID, PaneConfigMain
	Gui, PnCfgSrc: -Border -Caption
	
	Gui, PnCfgSrc: Show , % "w" winW " h" winH " x" 0 " y" 0, PaneConfigSource
		
	WinGet pnCfgSrcID, ID, PaneConfigSource

	srcPrintFrame := GetDC(prnSrcID)
	destPrintFrame := GetDC(pnCfgMainID)
	destFullFrame := GetDC(pnCfgSrcID)
	
	StretchBlt(destFullFrame, 0, 0, winW, winH, srcPrintFrame, 0, 0, winW, winH, 0xCC0020)
	
}

activate()
{
	zoom := 16
	zSide := magWinSide / zoom
	
	Loop
	{
		MouseGetPos, x, y
		x -= zSide/2
		y -= zSide/2
		StretchBlt(destPrintFrame, 0, 0, magWinSide, magWinSide, srcPrintFrame, x, y, zSide, zSide, 0xCC0020)
			
		crshDIBS := CreateDIBSection(magWinSide, magWinSide)
		crshRegObj := SelectObject(destPrintFrame, crshDIBS)tFrame)
		pen1 := Gdip_CreatePen(0x660000ff, 10)
				
		Gdip_DrawLine(destGpxDCP, pen1, 0, magWinSide/2, magWinSide, magWinSide/2)
		Gdip_DrawLine(destGpxDCP, pen1, magWinSide/2, 0, magWinSide/2, magWinSide)
		
		GetKeyState, state, LButton
		if state = D
		{
			zoomAct--
			return
		}
	}
}

GuiClose()
{
	ExitApp
}



Gdip_Shutdown(pToken)