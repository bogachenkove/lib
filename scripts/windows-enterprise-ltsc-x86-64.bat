@echo off
title Windows 10 Enterprise LTSC

::  Windows 10 Enterprise LTSC build 19044.5608 x86_64
::  Author: Bogachenko Vyacheslav <bogachenkove@gmail.com>
::  License: MIT license <https://raw.githubusercontent.com/bogachenko/lib/master/LICENSE.md>
::  Last update: March 2026

echo NETWORK INFORMATION RETRIEVAL.
timeout /t "1" /nobreak >nul
echo Running a script to get information about the network in the operating system.
ping -n 1 "1.1.1.1" >nul 2>&1
if errorlevel 1 (
    echo No internet connection detected. Exiting script.
    timeout /t "1" /nobreak >nul
    exit /b
) else (
    echo Internet connection detected. Proceeding with the script.
)
timeout /t "1" /nobreak >nul

echo SUPERUSER RIGHTS RETRIEVAL.
timeout /t "1" /nobreak >nul
echo Running a script to obtain superuser rights in the operating system.
setlocal enabledelayedexpansion
set "params=%*"
cd /d "%~dp0"
if exist "%temp%\getadmin.vbs" (
    del "%temp%\getadmin.vbs"
)
fsutil dirty query %systemdrive% 1>nul 2>nul
if errorlevel 1 (
    (
        echo Set UAC = CreateObject^("Shell.Application"^)
        echo UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 !params!", "", "runas", 1
    ) >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /b
)
set "url=https://github.com/M2Team/NanaRun/releases/download/1.0.18.0/NanaRun_1.0_Preview2_1.0.18.0.zip"
set "zipFile=%temp%\NanaRun_1.0_Preview2_1.0.18.0.zip"
set "destFolder=%temp%\NanaRun"
set "sudo="%temp%\NanaRun\x64\MinSudo.exe --TrustedInstaller""
if exist "%destFolder%" (
    rmdir /s /q "%destFolder%"
    mkdir "%destFolder%"
)
powershell -Command "Invoke-WebRequest -Uri '%url%' -OutFile '%zipFile%'"
powershell -Command "Expand-Archive -Path '%zipFile%' -DestinationPath '%destFolder%'"
timeout /t "1" /nobreak >nul

echo STOPPING THE WINDOWS EXPLORER PROCESS.
timeout /t "1" /nobreak >nul
echo Running a script to stop the process The Windows Explorer in the operating system.
tasklist /fi "imagename eq explorer.exe" 2>nul | find /i "explorer.exe" && (
    taskkill /f /im explorer.exe
) || (
    echo The Windows Explorer process was not found.
)
timeout /t "1" /nobreak >nul

echo RENAME THE COMPUTER.
timeout /t "1" /nobreak >nul
echo Running a script to edit the computer name in the operating system.
set /p newName="Enter a new computer name: "
wmic computersystem where caption='%computername%' rename "%newName%" >nul 2>&1
timeout /t "1" /nobreak >nul

echo DISABLING SYSTEM RESTORE PROTECTION.
timeout /t "1" /nobreak >nul
echo Running a script to disable the protection of the computer's disk in the operating system.
for %%S in (
    "DisableSR"
    "DisableConfig"
) do reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v %%~S /t REG_DWORD /d "1" /f
timeout /t "1" /nobreak >nul

echo CHECKING THE SETTINGS FOR THE LIST OF SERVICES IN WINDOWS OS.
timeout /t "1" /nobreak >nul
echo Running a script to disable Data Usage Service.
reg add "HKLM\System\CurrentControlSet\Services\DusmSvc" /v "Start" /t REG_DWORD /d "4" /f
echo Running a script to disable SSDP Discovery Service.
reg add "HKLM\System\CurrentControlSet\Services\SSDPSRV" /v "Start" /t REG_DWORD /d "4" /f
echo Running a script to disable Geolocation Service.
reg add "HKLM\System\CurrentControlSet\Services\lfsvc" /v "Start" /t REG_DWORD /d "4" /f
echo Running a script to disable Downloaded Maps Manager Service.
reg add "HKLM\System\CurrentControlSet\Services\MapsBroker" /v "Start" /t REG_DWORD /d "4" /f
echo Running a script to disable Delivery Optimization Service.
reg add "HKLM\System\CurrentControlSet\Services\DoSvc" /v "Start" /t REG_DWORD /d "4" /f
echo Running a script to disable Broadcast DVR User Service.
reg add "HKLM\System\CurrentControlSet\Services\BcastDVRUserService" /v "Start" /t REG_DWORD /d "4" /f
echo Running a script to disable Windows Biometric Service.
reg add "HKLM\System\CurrentControlSet\Services\WbioSrvc" /v "Start" /t REG_DWORD /d "4" /f
echo Running a script to disable Windows Insider Service.
reg add "HKLM\System\CurrentControlSet\Services\wisvc" /v "Start" /t REG_DWORD /d "4" /f
echo Running a script to disable Store Demonstration Service.
reg add "HKLM\System\CurrentControlSet\Services\RetailDemo" /v "Start" /t REG_DWORD /d "4" /f
echo Running a script to disable Windows Search Service.
reg add "HKLM\System\CurrentControlSet\Services\WSearch" /v "Start" /t REG_DWORD /d "4" /f
echo Running a script to disable Windows Defender Service.
for %%S in (
    "SecurityHealthService"
    "wscsvc"
    "WinDefend"
    "WdNisSvc"
    "WdNisDrv"
    "Sense"
    "WdFilter"
    "WdBoot"
    "MsSecFlt"
    "SgrmBroker"
    "SgrmAgent"
) do (
    "%sudo%" reg add "HKLM\System\CurrentControlSet\Services\%%~S" /v "Start" /t REG_DWORD /d "4" /f
    "%sudo%" sc stop "%%~S"
    "%sudo%" sc config "%%~S" start= disabled
)
echo Running a script to disable Diagnostics Tracking Service.
for %%S in (
    "DiagTrack"
    "diagsvc"
    "dmwappushservice"
    "diagnosticshub.standardcollector.service"
) do (
    "%sudo%" reg add "HKLM\System\CurrentControlSet\Services\%%~S" /v "Start" /t REG_DWORD /d "4" /f
    "%sudo%" sc stop "%%~S"
    "%sudo%" sc config "%%~S" start= disabled
)
echo Running a script to disable Xbox Services.
for %%S in (
    "XblAuthManager"
    "XblGameSave"
    "XboxGipSvc"
    "XboxNetApiSvc"
) do reg add "HKLM\System\CurrentControlSet\Services\%%~S" /v "Start" /t REG_DWORD /d "4" /f
echo Running a script to disable Windows Error Logging Services.
for %%S in (
    "WerSvc"
    "wercplsupport"
    "WpnService"
) do (
    "%sudo%" reg add "HKLM\System\CurrentControlSet\Services\%%~S" /v "Start" /t REG_DWORD /d "4" /f
    "%sudo%" sc stop "%%~S"
    "%sudo%" sc config "%%~S" start= disabled
)
echo Running a script to disable Smart Card.
for %%S in (
    "SCardSvr"
    "CertPropSvc"
) do reg add "HKLM\System\CurrentControlSet\Services\%%~S" /v "Start" /t REG_DWORD /d "4" /f
timeout /t "1" /nobreak >nul

