// src/services/wsClient.ts
export type WSMessage = { type: string; data: any };
type Handler = (msg: WSMessage) => void;

const LOCAL_HOSTS = new Set(["localhost", "127.0.0.1", "::1"]);

function isLocalHost(hostname: string) {
  return LOCAL_HOSTS.has(hostname);
}

function resolveWsUrl(configured: string): string {
  if (typeof window === "undefined") {
    return configured || "ws://localhost:8765";
  }

  const pageProtocol = window.location.protocol === "https:" ? "wss:" : "ws:";
  const pageHost = window.location.hostname;

  if (!configured) {
    return `${pageProtocol}//${pageHost}:8765`;
  }

  try {
    const parsed = new URL(configured);
    const configuredHost = parsed.hostname;
    const configuredProtocol = parsed.protocol === "wss:" || parsed.protocol === "ws:" ? parsed.protocol : pageProtocol;
    const hasExplicitPort = parsed.port.length > 0;

    // Si la app se abre por IP/host de red y el .env quedó con una IP vieja,
    // priorizamos el host actual de la página para evitar logins rotos en móvil.
    const shouldUsePageHost =
      !isLocalHost(pageHost) &&
      configuredHost !== pageHost;

    const finalHost = shouldUsePageHost ? pageHost : configuredHost;
    // En HTTPS nunca usar ws inseguro; en HTTP respetar el protocolo configurado.
    const finalProtocol = pageProtocol === "wss:" ? "wss:" : configuredProtocol;
    const finalPort = hasExplicitPort ? `:${parsed.port}` : "";

    return `${finalProtocol}//${finalHost}${finalPort}`;
  } catch {
    return `${pageProtocol}//${pageHost}:8765`;
  }
}

class WSClient {
  private ws: WebSocket | null = null;
  private handlers = new Set<Handler>();
  private isOpen = false;
  private url = "";
  private helloToken?: string;
  private pendingPayloads: string[] = [];
  private reconnectTimer: ReturnType<typeof setTimeout> | null = null;
  private reconnectDelayMs = 1500;
  private readonly maxReconnectDelayMs = 10000;
  private manualClose = false;

  connect(token?: string) {
    const configured = (import.meta.env.VITE_WS_URL as string) || "";
    this.url = resolveWsUrl(configured);
    this.helloToken = token;
    this.manualClose = false;

    if (this.ws && (this.ws.readyState === WebSocket.OPEN || this.ws.readyState === WebSocket.CONNECTING)) {
      return;
    }

    this.clearReconnectTimer();
    this.openSocket();
  }

  private openSocket() {
    this.isOpen = false;
    this.ws = new WebSocket(this.url);

    this.ws.onopen = () => {
      this.isOpen = true;
      this.reconnectDelayMs = 1500;
      console.log("[WS] connected:", this.url);

      if (this.helloToken) {
        this.send("hello", { token: this.helloToken });
      }

      this.flushPending();
    };

    this.ws.onmessage = (ev) => {
      try {
        const msg: WSMessage = JSON.parse(ev.data);
        this.handlers.forEach((h) => h(msg));
      } catch {
        console.log("[WS] invalid message:", ev.data);
      }
    };

    this.ws.onclose = () => {
      this.isOpen = false;
      this.ws = null;
      console.log("[WS] closed");

      if (!this.manualClose) {
        this.scheduleReconnect();
      }
    };

    this.ws.onerror = (e) => {
      console.log("[WS] error:", e);
    };
  }

  private scheduleReconnect() {
    if (this.reconnectTimer || !this.url) return;

    this.reconnectTimer = setTimeout(() => {
      this.reconnectTimer = null;
      this.openSocket();
      this.reconnectDelayMs = Math.min(this.reconnectDelayMs * 2, this.maxReconnectDelayMs);
    }, this.reconnectDelayMs);

    console.log("[WS] reconnect scheduled in", this.reconnectDelayMs, "ms");
  }

  private clearReconnectTimer() {
    if (!this.reconnectTimer) return;
    clearTimeout(this.reconnectTimer);
    this.reconnectTimer = null;
  }

  on(handler: Handler) {
    this.handlers.add(handler);
    return () => this.handlers.delete(handler);
  }

  send(type: string, data: any) {
    const payload = JSON.stringify({ type, data });

    if (this.ws && this.ws.readyState === WebSocket.OPEN && this.isOpen) {
      this.ws.send(payload);
      return;
    }

    // Si el socket no está listo (CONNECTING/CLOSED), guarda y envía al reconectar.
    this.pendingPayloads.push(payload);
    if (this.pendingPayloads.length > 200) {
      this.pendingPayloads.shift();
    }

    if (!this.ws || this.ws.readyState === WebSocket.CLOSED) {
      this.connect(this.helloToken);
    }
  }

  private flushPending() {
    if (!this.ws || this.ws.readyState !== WebSocket.OPEN) return;
    if (!this.pendingPayloads.length) return;

    const queue = [...this.pendingPayloads];
    this.pendingPayloads = [];

    for (const payload of queue) {
      try {
        this.ws.send(payload);
      } catch {
        // Si falla un envío, reencolar para próximo reconnect.
        this.pendingPayloads.unshift(payload);
        break;
      }
    }
  }

  close() {
    this.manualClose = true;
    this.clearReconnectTimer();
    this.isOpen = false;
    this.pendingPayloads = [];
    try {
      this.ws?.close();
    } catch {}
  }
}

export const wsClient = new WSClient();
