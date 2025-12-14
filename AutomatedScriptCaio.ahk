;80s per run
;==================================================================================================================================================================================================================================================================================================================================================================================================================================
;==================================================================================================================================================================================================================================================================================================================================================================================================================================
;==================================================================================================================================================================================================================================================================================================================================================================================================================================
;CONFIG
;==================================================================================================================================================================================================================================================================================================================================================================================================================================
;==================================================================================================================================================================================================================================================================================================================================================================================================================================
;==================================================================================================================================================================================================================================================================================================================================================================================================================================

#NoEnv
#SingleInstance, Force
#Include %A_ScriptDir%

; Verificar privilegios de administrador (necesarios para firewall)
if not A_IsAdmin
{
  Run *RunAs "%A_ScriptFullPath%",, UseErrorLevel
  if ErrorLevel != 0
  {
  MsgBox, 48, Error, Este script requiere privilegios de administrador para controlar el firewall!
  ExitApp
  }
  ExitApp
}

; Asegurar que el firewall se desactive al cerrar el script
OnExit("CleanupFirewall")

FileCreateDir, %A_WorkingDir%\images
FileInstall, images\map_button.bmp, %A_WorkingDir%\images\map_button.bmp, 1 ;map button
FileInstall, images\joining_online_button.bmp, %A_WorkingDir%\images\joining_online_button.bmp, 1 ;joining online button
FileInstall, images\browser_tile.png, %A_WorkingDir%\images\browser_tile.png, 1 ;browser tile
FileInstall, images\quick_actions_tile.bmp, %A_WorkingDir%\images\quick_actions_tile.bmp, 1 ;quick actions list tile
FileInstall, images\return_to_map_button.bmp, %A_WorkingDir%\images\return_to_map_button.bmp, 1 ;return to map button(dynasty 8)
FileInstall, images\retry_continue_buttons.bmp, %A_WorkingDir%\images\retry_continue_buttons.bmp, 1 ;retry/continue buttons
FileInstall, images\trade_in_property_menu.bmp, %A_WorkingDir%\images\trade_in_property_menu.bmp, 1 ;trade in property menu
FileInstall, images\interaction_menu.bmp, %A_WorkingDir%\images\interaction_menu.bmp, 1 ;interaction menu
FileInstall, images\interaction_menu2.bmp, %A_WorkingDir%\images\interaction_menu2.bmp, 1 ;interaction menu tile
SetKeyDelay, 130, 1
SetMouseDelay, 70
CoordMode, Pixel, Relative
SetTitleMatchMode, 2





;==================================================================================================================================================================================================================================================================================================================================================================================================================================
;==================================================================================================================================================================================================================================================================================================================================================================================================================================
;==================================================================================================================================================================================================================================================================================================================================================================================================================================
;HOTKEYS
;==================================================================================================================================================================================================================================================================================================================================================================================================================================
;==================================================================================================================================================================================================================================================================================================================================================================================================================================
;==================================================================================================================================================================================================================================================================================================================================================================================================================================
Numpad0:: ;preparation phase start hotkey
  MsgBox, 4,, You're going to start "preparation phase"`n!!!WARNING!!!`n You need to have at least $5,000,000 on your GTA Online's bank account!`n!!!WARNING!!!`nDo you want to continue?
  IfMsgBox, Yes
    {
    ApartmentsPrep()
    Return
    }
  else
    Return





Numpad1:: ;payback phase start hotkey
  MsgBox, 4,, You're going to start "payback phase"`n!!!WARNING!!!`nMake sure that you've prepared the slots!`n!!!WARNING!!!`nDo you want to continue?
  IfMsgBox, Yes
    {
    ApartmentsRun()
    Return
    }
  else
    Return





Numpad2:: ;"panic button" no-save enable hotkey
  saveblockEnable()
  Return





Numpad3:: ;"panic button" no-save disable hotkey
  saveblockDisable()
  Return





Numpad4:: ;"panic button" reload hotkey
  Reload
  Return





Numpad5:: ;"panic button" exit hotkey
  ExitApp
  Return
  
  
  
  
  


  



;==================================================================================================================================================================================================================================================================================================================================================================================================================================
;==================================================================================================================================================================================================================================================================================================================================================================================================================================
;==================================================================================================================================================================================================================================================================================================================================================================================================================================
;FUNCTIONS
;==================================================================================================================================================================================================================================================================================================================================================================================================================================
;==================================================================================================================================================================================================================================================================================================================================================================================================================================
;==================================================================================================================================================================================================================================================================================================================================================================================================================================





