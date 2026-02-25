-- Extensions
create extension if not exists "pgcrypto";

-- Enums
create type public.swipe_action as enum ('like', 'pass');
create type public.verification_status as enum ('pending', 'verified', 'rejected');
create type public.case_status as enum ('open', 'under_review', 'resolved');
create type public.subscription_status as enum ('inactive', 'active', 'past_due', 'canceled');

-- Tables
create table if not exists public.users_profile (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  bio text default '',
  prompts jsonb default '[]'::jsonb,
  interests text[] default '{}',
  age int,
  gender text,
  location text,
  is_banned boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.photos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users_profile(id) on delete cascade,
  storage_path text not null,
  is_primary boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.preferences (
  user_id uuid primary key references public.users_profile(id) on delete cascade,
  min_age int default 18,
  max_age int default 99,
  max_distance_km int default 100,
  interested_in text[] default '{}',
  updated_at timestamptz not null default now()
);

create table if not exists public.swipes (
  id uuid primary key default gen_random_uuid(),
  swiper_id uuid not null references public.users_profile(id) on delete cascade,
  target_user_id uuid not null references public.users_profile(id) on delete cascade,
  action public.swipe_action not null,
  created_at timestamptz not null default now(),
  unique(swiper_id, target_user_id)
);

create table if not exists public.matches (
  id uuid primary key default gen_random_uuid(),
  user_a uuid not null references public.users_profile(id) on delete cascade,
  user_b uuid not null references public.users_profile(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique(user_a, user_b),
  check (user_a <> user_b)
);

create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  match_id uuid not null references public.matches(id) on delete cascade,
  sender_id uuid not null references public.users_profile(id) on delete cascade,
  content text not null,
  flagged boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid not null references public.users_profile(id) on delete cascade,
  reported_user_id uuid not null references public.users_profile(id) on delete cascade,
  reason text not null,
  details text,
  created_at timestamptz not null default now()
);

create table if not exists public.moderation_cases (
  id uuid primary key default gen_random_uuid(),
  report_id uuid references public.reports(id) on delete set null,
  subject_user_id uuid not null references public.users_profile(id) on delete cascade,
  status public.case_status not null default 'open',
  assigned_admin uuid,
  resolution_notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.verification_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users_profile(id) on delete cascade,
  selfie_path text not null,
  status public.verification_status not null default 'pending',
  reviewed_by uuid,
  review_notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.audit_logs (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid,
  entity_type text not null,
  entity_id uuid,
  action text not null,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table if not exists public.subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references public.users_profile(id) on delete cascade,
  stripe_customer_id text,
  stripe_subscription_id text,
  plan text not null default 'free',
  status public.subscription_status not null default 'inactive',
  current_period_end timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Helper functions
create or replace function public.is_match_member(p_match_id uuid, p_user_id uuid)
returns boolean language sql stable as $$
  select exists (
    select 1 from public.matches m
    where m.id = p_match_id and (m.user_a = p_user_id or m.user_b = p_user_id)
  );
$$;

create or replace function public.message_allowed(p_sender_id uuid)
returns boolean language plpgsql stable as $$
declare
  sent_count int;
begin
  select count(*) into sent_count
  from public.messages
  where sender_id = p_sender_id
    and created_at > now() - interval '1 minute';

  return sent_count < 20;
end;
$$;

create or replace function public.create_match_if_mutual()
returns trigger language plpgsql as $$
declare
  reverse_like boolean;
  a uuid;
  b uuid;
begin
  if NEW.action <> 'like' then
    return NEW;
  end if;

  select exists (
    select 1 from public.swipes
    where swiper_id = NEW.target_user_id
      and target_user_id = NEW.swiper_id
      and action = 'like'
  ) into reverse_like;

  if reverse_like then
    a := least(NEW.swiper_id, NEW.target_user_id);
    b := greatest(NEW.swiper_id, NEW.target_user_id);
    insert into public.matches(user_a, user_b)
    values (a, b)
    on conflict do nothing;
  end if;

  return NEW;
end;
$$;

create trigger trg_create_match
after insert on public.swipes
for each row execute function public.create_match_if_mutual();

create or replace function public.flag_message_content()
returns trigger language plpgsql as $$
begin
  if NEW.content ~* '(scam|bitcoin|wire transfer|explicit)' then
    NEW.flagged := true;
  end if;

  if not public.message_allowed(NEW.sender_id) then
    raise exception 'Message rate limit exceeded';
  end if;

  return NEW;
end;
$$;

create trigger trg_flag_messages
before insert on public.messages
for each row execute function public.flag_message_content();

-- RLS
alter table public.users_profile enable row level security;
alter table public.photos enable row level security;
alter table public.preferences enable row level security;
alter table public.swipes enable row level security;
alter table public.matches enable row level security;
alter table public.messages enable row level security;
alter table public.reports enable row level security;
alter table public.moderation_cases enable row level security;
alter table public.verification_requests enable row level security;
alter table public.audit_logs enable row level security;
alter table public.subscriptions enable row level security;

create policy "users read own profile" on public.users_profile
for select using (id = auth.uid());
create policy "users write own profile" on public.users_profile
for all using (id = auth.uid()) with check (id = auth.uid());

create policy "users own photos" on public.photos
for all using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy "users own preferences" on public.preferences
for all using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy "users own swipes" on public.swipes
for all using (swiper_id = auth.uid()) with check (swiper_id = auth.uid());

create policy "users own matches" on public.matches
for select using (user_a = auth.uid() or user_b = auth.uid());

create policy "users own messages" on public.messages
for select using (public.is_match_member(match_id, auth.uid()));
create policy "users insert messages" on public.messages
for insert with check (sender_id = auth.uid() and public.is_match_member(match_id, auth.uid()));

create policy "users own reports" on public.reports
for insert with check (reporter_id = auth.uid());
create policy "users view reports" on public.reports
for select using (reporter_id = auth.uid());

create policy "users own verification" on public.verification_requests
for all using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy "users own subscription" on public.subscriptions
for select using (user_id = auth.uid());

-- Admin tables intentionally restricted to service_role only
create policy "deny all moderation_cases" on public.moderation_cases for all using (false) with check (false);
create policy "deny all audit_logs" on public.audit_logs for all using (false) with check (false);

