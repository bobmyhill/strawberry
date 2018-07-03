!define PRODUCT_NAME "Strawberry"
!define PRODUCT_PUBLISHER "Strawberry"
!define PRODUCT_VERSION_MAJOR 0
!define PRODUCT_VERSION_MINOR 1
!define PRODUCT_DISPLAY_VERSION "0.1.7"
!define PRODUCT_DISPLAY_VERSION_SHORT "0.1.7"
!define PRODUCT_WEB_SITE "http://www.strawbs.org/"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_INSTALL_DIR "$PROGRAMFILES\Strawberry Music Player"

; Set Application Capabilities info
!define CAPABILITIES_NAME "Strawberry Music Player"
!define CAPABILITIES_LOCAL_NAME "Strawberry"
!define CAPABILITIES_PROGID "Strawberry Music Player"
!define CAPABILITIES_PATH "Software\Clients\Media\Strawberry"
!define CAPABILITIES_DESCRIPTION "Strawberry Music Player"
!define CAPABILITIES_ICON "$INSTDIR\strawberry.ico"
!define CAPABILITIES_REINSTALL "Command to reinstall"
!define CAPABILITIES_HIDE_ICONS "Command to hide icons"
!define CAPABILITIES_SHOW_ICONS "Command to show icons"

SetCompressor /SOLID lzma
!addplugindir nsisplugins
!include "MUI2.nsh"
!include "FileAssociation.nsh"
!include "Capabilities.nsh"

!define MUI_ICON "strawberry.ico"

!define MUI_COMPONENTSPAGE_SMALLDESC
;!define MUI_FINISHPAGE_RUN
;!define MUI_FINISHPAGE_RUN_TEXT "Run Strawberry"
;!define MUI_FINISHPAGE_RUN_FUNCTION "RunStrawberry"

; Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES  
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English" ;first language is the default language

Name "${PRODUCT_NAME}"
OutFile "${PRODUCT_NAME}Setup-0.1.7.exe"
InstallDir "${PRODUCT_INSTALL_DIR}"

; Get the path where Strawberry was installed previously and set it as default path
InstallDirRegKey ${PRODUCT_UNINST_ROOT_KEY} ${PRODUCT_UNINST_KEY} "UninstallString"

ShowInstDetails show
ShowUnInstDetails show
RequestExecutionLevel admin
;RequestExecutionLevel user

; Check for previous installation, and call the uninstaller if any
Function CheckPreviousInstall

  ReadRegStr $R0 ${PRODUCT_UNINST_ROOT_KEY} ${PRODUCT_UNINST_KEY} "UninstallString"
  StrCmp $R0 "" done

  MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
  "${PRODUCT_NAME} is already installed. $\n$\nClick `OK` to remove the \
  previous version or `Cancel` to cancel this upgrade." \
  IDOK uninst
  Abort
; Run the uninstaller
uninst:
  ClearErrors
  ExecWait '$R0' ; Do not copy the uninstaller to a temp file

done:

FunctionEnd

Function .onInit

  !insertmacro MUI_LANGDLL_DISPLAY

  Call CheckPreviousInstall

FunctionEnd

;!define LVM_GETITEMCOUNT 0x1004
!define LVM_GETITEMTEXT 0x102D
 
Function DumpLog
  Exch $5
  Push $0
  Push $1
  Push $2
  Push $3
  Push $4
  Push $6
 
  FindWindow $0 "#32770" "" $HWNDPARENT
  GetDlgItem $0 $0 1016
  StrCmp $0 0 exit
  FileOpen $5 $5 "w"
  StrCmp $5 "" exit
    SendMessage $0 ${LVM_GETITEMCOUNT} 0 0 $6
    System::Alloc ${NSIS_MAX_STRLEN}
    Pop $3
    StrCpy $2 0
    System::Call "*(i, i, i, i, i, i, i, i, i) i \
      (0, 0, 0, 0, 0, r3, ${NSIS_MAX_STRLEN}) .r1"
    loop: StrCmp $2 $6 done
      System::Call "User32::SendMessageA(i, i, i, i) i \
        ($0, ${LVM_GETITEMTEXT}, $2, r1)"
      System::Call "*$3(&t${NSIS_MAX_STRLEN} .r4)"
      FileWrite $5 "$4$\r$\n"
      IntOp $2 $2 + 1
      Goto loop
    done:
      FileClose $5
      System::Free $1
      System::Free $3
  exit:
    Pop $6
    Pop $4
    Pop $3
    Pop $2
    Pop $1
    Pop $0
    Exch $5