echo CHECKING THE SETTINGS FOR THE LIST IN WINDOWS TASK SCHEDULER.
timeout /t "1" /nobreak >nul
echo Running a script to disable Windows Defender in the Task Scheduler.
setlocal enabledelayedexpansion
for %%T in (
    "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance"
    "Microsoft\Windows\Windows Defender\Windows Defender Cleanup"
    "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan"
    "Microsoft\Windows\Windows Defender\Windows Defender Verification"
    "Microsoft\Windows\ExploitGuard\ExploitGuard MDM policy Refresh"
) do (
    schtasks /query /tn "%%~T" >nul 2>&1
    if !errorlevel! equ 0 (
        schtasks /query /tn "%%~T" /fo LIST /v | findstr /i "Disabled" >nul 2>&1
        if !errorlevel! equ 0 (
            echo Task %%~T is already disabled.
        ) else (
            echo Disabling task: %%~T
            schtasks /change /tn "%%~T" /disable
            if !errorlevel! equ 0 (
                echo Task %%~T successfully disabled.
            ) else (
                echo Failed to disable task %%~T.
            )
        )
    ) else (
        echo Task %%~T not found.
    )
)
endlocal
timeout /t "1" /nobreak >nul
echo Running a script to disable diagnostics in the Task Scheduler.
setlocal enabledelayedexpansion
for %%T in (
    "Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"
    "Microsoft\Windows\Diagnosis\RecommendedTroubleshootingScanner"
    "Microsoft\Windows\Diagnosis\Scheduled"
    "Microsoft\Windows\Shell\IndexerAutomaticMaintenance"
    "Microsoft\Windows\WDI\ResolutionHost"
    "Microsoft\Windows\Flighting\OneSettings\RefreshCache"
    "Microsoft\Windows\Maintenance\WinSAT"
    "Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic"
) do (
    schtasks /query /tn "%%~T" >nul 2>&1
    if !errorlevel! equ 0 (
        schtasks /query /tn "%%~T" /fo LIST /v | findstr /i "Disabled" >nul 2>&1
        if !errorlevel! equ 0 (
            echo Task %%~T is already disabled.
        ) else (
            echo Disabling task: %%~T
            schtasks /change /tn "%%~T" /disable
            if !errorlevel! equ 0 (
                echo Task %%~T successfully disabled.
            ) else (
                echo Failed to disable task %%~T.
            )
        )
    ) else (
        echo Task %%~T not found.
    )
)
endlocal
timeout /t "1" /nobreak >nul
echo Running a script to disable Customer Experience Improvement in the Task Scheduler.
setlocal enabledelayedexpansion
for %%T in (
    "Microsoft\Windows\Autochk\Proxy"
    "Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
    "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"
    "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
    "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
    "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver"
    "Microsoft\Windows\PI\Sqm-Tasks"
) do (
    schtasks /query /tn "%%~T" >nul 2>&1
    if !errorlevel! equ 0 (
        schtasks /query /tn "%%~T" /fo LIST /v | findstr /i "Disabled" >nul 2>&1
        if !errorlevel! equ 0 (
            echo Task %%~T is already disabled.
        ) else (
            echo Disabling task: %%~T
            schtasks /change /tn "%%~T" /disable
            if !errorlevel! equ 0 (
                echo Task %%~T successfully disabled.
            ) else (
                echo Failed to disable task %%~T.
            )
        )
    ) else (
        echo Task %%~T not found.
    )
)
endlocal
timeout /t "1" /nobreak >nul
echo Running a script to disable telemetry in the Task Scheduler.
setlocal enabledelayedexpansion
for %%T in (
    "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
    "Microsoft\Windows\Application Experience\ProgramDataUpdater"
    "Microsoft\Windows\Application Experience\StartupAppTask"
    "Microsoft\Windows\UNP\RunUpdateNotificationMgr"
) do (
    schtasks /query /tn "%%~T" >nul 2>&1
    if !errorlevel! equ 0 (
        schtasks /query /tn "%%~T" /fo LIST /v | findstr /i "Disabled" >nul 2>&1
        if !errorlevel! equ 0 (
            echo Task %%~T is already disabled.
        ) else (
            echo Disabling task: %%~T
            schtasks /change /tn "%%~T" /disable
            if !errorlevel! equ 0 (
                echo Task %%~T successfully disabled.
            ) else (
                echo Failed to disable task %%~T.
            )
        )
    ) else (
        echo Task %%~T not found.
    )
)
endlocal
timeout /t "1" /nobreak >nul
echo Running a script to disable the creation of digital fingerprints of the disk in the Task Scheduler.
setlocal enabledelayedexpansion
for %%T in (
    "Microsoft\Windows\DiskFootprint\Diagnostics"
    "Microsoft\Windows\DiskFootprint\StorageSense"
) do (
    schtasks /query /tn "%%~T" >nul 2>&1
    if !errorlevel! equ 0 (
        schtasks /query /tn "%%~T" /fo LIST /v | findstr /i "Disabled" >nul 2>&1
        if !errorlevel! equ 0 (
            echo Task %%~T is already disabled.
        ) else (
            echo Disabling task: %%~T
            schtasks /change /tn "%%~T" /disable
            if !errorlevel! equ 0 (
                echo Task %%~T successfully disabled.
            ) else (
                echo Failed to disable task %%~T.
            )
        )
    ) else (
        echo Task %%~T not found.
    )
)
endlocal
timeout /t "1" /nobreak >nul
echo Running a script to disable Family Safety Mode in the Task Scheduler.
setlocal enabledelayedexpansion
for %%T in (
    "Microsoft\Windows\Shell\FamilySafetyMonitor"
    "Microsoft\Windows\Shell\FamilySafetyRefreshTask"
) do (
    schtasks /query /tn "%%~T" >nul 2>&1
    if !errorlevel! equ 0 (
        schtasks /query /tn "%%~T" /fo LIST /v | findstr /i "Disabled" >nul 2>&1
        if !errorlevel! equ 0 (
            echo Task %%~T is already disabled.
        ) else (
            echo Disabling task: %%~T
            schtasks /change /tn "%%~T" /disable
            if !errorlevel! equ 0 (
                echo Task %%~T successfully disabled.
            ) else (
                echo Failed to disable task %%~T.
            )
        )
    ) else (
        echo Task %%~T not found.
    )
)
endlocal
timeout /t "1" /nobreak >nul
echo Running a script to disable maintenance and management of backup using the File History feature in the Task Scheduler.
setlocal enabledelayedexpansion
for %%T in (
    "Microsoft\Windows\FileHistory\File History (maintenance mode)"
) do (
    schtasks /query /tn "%%~T" >nul 2>&1
    if !errorlevel! equ 0 (
        schtasks /query /tn "%%~T" /fo LIST /v | findstr /i "Disabled" >nul 2>&1
        if !errorlevel! equ 0 (
            echo Task %%~T is already disabled.
        ) else (
            echo Disabling task: %%~T
            schtasks /change /tn "%%~T" /disable
            if !errorlevel! equ 0 (
                echo Task %%~T successfully disabled.
            ) else (
                echo Failed to disable task %%~T.
            )
        )
    ) else (
        echo Task %%~T not found.
    )
)
endlocal
timeout /t "1" /nobreak >nul
echo Running a script to disable network diagnostic tools and network information gathering in the Task Scheduler.
setlocal enabledelayedexpansion
for %%T in (
    "Microsoft\Windows\NetTrace\GatherNetworkInfo"
) do (
    schtasks /query /tn "%%~T" >nul 2>&1
    if !errorlevel! equ 0 (
        schtasks /query /tn "%%~T" /fo LIST /v | findstr /i "Disabled" >nul 2>&1
        if !errorlevel! equ 0 (
            echo Task %%~T is already disabled.
        ) else (
            echo Disabling task: %%~T
            schtasks /change /tn "%%~T" /disable
            if !errorlevel! equ 0 (
                echo Task %%~T successfully disabled.
            ) else (
                echo Failed to disable task %%~T.
            )
        )
    ) else (
        echo Task %%~T not found.
    )
)
endlocal
timeout /t "1" /nobreak >nul
echo Running a script to disable Xbox in the Task Scheduler.
setlocal enabledelayedexpansion
for %%T in (
    "Microsoft\XblGameSave\XblGameSaveTask"
) do (
    schtasks /query /tn "%%~T" >nul 2>&1
    if !errorlevel! equ 0 (
        schtasks /query /tn "%%~T" /fo LIST /v | findstr /i "Disabled" >nul 2>&1
        if !errorlevel! equ 0 (
            echo Task %%~T is already disabled.
        ) else (
            echo Disabling task: %%~T
            schtasks /change /tn "%%~T" /disable
            if !errorlevel! equ 0 (
                echo Task %%~T successfully disabled.
            ) else (
                echo Failed to disable task %%~T.
            )
        )
    ) else (
        echo Task %%~T not found.
    )
)
endlocal
timeout /t "1" /nobreak >nul
echo Running a script to disable the automatic cleanup of content related to Retail Demo mode in the Task Scheduler.
setlocal enabledelayedexpansion
for %%T in (
    "Microsoft\Windows\RetailDemo\CleanupOfflineContent"
) do (
    schtasks /query /tn "%%~T" >nul 2>&1
    if !errorlevel! equ 0 (
        schtasks /query /tn "%%~T" /fo LIST /v | findstr /i "Disabled" >nul 2>&1
        if !errorlevel! equ 0 (
            echo Task %%~T is already disabled.
        ) else (
            echo Disabling task: %%~T
            schtasks /change /tn "%%~T" /disable
            if !errorlevel! equ 0 (
                echo Task %%~T successfully disabled.
            ) else (
                echo Failed to disable task %%~T.
            )
        )
    ) else (
        echo Task %%~T not found.
    )
)
endlocal
timeout /t "1" /nobreak >nul
echo Running a script to disable error reporting in the Task Scheduler.
setlocal enabledelayedexpansion
for %%T in (
    "Microsoft\Windows\Windows Error Reporting\QueueReporting"
) do (
    schtasks /query /tn "%%~T" >nul 2>&1
    if !errorlevel! equ 0 (
        schtasks /query /tn "%%~T" /fo LIST /v | findstr /i "Disabled" >nul 2>&1
        if !errorlevel! equ 0 (
            echo Task %%~T is already disabled.
        ) else (
            echo Disabling task: %%~T
            schtasks /change /tn "%%~T" /disable
            if !errorlevel! equ 0 (
                echo Task %%~T successfully disabled.
            ) else (
                echo Failed to disable task %%~T.
            )
        )
    ) else (
        echo Task %%~T not found.
    )
)
endlocal
timeout /t "1" /nobreak >nul
echo Running a script to disable location notifications and the Windows action dialog in the Task Scheduler.
setlocal enabledelayedexpansion
for %%T in (
    "Microsoft\Windows\Location\Notifications"
    "Microsoft\Windows\Location\WindowsActionDialog"
) do (
    schtasks /query /tn "%%~T" >nul 2>&1
    if !errorlevel! equ 0 (
        schtasks /query /tn "%%~T" /fo LIST /v | findstr /i "Disabled" >nul 2>&1
        if !errorlevel! equ 0 (
            echo Task %%~T is already disabled.
        ) else (
            echo Disabling task: %%~T
            schtasks /change /tn "%%~T" /disable
            if !errorlevel! equ 0 (
                echo Task %%~T successfully disabled.
            ) else (
                echo Failed to disable task %%~T.
            )
        )
    ) else (
        echo Task %%~T not found.
    )
)
endlocal
timeout /t "1" /nobreak >nul
echo Running a script to disable device information in the Task Scheduler.
setlocal enabledelayedexpansion
for %%T in (
    "Microsoft\Windows\Device Information\Device"
    "Microsoft\Windows\Device Information\Device User"
) do (
    schtasks /query /tn "%%~T" >nul 2>&1
    if !errorlevel! equ 0 (
        schtasks /query /tn "%%~T" /fo LIST /v | findstr /i "Disabled" >nul 2>&1
        if !errorlevel! equ 0 (
            echo Task %%~T is already disabled.
        ) else (
            echo Disabling task: %%~T
            schtasks /change /tn "%%~T" /disable
            if !errorlevel! equ 0 (
                echo Task %%~T successfully disabled.
            ) else (
                echo Failed to disable task %%~T.
            )
        )
    ) else (
        echo Task %%~T not found.
    )
)
endlocal
timeout /t "1" /nobreak >nul
echo Running a script to disable the Office ClickToRun Service Monitor in the Task Scheduler.
setlocal enabledelayedexpansion
for %%T in (
    "Microsoft\Office\Office ClickToRun Service Monitor"
) do (
    schtasks /query /tn "%%~T" >nul 2>&1
    if !errorlevel! equ 0 (
        schtasks /query /tn "%%~T" /fo LIST /v | findstr /i "Disabled" >nul 2>&1
        if !errorlevel! equ 0 (
            echo Task %%~T is already disabled.
        ) else (
            echo Disabling task: %%~T
            schtasks /change /tn "%%~T" /disable
            if !errorlevel! equ 0 (
                echo Task %%~T successfully disabled.
            ) else (
                echo Failed to disable task %%~T.
            )
        )
    ) else (
        echo Task %%~T not found.
    )
)
endlocal
timeout /t "1" /nobreak >nul
echo Running a script to disable Sysmain tasks in the Task Scheduler.
setlocal enabledelayedexpansion
for %%T in (
    "Microsoft\Windows\Sysmain\ResPriStaticDbSync"
    "Microsoft\Windows\Sysmain\WsSwapAssessmentTask"
) do (
    schtasks /query /tn "%%~T" >nul 2>&1
    if !errorlevel! equ 0 (
        schtasks /query /tn "%%~T" /fo LIST /v | findstr /i "Disabled" >nul 2>&1
        if !errorlevel! equ 0 (
            echo Task %%~T is already disabled.
        ) else (
            echo Disabling task: %%~T
            schtasks /change /tn "%%~T" /disable
            if !errorlevel! equ 0 (
                echo Task %%~T successfully disabled.
            ) else (
                echo Failed to disable task %%~T.
            )
        )
    ) else (
        echo Task %%~T not found.
    )
)
endlocal
timeout /t "1" /nobreak >nul
echo Running a script to disable the Mobile Broadband Accounts task in the Task Scheduler.
setlocal enabledelayedexpansion
for %%T in (
    "Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"
) do (
    schtasks /query /tn "%%~T" >nul 2>&1
    if !errorlevel! equ 0 (
        schtasks /query /tn "%%~T" /fo LIST /v | findstr /i "Disabled" >nul 2>&1
        if !errorlevel! equ 0 (
            echo Task %%~T is already disabled.
        ) else (
            echo Disabling task: %%~T
            schtasks /change /tn "%%~T" /disable
            if !errorlevel! equ 0 (
                echo Task %%~T successfully disabled.
            ) else (
                echo Failed to disable task %%~T.
            )
        )
    ) else (
        echo Task %%~T not found.
    )
)
endlocal
timeout /t "1" /nobreak >nul
echo Running a script to disable the Data Usage Subscription Management in the Task Scheduler.
setlocal enabledelayedexpansion
for %%T in (
    "Microsoft\Windows\DUSM\dusmtask"
) do (
    schtasks /query /tn "%%~T" >nul 2>&1
    if !errorlevel! equ 0 (
        schtasks /query /tn "%%~T" /fo LIST /v | findstr /i "Disabled" >nul 2>&1
        if !errorlevel! equ 0 (
            echo Task %%~T is already disabled.
        ) else (
            echo Disabling task: %%~T
            schtasks /change /tn "%%~T" /disable
            if !errorlevel! equ 0 (
                echo Task %%~T successfully disabled.
            ) else (
                echo Failed to disable task %%~T.
            )
        )
    ) else (
        echo Task %%~T not found.
    )
)
endlocal
timeout /t "1" /nobreak >nul

