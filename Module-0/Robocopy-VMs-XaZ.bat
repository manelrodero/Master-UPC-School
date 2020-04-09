@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

IF NOT EXIST X:\virtual_machines (
	ECHO Mapeando unidad X: a \\fibsmb\ex_cursos ...
	NET USE X: \\fibsmb\ex_cursos /USER:FIBSMB\%USERNAME% >NUL 2>&1
)
IF NOT EXIST X:\virtual_machines (
	ECHO ERROR: No se ha podido mapear la unidad X: !!!
	PAUSE
	GOTO FINAL
)

CALL :ROBO "27B. Win81 IE11 Trial 90"
CALL :ROBO "29B. Lubuntu Desktop 16.04.4 LTS x64"
CALL :ROBO "30B. Lubuntu Desktop 18.04 LTS x64"
CALL :ROBO "20B. OSSIM 5.3.2 x64"
REM CALL :ROBO "31B. OSSIM 5.6.0 x64"
REM CALL :ROBO "28B. Win2012R2 Trial 180"
GOTO FINAL

:ROBO
IF NOT EXIST "X:\virtual_machines\Monitorizacion\%~1" ( ECHO No existe la VM %~1 && GOTO :EOF )
IF NOT EXIST "Z:\Monitorizacion\%~1" MKDIR "Z:\Monitorizacion\%~1"
robocopy "X:\virtual_machines\Monitorizacion\%~1" "Z:\Monitorizacion\%~1" /mir /ipg:200
GOTO :EOF

:FINAL
ENDLOCAL
