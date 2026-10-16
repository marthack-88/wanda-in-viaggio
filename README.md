# Wanda in viaggio

Il diario delle nostre uscite con il Boxlife 540: viaggi, tappe sulla mappa, giorno per giorno, racconto e foto.

- **Sito**: GitHub Pages (questo repository)
- **Dati e foto**: Supabase, visibili solo alle email autorizzate

## Messa in funzione (una volta sola)

### 1. Database Supabase
1. Apri il progetto su [supabase.com](https://supabase.com) → **SQL Editor** → **New query**.
2. Incolla il contenuto di `supabase.sql`, **sostituisci le due email** con le vostre ed esegui con **Run**.

### 2. Login via email
In Supabase → **Authentication → URL Configuration**:
- **Site URL**: `https://marthack-88.github.io/wanda-in-viaggio/`
- **Redirect URLs**: aggiungi lo stesso indirizzo.

### 3. Configurazione del sito
Nel file `config.js` inserisci **Project URL** e chiave **anon public** (Supabase → Project Settings → API).
Non usare mai la chiave `service_role`/`secret`.

### 4. Pubblicazione
Su GitHub: **Settings → Pages → Build and deployment → Deploy from a branch → `main` / `/ (root)`** → Save.
Dopo un paio di minuti il diario è su `https://marthack-88.github.io/wanda-in-viaggio/`.

### 5. Codice di accesso nella mail (consigliato per l'app su iPhone)
Su iPhone l'app installata e Safari non condividono l'accesso: il link della mail si apre in Safari.
Per entrare anche dall'app, aggiungi il codice alla mail:
Supabase → **Authentication → Emails → Magic Link** → nel testo aggiungi ad esempio
`<p>Oppure inserisci questo codice: <b>{{ .Token }}</b></p>` → Save.

## Uso
- Si entra con la propria email: arriva un link (e, se attivato, un codice), niente password.
- **Installare l'app**: menu **⋯ → Installa l'app** (Android e computer). Su iPhone/iPad: in Safari
  **Condividi → Aggiungi alla schermata Home**.
- **Senza rete** l'app si apre lo stesso e mostra l'ultima copia di viaggi e tappe vista su quel
  dispositivo (in sola lettura). Uscendo con **Esci** la copia viene cancellata.
- **Nuova tappa**: "Usa la mia posizione" compila luogo e coordinate dal GPS; costo e coordinate
  sono in "Altri dettagli". "Naviga" apre Google Maps verso la tappa.
- **Backup** (in alto) scarica un file con tutti i viaggi e le note. Fatelo ogni tanto e conservatelo.
- Per autorizzare un'altra persona: in Supabase → SQL Editor esegui
  `insert into public.members (email) values (lower('nuova@email.it'));`

## Servizi usati
Mappa e satellite © Esri (con dati OpenStreetMap), ricerca luoghi Nominatim (OpenStreetMap).

## Aggiornare il sito
Se modifichi `index.html`, cambia anche il numero in `sw.js` (`const V = 'wanda-v1'` → `wanda-v2`…)
così l'app installata scarica la versione nuova.