echo CHECKING THE SETTINGS FOR ADDITIONAL COMPONENTS.
timeout /t "1" /nobreak >nul
echo Running a script to disable the Windows Media Player component.
setlocal
powershell -Command "if ((Get-WindowsCapability -Online -Name 'Media.WindowsMediaPlayer*').State -eq 'Installed') { Remove-WindowsCapability -Online -Name 'Media.WindowsMediaPlayer'; exit 0 } else { exit 1 }" > nul 2>&1
if %errorlevel% equ 0 (
    echo The Windows Media Player capability has been successfully removed.
) else (
    echo The Windows Media Player capability is not installed, cannot be found, or an error occurred.
)
endlocal
setlocal
powershell -Command "if ((Get-WindowsOptionalFeature -Online -FeatureName 'MediaPlayback').State -eq 'Enabled') { Disable-WindowsOptionalFeature -Online -FeatureName 'MediaPlayback' -NoRestart; exit 0 } else { exit 1 }" > nul 2>&1
if %errorlevel% equ 0 (
    echo The MediaPlayback feature has been successfully disabled.
) else (
    echo The MediaPlayback feature is not enabled, cannot be found, or an error occurred.
)
endlocal
echo Running a script to disable the Internet Explorer component.
setlocal
powershell -Command "if ((Get-WindowsCapability -Online -Name 'Browser.InternetExplorer*').State -eq 'Installed') { Remove-WindowsCapability -Online -Name 'Browser.InternetExplorer'; exit 0 } else { exit 1 }" > nul 2>&1
if %errorlevel% equ 0 (
    echo The Internet Explorer capability has been successfully removed.
) else (
    echo The Internet Explorer capability is not installed, cannot be found, or an error occurred.
)
endlocal
echo Running a script to disable the Hello Face component.
setlocal
powershell -Command "if ((Get-WindowsCapability -Online -Name 'Hello.Face*').State -eq 'Installed') { Remove-WindowsCapability -Online -Name 'Hello.Face'; exit 0 } else { exit 1 }" > nul 2>&1
if %errorlevel% equ 0 (
    echo The Windows Hello Face capability has been successfully removed.
) else (
    echo The Windows Hello Face capability is not installed, cannot be found, or an error occurred.
)
endlocal
echo Running a script to disable the Quick Assist component.
powershell -Command "if ((Get-WindowsCapability -Online -Name 'App.Support.QuickAssist*').State -eq 'Installed') { Remove-WindowsCapability -Online -Name 'App.Support.QuickAssist'; exit 0 } else { exit 1 }" > nul 2>&1
if %errorlevel% equ 0 (
    echo The Quick Assist capability has been successfully removed.
) else (
    echo The Quick Assist capability is not installed, cannot be found, or an error occurred.
)
endlocal
echo Running a script to disable the Steps Recorder component.
powershell -Command "if ((Get-WindowsCapability -Online -Name 'App.StepsRecorder*').State -eq 'Installed') { Remove-WindowsCapability -Online -Name 'App.StepsRecorder'; exit 0 } else { exit 1 }" > nul 2>&1
if %errorlevel% equ 0 (
    echo The Steps Recorder capability has been successfully removed.
) else (
    echo The Steps Recorder capability is not installed, cannot be found, or an error occurred.
)
endlocal
timeout /t "1" /nobreak >nul

