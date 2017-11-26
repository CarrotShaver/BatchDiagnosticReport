ECHO OFF
SETLOCAL

REM Calls createfilename function, then creates/overwrites file at filename
CALL :createfilename
REM From this point on, all stdout will be prefixed by the %1 argument if it exists
REM if the %1 argument does not exist, it will have no prefix on stdout
REM Section of code will get system's current version of windows, processor type+architecture
ECHO. %1 > %filename%
GOTO comment
ECHO ------------------------- >> %filename%
ECHO %1 SYSTEM OS ^& PROCESSOR >> %filename%
ECHO ------------------------- >> %filename%
ECHO %1 Operating System: >> %filename%
REM temporary crap code, because I don't know how to make ver an argument for ECHO
ver >> %filename%
ECHO %1 Processor Type: %PROCESSOR_IDENTIFIER% >> %filename%
ECHO %1 Processor Architecture: %PROCESSOR_ARCHITECTURE% >> %filename%

REM Section of code will print out each environmental variable and value
ECHO. %1 >> %filename%
ECHO ------------------------- >> %filename%
ECHO %1 ENVIRONMENTAL VARIABLES >> %filename%
ECHO ------------------------- >> %filename%
REM For loop will prefix ipconfig lines with parameter
FOR /F "tokens=*" %%A IN ('set') DO ( 
    ECHO %1 %%A >> %filename%
)

REM Section of code will print out the network configuration of the system
ECHO. %1 >> %filename%
ECHO ------------------------- >> %filename%
ECHO %1 NETWORK CONFIGURATION >> %filename%
ECHO ------------------------- >> %filename%
ipconfig /all > temp.txt
REM For loop will prefix ipconfig lines with parameter
FOR /F "tokens=*" %%A IN (temp.txt) DO ( 
    ECHO %1 %%A >> %filename%
)

REM Section of code will print out all programs the run at startup in the system
ECHO. %1 >> %filename%
ECHO ------------------------- >> %filename%
ECHO %1 STARTUP PROGRAMS >> %filename%
ECHO ------------------------- >> %filename%
wmic startup get caption,command > temp.txt
REM I don't know why this works, don't change it
type temp.txt > temp2.txt
REM For loop will prefix ipconfig lines from temp.txt with parameter
FOR /F "tokens=*" %%A IN (temp2.txt) DO ( 
    ECHO %1 %%A >> %filename%
)
DEL temp.txt
DEL temp2.txt

REM Section of code will print out all programs currently running on the system
ECHO. %1 >> %filename%
ECHO ------------------------- >> %filename%
ECHO %1 RUNNING PROGRAMS >> %filename%
ECHO ------------------------- >> %filename%
FOR /F "tokens=*" %%A IN ('tasklist.exe') DO ( 
    ECHO %1 %%A >> %filename%
)

REM Section of code will print out all scheduled tasks running on the system
ECHO. %1 >> %filename%
ECHO ------------------------- >> %filename%
ECHO %1 SCHEDULED TASKS >> %filename%
ECHO ------------------------- >> %filename%
FOR /F "tokens=*" %%A IN ('schtasks.exe') DO ( 
    ECHO %1 %%A >> %filename%
)

