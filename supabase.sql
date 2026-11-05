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