echo CHECKING THE SETTINGS FOR TIME AND LANGUAGE IN WINDOWS OS.
timeout /t "1" /nobreak >nul
echo Running a script to disable Improve Inking and Typing Recognition.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput" /v "AllowLinguisticDataCollection" /t REG_DWORD /d "0" /f
echo Running a script to disable input data analysis.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Input\Settings" /v "InsightsEnabled" /t REG_DWORD /d "0" /f
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Input\Settings" /v "HarvestContacts" /t REG_DWORD /d "0" /f
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Input\Settings" /v "LMDataLoggerEnabled" /t REG_DWORD /d "0" /f
echo Running a script to disable text suggestions while typing on a physical keyboard.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Input\Settings" /v "EnableHwkbTextPrediction" /t REG_DWORD /d "0" /f
echo Running a script to disable multilingual text suggestions.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Input\Settings" /v "MultilingualEnabled" /t REG_DWORD /d "0" /f
echo Running a script to disable voice typing.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Input\Settings" /v "VoiceTypingEnabled" /t REG_DWORD /d "0" /f
echo Running a script to disable collection and sending of user-typed text.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d "0" /f
echo Running a script to disable prediction and correction of misspelled words in user-typed text.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Policies\Microsoft\TabletTip\1.7" /v "DisablePrediction" /t REG_DWORD /d "1" /f
for %%H in (HKCU HKLM) do (
    for %%S in (
        "EnableAutocorrection"
        "EnableDoubleTapSpace"
        "EnablePredictionSpaceInsertion"
        "EnableSpellchecking"
        "EnableTextPrediction"
    ) do reg add "%%H\Software\Microsoft\TabletTip\1.7" /v %%~S /t REG_DWORD /d "0" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
        "TurnOffAutocorrectMisspelledWords"
        "TurnOffHighlightMisspelledWords"
        "TurnOffOfferTextPredictions"
    ) do reg add "%%H\Software\Policies\Microsoft\Control Panel\International" /v %%~S /t REG_DWORD /d "1" /f
)

echo CHECKING THE SETTINGS FOR GAMES IN WINDOWS OS.
timeout /t "1" /nobreak >nul
echo Running a script to disable Xbox support in the operating system.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" /v "value" /t REG_DWORD /d "0" /f
for %%H in (HKCU HKLM) do (
    for %%S in (
        "GameDVR_FSEBehavior"
        "GameDVR_FSEBehaviorMode"
        "GameDVR_Enabled"
    ) do reg add "%%H\System\GameConfigStore" /v %%~S /t REG_DWORD /d "0" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "AllowAutoGameMode"
    "AutoGameModeEnabled"
    "ShowStartupPanel"
    "UseNexusForGameBarEnabled"
    ) do reg add "%%H\Software\Microsoft\GameBar" /v %%~S /t REG_DWORD /d "0" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "AppCaptureEnabled"
    "AudioCaptureEnabled"
    "CursorCaptureEnabled"
    "HistoricalCaptureEnabled"
    ) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v %%~S /t REG_DWORD /d "0" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "DownloadGameInfo"
    "GameUpdateOptions"
    "ListRecentlyPlayed"
    ) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v %%~S /t REG_DWORD /d "0" /f
)
timeout /t "1" /nobreak >nul

echo CHECKING THE SETTINGS FOR MEDIA AND BLUETOOTH IN WINDOWS OS.
timeout /t "1" /nobreak >nul
echo Running a script to disable user tips for using an Android phone with Windows.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Mobility" /v "OptedIn" /t REG_DWORD /d "0" /f
echo Running a script to disable autoplay for all media and devices.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v "DisableAutoplay" /t REG_DWORD /d "1" /f
timeout /t "1" /nobreak >nul

