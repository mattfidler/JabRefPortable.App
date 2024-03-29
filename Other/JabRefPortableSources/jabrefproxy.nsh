
Var PROXY_ID
Var PROXY_IDE
Var PROXY_NAME
Var PROXY_SERVER
Var PROXY_PORT
Var PROXY_USER
Var PROXY_PASS
!include "blowfish.nsh"

Function ReadFileLine
  Exch $0 ;file
  Exch
  Exch $1 ;line number
  Push $2
  Push $3
  
  FileOpen $2 $0 r
  StrCpy $3 0
  
  Loop:
    IntOp $3 $3 + 1
    ClearErrors
    FileRead $2 $0
    IfErrors +2
    StrCmp $3 $1 0 loop
    FileClose $2
    
    Pop $3
    Pop $2
    Pop $1
    Exch $0
FunctionEnd

Function IPAddressesCallback
  Pop $5
  StrCmp "$PROXY_IDE" "" 0 end
  ExecDos::exec "cmd /c $\"nslookup $5 > $\"$\"$TEMP\ep-dns.txt$\"$\"$\""
  Push 1
  Push "$TEMP\ep-dns.txt"
  Call ReadFileLine
  Pop $R0
  StrCpy $R0 $R0 "" 9
  StrCpy $R0 $R0 -2
  StrCpy $PROXY_IDE "$R0"
  StrCpy $PROXY_ID "$PROXY_ID$R0"
  Delete "$TEMP\ep-dns.txt"
  end:
    ClearErrors
FunctionEnd

Function EnabledAdaptersCallback
  Pop $3
  #DetailPrint "Get Mac Address"
  #IpConfig::GetNetworkAdapterMACAddress $3
  #Pop $0
  #Pop $1
  #StrCpy $PROXY_ID "$PROXY_ID$1"
  GetFunctionAddress $4 IPAddressesCallback
  IpConfig::GetNetworkAdapterIPAddressesCB $3 $4
FunctionEnd

Function SetupProxy
  Pop $9
  StrCpy $PROXY_IDE ""
  StrCpy $PROXY_ID ""
  GetFunctionAddress $2 EnabledAdaptersCallback
  IpConfig::GetEnabledNetworkAdaptersIDsCB $2
  StrCpy $PROXY_NAME $PROXY_ID
  IfFileExists "$9\proxy-$PROXY_IDE.ini" 0 end
  ReadIniStr $R0 "$9\proxy-$PROXY_IDE.ini" "$PROXY_NAME" "Server"
  ${BlowFish_Decrypt} $R0 $R0 "$PROXY_ID"
  StrCpy "$PROXY_SERVER" "$R0"
  StrCmp "$R0" "" end
  StrCpy "$R1" "$R0"
  ReadIniStr "$R0" "$9\proxy-$PROXY_IDE.ini" "$PROXY_NAME" "Port"
  ${BlowFish_Decrypt} $R0 $R0 "$PROXY_ID"
  StrCpy "$PROXY_PORT" "$R0"  
  StrCmp "$R0" "" +2 0
  StrCpy "$R1" "$R1:$R0"
  ReadIniStr "$R0" "$9\proxy-$PROXY_IDE.ini" "$PROXY_NAME" "User"
  ${BlowFish_Decrypt} $R0 $R0 "$PROXY_ID"
  StrCpy $PROXY_USER "$R0"
  
  StrCmp "$R0" "" +2 0
  StrCpy "$R2" "$R0"
  ReadIniStr "$R0" "$9\proxy-$PROXY_IDE.ini" "$PROXY_NAME" "Password"
  ${BlowFish_Decrypt} $R0 $R0 "$PROXY_ID"
  StrCpy $PROXY_PASS $R0
  StrCmp "$R0" "" +3 0
  StrCmp "$R2" "" +2 0
  StrCpy "$R2" "$R2:$R0"
  StrCmp "$R2" "" +2 0
  StrCpy "$R1" "$R2@$R1"
  System::Call 'Kernel32::SetEnvironmentVariableA(t, t) i("HTTP_PROXY","http://$R1").r0'
  System::Call 'Kernel32::SetEnvironmentVariableA(t, t) i("HTTPS_PROXY","http://$R1").r0'
  System::Call 'Kernel32::SetEnvironmentVariableA(t, t) i("FTP_PROXY","ftp://$R1").r0'
  end:
    ClearErrors
FunctionEnd

!macro SetupProxy FILE
  Push "${FILE}"
  Call SetupProxy
  Pop $R0
!macroend

!define SetupProxy `!insertmacro SetupProxy "$EXEDIR\Data\ini\"`
!define SetupProxyFile `!insertmacro SetupProxy`
