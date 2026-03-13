# 🚀 Guía de Instalación Paso a Paso - Chat Local

## 📋 Requisitos Previos

Antes de comenzar, verifica que tengas instalado:

### 1. Verificar Node.js y npm
```powershell
node -v    # Debe mostrar v18 o superior
npm -v     # Debe mostrar v9 o superior
```
Si no lo tienes: [Descargar Node.js](https://nodejs.org/)

### 2. Verificar Python
```powershell
python --version    # Debe mostrar Python 3.11 o superior
```
Si no lo tienes: [Descargar Python](https://www.python.org/downloads/)

### 3. MySQL (XAMPP recomendado)
- Descarga [XAMPP](https://www.apachefriends.org/es/index.html)
- Instálalo y abre el Panel de Control de XAMPP
- Inicia el módulo **MySQL**

### 4. Chocolatey (para instalar mkcert)
```powershell
# Ejecuta PowerShell como Administrador y corre:
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

---

## 📦 PASO 1: Configuración para Cualquier Red

La aplicación está configurada para usar **localhost**, por lo que funcionará en **cualquier red** sin necesidad de reconfiguración.

✅ **Ventaja**: No importa si cambias de red, la aplicación siempre funcionará en tu PC.

**Opcional - Acceso desde otros dispositivos:**
Si quieres acceder desde tu móvil/tablet, ejecuta:

```powershell
ipconfig
```

Busca **"Dirección IPv4"** (ej: `192.168.1.72`) - la necesitarás solo para acceso desde otros dispositivos.

---

## 🔐 PASO 2: Generar Certificados SSL

Para que funcionen las videollamadas, necesitas HTTPS/WSS.

### 2.1 Instalar mkcert

```powershell
# PowerShell como Administrador
choco install mkcert -y
mkcert -install
```

### 2.2 Generar certificados para localhost

```powershell
# En la raíz del proyecto
cd c:\Users\reric\OneDrive\Documentos\chat-main

# Crear carpeta para certificados (si no existe)
mkdir certs

# Generar certificados para localhost
mkcert -key-file certs\local-key.pem -cert-file certs\local.pem localhost 127.0.0.1 ::1

# Verificar que se crearon
dir certs
```

Debes ver dos archivos:
- `local.pem` (certificado)
- `local-key.pem` (llave privada)

---

## 🗄️ PASO 3: Configurar Base de Datos

### 3.1 Abrir phpMyAdmin

1. Asegúrate que MySQL está corriendo en XAMPP
2. Abre tu navegador y ve a: http://localhost/phpmyadmin

### 3.2 Crear base de datos

Opción A - **Interfaz gráfica:**
1. Click en "Nueva" en el panel izquierdo
2. Nombre: `chatapp`
3. Cotejamiento: `utf8mb4_unicode_ci`
4. Click "Crear"

Opción B - **Usando SQL:**
1. Click en la pestaña "SQL"
2. Copia y pega el contenido del archivo `database.sql`
3. Click "Continuar"

```powershell
# O desde la terminal:
cd c:\Users\reric\OneDrive\Documentos\chat-main
mysql -u root -p < database.sql
# (Presiona Enter si no tiene contraseña)
```

### 3.3 Verificar tablas creadas

En phpMyAdmin, debes ver la base de datos `chatapp` con 4 tablas:
- ✅ users
- ✅ chats
- ✅ chat_members
- ✅ messages

---

## 🐍 PASO 4: Configurar Backend (Python)

### 4.1 Ir a la carpeta backend

```powershell
cd c:\Users\reric\OneDrive\Documentos\chat-main\backend
```

### 4.2 Crear entorno virtual

```powershell
python -m venv .venv
```

### 4.3 Activar entorno virtual

```powershell
.\.venv\Scripts\activate
```

Tu prompt debe cambiar a mostrar `(.venv)` al inicio.

### 4.4 Instalar dependencias

```powershell
pip install -r requirements.txt
```

Esto instalará:
- websockets
- PyJWT
- bcrypt
- mysql-connector-python
- python-dotenv

### 4.5 Configurar variables de entorno

```powershell
# Copiar archivo de ejemplo
copy .env.example .env

# Editar el archivo .env
notepad .env
```

Verifica que contenga:

```env
MYSQL_DB=chatapp
MYSQL_USER=root
MYSQL_PASSWORD=
MYSQL_HOST=127.0.0.1
MYSQL_PORT=3306

JWT_SECRET=mi_super_secreto_cambiar_en_produccion_12345

HOST=0.0.0.0
PORT=8765

SSL_CERT=../certs/local.pem
SSL_KEY=../certs/local-key.pem

LOG_WS_DISCONNECTS=0
```

**IMPORTANTE:** Si tu MySQL tiene contraseña, agrégala en `MYSQL_PASSWORD`.

### 4.6 Probar conexión a base de datos

```powershell
python -c "import db; print('Conexión exitosa')"
```

Si ves "Conexión exitosa", ¡todo está bien! ✅

### 4.7 Iniciar servidor backend

```powershell
python server.py
```

Debes ver:

```
WS server: wss://0.0.0.0:8765
```

**¡Déjalo corriendo!** Abre otra terminal para el frontend.

---

## ⚛️ PASO 5: Configurar Frontend (React)

### 5.1 Abrir NUEVA terminal

Abre otra ventana de PowerShell o CMD (sin cerrar el backend).

```powershell
cd c:\Users\reric\OneDrive\Documentos\chat-main\frontend
```

### 5.2 Instalar dependencias

```powershell
npm install
```

Esto puede tardar 2-3 minutos. Instalará React, Vite, shadcn/ui y todas las dependencias.

### 5.3 Configurar variables de entorno

```powershell
# Copiar archivo de ejemplo
copy .env.example .env

# Editar el archivo
notepad .env
```

Contenido:

```env
VITE_WS_URL=wss://localhost:8765
```

**Nota:** Usando localhost, la aplicación funciona en cualquier red sin reconfiguración.

### 5.4 Iniciar servidor de desarrollo

```powershell
npm run dev
```

Verás algo como:

```
  VITE v5.x.x  ready in xxx ms

  ➜  Local:   https://localhost:5173/
  ➜  Network: https://192.168.1.72:5173/
```

---

## 🌐 PASO 6: Abrir la Aplicación

### 6.1 En tu PC

Abre tu navegador (Chrome recomendado) y ve a:

```
https://localhost:5173
```

⚠️ **Advertencia de Seguridad:** El navegador dirá que el certificado no es confiable. Esto es normal con certificados locales.

**En Chrome:**
1. Click en "Avanzado"
2. Click en "Continuar a localhost (no seguro)"

**En Firefox:**
1. Click en "Avanzado"
2. Click en "Aceptar el riesgo y continuar"

### 6.2 Desde tu móvil/tablet (en la misma red WiFi)

Para acceder desde otros dispositivos:

1. Obtén tu IP con `ipconfig` (ej: `192.168.1.72`)
2. En el móvil, abre el navegador y ve a: `https://TU_IP:5173`
3. Acepta el certificado como en el punto anterior

**Nota:** Este paso es opcional. La aplicación siempre funciona en tu PC sin importar la red.

---

## ✅ PASO 7: Probar la Aplicación

### 7.1 Registrar primer usuario

1. Click en "Registrarse"
2. Completa el formulario:
   - Nombre: `Juan`
   - Usuario: `juan`
   - Email: `juan@test.com`
   - Contraseña: `123456`
3. Click "Registrarse"

Debes entrar automáticamente al chat.

### 7.2 Registrar segundo usuario (otra ventana/dispositivo)

1. Abre una ventana incógnito o usa otro dispositivo
2. Registra otro usuario:
   - Nombre: `María`
   - Usuario: `maria`
   - Email: `maria@test.com`
   - Contraseña: `123456`

### 7.3 Crear chat directo

Desde la cuenta de Juan:
1. Click en el botón "+" (abajo a la derecha)
2. Selecciona "Chat directo"
3. Busca: `maria`
4. Click en "Crear chat"

### 7.4 Enviar mensajes

Escribe un mensaje y presiona Enter. Debes verlo en ambas ventanas en tiempo real. ✅

### 7.5 Probar videollamada

1. En el chat con María, click en el ícono de video (arriba a la derecha)
2. Permite acceso a cámara y micrófono cuando lo pida
3. En la ventana de María, debe aparecer una notificación de llamada entrante
4. Click en "Aceptar" (ícono de teléfono verde)

¡Debes ver video en ambos lados! 🎥

---

## 🔧 Solución de Problemas Comunes

### ❌ "Backend no conecta"

**Causa:** MySQL no está corriendo.

**Solución:**
1. Abre el Panel de Control de XAMPP
2. Inicia el módulo MySQL
3. Reinicia el backend: `python server.py`

---

### ❌ "WebSocket error" en el navegador

**Causa:** El backend no está corriendo o la URL está mal.

**Solución:**
1. Verifica que `python server.py` esté corriendo
2. Revisa el archivo `frontend/.env` con tu IP correcta
3. Reinicia el frontend: `Ctrl+C` y luego `npm run dev`

---

### ❌ "No se puede acceder desde el móvil"

**Causa:** Firewall de Windows bloqueando.

**Solución:**
```powershell
# PowerShell como Administrador
New-NetFirewallRule -DisplayName "Chat Backend" -Direction Inbound -LocalPort 8765 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Chat Frontend" -Direction Inbound -LocalPort 5173 -Protocol TCP -Action Allow
```

---

### ❌ "Error de certificado persistente"

**Solución:**
1. En Chrome, escribe en la barra: `chrome://flags/#allow-insecure-localhost`
2. Cambia a "Enabled"
3. Reinicia Chrome

---

### ❌ "La cámara no funciona"

**Causas posibles:**
1. No estás usando HTTPS (debe ser `https://`, no `http://`)
2. No diste permisos al navegador
3. Otra aplicación está usando la cámara

**Solución:**
- Verifica la URL comience con `https://`
- Click en el candado en la barra de direcciones → Permisos → Permitir cámara y micrófono
- Cierra otras apps de video (Zoom, Teams, etc.)

---

### ❌ "ImportError: No module named 'websockets'"

**Causa:** No activaste el entorno virtual.

**Solución:**
```powershell
cd backend
.\.venv\Scripts\activate
python server.py
```

---

## 📱 Construir para Producción (Opcional)

Si quieres generar archivos optimizados:

```powershell
cd frontend
npm run build
```

Los archivos se generarán en `frontend/dist/`.

Para servirlos con HTTPS:

```powershell
npx serve -s dist -l 443 --ssl-cert ../certs/local.pem --ssl-key ../certs/local-key.pem
```

---

## 📊 Resumen de Puertos

| Servicio | Puerto | URL |
|----------|--------|-----|
| Backend WebSocket | 8765 | wss://localhost:8765 |
| Frontend Dev | 5173 | https://localhost:5173 |
| MySQL | 3306 | localhost:3306 |
| phpMyAdmin | 80 | http://localhost/phpmyadmin |

**Acceso desde otros dispositivos:** Cambia `localhost` por tu IP LAN (obtén con `ipconfig`).

---

## 🎉 ¡Listo!

Tu aplicación de chat está funcionando. Puedes:

- ✅ Registrar múltiples usuarios
- ✅ Chatear en tiempo real
- ✅ Crear chats directos y grupales
- ✅ Hacer videollamadas
- ✅ Acceder desde móviles en tu red WiFi

## 📚 Próximos Pasos

1. Lee [README.md](README.md) para entender la arquitectura
2. Lee [backend/README.md](backend/README.md) para detalles del backend
3. Lee [frontend/README.md](frontend/README.md) para detalles del frontend

---

## 🆘 ¿Problemas?

Si algo no funciona, verifica:

1. ✅ MySQL corriendo en XAMPP
2. ✅ Backend corriendo: `python server.py`
3. ✅ Frontend corriendo: `npm run dev`
4. ✅ Usando HTTPS (no HTTP)
5. ✅ IP correcta en `frontend/.env`
6. ✅ Firewall permite puertos 8765 y 5173

**Logs útiles:**
- Backend: Ver la consola donde corre `python server.py`
- Frontend: Abrir DevTools del navegador (F12) → Console
- Base de datos: Revisar phpMyAdmin

---

¡Disfruta tu chat local! 💬🎥