echo CHECKING THE SETTINGS FOR UPDATES AND SECURITY IN WINDOWS OS.
timeout /t "1" /nobreak >nul
echo Running a script to disable delivery otimization.
reg add "HKLM\Software\Policies\Microsoft\Windows\DeliveryOptimization" /v "DoDownLoadMode" /t REG_DWORD /d "0" /f
echo Running a script to enable font provider updates
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "EnableFontProviders" /t REG_DWORD /d "1" /f
echo Running a script to disable Windows Defender.
regsvr32.exe /u "C:\Program Files\Windows Defender\shellext.dll" /s
"%sudo%" reg delete "HKLM\Software\Classes\CLSID\{A463FCB9-6B1C-4E0D-A80B-A2CA7999E25D}" /f
reg delete "HKLM\Software\Policies\Microsoft\Windows Defender" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d "0" /f
reg add "HKLM\System\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /t REG_DWORD /d "0" /f
reg add "HKLM\System\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "HVCIMATRequired" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows Defender Security Center\Device security" /v "UILockdown" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoNTSecurity" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows Defender Security Center\Family options" /v "UILockdown" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows Defender Security Center\Notifications" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows Defender Security Center\Virus and threat protection" /v "UILockdown" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\MpEngine" /v "MpEnablePus" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Windows Defender/Operational" /v "Enabled" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Windows Defender/WHC" /v "Enabled" /t REG_DWORD /d "0" /f
reg add "HKLM\System\CurrentControlSet\Control\CI\Policy" /v "VerifiedAndReputablePolicyState" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Reporting" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\SpyNet" /v "DisableBlockAtFirstSeen" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Microsoft\Windows Defender Security Center\Virus and threat protection" /v "UILockdown" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Reporting" /v "DisableGenericRePorts" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\SmartScreen" /v "ConfigureAppInstallControlEnabled" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\SmartScreen" /v "ConfigureAppInstallControl" /t REG_SZ /d "Anywhere" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{09A47860-11B0-4DA5-AFA5-26D86198A780}" /t REG_SZ /d "" /f
"%sudo%" reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MpCmdRun.exe" /v "Debugger" /t REG_SZ /d "dllhost.exe" /f
"%sudo%" reg add "HKLM\Software\Microsoft\Windows Defender\Spynet" /v "SpyNetReportingLocation" /t REG_MULTI_SZ /d "http://0.0.0.0" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "AicEnabled" /t REG_SZ /d "Anywhere" /f
reg add "HKLM\Software\Microsoft\Internet Explorer\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AppHost" /v "PreventOverride" /t REG_DWORD /d "0" /f
"%sudo%" reg add "HKLM\Software\Microsoft\Windows Defender\Features" /v "TamperProtection" /t REG_DWORD /d "0" /f
"%sudo%" reg add "HKLM\System\CurrentControlSet\Control\DeviceGuard\Scenarios\KernelShadowStacks" /v "WasEnabledBy" /t REG_DWORD /d "4" /f
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d "0" /f
for %%S in (
    "SubmitSamplesConsent"
    "SpyNetReporting"
    "MAPSconcurrency"
) do "%sudo%" reg add "HKLM\Software\Microsoft\Windows Defender\Spynet" /v %%~S /t REG_DWORD /d "0" /f
for %%S in (
    "ScanOnlyIfIdle"
    "DisableScanningNetworkFiles"
    "DisableScanningMappedNetworkDrivesForFullScan"
    "DisableRestorePoint"
    "DisableRemovableDriveScanning"
    "DisableCatchupQuickScan"
    "DisableCatchupFullScan"
    "DisableArchiveScanning"
) do reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v %%~S /t REG_DWORD /d "1" /f
for %%S in (
    "SpynetReporting"
    "LocalSettingOverrideSpynetReporting"
) do reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Spynet" /v %%~S /t REG_DWORD /d "0" /f
for %%S in (
    "Enabled"
    "AuditModeEnabled"
) do reg add "HKLM\System\CurrentControlSet\Control\DeviceGuard\Scenarios\KernelShadowStacks" /v %%~S /t REG_DWORD /d "0" /f
set "regPath=HKLM\Software\Classes\exefile\shell"
for %%i in (
    "open"
    "runas"
    "runasuser"
) do (
    reg add "%regPath%\%%~i" /v "NoSmartScreen" /t REG_SZ /d "" /f
)
for %%S in (
    "SmartScreenEnabled"
    "SmartScreenPuaEnabled"
) do reg add "HKCU\Software\Policies\Microsoft\Edge" /v %%~S /t REG_DWORD /d "0" /f
for %%S in (
    "EnabledV9"
    "PreventOverride"
) do reg add "HKLM\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter" /v %%~S /t REG_DWORD /d "0" /f
for %%S in (
    "AppAndBrowser_EdgeSmartScreenOff"
    "AppAndBrowser_PuaSmartScreenOff"
    "AppAndBrowser_StoreAppsSmartScreenOff"
) do reg add "HKLM\Software\Microsoft\Windows Security Health\State" /v %%~S /t REG_DWORD /d "1" /f
for %%S in (
    "AllowFastServiceStartup"
    "ServiceKeepAlive"
    "PUADetection"
    "PUAProtection"
) do reg add "HKLM\Software\Policies\Microsoft\Windows Defender" /v %%~S /t REG_DWORD /d "0" /f
for %%S in (
    "Enabled"
    "Locked"
) do reg add "HKLM\System\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v %%~S /t REG_DWORD /d "0" /f
for %%S in (
    "RequirePlatformSecurityFeatures"
    "Locked"
) do reg add "HKLM\System\CurrentControlSet\Control\DeviceGuard" /v %%~S /t REG_DWORD /d "0" /f
for %%S in (
    "DisableBehaviorMonitoring"
    "DisableIOAVProtection"
    "DisableOnAccessProtection"
    "DisableRealtimeMonitoring"
    "DpaDisabled"
    "DisableRoutinelyTakingAction"
    "DisableScanOnRealtimeEnable"
    "DisableScriptScanning"
) do reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v %%~S /t REG_DWORD /d "1" /f
for %%S in (
    "LocalSettingOverrideDisableRealtimeMonitoring"
    "LocalSettingOverrideDisableBehaviorMonitoring"
    "LocalSettingOverrideDisableIOAVProtection"
) do reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v %%~S /t REG_DWORD /d "0" /f
for %%S in (
    "RealtimeSignatureDelivery"
    "UpdateOnStartUp"
) do reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v %%~S /t REG_DWORD /d "0" /f
for %%S in (
    "DisableScanOnUpdate"
    "DisableUpdateOnStartupWithoutEngine"
) do reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v %%~S /t REG_DWORD /d "1" /f
for %%S in (
    "DisableScanningMappedNetworkDrivesForFullScan"
    "DisableScanningNetworkFiles"
    "DisableAntiSpyware"
    "DisableAntiVirus"
    "DisableRoutinelyTakingAction"
) do reg add "HKLM\Software\Policies\Microsoft\Windows Defender" /v %%~S /t REG_DWORD /d "1" /f
for %%S in (
    "DisallowExploitProtectionOverride"
    "UILockdown"
) do reg add "HKLM\Software\Policies\Microsoft\Windows Defender Security Center\App and Browser protection" /v %%~S /t REG_DWORD /d "1" /f
for %%S in (
    "SpynetReporting"
    "SubmitSamplesConsent"
) do reg add "HKLM\Software\Policies\Microsoft\Windows Defender\SpyNet" /v %%~S /t REG_DWORD /d "1" /f
for %%H in (HKCU HKLM) do (
    for %%S in (
    "EnabledV9"
    "PreventOverride"
    "PreventOverrideAppRepUnknown"
    ) do reg add "%%H\Software\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v %%~S /t REG_DWORD /d "0" /f
)
timeout /t "1" /nobreak >nul