FunctionEnd

;Function RunStrawberry
  ;ShellExecAsUser::ShellExecAsUser "" "$INSTDIR/strawberry.exe" ""
;FunctionEnd

Section "Delete old files" oldfiles
SectionEnd

Section "Strawberry" Strawberry
  SetOutPath "$INSTDIR"

  File "strawberry.exe"
  File "strawberry-tagreader.exe"
  File "strawberry.ico"

  File "libbz2.dll"
  File "libcdio-16.dll"
  File "libchromaprint.dll"
  File "libcrypto-1_1.dll"
  File "libfaad-2.dll"
  File "libffi-6.dll"
  File "libFLAC-8.dll"
  File "libfreetype-6.dll"
  File "libgcc_s_sjlj-1.dll"
  File "libgio-2.0-0.dll"
  File "libglib-2.0-0.dll"
  File "libgmodule-2.0-0.dll"
  File "libgobject-2.0-0.dll"
  File "libgstapp-1.0-0.dll"
  File "libgstaudio-1.0-0.dll"
  File "libgstbase-1.0-0.dll"
  File "libgstfft-1.0-0.dll"
  File "libgstpbutils-1.0-0.dll"
  File "libgstreamer-1.0-0.dll"
  File "libgstriff-1.0-0.dll"
  File "libgstrtp-1.0-0.dll"
  File "libgstrtsp-1.0-0.dll"
  File "libgstsdp-1.0-0.dll"
  File "libgsttag-1.0-0.dll"
  File "libgstvideo-1.0-0.dll"
  File "libharfbuzz-0.dll"
  File "libiconv-2.dll"
  File "libintl-8.dll"
  File "libjpeg-9.dll"
  File "liblastfm5.dll"
  File "libmp3lame-0.dll"
  File "libogg-0.dll"
  File "libopus-0.dll"
  File "libpcre-1.dll"
  File "libpcre2-16-0.dll"
  File "libpng16-16.dll"
  File "libprotobuf-15.dll"
  File "libspeex-1.dll"
  File "libsqlite3-0.dll"
  File "libssl-1_1.dll"
  File "libstdc++-6.dll"
  File "libtag.dll"
  File "libvorbis-0.dll"
  File "libvorbisenc-2.dll"
  File "libwavpack-1.dll"
  File "libwinpthread-1.dll"
  File "Qt5Concurrent.dll"
  File "Qt5Core.dll"
  File "Qt5Gui.dll"
  File "Qt5Network.dll"
  File "Qt5Sql.dll"
  File "Qt5Widgets.dll"
  File "Qt5Xml.dll"
  File "zlib1.dll"
  File "libxine-2.dll"
  File "libmpcdec-5.dll"
  File "libtheora-0.dll"
  File "libfftw3-3.dll"

  ; Register Strawberry with Default Programs
  Var /GLOBAL AppIcon
  Var /GLOBAL AppExe
  StrCpy $AppExe "$INSTDIR\strawberry.exe"
  StrCpy $AppIcon "$INSTDIR\strawberry.ico"

  ${RegisterCapabilities}

  ${RegisterMediaType} ".mp3" $AppExe $AppIcon "MP3 Audio File"
  ${RegisterMediaType} ".flac" $AppExe $AppIcon "FLAC Audio File"
  ${RegisterMediaType} ".ogg" $AppExe $AppIcon "OGG Audio File"
  ${RegisterMediaType} ".spx" $AppExe $AppIcon "OGG Speex Audio File"
  ${RegisterMediaType} ".m4a" $AppExe $AppIcon "MP4 Audio File"
  ${RegisterMediaType} ".aac" $AppExe $AppIcon "AAC Audio File"
  ${RegisterMediaType} ".wma" $AppExe $AppIcon "WMA Audio File"
  ${RegisterMediaType} ".wav" $AppExe $AppIcon "WAV Audio File"

  ${RegisterMediaType} ".pls" $AppExe $AppIcon "PLS Audio File"
  ${RegisterMediaType} ".m3u" $AppExe $AppIcon "M3U Audio File"
  ${RegisterMediaType} ".xspf" $AppExe $AppIcon "XSPF Audio File"
  ${RegisterMediaType} ".asx" $AppExe $AppIcon "Windows Media Audio/Video playlist"

  ${RegisterMimeType} "audio/mp3" "mp3" "{cd3afa76-b84f-48f0-9393-7edc34128127}"
  ${RegisterMimeType} "audio/mp4" "m4a" "{cd3afa7c-b84f-48f0-9393-7edc34128127}"
  ${RegisterMimeType} "audio/x-ms-wma" "wma" "{cd3afa84-b84f-48f0-9393-7edc34128127}"
  ${RegisterMimeType} "audio/wav" "wav" "{cd3afa7b-b84f-48f0-9393-7edc34128127}"

  ${RegisterMimeType} "audio/mpegurl" "m3u" "{cd3afa78-b84f-48f0-9393-7edc34128127}"
  ${RegisterMimeType} "application/x-wmplayer" "asx" "{cd3afa96-b84f-48f0-9393-7edc34128127}"
  
  StrCpy $0 "$EXEDIR\install.log"
  Push $0
  Call DumpLog

