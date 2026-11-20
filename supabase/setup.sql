-- Goal tree database setup.
-- Run this once in Supabase: SQL Editor > New query > paste everything > Run.

create table if not exists public.goal_trees (
  user_id    uuid primary key references auth.users (id) on delete cascade,
  goal       text not null default '' check (char_length(goal) <= 300),
  fruits     text[] not null default '{}'
             check (coalesce(array_length(fruits, 1), 0) <= 6
                    and char_length(array_to_string(fruits, '')) <= 600),
  updated_at timestamptz not null default now()
);

-- Row Level Security: each signed-in person can only see and change their own row.
alter table public.goal_trees enable row level security;

drop policy if exists "Read own tree"   on public.goal_trees;
drop policy if exists "Insert own tree" on public.goal_trees;
drop policy if exists "Update own tree" on public.goal_trees;
drop policy if exists "Delete own tree" on public.goal_trees;

create policy "Read own tree" on public.goal_trees
  for select to authenticated using ((select auth.uid()) = user_id);

create policy "Insert own tree" on public.goal_trees
  for insert to authenticated with check ((select auth.uid()) = user_id);

create policy "Update own tree" on public.goal_trees
  for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "Delete own tree" on public.goal_trees
  for delete to authenticated using ((select auth.uid()) = user_id);

grant select, insert, update, delete on public.goal_trees to authenticated;
revoke all on public.goal_trees from anon;

-- Daily check-ins (also in update-checkins.sql for projects set up earlier).
alter table public.goal_trees
  add column if not exists checkins date[] not null default '{}';
alter table public.goal_trees drop constraint if exists goal_trees_checkins_len;
alter table public.goal_trees
  add constraint goal_trees_checkins_len check (coalesce(array_length(checkins, 1), 0) <= 400);
notify pgrst, 'reload schema';
