@echo off
REM Script de inicio rápido para el backend del chat
echo ======================================
echo   CHAT LOCAL - BACKEND (Python)
echo ======================================
echo.

cd /d "%~dp0"

if not exist ".venv" (
    echo [!] Entorno virtual no encontrado.
    echo [*] Creando entorno virtual...
    python -m venv .venv
    if errorlevel 1 (
        echo [ERROR] No se pudo crear el entorno virtual.
        echo [*] Verifica que Python este instalado: python --version
        pause
        exit /b 1
    )
    echo [OK] Entorno virtual creado.
)

echo [*] Activando entorno virtual...
call .venv\Scripts\activate.bat

if not exist ".venv\Lib\site-packages\websockets" (
    echo [!] Dependencias no encontradas.
    echo [*] Instalando dependencias...
    pip install -r requirements.txt
    if errorlevel 1 (
        echo [ERROR] No se pudieron instalar las dependencias.
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
        echo [ATENCION] Edita el archivo .env con tus configuraciones.
        pause
    ) else (
        echo [ERROR] Archivo .env.example tampoco existe.
        pause
        exit /b 1
    )
)

echo.
echo [*] Verificando conexion a MySQL...
python -c "import db; print('[OK] Conexion a base de datos exitosa')" 2>nul
if errorlevel 1 (
    echo [ERROR] No se pudo conectar a MySQL.
    echo [*] Verifica que:
    echo     1. MySQL este corriendo en XAMPP
    echo     2. El archivo .env tenga las credenciales correctas
    echo     3. La base de datos 'chatapp' exista
    pause
    exit /b 1
)

echo.
echo ======================================
echo   Iniciando servidor WebSocket...
echo ======================================
echo.
echo [i] Presiona Ctrl+C para detener
echo.

python server.py

pause