SectionEnd

Section "Qt Platforms" platforms
  SetOutPath "$INSTDIR\platforms"
  File "/oname=qwindows.dll" "platforms\qwindows.dll"
  
  StrCpy $0 "$EXEDIR\install.log"
  Push $0
  Call DumpLog
  
SectionEnd

Section "Qt SQL Drivers" sqldrivers
  SetOutPath "$INSTDIR\sqldrivers"
  File "/oname=qsqlite.dll" "sqldrivers\qsqlite.dll"
  
  StrCpy $0 "$EXEDIR\install.log"
  Push $0
  Call DumpLog
  
SectionEnd

Section "Qt image format plugins" imageformats
  SetOutPath "$INSTDIR\imageformats"
  File "/oname=qgif.dll" "imageformats\qgif.dll"
  File "/oname=qico.dll" "imageformats\qico.dll"
  File "/oname=qjpeg.dll" "imageformats\qjpeg.dll"
  
  StrCpy $0 "$EXEDIR\install.log"
  Push $0
  Call DumpLog
  
SectionEnd

Section "Gstreamer plugins" gstreamer-plugins
  SetOutPath "$INSTDIR\gstreamer-plugins"

  File "/oname=libgstapetag.dll" "gstreamer-plugins\libgstapetag.dll"
  File "/oname=libgstapp.dll" "gstreamer-plugins\libgstapp.dll"
  File "/oname=libgstasf.dll" "gstreamer-plugins\libgstasf.dll"
  File "/oname=libgstaiff.dll" "gstreamer-plugins\libgstaiff.dll"
  File "/oname=libgstaudioconvert.dll" "gstreamer-plugins\libgstaudioconvert.dll"
  File "/oname=libgstaudiofx.dll" "gstreamer-plugins\libgstaudiofx.dll"
  File "/oname=libgstaudioparsers.dll" "gstreamer-plugins\libgstaudioparsers.dll"
  File "/oname=libgstaudioresample.dll" "gstreamer-plugins\libgstaudioresample.dll"
  File "/oname=libgstaudiotestsrc.dll" "gstreamer-plugins\libgstaudiotestsrc.dll"
  File "/oname=libgstautodetect.dll" "gstreamer-plugins\libgstautodetect.dll"
  File "/oname=libgstcoreelements.dll" "gstreamer-plugins\libgstcoreelements.dll"
  File "/oname=libgstdirectsound.dll" "gstreamer-plugins\libgstdirectsound.dll"
  File "/oname=libgstequalizer.dll" "gstreamer-plugins\libgstequalizer.dll"
  File "/oname=libgstfaad.dll" "gstreamer-plugins\libgstfaad.dll"
  File "/oname=libgstflac.dll" "gstreamer-plugins\libgstflac.dll"
  File "/oname=libgstgio.dll" "gstreamer-plugins\libgstgio.dll"
  File "/oname=libgsticydemux.dll" "gstreamer-plugins\libgsticydemux.dll"
  File "/oname=libgstid3demux.dll" "gstreamer-plugins\libgstid3demux.dll"
  File "/oname=libgstisomp4.dll" "gstreamer-plugins\libgstisomp4.dll"
  File "/oname=libgstlame.dll" "gstreamer-plugins\libgstlame.dll"
  File "/oname=libgstogg.dll" "gstreamer-plugins\libgstogg.dll"
  File "/oname=libgstopusparse.dll" "gstreamer-plugins\libgstopusparse.dll"
  File "/oname=libgstplayback.dll" "gstreamer-plugins\libgstplayback.dll"
  File "/oname=libgstreplaygain.dll" "gstreamer-plugins\libgstreplaygain.dll"
  File "/oname=libgstspectrum.dll" "gstreamer-plugins\libgstspectrum.dll"
  File "/oname=libgstspeex.dll" "gstreamer-plugins\libgstspeex.dll"
  File "/oname=libgsttaglib.dll" "gstreamer-plugins\libgsttaglib.dll"
  File "/oname=libgsttypefindfunctions.dll" "gstreamer-plugins\libgsttypefindfunctions.dll"
  File "/oname=libgstvolume.dll" "gstreamer-plugins\libgstvolume.dll"
  File "/oname=libgstvorbis.dll" "gstreamer-plugins\libgstvorbis.dll"
  File "/oname=libgstwavpack.dll" "gstreamer-plugins\libgstwavpack.dll"
  File "/oname=libgstwavparse.dll" "gstreamer-plugins\libgstwavparse.dll"
  
  StrCpy $0 "$EXEDIR\install.log"
  Push $0
  Call DumpLog

