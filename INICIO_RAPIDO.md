# 🚀 Inicio Rápido - Chat Local

Si ya configuraste todo y solo quieres iniciar la aplicación, sigue estos pasos:

## ⚡ Inicio Rápido (3 pasos)

### 1️⃣ Iniciar MySQL
- Abre el Panel de Control de XAMPP
- Click en "Start" en el módulo MySQL

### 2️⃣ Iniciar Backend
```powershell
cd backend
start.bat
```

O manualmente:
```powershell
cd backend
.\.venv\Scripts\activate
python server.py
```

Debes ver:
```
WS server: wss://0.0.0.0:8765
```

### 3️⃣ Iniciar Frontend (en otra terminal)
```powershell
cd frontend
start.bat
```

O manualmente:
```powershell
cd frontend
npm run dev
```

### 4️⃣ Abrir en el navegador
```
https://localhost:5173
```

**Nota**: La aplicación está configurada para usar `localhost`, así que funciona en **cualquier red** sin reconfiguración.

---

## 📝 Checklist Pre-inicio

Antes de ejecutar por primera vez, asegúrate de haber completado:

### Requisitos instalados:
- [ ] Node.js 18+ (`node -v`)
- [ ] Python 3.11+ (`python --version`)
- [ ] MySQL (XAMPP)
- [ ] mkcert (`mkcert -version`)

### Base de datos configurada:
- [ ] MySQL corriendo en XAMPP
- [ ] Base de datos `chatapp` creada
- [ ] Tablas creadas (ejecutaste `database.sql`)

### Certificados SSL generados:
- [ ] Existe `certs/local.pem`
- [ ] Existe `certs/local-key.pem`

### Backend configurado:
- [ ] Existe `backend/.venv/`
- [ ] Dependencias instaladas (`pip install -r requirements.txt`)
- [ ] Existe `backend/.env` (copia de `.env.example`)
- [ ] Credenciales MySQL correctas en `.env`

### Frontend configurado:
- [ ] Existe `frontend/node_modules/`
- [ ] Dependencias instaladas (`npm install`)
- [ ] Existe `frontend/.env` con `VITE_WS_URL=wss://localhost:8765`

---

## ❓ Si es tu primera vez

Lee la [GUIA_INSTALACION.md](GUIA_INSTALACION.md) completa para configuración paso a paso.

---

## 🔄 Comandos Útiles

### Acceder desde tu PC
```
https://localhost:5173
```

### Acceder desde móvil/tablet en la misma red
```powershell
# Obtén tu IP LAN
ipconfig
```
Para acceder desde otros dispositivos, usa: `https://TU_IP:5173`

**Importante**: Si cambias de red, la aplicación seguirá funcionando en tu PC sin cambios. Solo necesitas actualizar la IP para acceso desde otros dispositivos.

### Reiniciar servicios

**Opción A - Si el puerto está ocupado** (recomendado):
```powershell
# Backend - cierra automáticamente procesos anteriores
cd backend
reiniciar.bat

# Frontend - cierra automáticamente procesos anteriores
cd frontend
reiniciar.bat
```

**Opción B - Reinicio manual**:
```powershell
# 1. Detener servicios (Ctrl+C en cada terminal)
# 2. Iniciar nuevamente:

# Backend
cd backend
start.bat

# Frontend
cd frontend
start.bat
```

### Ver logs del backend
El backend muestra logs en la consola donde ejecutaste `python server.py`

### Ver logs del frontend
Abre DevTools en el navegador (F12) → Consola

### Limpiar datos y empezar de cero
```sql
-- En phpMyAdmin o MySQL cliente
USE chatapp;
DELETE FROM messages;
DELETE FROM chat_members;
DELETE FROM chats;
DELETE FROM users;
```

---

## 🆘 Problemas Comunes

| Problema | Solución Rápida |
|----------|-----------------|
| **Puerto 8765/5173 ocupado** | Ejecuta `backend\reiniciar.bat` o `frontend\reiniciar.bat` según corresponda |
| Backend no arranca | 1. Activa el entorno virtual<br>2. Verifica que MySQL esté corriendo<br>3. Revisa credenciales en `.env` |
| Frontend error de conexión | 1. Verifica que backend esté corriendo<br>2. Revisa que `VITE_WS_URL=wss://localhost:8765` en `frontend/.env`<br>3. Reinicia el frontend |
| Certificado no confiable | Normal. Click "Avanzado" → "Continuar de todos modos" |
| No funciona en móvil | 1. Obtén tu IP con `ipconfig`<br>2. Accede con `https://TU_IP:5173` desde el móvil<br>3. Acepta el certificado SSL en el navegador móvil<br>4. Abre puertos en firewall si es necesario |
| Cámara no funciona | 1. Usa HTTPS (no HTTP)<br>2. Da permisos en el navegador<br>3. Cierra otras apps de video |

---

## 📦 Estructura de Puertos

| Servicio | Puerto | URL de Acceso |
|----------|--------|---------------|
| Backend WS | 8765 | wss://localhost:8765 |
| Frontend Dev | 5173 | https://localhost:5173 |
| MySQL | 3306 | localhost:3306 |
| phpMyAdmin | 80 | http://localhost/phpmyadmin |

**Acceso desde otros dispositivos**: Cambia `localhost` por tu IP LAN (obtén con `ipconfig`).

---

## 🎯 Flujo Típico de Uso

1. **Configurar una vez** (Primera vez):
   - Instalar requisitos
   - Crear certificados
   - Configurar base de datos
   - Configurar .env en backend y frontend

2. **Cada vez que uses la app**:
   - Iniciar MySQL en XAMPP
   - Ejecutar `backend/start.bat`
   - Ejecutar `frontend/start.bat`
   - Abrir navegador

3. **Compartir con otros en tu red**:
   - Dale tu IP LAN: `192.168.1.72:5173`
   - Deben estar en la misma red WiFi
   - Deben aceptar el certificado en su navegador

---

## 🔐 Tips de Seguridad

- ✅ Cambia `JWT_SECRET` en `backend/.env`
- ✅ No compartas tu `.env` en Git
- ✅ Usa contraseñas fuertes para usuarios
- ✅ Solo para uso en red local confiable

---

**⚡ ¡Listo para chatear!** 💬🎥

¿Problemas? Consulta [GUIA_INSTALACION.md](GUIA_INSTALACION.md) o revisa los logs.