ApartmentsRun() ;function that runs "payback phase"
  {
  InputBox, runsNum,, How many runs?,
  totaltime := Format("{1:.2f}",((runsNum*80)/60)) 
  totaltime2 := Format("{1:.2f}",(totaltime/60.0)) 
  totalpayout := RegExReplace((runsNum*5200000), "(\d)(?=(?:\d{3})+(?:\.|$))", "$1,")
  cashperminute := "3,900,000"
  MsgBox, 4,, Don't press anything after choosing "Yes"!!!`n`nWhole process will take %runsNum% runs -  around %totaltime% minutes(%totaltime2% hours).`n`nYou'll earn around $%totalpayout%.`n`nEstimated $/minute profit: $%cashperminute%.`n`n Do you want to continue?
  IfMsgBox, No
    {
    Return
    }
  else
    {
    WinActivate, Grand Theft Auto V
    QPC(1)
    Loop % runsNum 
      {
      ToolTip, Going...(Run %A_index%), 400, 0
      fromSingleToOnline()
      ApartmentsExchange()
      fromOnlineToSingle()
      Tooltip,,
      }
    MenuMapChecker()
  timer := Round(QPC(0), 2)
  perRun := Round(timer/runsNum, 2)
    saveblockDisable()
    MsgBox End of the line. Rounds passed: %runsNum%. Time passed: %timer%s. Cash earned: $%totalpayout%. Time per run: %perRun%s.
    }
  } 





ApartmentsPrep() ;function that runs preparation phase
  {
  MsgBox, 4,, Don't press anything after choosing "Yes"!!!`n`nWhole process will take around 15 minutes. Do you want to continue?
  IfMsgBox Yes
    {
    PrepTime()
    }
  else
    {
    Return
    }
  }





ApartmentsExchange() ;function that trades in all apartments into cheapest one(MUST PREPARE THE SLOTS FIRST !!!!)
{
  tradebutton_y := 80 ;y cord of tradein slot; needed for later loop
  PullUpPhone()
  Sleep 300
  EnterBrowser()
  EnterDynastyEstate()
  
  ; PRIMERA COMPRA - CON ACTIVACIÓN DE FIREWALL
  BuyTrashBlocker()
  TradeInChecker()
  PressKey("Enter", 50, 1, 300)
  PressKey("Enter", 50, 1, 0)
  ReturnToMapChecker()
  ReturnToMapPress()
  
  ; RESTO DE COMPRAS (9 más) - SIN ACTIVAR FIREWALL (ya está activo)
  Loop, 9
    {
    BuyTrashNoFirewall()
    TradeInChecker()
    tradebutton_y := tradebutton_y + 27
  MouseMove, 70, tradebutton_y, 0
  Click
    PressKey("Enter", 50, 2, 0) ;confirm
    ReturnToMapChecker()
    ReturnToMapPress()
    }
  ExitBrowser()
  Sleep 150
}





PrepTime() ;function that prepares all apartment slots so all of them will be worth 550k each
{
  WinActivate, Grand Theft Auto V
  QPC(1)
  Loop, 10
    {
  counter := A_index - 1
    Tooltip, Preparing apartment no.(%A_index%), 400, 0
    Sleep 200
    fromSingleToOnline()
    BringInteractionMenu()
  Sleep 200
    OutfitForceSave()
    HideInteractionMenu()
    Sleep 50
  PullUpPhone()
    Sleep 300
    EnterBrowser()
  EnterDynastyEstate()
    BuyEclipse()
    TradeInChecker()
    Sleep 300
    if (A_Index = 1)
      {
      PressKey("Enter", 50, 2, 0) ;confirm
      }
    else
      {
      PressKey("Down", 50, counter, 30) ;choose slot
      PressKey("Enter", 50, 2, 0) ;confirm
      }
  Sleep 400
  ExitBrowser()
  PullUpPhone()
    Sleep 300
    EnterBrowser()
  EnterDynastyEstate()
    BuyTrashBlocker()
  Sleep 200
    TradeInChecker()
    if(A_Index = 1)
      {
      PressKey("Enter", 50, 2, 50)
      }
    else
      {
      PressKey("Down", 50, counter, 30) ;choose slot
      PressKey("Enter", 50, 2, 0) ;confirm
      }
    ReturnToMapChecker()
    ReturnToMapPress()
  ExitBrowser()
    Sleep 150
    fromOnlineToSingle()
    Tooltip,,
  }
  MenuMapChecker()
  timer := Round(QPC(0), 2)
  MsgBox, time needed: %timer%
}