echo CHECKING THE SETTINGS FOR PRIVACY IN WINDOWS OS.
timeout /t "1" /nobreak >nul
echo Running a script to disable telemetry in Windows PowerShell.
setx POWERSHELL_TELEMETRY_OPTOUT "1"
echo Running a script to disable telemetry in DOTNET cli.
setx DOTNET_CLI_TELEMETRY_OPTOUT "1"
echo Running a script to disable Windows Tips.
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Microsoft\PolicyManager\default\Settings\AllowOnlineTips" /v "value" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AllowOnlineTips" /t REG_DWORD /d "0" /f
echo Running a script to disable insecure Wi-Fi hotspot features.
for %%S in (
    "AllowWiFiHotSpotReporting"
    "AllowAutoConnectToWiFiSenseHotspots"
) do reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi" /v %%~S /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\WcmSvc\wifinetworkmanager\config" /v "AutoConnectAllowedOEM" /t REG_DWORD /d "0" /f
echo Running a script to disable sensors in the operating system.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableSensors" /t REG_DWORD /d "1" /f
echo Running a script to disable location in the operating system.
for %%H in (HKCU HKLM) do (
    for %%S in (
    "DisableLocationScripting"
    "DisableLocation"
    "DisableWindowsLocationProvider"
    ) do reg add "%%H\Software\Policies\Microsoft\Windows\LocationAndSensors" /v %%~S /t REG_DWORD /d "1" /f
)
echo Running a script to disable biometrics in the operating system.
reg add "HKLM\Software\Policies\Microsoft\Biometrics\Credential Provider" /v "Enabled" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Biometrics" /v "Enabled" /t REG_DWORD /d "0" /f
echo Running a script to disable personalized advertising based on user advertising identifier.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Id" /t REG_SZ /d "null" /f
echo Running a script to disable locally relevant content by using the user's language list.
reg add "HKCU\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d "1" /f
echo Running a script to disable enhancing search results in the Start menu by tracking app launches.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f
echo Running a script to disable activity feed.
for %%S in (
    "PublishUserActivities"
    "EnableActivityFeed"
    "UploadUserActivities"
) do reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v %%~S /t REG_DWORD /d "0" /f
echo Running a script to disable suggested content.
for %%H in (HKCU HKLM) do (
    for %%S in (
    "SystemPaneSuggestionsEnabled"
    "SoftLandingEnabled"
    "SlideshowEnabled"
    "SilentInstalledAppsEnabled"
    "RotatingLockScreenOverlayEnabled"
    "RotatingLockScreenEnabled"
    "PreInstalledAppsEverEnabled"
    "PreInstalledAppsEnabled"
    "OemPreInstalledAppsEnabled"
    "ContentDeliveryAllowed"
    ) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v %%~S /t REG_DWORD /d "0" /f
)
echo Running a script to disable online speech recognition.
reg add "HKCU\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v "HasAccepted" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\PolicyManager\default\Privacy\AllowInputPersonalization" /v "value" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\InputPersonalization" /v "AllowInputPersonalization" /t REG_DWORD /d "0" /f
echo Running a script to disable inking and typing personalization.
for %%H in (HKCU HKLM) do (
    for %%S in (
    "RestrictImplicitInkCollection"
    "RestrictImplicitTextCollection"
    ) do reg add "%%H\Software\Microsoft\InputPersonalization" /v %%~S /t REG_DWORD /d "1" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "RestrictImplicitInkCollection"
    "RestrictImplicitTextCollection"
    ) do reg add "%%H\Software\Policies\Microsoft\InputPersonalization" /v %%~S /t REG_DWORD /d "1" /f
)
for %%H in (HKCU HKLM) do reg add "%%H\Software\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f
for %%H in (HKCU HKLM) do reg add "%%H\Software\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f
reg add "HKCU\Software\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f
echo Running a script to disable sending additional diagnostic data.
for %%H in (HKCU HKLM) do (
    for %%S in (
    "AllowTelemetry"
    "MaxTelemetryAllowed"
    ) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v %%~S /t REG_DWORD /d "0" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "AllowTelemetry"
    "AllowDeviceNameInTelemetry"
    "AllowDesktopAnalyticsProcessing"
    ) do reg add "%%H\Software\Policies\Microsoft\Windows\DataCollection" /v %%~S /t REG_DWORD /d "0" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "DoNotShowFeedbackNotification"
    "DisableDiagnosticDataViewer"
    ) do reg add "%%H\Software\Policies\Microsoft\Windows\DataCollection" /v %%~S /t REG_DWORD /d "1" /f
)
echo Running a script to disable telemetry.
"%sudo%" reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing" /v "DisableWerReporting" /t REG_DWORD /d "1" /f
for %%H in (HKCU HKLM) do reg add "%%H\Software\Policies\Microsoft\Messenger\Client" /v "CEIP" /t REG_DWORD /d "2" /f
for %%H in (HKCU HKLM) do reg add "%%H\Software\Policies\Microsoft\Messenger\Client" /v "PreventRun" /t REG_DWORD /d "1" /f
set "regPath=HKLM\Software\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience"
for %%i in (
    "Program-Compatibility-Assistant"
    "Program-Compatibility-Troubleshooter"
    "Program-Inventory"
    "Program-Telemetry"
    "Diagtrack-Listener"
    "SetupPlatformTel"
    "Steps-Recorder"
) do (
    reg add "%regPath%\%%~i" /v "Enabled" /t REG_DWORD /d "0" /f
)
set "regPath=HKLM\SOFTWARE\Microsoft\PolicyManager\default\System"
for %%i in (
    "AllowTelemetry"
    "AllowLocation"
    "AllowDesktopAnalyticsProcessing"
    "AllowDeviceNameInDiagnosticData"
    "AllowExperimentation"
    "AllowCommercialDataPipeline"
) do (
    reg add "%regPath%\%%~i" /v "value" /t REG_DWORD /d "0" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "EnableExperimentation"
    "EnableConfigFlighting"
    ) do reg add "%%H\Software\Policies\Microsoft\Windows\PreviewBuilds" /v %%~S /t REG_DWORD /d "0" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "DownloadToolsEnabled"
    "ScenarioExecutionEnabled"
    ) do reg add "%%H\Software\Policies\Microsoft\Windows\WDI\{C295FBBA-FD47-46ac-8BEE-B1715EC634E5}" /v %%~S /t REG_DWORD /d "0" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "DownloadToolsEnabled"
    "ScenarioExecutionEnabled"
    ) do reg add "%%H\Software\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}" /v %%~S /t REG_DWORD /d "0" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "HeartbeatTrackingIndex"
    "SpyNetReportingLocation"
    ) do reg add "%%H\Software\Microsoft\RemovalTools\MpGears" /v %%~S /t REG_DWORD /d "0" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "DontOfferThroughWUAU"
    "DontReportInfectionInformation"
    ) do reg add "%%H\Software\Policies\Microsoft\MRT" /v %%~S /t REG_DWORD /d "1" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "DisableUAR"
    "DisableInventory"
    ) do reg add "%%H\Software\Policies\Microsoft\Windows\AppCompat" /v %%~S /t REG_DWORD /d "1" /f
)
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\TelemetryController" /v "RunsBlocked" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\System" /v "AllowExperimentation" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Bluetooth" /v "AllowAdvertising" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\ScheduledDiagnostics" /v "EnabledExecution" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\Windows\ScheduledDiagnostics" /v "EnabledExecution" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\PCHealth\ErrorReporting" /v "DoReport" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\ScriptedDiagnosticsProvider\Policy" /v "DisableQueryRemoteServer" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t REG_DWORD /d "1" /f
echo Running a script to disable tailored experiences.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d "0" /f
echo Running a script to disable feedback frequency.
reg add "HKCU\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f
echo Running a script to disable Windows Search.
dism.exe /online /disable-feature /FeatureName:searchengine-client-package /NoRestart
for %%H in (HKCU HKLM) do (
    for %%S in (
    "DisableWebSearch"
    "DisableRemovableDriveIndexing"
    "PreventRemoteQueries"
    "PreventIndexOnBattery"
    "PreventIndexingEmailAttachments"
    "PreventIndexingOutlook"
    ) do reg add "%%H\Software\Policies\Microsoft\Windows\Windows Search" /v %%~S /t REG_DWORD /d "1" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "BackgroundAppGlobalToggle"
    "VoiceShortcut"
    "CortanaInAmbientMode"
    "HistoryViewEnabled"
    "DeviceHistoryEnabled"
    "CortanaConsent"
    "CanCortanaBeEnabled"
    "CortanaEnabled"
    "BingSearchEnabled"
    "AllowSearchToUseLocation"
    ) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\Search" /v %%~S /t REG_DWORD /d "0" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "SafeSearchMode"
    "IsMSACloudSearchEnabled"
    "IsDeviceSearchHistoryEnabled"
    "IsAADCloudSearchEnabled"
    ) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v %%~S /t REG_DWORD /d "0" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "ConnectedSearchUseWeb"
    "AllowCortana"
    "AllowCortanaAboveLock"
    "ConnectedSearchUseWebOverMeteredConnections"
    "AlwaysUseAutoLangDetection"
    "AllowSearchToUseLocation"
    "AllowCloudSearch"
    "BingSearchEnabled"
    ) do reg add "%%H\Software\Policies\Microsoft\Windows\Windows Search" /v %%~S /t REG_DWORD /d "0" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "VoiceActivationOn"
    "VoiceActivationDefaultOn"
    "VoiceActivationEnableAboveLockscreen"
    "ModelDownloadAllowed"
    ) do reg add "%%H\Software\Microsoft\Speech_OneCore\Preferences" /v %%~S /t REG_DWORD /d "0" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "ConnectedSearchPrivacy"
    "ConnectedSearchSafeSearch"
    ) do reg add "%%H\Software\Policies\Microsoft\Windows\Windows Search" /v %%~S /t REG_DWORD /d "3" /f
)
reg add "HKLM\Software\Microsoft\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\OOBE" /v "DisableVoice" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Microsoft\PolicyManager\default\Search\AllowCloudSearch" /v "value" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\PolicyManager\default\Experience\AllowCortana" /v "value" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\AboveLock" /v "AllowCortanaAboveLock" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Experience" /v "AllowCortana" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCortanaButton" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "wholeFileSystem" /t REG_DWORD /d "1" /f
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaConsent" /t REG_DWORD /d "0" /f
echo Running a script to disable location access.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f
reg add "HKLM\Software\Microsoft\PolicyManager\default\System\AllowLocation" /v "value" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessLocation" /t REG_DWORD /d "2" /f
echo Running a script to disable voice activation access.
for %%S in (
    "AgentActivationEnabled"
    "AgentActivationOnLockScreenEnabled"
) do "%sudo%" reg add "HKLM\Software\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /v %%~S /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsActivateWithVoice" /t REG_DWORD /d "2" /f
echo Running a script to disable access to background apps.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d "2" /f
echo Running a script to disable access to account information.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t REG_SZ /d "Deny" /f
echo Running a script to disable access to contacts.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v "Value" /t REG_SZ /d "Deny" /f
echo Running a script to disable access to calendar.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /v "Value" /t REG_SZ /d "Deny" /f
echo Running a script to disable access to phone calls.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" /v "Value" /t REG_SZ /d "Deny" /f
echo Running a script to disable access to call history.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /v "Value" /t REG_SZ /d "Deny" /f
echo Running a script to disable access to tasks.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /v "Value" /t REG_SZ /d "Deny" /f
echo Running a script to disable access to email.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /v "Value" /t REG_SZ /d "Deny" /f
echo Running a script to disable access to messages.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /v "Value" /t REG_SZ /d "Deny" /f
echo Running a script to disable access to radio control.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /v "Value" /t REG_SZ /d "Deny" /f
echo Running a script to disable diagnostic access to applications.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v "Value" /t REG_SZ /d "Deny" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsGetDiagnosticInfo" /t REG_DWORD /d "2" /f
echo Running a script to disable the Standard Microsoft Diagnostic Data Collector.
for %%H in (HKCU HKLM) do (
    for %%S in (
    "ShowedToastAtLevel"
    "ConnectivityNoNetworkTime"
    "DisableAutomaticTelemetryKeywordReporting"
    "Disabled"
    "TelemetryServiceDisabled"
    ) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v %%~S /t REG_DWORD /d "1" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "DiagTrackAuthorization"
    "UploadPermissionReceived"
    ) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v %%~S /t REG_DWORD /d "0" /f
)
set "regPath=HKLM\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack"
reg add "%regPath%\EventTranscriptKey" /v "EnableEventTranscript" /t REG_DWORD /d "0" /f
reg add "%regPath%\TraceManager" /v "MiniTraceSlotEnabled" /t REG_DWORD /d "0" /f
reg add "%regPath%\TestHooks" /v "DisableAsimovUpLoad" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Diagnostics\PerfTrack" /v "Disabled" /t REG_DWORD /d "1" /f
echo Running a script to disable logging in the operating system.
set "regPath=HKLM\System\CurrentControlSet\Control\WMI\Autologger"
for %%i in (
    "AutoLogger-Diagtrack-Listener"
    "DefenderApiLogger"
    "DefenderAuditLogger"
    "DiagLog"
    "Diagtrack-Listener"
    "SetupPlatformTel"
    "WiFiSession"
) do (
    "%sudo%" reg add "%regPath%\%%~i" /v "Start" /t REG_DWORD /d "0" /f
)
echo Running a script to disable the system debugger in the operating system.
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\AeDebug" /v "Auto" /t REG_SZ /d "0" /f
echo Running a script to disable error reporting in the operating system.
for %%H in (HKCU HKLM) do (
    for %%S in (
    "Disabled"
    "LoggingDisabled"
    "DontSendAdditionalData"
    "DontShowUI"
    ) do reg add "%%H\Software\Microsoft\Windows\Windows Error Reporting" /v %%~S /t REG_DWORD /d "1" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "AutoApproveOSDumps"
    "BypassDataThrottling"
    ) do reg add "%%H\Software\Policies\Microsoft\Windows\Windows Error Reporting" /v %%~S /t REG_DWORD /d "0" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "Disabled"
    "DontSendAdditionalData"
    "LoggingDisabled"
    ) do reg add "%%H\Software\Policies\Microsoft\Windows\Windows Error Reporting" /v %%~S /t REG_DWORD /d "1" /f
)
for %%H in (HKCU HKLM) do (
    for %%S in (
    "DefaultConsent"
    "NewUserDefaultConsent"
    "DefaultOverrideBehavior"
    ) do reg add "%%H\Software\Microsoft\Windows\Windows Error Reporting\Consent" /v %%~S /t REG_DWORD /d "1" /f
)
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /v "MachineID" /t REG_SZ /d "{00000000-0000-0000-0000-000000000000}" /f
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting\WMR" /v "Disabled" /t REG_DWORD /d "1" /f
echo Running a script to disable the Customer Experience Improvement Program in the operating system.
reg add "HKLM\Software\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f
echo Running a script to disable the Insider Program in the operating system.
reg add "HKLM\Software\Microsoft\WindowsSelfHost\UI\Visibility" /v "HideInsiderPage" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\PreviewBuilds" /v "AllowBuildPreview" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\System\AllowBuildPreview" /v "value" /t REG_DWORD /d "0" /f
echo Running a script to enable developer mode in the operating system.
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v "AllowDevelopmentWithoutDevLicense" /t REG_DWORD /d "1" /f
echo Running a script to disable the user device finding function in the operating system.
reg add "HKLM\Software\Policies\Microsoft\FindMyDevice" /v "AllowFindMyDevice" /t REG_DWORD /d "0" /f
echo Running a script to disable synchronization in the operating system.
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d "2" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /v "EnableBackupForWin8Apps" /t REG_DWORD /d "0" /f
echo Running a script to disable WMI Reliability Providers.
reg add "HKLM\Software\Policies\Microsoft\Windows\Reliability Analysis\WMI" /v "WMIEnable" /t REG_DWORD /d "0" /f
timeout /t "1" /nobreak >nul

