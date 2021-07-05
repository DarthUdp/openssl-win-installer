# Generated with generator-nsis
# https://github.com/idleberg/generator-nsis

# Includes ---------------------------------
!include "LogicLib.nsh"
!include "MUI2.nsh"
!include "x64.nsh"

# Settings ---------------------------------
Name "OpenSSL For Windows"
OutFile "openssl-setup.exe"
Unicode true
SetCompressor lzma
RequestExecutionLevel admin
InstallDir "$PROGRAMFILES64\openssl"

# Pages ------------------------------------
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "openssl/LICENSE.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR/README.txt"
!define MUI_FINISHPAGE_LINK "Star the repository on github :)"
!define MUI_FINISHPAGE_LINK_LOCATION "https://github.com/DarthUdp/openssl-win-installer"
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

# Languages --------------------------------
!insertmacro MUI_LANGUAGE "English"

# Sections ---------------------------------
Section
    SetOutPath $INSTDIR\bin
    File /r openssl\*.*
    File /r openssl\engines*
    File /r openssl\include
    File /r openssl\lib
    SetOutPath $INSTDIR
    File openssl\*.txt
    File opensslvars.bat
    WriteUninstaller "$OUTDIR\uninstaller.exe"
    CreateDirectory "$SMPROGRAMS\openssl"
    CreateShortcut "$SMPROGRAMS\openssl\OpenSSL Prompt.lnk" "cmd.exe /k $INSTDIR\opensslvars.bat"
    CreateShortCut "$SMPROGRAMS\openssl\openssl.lnk" $INSTDIR\bin\openssl.exe
SectionEnd

Section "Uninstall"
    Delete "$INSTDIR/uninstall.exe"
    Delete "$SMPROGRAMS\openssl\OpenSSL Prompt.lnk"
    RMDir /r "$SMPROGRAMS\openssl"
    RMDir /r /REBOOTOK "$INSTDIR"
SectionEnd


# Functions --------------------------------