PressKey(button, presstime, presses, sleeptime)
  {
  Loop, %presses%
    {
    SendInput, {%button% down}
    Sleep %presstime%
    SendInput {%button% up}
    if( presses > 1)
    Sleep 100
    Sleep %sleeptime%
    }
  } ;presskey function - very fast, at least faster than send





fromSingleToOnline()
  {
  SetMouseDelay, 60
  MenuMapChecker()
  MouseMove, 913, 172, 0
  Click
  Sleep 700
  PressKey("Up", 50, 1, 150)
  PressKey("Enter", 50, 1, 150)
  PressKey("Up", 50, 1, 150)
  Critical
  saveblockDisable()
  Critical, Off
  PressKey("Enter", 60, 2, 100)
  Loop
    {
    ImageSearch, FoundX, FoundY, 867, 766, 984, 783, *80 %A_WorkingDir%\images\joining_online_button.bmp ;eighth image check
    if (ErrorLevel = 0) AND (FoundX != 0) AND (FoundY != 0)
      {
      break
      }
    ImageSearch, FoundX, FoundY, 831, 747, 1023, 795, *50 %A_WorkingDir%\images\retry_continue_buttons.bmp ;seventh image check
    if (ErrorLevel = 0) AND (FoundX != 0) AND (FoundY != 0)
      {
      Critical
      saveblockDisable()
      Critical, Off
      Sleep 4000
      PressKey("Space", 500, 1, 0)
      break
      }
    }
  } ;function that goes from story mode into gta online


MenuMapChecker()
{
Loop
    {
    PressKey("p", 50, 1, 370)
    ImageSearch, FoundX, FoundY, 0, 0, 165, 182, *100 %A_WorkingDir%\images\map_button.bmp ;first image check
    } Until (ErrorLevel = 0) AND (FoundX != 0) AND (FoundY != 0)
}


fromOnlineToSingle()
  {
  ; Secuencia exacta para entrar a Story Mode
  Sleep 500
  SendInput {Esc}
  Sleep 500
  SendInput {e}
  Sleep 500
  SendInput {Enter}
  Sleep 500
  
  ; Presionar UP 3 veces de forma más explícita
  SendInput {Up}
  Sleep 200
  SendInput {Up}
  Sleep 200
  SendInput {Up}
  Sleep 500
  
  ; DOS ENTER para confirmar
  SendInput {Enter}
  Sleep 300
  SendInput {Enter}  ; ENTER ADICIONAL
  
  ; Esperar 35 segundos a que cargue completamente y guarde
  ToolTip, Esperando 35s para desactivar firewall..., 400, 0
  Sleep 35000
  ToolTip
  
  ; DESACTIVAR FIREWALL después de 35s en Story Mode
  Critical
  saveblockDisable()
  Critical, Off
  
  Sleep 1000
  
  ; CICLO DE LIMPIEZA: Volver a Online y luego a Story Mode
  ToolTip, Ciclo de limpieza: Entrando a Online..., 400, 0
  fromSingleToOnlineCleanup()
  Sleep 2000
  ToolTip, Ciclo de limpieza: Volviendo a Story Mode..., 400, 0
  fromOnlineToSingleCleanup()
  ToolTip, Run completado - Listo para el siguiente, 400, 0
  Sleep 2000
  ToolTip
  
  } ;function that goes from gta online to story mode





saveblockEnable() ;function to enable no-save mode
  {
    RunWait %comspec% /c "netsh advfirewall firewall add rule name="GTAOSAVEBLOCK" dir=out action=block remoteip=192.81.241.171 enable=yes" ,,Hide
    ToolTip, FIREWALL ACTIVADO - NO SAVE MODE ON, 10, 10
    SetTimer, RemoveToolTip, 2000
  }




  
saveblockDisable()
  {
  RunWait %comspec% /c "netsh advfirewall firewall delete rule name="GTAOSAVEBLOCK" ,,Hide
  ToolTip, FIREWALL DESACTIVADO - SAVE MODE ON, 10, 10
  SetTimer, RemoveToolTip, 2000
  } ;function to disable no-save mode

