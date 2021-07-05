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

!define APPNAME "OpenSSL for windows"
!define COMPANYNAME "rzor-io"
!define DESCRIPTION "OpenSSL for windows made easy"
!define VERSIONMAJOR 1
!define VERSIONMINOR 1
!define VERSIONBUILD 1
# These will be displayed by the "Click here for support information" link in "Add/Remove Programs"
# It is possible to use "mailto:" links in here to open the email client
!define HELPURL "https://github.com/DarthUdp/openssl-win-installer/issues" # "Support Information" link
!define UPDATEURL "https://github.com/DarthUdp/openssl-win-installer/releases" # "Product Updates" link
!define ABOUTURL "https://github.com/DarthUdp/openssl-win-installer" # "Publisher" link

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

    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayName" "${APPNAME} - ${DESCRIPTION}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "InstallLocation" "$\"$INSTDIR$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayIcon" "$\"$INSTDIR\logo.ico$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "Publisher" "$\"${COMPANYNAME}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "HelpLink" "$\"${HELPURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "URLUpdateInfo" "$\"${UPDATEURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "URLInfoAbout" "$\"${ABOUTURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayVersion" "$\"${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}$\""
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "VersionMajor" ${VERSIONMAJOR}
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "VersionMinor" ${VERSIONMINOR}
	# There is no option for modifying or repairing the install
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "NoModify" 1
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "NoRepair" 1

    WriteUninstaller "$OUTDIR\uninstall.exe"
    CreateDirectory "$SMPROGRAMS\openssl"
    CreateShortcut "$SMPROGRAMS\openssl\OpenSSL Prompt.lnk" 'cmd.exe /k "$INSTDIR\opensslvars.bat"'
    CreateShortCut "$SMPROGRAMS\openssl\openssl.lnk" $INSTDIR\bin\openssl.exe
SectionEnd

Section "Uninstall"
    Delete "$INSTDIR/uninstall.exe"
    Delete "$SMPROGRAMS\openssl\OpenSSL Prompt.lnk"
    RMDir /r "$SMPROGRAMS\openssl"
    RMDir /r /REBOOTOK "$INSTDIR"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}"
SectionEnd


# Functions --------------------------------
!macro VerifyUserIsAdmin
UserInfo::GetAccountType
pop $0
${If} $0 != "admin" ;Require admin rights on NT4+
        messageBox mb_iconstop "Administrator rights required!"
        setErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
        quit
${EndIf}
!macroend

function .onInit
	setShellVarContext all
	!insertmacro VerifyUserIsAdmin
functionEnd