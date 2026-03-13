@echo off
chcp 65001 > nul
cls

echo ======================================
echo   REINICIAR BACKEND
echo ======================================
echo.

echo [*] Buscando procesos en puerto 8765...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8765 ^| findstr LISTENING') do (
    echo [!] Cerrando proceso %%a...
    taskkill /F /PID %%a > nul 2>&1
)

echo [OK] Puerto 8765 liberado
echo.
echo [*] Iniciando backend...
echo.

call start.bat