SectionEnd

Section "Xine plugins" xine-plugins
  SetOutPath "$INSTDIR\xine-plugins"
  File "/oname=xineplug_ao_out_directx2.dll" "xine-plugins\xineplug_ao_out_directx2.dll"
  File "/oname=xineplug_ao_out_directx.dll" "xine-plugins\xineplug_ao_out_directx.dll"
  File "/oname=xineplug_decode_dts.dll" "xine-plugins\xineplug_decode_dts.dll"
  File "/oname=xineplug_decode_dvaudio.dll" "xine-plugins\xineplug_decode_dvaudio.dll"
  File "/oname=xineplug_decode_faad.dll" "xine-plugins\xineplug_decode_faad.dll"
  File "/oname=xineplug_decode_gsm610.dll" "xine-plugins\xineplug_decode_gsm610.dll"
  File "/oname=xineplug_decode_lpcm.dll" "xine-plugins\xineplug_decode_lpcm.dll"
  File "/oname=xineplug_decode_mad.dll" "xine-plugins\xineplug_decode_mad.dll"
  File "/oname=xineplug_decode_mpc.dll" "xine-plugins\xineplug_decode_mpc.dll"
  File "/oname=xineplug_decode_mpeg2.dll" "xine-plugins\xineplug_decode_mpeg2.dll"
  File "/oname=xineplug_dmx_asf.dll" "xine-plugins\xineplug_dmx_asf.dll"
  File "/oname=xineplug_dmx_audio.dll" "xine-plugins\xineplug_dmx_audio.dll"
  File "/oname=xineplug_dmx_playlist.dll" "xine-plugins\xineplug_dmx_playlist.dll"
  File "/oname=xineplug_dmx_slave.dll" "xine-plugins\xineplug_dmx_slave.dll"
  File "/oname=xineplug_flac.dll" "xine-plugins\xineplug_flac.dll"
  File "/oname=xineplug_wavpack.dll" "xine-plugins\xineplug_wavpack.dll"
  File "/oname=xineplug_xiph.dll" "xine-plugins\xineplug_xiph.dll"

  StrCpy $0 "$EXEDIR\install.log"
  Push $0
  Call DumpLog
  
SectionEnd

Section "Xine plugins post" xine-plugins-post
  SetOutPath "$INSTDIR\xine-plugins\post"
  File "/oname=xineplug_post_audio_filters.dll" "xine-plugins\post\xineplug_post_audio_filters.dll"
  File "/oname=xineplug_post_goom.dll" "xine-plugins\post\xineplug_post_goom.dll"
  File "/oname=xineplug_post_mosaico.dll" "xine-plugins\post\xineplug_post_mosaico.dll"
  File "/oname=xineplug_post_planar.dll" "xine-plugins\post\xineplug_post_planar.dll"
  File "/oname=xineplug_post_switch.dll" "xine-plugins\post\xineplug_post_switch.dll"
  File "/oname=xineplug_post_tvtime.dll" "xine-plugins\post\xineplug_post_tvtime.dll"
  File "/oname=xineplug_post_visualizations.dll" "xine-plugins\post\xineplug_post_visualizations.dll"

  StrCpy $0 "$EXEDIR\install.log"
  Push $0
  Call DumpLog
  
SectionEnd

Section "Start menu items" startmenu
  ; Create Start Menu folders and shortcuts.
  SetShellVarContext all

  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\strawberry.exe"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
  
  StrCpy $0 "$EXEDIR\install.log"
  Push $0
  Call DumpLog
  
SectionEnd

