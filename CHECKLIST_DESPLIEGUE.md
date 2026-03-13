# Checklist corto de despliegue (Render / Railway / VPS)

> Si aún no tienes dominio/proveedor definido, empieza por [DESPLIEGUE_SIN_DOMINIO.md](DESPLIEGUE_SIN_DOMINIO.md).

## Antes de desplegar

- [ ] Elegir dominio para frontend (ej: `chat.tudominio.com`).
- [ ] Elegir subdominio para backend WS (ej: `api.tudominio.com`).
- [ ] Crear base MySQL remota y validar acceso desde backend.
- [ ] Configurar `.env.production` de frontend y backend.
- [ ] Definir secreto JWT fuerte (mínimo 32+ caracteres aleatorios).

## Backend (WS)

- [ ] Desplegar `backend/` en proveedor.
- [ ] Exponer puerto `8765` o usar reverse proxy con soporte WebSocket.
- [ ] Activar TLS válido (`wss://`) con certificado de dominio.
- [ ] Probar conexión WS desde navegador sin errores de certificado.

## Frontend

- [ ] Build: `npm run build` en `frontend/`.
- [ ] Publicar `frontend/dist` en hosting HTTPS.
- [ ] Verificar que `VITE_WS_URL` apunte al backend público.

## Llamadas WebRTC

- [ ] Mantener STUN configurado.
- [ ] Configurar TURN (coturn o servicio gestionado) para máxima compatibilidad entre redes.
- [ ] Probar llamada entre dos usuarios en redes diferentes (WiFi/4G).

## Prueba final

- [ ] Registro/login correcto.
- [ ] Mensajes en tiempo real funcionando.
- [ ] Llamada audio/video estable.
- [ ] Sin errores críticos en consola del navegador ni en logs del backend.