echo CHECKING OTHER SETTINGS IN WINDOWS OS.
timeout /t "1" /nobreak >nul
echo Running a script to enable a password request when exiting sleep or hibernation mode.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Policies\Microsoft\Windows\System\Power" /v "PromptPasswordOnResume" /t REG_DWORD /d "1" /f
echo Running a script to disable changing the mouse pointer.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Policies\Microsoft\Windows\Personalization" /v "NoChangingMousePointers" /t REG_DWORD /d "1" /f
echo Running a script to disable Windows Maps.
for %%H in (HKCU HKLM) do (
    for %%S in (
    "AllowUntriggeredNetworkTrafficOnSettingsPage"
    "AutoDownloadAndUpdateMapData"
    ) do reg add "%%H\Software\Policies\Microsoft\Windows\Maps" /v %%~S /t REG_DWORD /d "0" /f
)
echo Running a script to enable hidden folders and files in the operating system.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "1" /f
echo Running a script to enable file name extensions in the operating system.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f
echo Running a script to enable separate processes for folders in the operating system.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SeparateProcess" /t REG_DWORD /d "1" /f
echo Running a script to enable checkboxes for folder items in the operating system.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "AutoCheckSelect" /t REG_DWORD /d "1" /f
echo Running a script to disable task view on the taskbar in the operating system.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d "0" /f
echo Running a script to disable transparency effects in the operating system.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f
echo Running a script to disable recent items in jump lists.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d "0" /f
echo Running a script to enable small taskbar button size in the operating system.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSmallIcons" /t REG_DWORD /d "1" /f
echo Running a script to enable small icon size on the desktop in the operating system.
reg add "HKCU\Software\Microsoft\Windows\Shell\Bags\1\Desktop" /v "IconSize" /t REG_DWORD /d "32" /f
reg add "HKCU\Software\Microsoft\Windows\Shell\Bags\1\Desktop" /v "Mode" /t REG_DWORD /d "1" /f
reg add "HKCU\Software\Microsoft\Windows\Shell\Bags\1\Desktop" /v "LogicalViewMode" /t REG_DWORD /d "3" /f
echo Running a script to disable the background image on the login screen in the operating system.
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "DisableLogonBackgroundImage" /t REG_DWORD /d "1" /f
echo Running a script to enable blocking desktop wallpaper changes in the operating system.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoChangingWallPaper" /t REG_DWORD /d "1" /f
reg add "HKCU\Control Panel\Desktop" /v "Wallpaper" /t REG_SZ /d "" /f
echo Running a script to disable storing information about recently opened documents in the operating system.
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d "0" /f
echo Running a script to disable the list of frequently used programs in the Start menu in the operating system.
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartMenuMFUprogramsList" /t REG_DWORD /d "0" /f
echo Running a script to disable the welcome screen in the operating system.
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWelcomeScreen" /t REG_DWORD /d "0" /f
echo Running a script to disable recent applications to the Start menu in the operating system.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Policies\Microsoft\Windows\Explorer" /v "HideRecentlyAddedApps" /t REG_DWORD /d "1" /f
echo Running a script to disable advertisements in OneDrive.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d "1" /f
echo Running a script to disable thumbnail caching in hidden files in the operating system.
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableThumbsDBOnNetworkFolders" /t REG_DWORD /d "1" /f
echo Running a script to disable window title and border colors in the operating system.
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "ColorPrevalence" /t REG_DWORD /d "0" /f
echo Running a script to disable active help in the operating system.
reg add "HKCU\Software\Classes\AppID\{8cec58ae-07a1-11d9-b15e-000d56bfe6ee}" /v "RunAs" /t REG_SZ /d "" /f
for %%H in (HKCU HKLM) do (
    for %%S in (
    "NoImplicitFeedback"
    "NoExplicitFeedback"
    "NoOnlineAssist"
    "NoActiveHelp"
    ) do reg add "%%H\Software\Policies\Microsoft\Assistance\Client\1.0" /v %%~S /t REG_DWORD /d "1" /f
)
echo Running a script to disable web publishing in the task list for files and folders in the operating system.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoPublishingWizard" /t REG_DWORD /d "1" /f
echo Running a script to disable the update of content files for the search assistant in the operating system.
reg add "HKLM\Software\Policies\Microsoft\SearchCompanion" /v "DisableContentFileUpdates" /t REG_DWORD /d "1" /f
echo Running a script to disable speech data updates in the operating system.
reg add "HKLM\Software\Policies\Microsoft\Search" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f
echo Running a script to configure the quality percentage of the desktop wallpaper in the operating system.
reg add "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d "100" /f
echo Running a script to clean up the context menu by removing unnecessary items in the operating system.
reg delete "HKLM\Software\Classes\.zip\CompressedFolder\ShellNew" /f
for %%i in (.bmp .contact .rtf) do (
    reg delete "HKLM\Software\Classes\%%i\ShellNew" /f
)
set "regPath=HKLM\Software\Classes\SystemFileAssociations"
for %%i in (.3ds .3mf .bmp .dae .dxf .fbx .gif .glb .jfif .jpeg .jpe .jpg .obj .ply .png .stl .tiff .tif .wrl) do (
    reg add "%regPath%\%%i\Shell\3D Edit" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
    reg add "%regPath%\%%i\Shell\3D Print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
)
set "regPath=HKLM\Software\Classes\Drive\shell"
for %%i in (change-passphrase change-pin encrypt-bde encrypt-bde-elev manage-bde resume-bde resume-bde-elev unlock-bde) do (
    reg add "%regPath%\%%i" /v "LegacyDisable" /t REG_SZ /d "" /f
)
for %%i in (batfile cmdfile) do (
    reg add "HKLM\Software\Classes\%%i\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
)
echo Running a script to configure the opening of My computer in Explorer in the operating system.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d "1" /f
echo Running a script to disable the People icon on the taskbar in the operating system.
for %%H in (HKCU HKLM) do reg add "%%H\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "HidePeopleBar" /t REG_DWORD /d "1" /f
echo Running a script to clean up unnecessary items in Settings in the operating system.
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /t REG_SZ /d "hide:cortana;cortana-language;cortana-moredetails;cortana-notifications;cortana-permissions;cortana-windowssearch;gaming-broadcasting;gaming-gamebar;gaming-gamedvr;gaming-gamemode;gaming-trueplay;gaming-xboxnetworking;mobile-devices;mobile-devices-addphone;mobile-devices-addphone-direct;windowsdefender" /f
echo Running a script to configure the Windows Spotlight.
for %%H in (HKCU HKLM) do (
    for %%S in (
    "DisableWindowsSpotlightWindowsWelcomeExperience"
    "DisableSpotlightCollectionOnDesktop"
    "DisableThirdPartySuggestions"
    "DisableTailoredExperiencesWithDiagnosticData"
    "DisableWindowsSpotlightOnSettings"
    "DisableWindowsSpotlightOnActionCenter"
    "DisableWindowsSpotlightFeatures"
    ) do reg add "%%H\Software\Policies\Microsoft\Windows\CloudContent" /v %%~S /t REG_DWORD /d "1" /f
)
echo Running a script to disable desktop gadgets in the operating system.
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Windows\Sidebar" /v "TurnOffSidebar" /t REG_DWORD /d "1" /f
echo Running a script to disable Microsoft Consumer Experiences in the operating system.
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f
echo Running a script to configure taskbar locking in the operating system.
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "LockTaskbar" /t REG_DWORD /d "1" /f
echo Running a script to configure clearing the pagefile.sys swap file upon Windows shutdown.
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /t REG_DWORD /d "1" /f
echo Running a script to configure the Downloads folder in the operating system.
set "DownloadsFolder=%USERPROFILE%\Downloads"
if not exist "%DownloadsFolder%" mkdir "%DownloadsFolder%"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "{374DE290-123F-4565-9164-39C4925E467B}" /t REG_SZ /d "C:\Users\%USERNAME%\Downloads" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "{374DE290-123F-4565-9164-39C4925E467B}" /t REG_EXPAND_SZ /d "%USERPROFILE%\Downloads" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}" /t REG_EXPAND_SZ /d "%USERPROFILE%\Downloads" /f
attrib +r -s -h "%DownloadsFolder%" /s /d
echo Running a script to delete folders from My Computer in the operating system.
for %%S in (
    "{088e3905-0323-4b02-9826-5d99428e115f}"
    "{24ad3ad4-a569-4530-98e1-ab02f9417aa8}"
    "{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}"
    "{d3162b92-9365-467a-956b-92703aca08af}"
    "{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}"
    "{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}"
    "{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
) do reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\%%~S" /f
timeout /t "1" /nobreak >nul