RemoveToolTip:
  ToolTip
return





BringInteractionMenu()
{
  Loop
      {
      PressKey("m", 50, 1, 70)
      ImageSearch, FoundX, FoundY, 27, 117, 175, 134, *100 %A_WorkingDir%\images\interaction_menu.bmp
      Sleep 70
      } Until (ErrorLevel = 0) AND (FoundX != 0) AND (FoundY != 0)
} ;function to bring out interaction menu





OutfitForceSave()
{
  MouseMove, 100, 285, 0
  Sleep 120
  Click
  Sleep 120
  PressKey("Enter", 50, 1, 70)
  PressKey("Down", 50, 1, 80)
  PressKey("Enter", 50, 2, 80)
  PressKey("Backspace", 50, 1, 80)
  PressKey("m", 50, 1, 50)
} ;function to force a game save by changing outfit





HideInteractionMenu()
{
  ;deprecated
} ;function to close interaction menu





PullUpPhone()
{
  Loop
      {
      PressKey("MButton", 1, 1, 50)
      ImageSearch, FoundX, FoundY, 920, 647, 943, 672, *80 %A_WorkingDir%\images\quick_actions_tile.bmp
      }Until (ErrorLevel = 0) AND (FoundX != 0) AND (FoundY != 0) ;state checker - presses up arrow key until character's phone will be pulled up
} ;function to take out gtao char phone





EnterBrowser()
{
  Loop
      {
      PressKey("Down", 50, 1, 50)
      ImageSearch, FoundX, FoundY, 914, 696, 948, 729, *100 %A_WorkingDir%\images\browser_tile.png
      }Until (ErrorLevel = 0) AND (FoundX != 0) AND (FoundY != 0) ;state checker - presses down arrow key until browser's tile on phone will be chosen
  Sleep 30
    PressKey("Enter", 50, 1, 600) ;enter browser
    
} ;function to enter phone's browser





EnterDynastyEstate()
{
  MouseMove, 388, 587, 0 ;enter dynasty 8 website (COORDENADA CORREGIDA)
  Sleep 60
    Click
    Sleep 300  ;tiempo adicional para que cargue la página
    MouseMove, 310, 450, 1 ;"view property listings"
  Sleep 200
  Click
} ;function to enter dynasty 8 website and then property listings





BuyEclipse()
{
  MouseMove, 240, 270, 0 ;sort from low to high
  Click
  Sleep 100
    MouseMove, 310, 270, 0 ;sort from high to low
  Click
  Sleep 100
    MouseMove, 300, 400, 0 ;choose apartment
  Click
  Sleep 120
    MouseMove, 780, 600, 0 ;select interiors
  Click
  Sleep 100
    PressKey("WheelDown", 10, 3, 10) ;scroll down to show purchase button
  MouseMove, 760, 720, 0
  Sleep 50
  Click
  ;Click, 760 720 ;purchase property
} ;function to buy most expensive apartment available for character





TradeInChecker()
{
Loop
      {
      Sleep 100
      ImageSearch, FoundX, FoundY, 27, 49, 150, 66, *80 %A_WorkingDir%\images\trade_in_property_menu.bmp ;fifth image check
      }Until (ErrorLevel = 0) AND (FoundX != 0) AND (FoundY != 0)
} ;function to check presence of trade-in window using image recognition





ExitBrowser()
{
MouseMove, 842, 108, 0 ;exit web browser
  Click
  Sleep 300
} ;function to exit phone's browser





BuyTrash()
{
    MouseMove, 310, 270, 0 ;sort from high to low
    Click
    Sleep 100
    MouseMove, 240, 270, 0 ;sort from low to high
    Click
    Sleep 100
    MouseMove, 300, 400, 0 ;choose apartment (SELECCIONAR PRIMERA CASA)
    Click
    Sleep 300
    
    ; ⚡⚡⚡ ACTIVAR FIREWALL AQUÍ - JUSTO DESPUÉS DE SELECCIONAR LA CASA ⚡⚡⚡
    Critical
    saveblockEnable()
    Sleep 500
    Critical, Off
    
    ; Ahora proceder con la compra
    MouseMove, 750, 600, 0 ;purchase property button
    Sleep 50
    Click
} ;function to buy cheapest apartment available for character