:comment
REM Section of code will print out various registry settings running on the system
ECHO. %1 >> %filename%
ECHO ------------------------- >> %filename%
ECHO %1 REGISTRY SETTINGS AND INFORMATION >> %filename%
ECHO ------------------------- >> %filename%
ECHO %1 HKLM\Software\Microsoft\Windows\CurrentVersion\Runonce: >> %filename%
ECHO ------------------------- >> %filename%
FOR /F "tokens=*" %%A IN ('REG QUERY HKLM\Software\Microsoft\Windows\CurrentVersion\Runonce') DO ( 
    ECHO %1 %%A >> %filename%
)
ECHO ------------------------- >> %filename%
ECHO %1 HKLM\Software\Microsoft\Windows\CurrentVersion\Run: >> %filename%
ECHO ------------------------- >> %filename%
FOR /F "tokens=*" %%A IN ('REG QUERY HKLM\Software\Microsoft\Windows\CurrentVersion\Run') DO ( 
    ECHO %1 %%A >> %filename%
)
ECHO ------------------------- >> %filename%
ECHO %1 HKLM\Software\Microsoft\Windows\CurrentVersion\policies\Explorer\Run: >> %filename%
ECHO ------------------------- >> %filename%
FOR /F "tokens=*" %%A IN ('REG QUERY HKLM\Software\Microsoft\Windows\CurrentVersion\policies\Explorer\Run') DO ( 
    ECHO %1 %%A >> %filename%
)
ECHO ------------------------- >> %filename%
ECHO %1 HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows\Run: >> %filename%
ECHO ------------------------- >> %filename%
FOR /F "tokens=*" %%A IN ('REG QUERY "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows\Run"') DO ( 
    ECHO %1 %%A >> %filename%
)
ECHO ------------------------- >> %filename%
ECHO %1 HKCU\Software\Microsoft\Windows\CurrentVersion\Run: >> %filename%
ECHO ------------------------- >> %filename%
FOR /F "tokens=*" %%A IN ('REG QUERY HKCU\Software\Microsoft\Windows\CurrentVersion\Run') DO ( 
    ECHO %1 %%A >> %filename%
)
ECHO ------------------------- >> %filename%
ECHO %1 HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce: >> %filename%
ECHO ------------------------- >> %filename%
FOR /F "tokens=*" %%A IN ('REG QUERY HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce') DO ( 
    ECHO %1 %%A >> %filename%
)
ECHO ------------------------- >> %filename%
ECHO %1 HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce: >> %filename%
ECHO ------------------------- >> %filename%
FOR /F "tokens=*" %%A IN ('REG QUERY HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce') DO ( 
    ECHO %1 %%A >> %filename%
)
ECHO ------------------------- >> %filename%
ECHO %1 Registry Most Recently Used Programs: >> %filename%
ECHO ------------------------- >> %filename%
FOR /F "tokens=*" %%A IN ('REG QUERY HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU') DO ( 
    ECHO %1 %%A >> %filename%
)
ECHO ------------------------- >> %filename%
ECHO %1 Subkeys of UserAssist key: >> %filename%
ECHO ------------------------- >> %filename%
FOR /F "tokens=*" %%A IN ('REG QUERY "HCU\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist" /v') DO ( 
    ECHO %1 %%A >> %filename%
)
ECHO ------------------------- >> %filename%
ECHO %1 Wireless Networks and Settings visited from this Machine: >> %filename%
ECHO ------------------------- >> %filename%
FOR /F "tokens=*" %%A IN ('REG QUERY "HKLM\SOFTWARE\Microsoft\WZCSVC\Parameters\Interfaces"') DO ( 
    ECHO %1 %%A >> %filename%
)
FOR /F "tokens=*" %%A IN ('REG QUERY "HKLM\SYSTEM\ControlSet001\Services\Tcpip\Parameters\Interfaces\"') DO ( 
    ECHO %1 %%A >> %filename%
)
ECHO ------------------------- >> %filename%
ECHO %1 LAN Devices this Computer has had access to: >> %filename%
ECHO ------------------------- >> %filename%
FOR /F "tokens=*" %%A IN ('REG QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComputerDescriptions"') DO ( 
    ECHO %1 %%A >> %filename%
)

PAUSE
EXIT


REM _createfilename_ function will create a diagnostic report file
REM report file is formatted as "WindowsDiagnosticsReport_MachineName_YYYYMMDDHHMMSS".txt
:createfilename
SET formatDate=%date:~10,4%%date:~4,2%%date:~7,2%
SET formatTime=%time:~0,2%%time:~3,2%%time:~6,2%
REM TODO: SWAP COMMENT AND CODE LINES BELOW TO STOP OVERWRITING FILE
REM SET filename=WindowsDiagnosticsReport_%COMPUTERNAME%_%formatDate%%formatTime%.txt
SET filename=WindowsDiagnosticsReport_%COMPUTERNAME%_%formatDate%.txt
EXIT /b 0

