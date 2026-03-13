# 🔒 Configurar IP Estática (Recomendado)

## ¿Por qué necesitas esto?

Si tu IP es dinámica, puede cambiar y romper tu configuración. Con IP estática, siempre tendrás la misma IP `192.168.1.72`.

---

## Método 1: En Windows (Recomendado - Más fácil)

### Paso 1: Abrir Configuración de Red

```powershell
# Abre: Panel de Control > Centro de redes y recursos compartidos
# O ejecuta:
ncpa.cpl
```

### Paso 2: Configurar IP Estática

1. Clic derecho en tu adaptador WiFi/Ethernet → **Propiedades**
2. Doble clic en **"Protocolo de Internet versión 4 (TCP/IPv4)"**
3. Selecciona **"Usar la siguiente dirección IP"**
4. Ingresa:
   ```
   Dirección IP: 192.168.1.72
   Máscara de subred: 255.255.255.0
   Puerta de enlace predeterminada: 192.168.1.1  (la IP de tu router)
   
   DNS preferido: 8.8.8.8  (Google DNS)
   DNS alternativo: 8.8.4.4
   ```
5. Click **Aceptar** en todas las ventanas

### Paso 3: Verificar

```powershell
ipconfig
```

Deberías ver tu IP fija en `192.168.1.72`.

---

## Método 2: Reserva DHCP en el Router (Más avanzado)

Esto hace que el router siempre te asigne la misma IP.

### Paso 1: Obtener tu MAC Address

```powershell
ipconfig /all
```

Busca **"Dirección física"** de tu adaptador (ej: `AA-BB-CC-DD-EE-FF`)

### Paso 2: Acceder a tu Router

1. Abre navegador y ve a: `http://192.168.1.1` (o la IP de tu router)
2. Ingresa usuario/contraseña (usualmente `admin/admin` o está en la etiqueta del router)

### Paso 3: Configurar Reserva DHCP

Esto varía por router, pero generalmente:

1. Busca sección **"DHCP"** o **"LAN"**
2. Encuentra **"Reservas DHCP"** o **"Static IP Allocation"**
3. Agrega nueva reserva:
   - **MAC Address**: Tu dirección física
   - **IP Address**: `192.168.1.72`
4. Guarda y reinicia el router

---

## ✅ Ventajas de IP Estática

- ✅ No necesitas reconfigurar nada
- ✅ Los certificados SSL siguen funcionando
- ✅ El frontend siempre conecta correctamente
- ✅ Puedes crear accesos directos con la IP

---

## 📱 Para usar en otra red (Trabajo, Amigo, etc.)

Si llevas tu laptop a otra red, necesitas:

### Opción A: Script de Configuración Rápida

Crea `cambiar_ip.bat`:

```batch
@echo off
set /p NUEVA_IP="Ingresa tu nueva IP (ej: 192.168.0.50): "

echo Regenerando certificados...
cd certs
mkcert -key-file local-key.pem -cert-file local.pem %NUEVA_IP% localhost 127.0.0.1

echo Actualizando frontend/.env...
echo VITE_WS_URL=wss://%NUEVA_IP%:8765 > ..\frontend\.env

echo.
echo ¡Listo! Ahora puedes ejecutar start.bat en backend y frontend
pause
```

### Opción B: Usar localhost únicamente

Si solo vas a usar la app en tu propia PC (no desde móvil):

**frontend/.env**:
```env
VITE_WS_URL=wss://localhost:8765
```

**Regenerar certificados**:
```powershell
cd certs
mkcert -key-file local-key.pem -cert-file local.pem localhost 127.0.0.1
```

Con esto funcionará en **cualquier red**, pero solo desde tu PC (no desde otros dispositivos).

---

## 🆘 Si tu IP cambia y no funciona

1. **Verificar nueva IP**:
   ```powershell
   ipconfig
   ```

2. **Regenerar certificados**:
   ```powershell
   cd c:\Users\reric\OneDrive\Documentos\chat-main\certs
   mkcert -key-file local-key.pem -cert-file local.pem TU_NUEVA_IP localhost 127.0.0.1
   ```

3. **Actualizar frontend/.env**:
   ```env
   VITE_WS_URL=wss://TU_NUEVA_IP:8765
   ```

4. **Reiniciar backend y frontend**

---

## 💡 Resumen

| Situación | Solución |
|-----------|----------|
| **Uso solo en esta red** | Configura IP estática en Windows |
| **Uso en varias redes** | Usa `localhost` en vez de IP |
| **Uso LAN + móvil** | IP estática + abrir puertos firewall |
| **IP cambió** | Regenera certificados + actualiza .env |
