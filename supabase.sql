-- 덩굴숲: 앵무새가 기억하는 말
-- Supabase 대시보드 → SQL Editor 에 붙여넣고 Run 한 번이면 끝.

create table if not exists public.parrot_lines (
  id bigint generated always as identity primary key,
  parrot smallint not null check (parrot between 0 and 30),
  text text not null check (char_length(text) between 1 and 80),
  created_at timestamptz not null default now()
);

alter table public.parrot_lines enable row level security;

-- 누구나 읽고 남길 수 있지만, 고치거나 지울 수는 없음
create policy "parrot lines are readable" on public.parrot_lines
  for select to anon using (true);
create policy "anyone can teach a parrot" on public.parrot_lines
  for insert to anon with check (true);

-- 다른 사람이 가르친 말을 실시간으로 받기
alter publication supabase_realtime add table public.parrot_lines;

-- ---------------------------------------------------------------
-- 리본: 나무에 묶는 표식 (한 사람당 5개, 내 리본만 풀 수 있음)
create table if not exists public.ribbons (
  id bigint generated always as identity primary key,
  owner_hash text not null check (char_length(owner_hash) = 64),
  name text not null default '' check (char_length(name) <= 12),
  color text not null check (color ~ '^#[0-9a-fA-F]{6}$'),
  x real not null check (x >= 0 and x < 96),
  y real not null check (y >= 0 and y < 96),
  created_at timestamptz not null default now()
);
alter table public.ribbons enable row level security;
create policy "ribbons are readable" on public.ribbons for select to anon using (true);
create policy "anyone can tie a ribbon" on public.ribbons for insert to anon with check (true);
alter publication supabase_realtime add table public.ribbons;

-- 리본 풀기: 묶은 사람의 브라우저에만 있는 열쇠가 맞아야 지워짐
create or replace function public.untie_ribbon(rid bigint, owner_key text) returns void
language sql security definer set search_path = public as $$
  delete from public.ribbons where id = rid and owner_hash = encode(sha256(convert_to(owner_key, 'UTF8')), 'hex');
$$;
grant execute on function public.untie_ribbon(bigint, text) to anon;

-- ---------------------------------------------------------------
-- 앵무새가 누구 말인지 기억 (같이 있었던 사람 말을 먼저 따라 하려고)
alter table public.parrot_lines add column if not exists speaker text not null default '' check (char_length(speaker) <= 40);
