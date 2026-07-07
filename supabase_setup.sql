-- Run this in Supabase → SQL Editor → New Query → paste this whole thing → Run

create table if not exists te_data (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  key text not null,
  value jsonb not null,
  updated_at timestamptz not null default now(),
  unique (user_id, key)
);

alter table te_data enable row level security;

create policy "Users can read their own data"
  on te_data for select
  using (auth.uid() = user_id);

create policy "Users can insert their own data"
  on te_data for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own data"
  on te_data for update
  using (auth.uid() = user_id);

create policy "Users can delete their own data"
  on te_data for delete
  using (auth.uid() = user_id);
