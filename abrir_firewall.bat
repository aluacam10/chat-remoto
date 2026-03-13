@echo off
chcp 65001 > nul
cls

echo ======================================
echo   ABRIR PUERTOS EN FIREWALL
echo ======================================
echo.
echo Este script necesita permisos de ADMINISTRADOR
echo.
echo Presiona cualquier tecla para continuar...
pause > nul

echo.
echo [*] Abriendo puertos del firewall...
echo.

powershell -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command \"New-NetFirewallRule -DisplayName ''Chat Frontend'' -Direction Inbound -LocalPort 5173,8080,8081,8082,8083 -Protocol TCP -Action Allow; New-NetFirewallRule -DisplayName ''Chat Backend'' -Direction Inbound -LocalPort 8765 -Protocol TCP -Action Allow; Write-Host ''''; Write-Host ''[OK] Puertos abiertos correctamente'' -ForegroundColor Green; Write-Host ''''; Write-Host ''Puertos habilitados:''; Write-Host ''  - Frontend: 5173, 8080-8083''; Write-Host ''  - Backend: 8765''; Write-Host ''''; Write-Host ''Presiona cualquier tecla para cerrar...''; Read-Host\"'"

echo.
echo [OK] Comando ejecutado
echo.
echo Si aparecio una ventana de permisos (UAC), acepta y espera.
echo Los puertos estaran abiertos una vez complete el proceso.
echo.
pause
