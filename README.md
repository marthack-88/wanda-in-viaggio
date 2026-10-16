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

## Uso
- Si entra con la propria email: arriva un link, niente password.
- **Backup** (in alto) scarica un file con tutti i viaggi e le note. Fatelo ogni tanto e conservatelo.
- Per autorizzare un'altra persona: in Supabase → SQL Editor esegui
  `insert into public.members (email) values (lower('nuova@email.it'));`

## Servizi usati
Mappa © OpenStreetMap e CARTO, satellite © Esri, ricerca luoghi Nominatim (OpenStreetMap).
