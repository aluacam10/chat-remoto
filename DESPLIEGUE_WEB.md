# Despliegue remoto en Internet (Web)

Esta guía adapta este proyecto (pensado para LAN) para funcionar en Internet.

## 1) Arquitectura recomendada

- **Frontend**: hosting estático con HTTPS (Vercel, Netlify, Nginx, Azure Static Web Apps, etc.)
- **Backend WS**: servidor público con `wss://` (VPS, Render, Railway, Azure App Service/Linux, etc.)
- **Base de datos**: MySQL accesible desde backend (ideal gestionada en la nube)
- **WebRTC**: STUN + TURN para usuarios detrás de NAT/firewall

## 2) Variables de entorno

### Backend (`backend/.env`)

Ejemplo producción:

```env
MYSQL_DB=chatapp
MYSQL_USER=tu_usuario
MYSQL_PASSWORD=tu_password
MYSQL_HOST=tu-host-mysql
MYSQL_PORT=3306

JWT_SECRET=CAMBIA_ESTA_CLAVE

HOST=0.0.0.0
PORT=8765

# Certificados públicos del servidor/backend
SSL_CERT=/ruta/o/montaje/fullchain.pem
SSL_KEY=/ruta/o/montaje/privkey.pem

LOG_WS_DISCONNECTS=0
```

> En producción usa un `JWT_SECRET` largo y único.

### Frontend (`frontend/.env.production`)

```env
# Endpoint público del backend WebSocket
VITE_WS_URL=wss://api.tudominio.com:8765

# Opcional: lista de ICE servers separados por coma
# Si se omite, usa STUN públicos por defecto.
VITE_ICE_SERVERS=stun:stun.l.google.com:19302,stun:stun1.l.google.com:19302

# Recomendado para producción real: TURN
VITE_TURN_URL=turn:turn.tudominio.com:3478
VITE_TURN_USERNAME=usuario_turn
VITE_TURN_CREDENTIAL=clave_turn
```

## 3) DNS y certificados

1. Crea dominios, por ejemplo:
   - `chat.tudominio.com` (frontend)
   - `api.tudominio.com` (backend WS)
2. Apunta DNS al proveedor/servidor.
3. Configura certificados TLS válidos (Let's Encrypt o gestionados por plataforma).
4. Verifica que el backend responda por `wss://api.tudominio.com:8765`.

## 4) Puertos y red

- Abre/permite el puerto del backend (`8765`) o publícalo detrás de reverse proxy.
- Si usas Nginx/Caddy, puedes terminar TLS en proxy y reenviar al proceso Python.
- Mantén cerrado todo puerto no necesario.

## 5) Build y publicación frontend

En `frontend/`:

```bash
npm install
npm run build
```

Publica la carpeta `dist/` en tu hosting estático.

## 6) Despliegue backend

En `backend/`:

```bash
python -m venv .venv
# Windows: .\.venv\Scripts\activate
# Linux/macOS: source .venv/bin/activate
pip install -r requirements.txt
python server.py
```

Para producción, usa proceso administrado (`systemd`, `pm2`, `supervisor`, contenedor, etc.).

## 7) Checklist de validación

- Frontend abre por `https://chat.tudominio.com`
- Login funciona
- `wss` conecta sin errores de certificado
- Envío/recepción de mensajes funciona entre dos redes distintas
- Llamadas funcionan con STUN/TURN (especialmente en 4G/5G o redes corporativas)

## 8) Problemas típicos en producción

- **Conecta chat pero no llamada**: falta TURN o está bloqueado por firewall.
- **Error de certificado WS**: certificado inválido, vencido o dominio no coincide.
- **CORS/proxy/rutas**: si usas proxy, confirma upgrade de WebSocket habilitado.
- **IP fija en `.env`**: usar dominio público en `VITE_WS_URL`, no IP LAN.
