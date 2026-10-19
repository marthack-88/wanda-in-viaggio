# Wanda in viaggio

Il diario delle nostre uscite con il Knaus BoxLife 540: viaggi, tappe sulla mappa, giorno per giorno, racconto e foto.

- **Sito**: GitHub Pages (questo repository)
- **Dati e foto**: Supabase, visibili solo alle email autorizzate

## Messa in funzione (una volta sola)

### 1. Database Supabase
1. Apri il progetto su [supabase.com](https://supabase.com) → **SQL Editor** → **New query**.
2. Incolla il contenuto di `supabase.sql`, **sostituisci le due email** con le vostre ed esegui con **Run**.

### 2. Accesso con email e password
In Supabase → **Authentication → URL Configuration**:
- **Site URL**: `https://marthack-88.github.io/wanda-in-viaggio/`
- **Redirect URLs**: aggiungi lo stesso indirizzo (serve al link "reimposta password").

Per ogni persona serve un utente con password:
- **Authentication → Users → Add user → Create new user**: email, password e spunta
  **Auto Confirm User**;
- oppure, se l'utente esiste già, dal sito: **Password dimenticata o primo accesso?** → arriva una
  mail → si sceglie la password.

Consigliato, quando gli utenti ci sono tutti: **Authentication → Sign In / Providers →
Allow new users to sign up** spento, così nessun altro può creare account.

### 3. Configurazione del sito
Nel file `config.js` inserisci **Project URL** e chiave **anon public** (Supabase → Project Settings → API).
Non usare mai la chiave `service_role`/`secret`.

### 4. Pubblicazione
Su GitHub: **Settings → Pages → Build and deployment → Deploy from a branch → `main` / `/ (root)`** → Save.
Dopo un paio di minuti il diario è su `https://marthack-88.github.io/wanda-in-viaggio/`.

## Uso
- Si entra con email e password, una volta per dispositivo: poi l'accesso resta ricordato.
- **Cambia password**: menu **⋯ → Cambia password**. Password dimenticata: dalla pagina di accesso.
- **Installare l'app**: menu **⋯ → Installa l'app** (Android e computer). Su iPhone/iPad: in Safari
  **Condividi → Aggiungi alla schermata Home**.
- **Senza rete** l'app si apre lo stesso e mostra l'ultima copia di viaggi e tappe vista su quel
  dispositivo (in sola lettura). Uscendo con **Esci** la copia viene cancellata.
- **Nuova tappa**: "Usa la mia posizione" compila luogo e coordinate dal GPS; costo e coordinate
  sono in "Altri dettagli". "Naviga" apre Google Maps verso la tappa.
- **Calendario**: tutti i giorni con Wanda, mese per mese. I giorni con una nota di diario sono
  pieni (arancio/rosa), gli altri giorni in viaggio sono chiari. Toccando un giorno si vede dove
  eravate e la nota; "Apri la tappa" porta alla tappa nella scheda Tappe.
- **Foto in blocco** (menu **⋯**, oppure scheda Foto): scegli tante foto insieme, anche di viaggi
  diversi. Ognuna va da sola nella tappa del giorno dello scatto (la più vicina, se la foto ha la
  posizione; nei giorni senza tappa, quella dove avete dormito). Prima di caricare si può cambiare
  la tappa o scegliere "Non caricare". Le foto già caricate così vengono riconosciute e saltate.
  Su iPhone conviene scegliere le foto dall'app File o da Foto: la data dello scatto resta, la
  posizione a volte no (in quel caso conta solo la data).
- **Checklist partenza** (menu **⋯**): l'elenco delle cose da controllare prima di uscire, condiviso
  tra voi. "Modifica elenco" per aggiungere o togliere voci e sezioni, "Togli le spunte" per
  ricominciare al viaggio dopo.
- **Backup** (menu **⋯**) scarica un file con tutti i viaggi e le note. Fatelo ogni tanto e conservatelo.
- Per autorizzare un'altra persona: in Supabase → SQL Editor esegui
  `insert into public.members (email) values (lower('nuova@email.it'));`
  e crea il suo utente con password (vedi sopra).

## Km e percorsi
I km sono calcolati **su strada** tra una tappa e l'altra, con **andata e ritorno da casa** (Milano,
modificabile per ogni viaggio in ⋯ → Modifica viaggio). I percorsi si calcolano con OSRM la prima volta
che si apre un viaggio e restano salvati nel viaggio; finché non sono pronti i km hanno il simbolo ≈.

## Servizi usati
Mappa e satellite © Esri (con dati OpenStreetMap), ricerca luoghi Nominatim (OpenStreetMap),
percorsi stradali OSRM (project-osrm.org).

## Aggiornare il sito
Se modifichi `index.html`, cambia anche il numero in `sw.js` (`const V = 'wanda-v1'` → `wanda-v2`…)
così l'app installata scarica la versione nuova.
