-- Tabela de perfis de utilizador
create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  name text,
  email text,
  avatar_url text,
  created_at timestamp with time zone default now()
);

-- Habilitar Row Level Security
alter table public.profiles enable row level security;

-- Política: utilizador só pode ler o seu próprio perfil
create policy "Users can view own profile"
  on public.profiles for select
  using ( auth.uid() = id );

-- Política: utilizador só pode editar o seu próprio perfil
create policy "Users can update own profile"
  on public.profiles for update
  using ( auth.uid() = id );

-- Política: utilizador só pode inserir o seu próprio perfil
create policy "Users can insert own profile"
  on public.profiles for insert
  with check ( auth.uid() = id );

-- Função trigger para inserir automaticamente após registo em auth.users
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, name, email, avatar_url)
  values (
    new.id,
    new.raw_user_meta_data->>'name',
    new.email,
    new.raw_user_meta_data->>'avatar_url'
  );
  return new;
end;
$$ language plpgsql security definer;

-- Trigger executado após cada inserção em auth.users
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
