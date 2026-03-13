# Despliegue rápido sin dominio propio (Render / Railway)

Esta opción usa URLs temporales del proveedor (subdominios automáticos).

## Opción recomendada para empezar hoy

- **Backend WS**: Render o Railway (Python service)
- **Frontend**: Vercel o Netlify (sitio estático)
- **DB**: MySQL remoto (Railway MySQL, PlanetScale, Aiven, etc.)

---

## 1) Backend en Render (sin dominio)

1. Sube el repo a GitHub.
2. En Render: **New +** → **Web Service** → conecta repo.
3. Configura:
   - **Root Directory**: `backend`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `python server.py`
4. Variables de entorno (mínimas):
   - `MYSQL_DB`
   - `MYSQL_USER`
   - `MYSQL_PASSWORD`
   - `MYSQL_HOST`
   - `MYSQL_PORT`
   - `JWT_SECRET`
   - `HOST=0.0.0.0`
   - `PORT` (Render la define automáticamente)
5. TLS:
   - Si Render termina TLS por ti y te da URL `https://xxxx.onrender.com`, usa en frontend `wss://xxxx.onrender.com`.
   - Si tu servicio exige cert local en app (`SSL_CERT`/`SSL_KEY`), deja esos valores vacíos para que inicie en `ws` interno detrás de proxy TLS del proveedor.

Resultado esperado: URL pública tipo `https://mi-backend.onrender.com`.
Para frontend usarás: `wss://mi-backend.onrender.com`.

---

## 2) Backend en Railway (alternativa)

1. New Project → Deploy from GitHub.
2. Selecciona carpeta `backend` como servicio Python.
3. Comandos:
   - Build: `pip install -r requirements.txt`
   - Start: `python server.py`
4. Define mismas variables (`MYSQL_*`, `JWT_SECRET`, `HOST`, `PORT`).
5. Usa la URL pública Railway para `VITE_WS_URL` en formato `wss://...`.

---

## 3) Frontend en Vercel o Netlify

1. Conecta el repo.
2. Configura **Root Directory** = `frontend`.
3. Build command = `npm run build`.
4. Output directory = `dist`.
5. Environment variable:
   - `VITE_WS_URL=wss://<tu-backend-publico>`
   - Opcional TURN:
     - `VITE_TURN_URL`
     - `VITE_TURN_USERNAME`
     - `VITE_TURN_CREDENTIAL`

---

## 4) Valor exacto de `VITE_WS_URL` sin dominio propio

- Si tu backend es `https://mi-backend.onrender.com` → usa `wss://mi-backend.onrender.com`
- Si tu backend es `https://mi-backend.up.railway.app` → usa `wss://mi-backend.up.railway.app`

> No pongas puerto si el proveedor no te lo pide explícitamente.

---

## 5) Limitaciones reales sin dominio propio

- Sí funciona para login/chat remoto entre redes.
- Llamadas WebRTC pueden fallar en algunas redes si no configuras TURN.
- URLs del proveedor pueden cambiar según plan/configuración.

---

## 6) Prueba mínima final

- Abre frontend público en dos dispositivos/redes distintas.
- Crea dos usuarios y valida login/mensajes.
- Inicia llamada y verifica audio/video.
- Si falla llamada en redes distintas: configurar TURN.
