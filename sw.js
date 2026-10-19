// Service worker di "Wanda in viaggio": l'app si apre anche senza rete.
// - pagina e config: prima la rete (così gli aggiornamenti arrivano subito), poi la copia salvata
// - librerie, caratteri, mappe e foto già viste: copia salvata, altrimenti rete
// - dati e accesso Supabase: sempre dalla rete (la copia dei dati la tiene la pagina)
const V = 'wanda-v8';
const FOTO = 'wanda-foto';
const MAPPA = 'wanda-mappa';
const SHELL = [
  './', 'index.html', 'config.js', 'manifest.webmanifest', 'icons/icon-192.png', 'icons/icon-512.png',
  'https://unpkg.com/leaflet@1.9.4/dist/leaflet.css',
  'https://unpkg.com/leaflet@1.9.4/dist/leaflet.js',
  'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2.45.4/dist/umd/supabase.min.js'
];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(V)
    .then(c => Promise.all(SHELL.map(u => c.add(u).catch(() => {}))))
    .then(() => self.skipWaiting()));
});

self.addEventListener('activate', e => {
  e.waitUntil(caches.keys()
    .then(ks => Promise.all(ks.filter(k => k !== V && k !== FOTO && k !== MAPPA).map(k => caches.delete(k))))
    .then(() => self.clients.claim()));
});

// tiene al massimo "max" elementi, togliendo i più vecchi
async function trim(name, max) {
  const c = await caches.open(name);
  const ks = await c.keys();
  for (let i = 0; i < ks.length - max; i++) await c.delete(ks[i]);
}

async function networkFirst(req) {
  const c = await caches.open(V);
  try {
    const r = await fetch(req);
    if (r.ok) c.put(req, r.clone());
    return r;
  } catch (e) {
    const m = await c.match(req, { ignoreSearch: true });
    if (m) return m;
    if (req.mode === 'navigate') {
      const i = await c.match('index.html');
      if (i) return i;
    }
    throw e;
  }
}

// per foto e mappe chiedo una risposta CORS: le risposte "opache" occupano troppo spazio in cache
async function cacheFirst(req, name, max, cors) {
  const c = await caches.open(name);
  const m = await c.match(req.url);
  if (m) return m;
  let r;
  try { r = await fetch(cors ? new Request(req.url, { mode: 'cors', credentials: 'omit' }) : req); }
  catch (e) { if (!cors) throw e; return fetch(req); }
  if (r.ok) {
    c.put(req.url, r.clone());
    if (max) trim(name, max);
  }
  return r;
}

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const u = new URL(req.url);
  if (u.origin === location.origin) { e.respondWith(networkFirst(req)); return; }
  if (u.hostname.endsWith('.supabase.co')) {
    if (u.pathname.startsWith('/storage/v1/object/sign/')) e.respondWith(cacheFirst(req, FOTO, 400, true));
    return;
  }
  if (u.hostname === 'server.arcgisonline.com') { e.respondWith(cacheFirst(req, MAPPA, 1500, true)); return; }
  if (['unpkg.com', 'cdn.jsdelivr.net', 'fonts.googleapis.com', 'fonts.gstatic.com'].includes(u.hostname)) {
    e.respondWith(cacheFirst(req, V));
  }
});
