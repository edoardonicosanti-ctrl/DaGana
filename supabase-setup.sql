-- Tabella per le schede tecniche di ChefCost Da Gana
create table if not exists public.recipes (
  user_id    uuid not null default auth.uid() references auth.users(id) on delete cascade,
  id         text not null,
  data       jsonb not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

-- Ogni utente vede e modifica solo le proprie schede
alter table public.recipes enable row level security;

create policy "recipes_select_own" on public.recipes
  for select to authenticated using (auth.uid() = user_id);

create policy "recipes_insert_own" on public.recipes
  for insert to authenticated with check (auth.uid() = user_id);

create policy "recipes_update_own" on public.recipes
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "recipes_delete_own" on public.recipes
  for delete to authenticated using (auth.uid() = user_id);
