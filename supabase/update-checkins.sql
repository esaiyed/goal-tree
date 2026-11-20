-- Daily check-ins update.
-- Run this once in Supabase: SQL Editor > New query > paste everything > Run.
-- Safe to run more than once.

alter table public.goal_trees
  add column if not exists checkins date[] not null default '{}';

alter table public.goal_trees drop constraint if exists goal_trees_checkins_len;
alter table public.goal_trees
  add constraint goal_trees_checkins_len check (coalesce(array_length(checkins, 1), 0) <= 400);

notify pgrst, 'reload schema';