echo CHECKING SETTINGS FOR IPv6.
timeout /t "1" /nobreak >nul
netsh int ipv6 isatap set state enabled
netsh int teredo set state enterpriseclient
netsh interface ipv6 6to4 set state state=default
reg add "HKLM\System\CurrentControlSet\Services\Tcpip6\Parameters" /v "DisabledComponents" /t REG_DWORD /d "0" /f
timeout /t "1" /nobreak >nul

echo CHECKING FONTS SETTINGS FOR THE OPERATING SYSTEM.
timeout /t "1" /nobreak >nul
set "url=https://github.com/notofonts/notofonts.github.io/archive/main.zip"
set "zipFile=%temp%\Noto_Fonts.zip"
set "destFolder=%temp%\NotoFonts"
set "extractedFolder=%destFolder%\notofonts.github.io-main"
set "sourceFontsFolder=%extractedFolder%\fonts"
set "targetFontsFolder=%temp%\NotoFonts\Fonts"
set "fontsFolder=%windir%\Fonts"
set /p "userChoice=Do you want to download Google Fonts Noto? ([Y]es/[N]o): "
if /I "%userChoice%"=="Y" (
    echo Downloading Google Fonts Noto...
if exist "%destFolder%" (
    rmdir /s /q "%destFolder%"
)
if exist "%targetFontsFolder%" (
    rmdir /s /q "%targetFontsFolder%"
)
mkdir "%targetFontsFolder%"
mkdir "%destFolder%"
powershell -Command "Invoke-WebRequest -Uri '%url%' -OutFile '%zipFile%'"
powershell -Command "Expand-Archive -Path '%zipFile%' -DestinationPath '%destFolder%'"
for /r "%sourceFontsFolder%" %%f in (*.otf *.ttf) do (
    move "%%f" "%targetFontsFolder%"
    )
for %%f in ("%targetFontsFolder%\*.otf" "%targetFontsFolder%\*.ttf") do (
        echo Installing %%~nxf
        copy "%%f" "%fontsFolder%"
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "%%~nxf" /t REG_SZ /d "%%~nxf" /f
    )
) else (
    echo Skipping download of Google Fonts Noto.
)
timeout /t "1" /nobreak >nul

echo CHECKING THE POWER AND SLEEP SETTINGS.
timeout /t "1" /nobreak >nul
powercfg -x standby-timeout-dc "0"
powercfg -x standby-timeout-ac "0"
timeout /t "1" /nobreak >nul

echo CHECKING THE SETTINGS FOR FIREWALL.
timeout /t "1" /nobreak >nul
echo Running a script to disable the default Windows Firewall.
netsh advfirewall set allprofiles state off
timeout /t "1" /nobreak >nul

echo CHECKING SETTINGS FOR ACTIVATION.
start /b "" cmd /c "cscript //nologo //e:vbscript %SystemRoot%\System32\slmgr.vbs /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX >nul 2>&1"
start /b "" cmd /c "cscript //nologo //e:vbscript %SystemRoot%\System32\slmgr.vbs /skms kms.digiboy.ir >nul 2>&1"
start /b "" cmd /c "cscript //nologo //e:vbscript %SystemRoot%\System32\slmgr.vbs /ato >nul 2>&1"
timeout /t "1" /nobreak >nul

echo REBOOT THE OPERATING SYSTEM.
timeout /t "1" /nobreak >nul
shutdown /r /f /t "0"