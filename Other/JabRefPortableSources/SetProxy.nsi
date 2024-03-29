
CRCCheck On
RequestExecutionLevel user

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On
AutoCloseWindow true

!include "MUI2.nsh"

!include "FileFunc.nsh"
!include ReadINIStrWithDefault.nsh
!include blowfish.nsh
!include "jabrefproxy.nsh"

Name "JabRefPortable.App Options"
OutFile "..\..\set-proxy.exe"
BrandingText "PortableJabRef.App"

InstallDir "$EXEDIR"

!define MUI_ICON "jabrefportable.ico"
#!define MUI_UNICON
!define MUI_HEADERIMAGE

!define MUI_ABORTWARNING
!define MUI_UNABORTWARNING
!define MUI_PAGE_HEADER_TEXT "JabRefPortable.app"
!define MUI_PAGE_HEADER_SUBTEXT "JabRef on the Go"

!define MUI_COMPONENTSPAGE_SMALLDESC

!define TEMP1 $R0 ;Temp variable

!define ep_proxy_server "Field 2"
!define ep_proxy_port "Field 4"

;Order of pages
Page custom SetCustom ValidateCustom ": JabRefPortable Options" ;Custom page. InstallOptions gets called in SetCustom.
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

!macro WR OPT EP
  ReadINIStr $R0 "$EXEDIR\Data\ini\proxy.ini" "${EP}" "State"
  WriteIniStr "$EXEDIR\Data\ini\JabRefPortableApp.ini" "JabRefPortableApp" ${OPT} "$R0"
!macroend
!define WR "!insertmacro WR"


!macro RW OPT EP
  ReadIniStr $R0 "$EXEDIR\Data\ini\JabRefPortableApp.ini" "JabRefPortableApp" ${OPT}
  WriteINIStr "$EXEDIR\Data\ini\proxy.ini" "${EP}" "State" "$R0"
!macroend

!define RW "!insertmacro RW"

Function .onInit
  var /GLOBAL versions
  var /GLOBAL nemacs
  var /GLOBAL lastversion
  SetOutPath "$EXEDIR\Data\ini"
  IfFileExists "$EXEDIR\Data\ini\proxy.ini" +2 0
  CopyFiles /SILENT "$EXEDIR\App\proxy.ini" "$EXEDIR\Data\ini\proxy.ini"
  ${SetupProxy}
  WriteIniStr "$EXEDIR\Data\ini\proxy.ini" "${ep_proxy_server}" "State" ""
  WriteIniStr "$EXEDIR\Data\ini\proxy.ini" "${ep_proxy_port}" "State" ""
  
  
  IfFileExists "$EXEDIR\Data\ini\proxy-$PROXY_IDE.ini" 0 end_proxy_init
  ReadINIStr $R0 "$EXEDIR\Data\ini\proxy-$PROXY_IDE.ini" "$PROXY_NAME" "Server"
  ${BlowFish_Decrypt} $R0 $R0 "$PROXY_ID"
  WriteINIStr "$EXEDIR\Data\ini\proxy.ini" "${ep_proxy_server}" "State" "$R0"
  
  ReadIniStr $R0 "$EXEDIR\Data\ini\proxy-$PROXY_IDE.ini" "$PROXY_NAME" "Port"
  ${BlowFish_Decrypt} $R0 $R0 "$PROXY_ID"
  WriteINIStr "$EXEDIR\Data\ini\proxy.ini" "${ep_proxy_port}" "State" "$R0"
  
  
  end_proxy_init:
    
  end_init:
    
  FunctionEnd

Function SetCustom
  
  ;Display the InstallOptions dialog
  
  Push ${TEMP1}
  
  InstallOptions::dialog "$EXEDIR\Data\ini\proxy.ini"
  Pop ${TEMP1}
  
  Pop ${TEMP1}
FunctionEnd

Function ValidateCustom
;
;  ReadINIStr ${TEMP1} "$PLUGINSDIR\test.ini" "Field 2" "State"
;  StrCmp ${TEMP1} 1 done

;  ReadINIStr ${TEMP1} "$PLUGINSDIR\test.ini" "${ep_version}" "State"
;  StrCmp ${TEMP1} 1 done

;  ReadINIStr ${TEMP1} "$PLUGINSDIR\test.ini" "Field 4" "State"
;  StrCmp ${TEMP1} 1 done
;    MessageBox MB_ICONEXCLAMATION|MB_OK "You must select at least one install option!"
;    Abort

;  done:
   
   
   
   ReadINIStr $R0 "$EXEDIR\Data\ini\proxy.ini" "${ep_proxy_server}" "State"
   StrCmp $R0 "" skip_proxy
   ${BlowFish_Encrypt} $R0 $R0 "$PROXY_ID"
   WriteIniStr "$EXEDIR\Data\ini\proxy-$PROXY_IDE.ini" "$PROXY_NAME" "Server" "$R0"
   ReadINIStr $R0 "$EXEDIR\Data\ini\proxy.ini" "${ep_proxy_port}" "State"
   ${BlowFish_Encrypt} $R0 $R0 "$PROXY_ID"
   WriteIniStr "$EXEDIR\Data\ini\proxy-$PROXY_IDE.ini" "$PROXY_NAME" "Port" "$R0"
   skip_proxy:
     
FunctionEnd

Section "Components" 
  ;Get Install Options dialog user input
  
  
SectionEnd
