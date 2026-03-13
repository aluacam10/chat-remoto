@echo off
REM Script de inicio rápido para el frontend del chat
echo ======================================
echo   CHAT LOCAL - FRONTEND (React)
echo ======================================
echo.

cd /d "%~dp0"

if not exist "node_modules" (
    echo [!] Dependencias no encontradas.
    echo [*] Instalando dependencias de npm...
    echo [*] Esto puede tardar 2-3 minutos...
    call npm install
    if errorlevel 1 (
        echo [ERROR] No se pudieron instalar las dependencias.
        echo [*] Verifica que Node.js este instalado: node -v
        pause
        exit /b 1
    )
    echo [OK] Dependencias instaladas.
)

if not exist ".env" (
    echo [!] Archivo .env no encontrado.
    if exist ".env.example" (
        echo [*] Copiando .env.example a .env
        copy .env.example .env
        echo.
        echo [ATENCION] Verifica que .env tenga tu IP LAN correcta:
        echo     VITE_WS_URL=wss://TU_IP_LAN:8765
        echo.
        echo Para conocer tu IP, ejecuta: ipconfig
        echo.
        pause
    ) else (
        echo [ERROR] Archivo .env.example tampoco existe.
        pause
        exit /b 1
    )
)

echo.
echo ======================================
echo   Iniciando servidor de desarrollo...
echo ======================================
echo.
echo [i] Una vez iniciado, abre tu navegador en:
echo     https://localhost:5173
echo.
echo [i] Presiona Ctrl+C para detener
echo.

call npm run dev

pause