BuyTrashNoFirewall()
{
    MouseMove, 310, 270, 0 ;sort from high to low
    Click
    Sleep 100
    MouseMove, 240, 270, 0 ;sort from low to high
    Click
    Sleep 100
    MouseMove, 300, 400, 0 ;choose apartment
    Click
    Sleep 120
    
    ; SIN ACTIVAR FIREWALL - Ya está activo desde la primera compra
    
    MouseMove, 750, 600, 0 ;purchase property button
    Sleep 50
    Click
} ;function to buy cheapest apartment WITHOUT activating firewall (for subsequent purchases)





BuyTrashBlocker()
{
    MouseMove, 310, 270, 0 ;sort from high to low
    Click
    Sleep 100
    MouseMove, 240, 270, 0 ;sort from low to high
    Click
    Sleep 100
    MouseMove, 300, 400, 0 ;choose apartment (SELECCIONAR PRIMERA CASA)
    Click
    Sleep 300
    
    ; ⚡⚡⚡ ACTIVAR FIREWALL AQUÍ - JUSTO DESPUÉS DE SELECCIONAR LA CASA ⚡⚡⚡
    Critical
    saveblockEnable()
    Sleep 500
    Critical, Off
    
    ; Ahora proceder con la compra
    MouseMove, 750, 600, 0 ;purchase property button
    Sleep 50
    Click
} ;function to buy cheapest apartment available for character(modified version for "preparation phase" - this one enables blocker before swap so trade-in value of most expensive apartment will stay but actual cheapest building will be used, resulting in some cheap house in paleto(for example) being worth as much as eclipse tower apartment





ReturnToMapChecker()
{
  Loop
    {
      ImageSearch, FoundX, FoundY, 414, 621, 573, 646, *50 %A_WorkingDir%\images\return_to_map_button.bmp
      Sleep 100
    } Until (ErrorLevel = 0) AND (FoundX != 0) AND (FoundY != 0)
} ;state checker - checks presence of "return to map" button using image recognition





ReturnToMapPress()
{
  MouseMove, 500, 630, 1 ;return to map button
  Click
  Sleep 300
}



QPC( R := 0 ) 
  {   
  ; By SKAN,  http://goo.gl/nf7O4G,  CD:01/Sep/2014 | MD:01/Sep/2014
  Static P := 0,  F := 0,     Q := DllCall( "QueryPerformanceFrequency", "Int64P",F )
  Return ! DllCall( "QueryPerformanceCounter","Int64P",Q ) + ( R ? (P:=Q)/F : (Q-P)/F ) 
  } ;timer, mostly for checking performance of script


CleanupFirewall()
{
  ; Limpieza automática al cerrar el script
  RunWait netsh advfirewall firewall delete rule name="GTAOSAVEBLOCK" ,,hide
  ToolTip, Script cerrado - Firewall limpiado, 10, 10
  Sleep 1500
  ToolTip
}


fromSingleToOnlineCleanup()
  {
  ; Versión simplificada para el ciclo de limpieza (sin saveblock)
  SetMouseDelay, 60
  MenuMapChecker()
  MouseMove, 913, 172, 0
  Click
  Sleep 700
  PressKey("Up", 50, 1, 150)
  PressKey("Enter", 50, 1, 150)
  PressKey("Up", 50, 1, 150)
  PressKey("Enter", 60, 2, 100)
  
  ; Esperar a que cargue online (más tiempo por seguridad)
  Sleep 15000
  } ;function that goes from story mode to online for cleanup cycle


fromOnlineToSingleCleanup()
  {
  ; Esperar 25 segundos en Online
  ToolTip, Esperando 25s en Online (limpieza)..., 400, 0
  Sleep 25000
  ToolTip
  
  ; Secuencia para salir a Story Mode: ESC > E > Enter > Up×3 > Enter×2
  Sleep 500
  SendInput {Esc}
  Sleep 500
  SendInput {e}
  Sleep 500
  SendInput {Enter}
  Sleep 500
  
  ; Presionar UP 3 veces
  SendInput {Up}
  Sleep 200
  SendInput {Up}
  Sleep 200
  SendInput {Up}
  Sleep 500
  
  ; DOS ENTER para confirmar
  SendInput {Enter}
  Sleep 300
  SendInput {Enter}
  Sleep 500
  
  ; Esperar 35 segundos en Story Mode
  ToolTip, Esperando 35s en Story Mode (limpieza final)..., 400, 0
  Sleep 35000
  ToolTip
  } ;function that goes from online to story mode for cleanup cycle