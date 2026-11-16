# 🚀 WBS - Aplicação estilo Splitwise em Flutter

## 📱 Visão Geral da App
Aplicação móvel desenvolvida em **Flutter** para gestão e partilha de despesas de grupos (estilo Splitwise). 
A app permite a utilizadores autenticados criar e gerir múltiplos grupos de despesas (com capacidade para 10+ pessoas por grupo). A adesão a um grupo é feita de forma simples e direta através da inserção de um **código alfanumérico único** gerado pelo criador do grupo.
Dentro de cada grupo, os membros podem registar despesas categorizadas e visualizar em tempo real a divisão dos custos e quem pagou o quê através de um **gráfico circular (Pie Chart)**.

## 🛠️ Stack Tecnológica & Arquitetura Definida

* **Framework:** Flutter (Clean / Feature-first Architecture)
* **Gestão de Estado:** `flutter_riverpod` + `riverpod_annotation`
* **Navegação:** `go_router`
* **Backend & Base de Dados:** `supabase_flutter` (PostgreSQL / Realtime)
* **Visualização de Dados:** `fl_chart`
* **Utilitários:** `uuid`, `intl`, `build_runner`

## 📌 Regras de Execução para Agentes / Programadores

1. Executar **estritamente uma tarefa de cada vez**.
2. Não avançar para a tarefa seguinte sem testar e obter aprovação.
3. Marcar a tarefa com `[x]` assim que for concluída e validada.

---

## 📌 Milestone 1: Setup, Arquitetura e Estrutura Base

* [x] **Tarefa 1.1: Estrutura de Pastas**
  * Criar a estrutura base seguindo a abordagem *Feature-first*:
    ```text
    lib/
     ├── core/           # Tema, rotas, constantes, cliente Supabase
     ├── features/
     │    ├── auth/      # Login / Autenticação e perfil de utilizador
     │    ├── home/      # Lista de grupos ativos e fechados
     │    ├── groups/    # Criação, adesão por código, gestão de membros
     │    └── expenses/  # Adicionar/listar despesas, gráficos
     └── main.dart
    ```

* [x] **Tarefa 1.2: Configuração do `pubspec.yaml` e Dependências**
  * Adicionar e instalar as dependências principais:
    * Gestão de estado: `flutter_riverpod`, `riverpod_annotation`
    * Navegação: `go_router`
    * Backend: `supabase_flutter`
    * Gráficos: `fl_chart`
    * Utilitários: `uuid`, `intl`
    * Dev Dependencies: `build_runner`, `riverpod_generator`, `json_serializable`
  * Executar `flutter pub get` e verificar compilação limpa.

* [x] **Tarefa 1.3: Configuração Inicial do Supabase e Modelos de Dados (Data Models)**
  * Configurar a inicialização do Supabase no `main.dart` usando variáveis de ambiente/constantes.
  * Criar os modelos imutáveis em Dart (com serialização JSON para integração com Supabase):
    * `UserModel` (`id`, `name`, `email`, `avatarUrl`)
    * `GroupModel` (`id`, `name`, `code`, `isClosed`, `createdBy`, `createdAt`)
    * `ExpenseModel` (`id`, `groupId`, `title`, `amount`, `paidByUserId`, `category`, `splitWithUserIds`, `createdAt`)

* [x] **Tarefa 1.4: Criar tabelas no Supabase (SQL)**
  * Executar no Supabase Dashboard → SQL Editor:
    * Tabela `profiles` (id uuid references auth.users, name, email, avatar_url nullable, created_at)
    * Trigger SQL para inserir automaticamente em `profiles` quando um utilizador é criado em `auth.users`
    * Tabela `groups` (id, name, code, is_closed, created_by, created_at)
    * Tabela `group_members` (id, group_id, user_id, joined_at)
    * Tabela `expenses` (id, group_id, title, amount, paid_by_user_id, category, split_with_user_ids, created_at)
  * Verificar que as tabelas aparecem no Table Editor do Supabase

---

## 📌 Milestone 2: Autenticação e Gestão de Utilizadores (Auth)

* [x] **Tarefa 2.1: Serviços de Autenticação com Supabase**
  * Configurar o cliente Supabase Auth para registo e login (E-mail/Password).
  * Criar o repositório `AuthRepository` para gerir o registo, login, logout e sessão atual.
  * Garantir que dados adicionais do utilizador (nome, avatar) são persistidos após registo (ver Tarefa 2.4).

* [x] **Tarefa 2.2: Ecrãs de Login / Registo e Proteção de Rotas**
  * Criar a interface de utilizador para o ecrã de Login / Registo.
  * Configurar o `GoRouter` com um *redirect guard*: se o utilizador não estiver autenticado, é redirecionado para o ecrã de Login; se estiver, vai direto para a Home.

