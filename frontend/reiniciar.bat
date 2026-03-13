@echo off
chcp 65001 > nul
cls

echo ======================================
echo   REINICIAR FRONTEND
echo ======================================
echo.

echo [*] Buscando procesos en puerto 5173...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5173 ^| findstr LISTENING') do (
    echo [!] Cerrando proceso %%a...
    taskkill /F /PID %%a > nul 2>&1
)

echo [OK] Puerto 5173 liberado
echo.
echo [*] Iniciando frontend...
echo.

call start.bat
