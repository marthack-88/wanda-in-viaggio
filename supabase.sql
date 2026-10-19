-- =====================================================================
--  Wanda in viaggio – preparazione del database Supabase
--  Come si usa: Supabase → SQL Editor → New query → incolla tutto → Run
--  PRIMA di eseguire: sostituisci le due email qui sotto con le vostre.
-- =====================================================================

-- 1) Chi può entrare nel diario
create table if not exists public.members (email text primary key);

insert into public.members (email) values
  (lower('mrt.fabiano@gmail.com')),
  (lower('martafab8@gmail.com'))
on conflict do nothing;

alter table public.members enable row level security;
drop policy if exists "leggo solo la mia email" on public.members;
create policy "leggo solo la mia email" on public.members
  for select to authenticated
  using (email = lower(auth.jwt() ->> 'email'));

create or replace function public.is_member() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.members where email = lower(auth.jwt() ->> 'email'));
$$;
-- la funzione serve solo agli utenti autenticati (usata dalle regole)
revoke execute on function public.is_member() from public, anon;
grant execute on function public.is_member() to authenticated;

-- 2) Viaggi e tappe
create table if not exists public.trips (
  id text primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
create table if not exists public.stops (
  id text primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.trips enable row level security;
alter table public.stops enable row level security;

drop policy if exists "solo i membri" on public.trips;
create policy "solo i membri" on public.trips
  for all to authenticated using (public.is_member()) with check (public.is_member());

drop policy if exists "solo i membri" on public.stops;
create policy "solo i membri" on public.stops
  for all to authenticated using (public.is_member()) with check (public.is_member());

-- liste condivise (la checklist di partenza)
create table if not exists public.lists (
  id text primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.lists enable row level security;
drop policy if exists "solo i membri" on public.lists;
create policy "solo i membri" on public.lists
  for all to authenticated using (public.is_member()) with check (public.is_member());

-- aggiornamenti in tempo reale tra i vostri due telefoni
do $$ begin
  begin alter publication supabase_realtime add table public.trips; exception when others then null; end;
  begin alter publication supabase_realtime add table public.stops; exception when others then null; end;
  begin alter publication supabase_realtime add table public.lists; exception when others then null; end;
end $$;

-- 3) Spazio privato per le foto
insert into storage.buckets (id, name, public)
values ('foto', 'foto', false)
on conflict (id) do nothing;

drop policy if exists "foto: membri leggono" on storage.objects;
create policy "foto: membri leggono" on storage.objects
  for select to authenticated using (bucket_id = 'foto' and public.is_member());

drop policy if exists "foto: membri caricano" on storage.objects;
create policy "foto: membri caricano" on storage.objects
  for insert to authenticated with check (bucket_id = 'foto' and public.is_member());

drop policy if exists "foto: membri modificano" on storage.objects;
create policy "foto: membri modificano" on storage.objects
  for update to authenticated using (bucket_id = 'foto' and public.is_member());

drop policy if exists "foto: membri eliminano" on storage.objects;
create policy "foto: membri eliminano" on storage.objects
  for delete to authenticated using (bucket_id = 'foto' and public.is_member());

-- Per aggiungere un'altra persona in futuro:
-- insert into public.members (email) values (lower('nuova@email.it'));