* [x] **Tarefa 2.3: Estado Global de Utilizador (Auth Provider)**
  * Criar um provider em `Riverpod` (`currentUserProvider`) para expor o estado do utilizador logado em tempo real em toda a aplicação.
  * O provider deve combinar dados de `auth.users` (email, id) com a tabela `profiles` (nome, avatar_url).

* [x] **Tarefa 2.4: Perfil de Utilizador e Persistência de Dados**
  * Criar tabela `profiles` no Supabase com colunas:
    * `id` (uuid, references auth.users, primary key)
    * `name` (text)
    * `email` (text)
    * `avatar_url` (text, nullable)
    * `created_at` (timestamp with time zone, default now())
  * Criar trigger SQL para inserir automaticamente na tabela `profiles`
    quando um novo utilizador é criado em `auth.users`.
  * Criar modelo `ProfileModel` em Dart (imutável, serialização JSON):
    * `lib/features/auth/data/models/profile_model.dart`
  * Atualizar `AuthRepository.signUp` para garantir que o perfil é
    criado/consistente após registo (ou confiar no trigger do Supabase).
  * Atualizar `currentUserProvider` para incluir dados do profile
    (ex: juntar `name` e `avatar_url` da tabela `profiles`).

---

## 📌 Milestone 3: Ecrã Principal e Gestão de Grupos

* [x] **Tarefa 3.1: Ecrã Home Base (Requisito 4)**
  * Criar o ecrã principal utilizando `GoRouter` e `Riverpod`.
  * Implementar duas secções/abas: **Grupos Ativos** e **Grupos Fechados**, ligadas ao Supabase.
  * Adicionar o botão flutuante (`FloatingActionButton` com ícone `+`) para abrir a criação/adesão a grupos.

* [x] **Tarefa 3.2: Criar Grupo e Gerar Código (Requisito 3)**
  * Criar formulário para inserção do nome do grupo.
  * Implementar gerador de código alfanumérico único de 6 dígitos (ex: `A7X92B`).
  * Guardar o novo grupo na tabela de grupos do Supabase.
  * Associar o utilizador atual (id da tabela `profiles`) como criador e primeiro membro do grupo.

* [ ] **Tarefa 3.3: Juntar-se a um Grupo por Código (Requisitos 1 e 3)**
  * Criar ecrã/modal onde o utilizador insere o código de 6 dígitos.
  * Validar a existência do código na base de dados.
  * Adicionar o utilizador autenticado (id da tabela `profiles`) à lista de membros do grupo.
  * Garantir suporte a pelo menos 10 pessoas por grupo.

* [ ] **Tarefa 3.4: Listagem de Membros no Detalhe do Grupo**
  * Criar a vista interna do grupo com a lista visual de todos os membros associados.
  * Buscar nomes e avatares dos membros da tabela `profiles` do Supabase.

---

## 📌 Milestone 4: Categorias e Registo de Despesas

* [ ] **Tarefa 4.1: Configuração de Categorias (Requisito 6)**
  * Criar o enum e utilitário `ExpenseCategory` com as categorias padrão (ex: *Alimentação, Habitação, Transporte, Lazer, Outros*) com ícones e cores dedicados.

* [ ] **Tarefa 4.2: Ecrã de Adicionar Despesa**
  * Criar formulário para registar despesa:
    * Campo de Título e Valor monetário.
    * Seleção da Categoria (usando o enum da Tarefa 4.1).
    * Seleção de quem pagou a despesa (default: utilizador logado).
    * Seleção dos membros entre os quais a despesa será dividida.

* [ ] **Tarefa 4.3: Listagem Cronológica de Despesas**
  * Criar a lista de despesas na página do grupo, ordenadas por data descritiva, mostrando o ícone da categoria, valor e quem pagou, sincronizadas em tempo real via Supabase.

---

## 📌 Milestone 5: Gráfico Circular, Saldos e Archiving

* [ ] **Tarefa 5.1: Lógica Matemática de Saldos**
  * Desenvolver a função/provider em Riverpod que calcula o total gasto no grupo e o saldo individual de cada membro (quanto pagou vs. quanto deve).

* [ ] **Tarefa 5.2: Gráfico Circular com `fl_chart` (Requisito 5)**
  * Integrar o componente de *Pie Chart* no topo do ecrã do grupo.
  * Mapear as percentagens do gráfico para refletir a proporção do total de despesas paga por cada participante.

* [ ] **Tarefa 5.3: Fecho de Grupo (Requisito 4)**
  * Adicionar opção para marcar um grupo como "Fechado".
  * Mover o grupo da secção "Ativos" para "Fechados" na Home e desativar a criação de novas despesas.