Section "Uninstaller"
  ; Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\strawberry.ico"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_DISPLAY_VERSION}"
  WriteRegDWORD ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "VersionMajor" "${PRODUCT_VERSION_MAJOR}"
  WriteRegDWORD ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "VersionMinor" "${PRODUCT_VERSION_MINOR}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"

  StrCpy $0 "$EXEDIR\install.log"
  Push $0
  Call DumpLog
  
SectionEnd

Section "Uninstall"
  ; Kill strawberry.exe if it's running
  ; This calling convention is retarded...
  ;StrCpy $0 "strawberry.exe"
  ;KillProc::FindProcesses
  ;StrCmp $1 "-1" wooops

  ;StrCmp $0 "0" completed
  
  ;DetailPrint "Killing running strawberry.exe..."

  ;StrCpy $0 "strawberry.exe"
  ;KillProc::KillProcesses
  ;StrCmp $1 "-1" wooops

  ;Sleep 2000
  ;Goto completed

  ;wooops:
  ;DetailPrint "-> Error: Something went wrong while killing running strawberry.exe"
  ;Abort

  ;completed:

  ; Delete all the files
  
  ;Delete "$EXEDIR\install.log"
  
  Delete "$INSTDIR\strawberry.ico"
  Delete "$INSTDIR\strawberry.exe"
  Delete "$INSTDIR\strawberry-tagreader.exe"

  Delete "$INSTDIR\libbz2.dll"
  Delete "$INSTDIR\libcdio-16.dll"
  Delete "$INSTDIR\libchromaprint.dll"
  Delete "$INSTDIR\libcrypto-1_1.dll"
  Delete "$INSTDIR\libfaad-2.dll"
  Delete "$INSTDIR\libffi-6.dll"
  Delete "$INSTDIR\libFLAC-8.dll"
  Delete "$INSTDIR\libfreetype-6.dll"
  Delete "$INSTDIR\libgcc_s_sjlj-1.dll"
  Delete "$INSTDIR\libgio-2.0-0.dll"
  Delete "$INSTDIR\libglib-2.0-0.dll"
  Delete "$INSTDIR\libgmodule-2.0-0.dll"
  Delete "$INSTDIR\libgobject-2.0-0.dll"
  Delete "$INSTDIR\libgstapp-1.0-0.dll"
  Delete "$INSTDIR\libgstaudio-1.0-0.dll"
  Delete "$INSTDIR\libgstbase-1.0-0.dll"
  Delete "$INSTDIR\libgstfft-1.0-0.dll"
  Delete "$INSTDIR\libgstpbutils-1.0-0.dll"
  Delete "$INSTDIR\libgstreamer-1.0-0.dll"
  Delete "$INSTDIR\libgstriff-1.0-0.dll"
  Delete "$INSTDIR\libgstrtp-1.0-0.dll"
  Delete "$INSTDIR\libgstrtsp-1.0-0.dll"
  Delete "$INSTDIR\libgstsdp-1.0-0.dll"
  Delete "$INSTDIR\libgsttag-1.0-0.dll"
  Delete "$INSTDIR\libgstvideo-1.0-0.dll"
  Delete "$INSTDIR\libharfbuzz-0.dll"
  Delete "$INSTDIR\libiconv-2.dll"
  Delete "$INSTDIR\libintl-8.dll"
  Delete "$INSTDIR\libjpeg-9.dll"
  Delete "$INSTDIR\liblastfm5.dll"
  Delete "$INSTDIR\libmp3lame-0.dll"
  Delete "$INSTDIR\libogg-0.dll"
  Delete "$INSTDIR\libopus-0.dll"
  Delete "$INSTDIR\libpcre-1.dll"
  Delete "$INSTDIR\libpcre2-16-0.dll"
  Delete "$INSTDIR\libpng16-16.dll"
  Delete "$INSTDIR\libprotobuf-15.dll"
  Delete "$INSTDIR\libspeex-1.dll"
  Delete "$INSTDIR\libsqlite3-0.dll"
  Delete "$INSTDIR\libssl-1_1.dll"
  Delete "$INSTDIR\libstdc++-6.dll"
  Delete "$INSTDIR\libtag.dll"
  Delete "$INSTDIR\libvorbis-0.dll"
  Delete "$INSTDIR\libvorbisenc-2.dll"
  Delete "$INSTDIR\libwavpack-1.dll"
  Delete "$INSTDIR\libwinpthread-1.dll"
  Delete "$INSTDIR\Qt5Concurrent.dll"
  Delete "$INSTDIR\Qt5Core.dll"
  Delete "$INSTDIR\Qt5Gui.dll"
  Delete "$INSTDIR\Qt5Network.dll"
  Delete "$INSTDIR\Qt5Sql.dll"
  Delete "$INSTDIR\Qt5Widgets.dll"
  Delete "$INSTDIR\Qt5Xml.dll"
  Delete "$INSTDIR\zlib1.dll"
  Delete "$INSTDIR\libxine-2.dll"
  Delete "$INSTDIR\libmpcdec-5.dll"
  Delete "$INSTDIR\libtheora-0.dll"
  Delete "$INSTDIR\libfftw3-3.dll"

  Delete "$INSTDIR\platforms\qwindows.dll"
  Delete "$INSTDIR\sqldrivers\qsqlite.dll"

  Delete "$INSTDIR\imageformats\qgif.dll"
  Delete "$INSTDIR\imageformats\qico.dll"
  Delete "$INSTDIR\imageformats\qjpeg.dll"

  Delete "$INSTDIR\gstreamer-plugins\libgstapetag.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstapp.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstasf.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstaiff.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstaudioconvert.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstaudiofx.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstaudioparsers.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstaudioresample.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstaudiotestsrc.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstautodetect.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstcoreelements.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstdirectsound.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstequalizer.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstfaad.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstflac.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstgio.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgsticydemux.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstid3demux.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstisomp4.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstlame.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstogg.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstopusparse.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstplayback.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstreplaygain.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstspectrum.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstspeex.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgsttaglib.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgsttypefindfunctions.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstvolume.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstvorbis.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstwavpack.dll"
  Delete "$INSTDIR\gstreamer-plugins\libgstwavparse.dll"

  Delete "$INSTDIR\xine-plugins\xineplug_ao_out_directx2.dll"
  Delete "$INSTDIR\xine-plugins\xineplug_ao_out_directx.dll"
  Delete "$INSTDIR\xine-plugins\xineplug_decode_dts.dll"
  Delete "$INSTDIR\xine-plugins\xineplug_decode_dvaudio.dll"
  Delete "$INSTDIR\xine-plugins\xineplug_decode_faad.dll"
  Delete "$INSTDIR\xine-plugins\xineplug_decode_gsm610.dll"
  Delete "$INSTDIR\xine-plugins\xineplug_decode_lpcm.dll"
  Delete "$INSTDIR\xine-plugins\xineplug_decode_mad.dll"
  Delete "$INSTDIR\xine-plugins\xineplug_decode_mpc.dll"
  Delete "$INSTDIR\xine-plugins\xineplug_decode_mpeg2.dll"
  Delete "$INSTDIR\xine-plugins\xineplug_dmx_asf.dll"
  Delete "$INSTDIR\xine-plugins\xineplug_dmx_audio.dll"
  Delete "$INSTDIR\xine-plugins\xineplug_dmx_playlist.dll"
  Delete "$INSTDIR\xine-plugins\xineplug_dmx_slave.dll"
  Delete "$INSTDIR\xine-plugins\xineplug_flac.dll"
  Delete "$INSTDIR\xine-plugins\xineplug_wavpack.dll"
  Delete "$INSTDIR\xine-plugins\xineplug_xiph.dll"

  Delete "$INSTDIR\xine-plugins\post\xineplug_post_audio_filters.dll"
  Delete "$INSTDIR\xine-plugins\post\xineplug_post_goom.dll"
  Delete "$INSTDIR\xine-plugins\post\xineplug_post_mosaico.dll"
  Delete "$INSTDIR\xine-plugins\post\xineplug_post_planar.dll"
  Delete "$INSTDIR\xine-plugins\post\xineplug_post_switch.dll"
  Delete "$INSTDIR\xine-plugins\post\xineplug_post_tvtime.dll"
  Delete "$INSTDIR\xine-plugins\post\xineplug_post_visualizations.dll"

  Delete "$INSTDIR\Uninstall.exe"

  ; Remove the installation folders.
  RMDir "$INSTDIR\platforms"
  RMDir "$INSTDIR\sqldrivers"
  RMDir "$INSTDIR\imageformats"
  RMDir "$INSTDIR\gstreamer-plugins"
  RMDir "$INSTDIR\xine-plugins\post"
  RMDir "$INSTDIR\xine-plugins"
  RMDir "$INSTDIR"

  ; Remove the Shortcuts
  SetShellVarContext all

  Delete "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk"
  RMDir /r "$SMPROGRAMS\${PRODUCT_NAME}"

  ; Remove the entry from 'installed programs list'
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"

  ; Unregister from Default Programs
  ${UnRegisterCapabilities}

SectionEnd
