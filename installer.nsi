# Generated with generator-nsis
# https://github.com/idleberg/generator-nsis

# Includes ---------------------------------
!include "LogicLib.nsh"
!include "MUI2.nsh"
!include "x64.nsh"

# Settings ---------------------------------
Name "curl-openssl-windows"
OutFile "curl-openssl-setup.exe"
Unicode true
SetCompressor lzma
RequestExecutionLevel admin
InstallDir "$PROGRAMFILES64\curl-openssl"

# Pages ------------------------------------
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "openssl/LICENSE.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR/openssl/README.txt"
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

# Languages --------------------------------
!insertmacro MUI_LANGUAGE "English"

# Sections ---------------------------------
Section
    SetOutPath $INSTDIR
    File /r openssl
    WriteUninstaller "$OUTDIR\uninstaller.exe"
SectionEnd

Section "Uninstall"
    Delete "$INSTDIR/uninstall.exe"
    RMDir /r /REBOOTOK "$INSTDIR"
SectionEnd


# Functions --------------------------------
