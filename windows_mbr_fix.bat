@echo off
setlocal
title Windows Legacy BIOS/MBR boot repair

fltmc >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Ejecuta este archivo como administrador.
    exit /b 1
)

echo ============================================================
echo  Windows boot repair - SOLO Legacy BIOS + MBR
echo ============================================================
echo.
echo NO ejecutes este script en un sistema UEFI/GPT.
echo Este script no elimina particiones ni convierte discos.
echo Se recomienda usarlo desde el Entorno de recuperacion de Windows.
echo.
echo Antes de continuar debes haber confirmado:
echo   - firmware Legacy BIOS
echo   - disco de Windows con estilo MBR
echo   - copia de seguridad o snapshot disponible
echo.
set /p CONFIRM=Escribe MBR para continuar: 
if /I not "%CONFIRM%"=="MBR" (
    echo Operacion cancelada. No se realizaron cambios.
    exit /b 2
)

echo.
echo [1/4] Reparando MBR...
bootrec /fixmbr
if errorlevel 1 goto :failed

echo [2/4] Reparando sector de arranque...
bootrec /fixboot
if errorlevel 1 goto :failed

echo [3/4] Buscando instalaciones de Windows...
bootrec /scanos
if errorlevel 1 goto :failed

echo [4/4] Reconstruyendo BCD...
bootrec /rebuildbcd
if errorlevel 1 goto :failed

echo.
echo [OK] Los comandos finalizaron sin codigo de error.
echo Reinicia y verifica manualmente que Windows arranque correctamente.
exit /b 0

:failed
echo.
echo [ERROR] La reparacion se detuvo porque un comando fallo.
echo Revisa la salida anterior. No asumas que el arranque fue reparado.
exit /b 1
