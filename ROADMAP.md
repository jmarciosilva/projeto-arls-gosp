# ROADMAP — Plataforma de Gestão para Lojas GOSP

## 1. Visão Geral do Produto

### Objetivo

Desenvolver uma plataforma de gestão administrativa para Lojas Maçônicas filiadas exclusivamente ao **GOSP**. Diferente de um SaaS self-service tradicional, o cadastro de cada Loja é feito manualmente pelo administrador da plataforma; a Loja não se auto-cadastra. Após o provisionamento, a Loja acessa sua própria área através de um login dedicado, onde a Secretaria administra membros, candidatos, sessões e balaústres.

### Origem deste projeto

Este projeto substitui `PROJETO_APP_ARLS`, que foi desenhado como SaaS multi-potência com auto-cadastro aberto (qualquer pessoa se cadastrava e virava administradora da Loja na hora, sem aprovação). Essa decisão foi revertida: o modelo atual é de provisionamento controlado, escopo reduzido a uma única Potência, e o primeiro módulo funcional é a Secretaria — não a Fundação genérica multi-tenant do projeto anterior.

### Público-alvo

- Administrador da plataforma (você): cadastra e gerencia as Lojas GOSP.
- Administrador da Loja: usuário criado no cadastro da Loja, responsável pelo acesso inicial.
- Secretaria da Loja: opera o CRUD de Membros, Candidatos, Sessões, Balaústres e Usuários.
- Futuramente: demais oficiais e obreiros, via módulos posteriores.

### Diferenciais deste modelo

- Onboarding controlado elimina a necessidade de fluxos de aprovação assíncrona de auto-cadastro.
- Escopo mono-potência (GOSP) simplifica listas fixas e regras de negócio — sem necessidade de suportar variações entre potências diferentes.
- Login único da plataforma com seleção de Loja evita a complexidade de subdomínios por tenant nesta fase.

## 2. Decisões assumidas

Registradas aqui para não precisar re-perguntar nas próximas sessões. Qualquer uma pode ser revista, mas é o ponto de partida:

1. **Login único com seleção de Loja.** Não há subdomínio dedicado por Loja nesta fase; uma única tela de login busca/lista Lojas e autentica o usuário no contexto dela.
2. **Membro e Candidato são a mesma entidade** (`members`), diferenciados por um campo de situação (`candidato`, `ativo`, `inativo`), permitindo promover Candidato → Membro sem recadastro.
3. **Secretaria opera em painel web**, não no app mobile. O mobile fica para uma fase posterior, focado em consulta/uso do obreiro comum.
4. **1 balaústre por sessão** (relação um-para-um entre `sessions` e `balaustres`).
5. **Potência fixa GOSP** — não é um campo editável em nenhum formulário, é constante do sistema.
6. **Grau maçônico tem só 3 valores** (Aprendiz, Companheiro, Mestre) — Venerável e demais são tratados como **Cargo**, não como Grau.
7. **WhatsApp e CPF são armazenados só com dígitos**; a máscara é aplicada apenas na exibição/input.

## 3. Arquitetura Geral

### Backend

Laravel 12, PHP 8.3, MySQL 8, API REST versionada (`/api/v1`), autenticação via Sanctum. Reaproveita os padrões já validados no projeto anterior: Form Requests para validação, API Resources para respostas, Services para regras de negócio, Policies/Gates para autorização, estrutura modular (`app/Modules/{ModuleName}`).

### Painel Administrativo Web

Construído em Laravel (Blade/Livewire). Dois contextos de acesso:

- **Admin da plataforma**: cadastra Lojas (wizard 2 passos), gerencia a lista de Lojas GOSP.
- **Secretaria da Loja**: após login, acessa CRUDs de Membros/Candidatos, Sessões, Balaústres, Usuários — escopados pela própria Loja.

### Banco de Dados

Multi-tenant lógico: `lodge_id` em todas as tabelas de domínio da Loja, isolamento por escopo aplicado nas queries. Sem separação física de banco por tenant nesta fase.

Entidades previstas:

- `lodges`: Lojas GOSP cadastradas.
- `lodge_administrators` (ou papel em `users`): administrador definido no cadastro da Loja.
- `members`: Membros/Candidatos (unificados, campo `status`).
- `sessions`: sessões da Loja.
- `balaustres`: balaústres, vinculados 1:1 a uma sessão.
- `users`: contas de acesso à plataforma, escopadas por Loja.

## 4. Fluxo 1 — Cadastro da Loja (feito pelo administrador da plataforma)

### Passo 1

| Campo | Observação |
| --- | --- |
| Nome da Loja | obrigatório |
| E-mail de contato da Loja | obrigatório, único |
| Número da Loja | obrigatório |
| Rito | lista fixa (ver abaixo) |

Potência não aparece como campo — é constante `GOSP`.

**Lista de Ritos**: Adonhiramita, Brasileiro, Escocês Antigo e Aceito, Escocês Retificado, Maçons Livres Antigos e Aceitos, São João, Schroeder, York.

### Passo 2 — Endereço da Loja

| Campo | Observação |
| --- | --- |
| CEP | máscara `00000-000`; consulta ViaCEP preenche os demais campos |
| Logradouro | preenchido via CEP, editável |
| Número | manual |
| Complemento | opcional |
| Bairro | preenchido via CEP, editável |
| Cidade | preenchido via CEP, editável |
| Estado | preenchido via CEP, editável |

### Passo 2 — Administrador da Loja

| Campo | Observação |
| --- | --- |
| Nome completo | obrigatório |
| Apelido | opcional |
| CIM | numérico, até 8 dígitos |
| CPF | máscara `000.000.000-00`, único |
| Grau | Aprendiz, Companheiro, Mestre |
| E-mail | obrigatório, único, usado no login |
| WhatsApp | máscara `(11) 94893-2064`, armazenado só com dígitos |
| Senha / Confirmar senha | obrigatório |

Ao concluir, a Loja é criada e o administrador recebe as credenciais para acessar a **tela de login única da plataforma**, onde seleciona/busca sua Loja.

## 5. Fluxo 2 — Módulo Secretaria (operado pela própria Loja)

### Membros da Loja (Irmão) / Candidato

Entidade única `members`, com botão **Ativo/Inativo** e campo de situação que também cobre `candidato`.

**Dados Pessoais**
- Nome
- Data de nascimento
- Natural de (lista de estados brasileiros)
- Estado civil
- E-mail
- Fone residencial
- Fone celular
- CPF nº
- RG nº
- Tipo sanguíneo

**Profissão**
- Ocupação
- Local de trabalho
- Fone comercial

**Endereço Residencial**
- Estado
- Cidade
- Rua
- Número
- Complemento
- Bairro
- CEP

**Dados Maçônicos**
- CIM nº
- Grau: Aprendiz, Companheiro, Mestre
- Cargo: lista de cargos maçônicos (ver abaixo)
- Data de ingresso
- Tipo de ingresso
- Observação

### Sessões

| Campo | Observação |
| --- | --- |
| Data | obrigatório |
| Tipo | lista fixa (ver abaixo) |
| Grau | Aprendiz, Companheiro, Mestre |
| Rito | mesma lista de Ritos da Loja |
| Tronco | valor em R$ |
| Pauta/Resumo | texto livre |

**Lista de Tipos de Sessão**: Ordinária, Magna, Pública, Econômica/Administrativa, Instrução, Iniciação, Elevação, Exaltação, Especial/Extraordinária, Magna Fúnebre.

### Balaústres

| Campo | Observação |
| --- | --- |
| Sessão | vínculo 1:1 com `sessions` |
| Grau | Aprendiz, Companheiro, Mestre |
| Tipo | mesma lista de Tipos de Sessão |
| N° ata | obrigatório |
| Aprovado | Sim/Não |

### Usuários

CRUD das contas de acesso da Loja — vinculadas ou não a um Membro, com papel/permissão dentro do escopo da própria Loja.

## 6. Listas fixas (dropdowns)

Centralizar em arquivo de configuração único (equivalente ao antigo `config/lodge.php`), expostas via endpoint público para consumo do painel.

- **Potência**: GOSP (constante, sem dropdown).
- **Rito**: Adonhiramita, Brasileiro, Escocês Antigo e Aceito, Escocês Retificado, Maçons Livres Antigos e Aceitos, São João, Schroeder, York.
- **Grau**: Aprendiz, Companheiro, Mestre.
- **Tipo de Sessão**: Ordinária, Magna, Pública, Econômica/Administrativa, Instrução, Iniciação, Elevação, Exaltação, Especial/Extraordinária, Magna Fúnebre.
- **Cargo maçônico**: Venerável Mestre, Primeiro Vigilante, Segundo Vigilante, Orador, Orador Adjunto, Secretário, Secretário Adjunto, Tesoureiro, Tesoureiro Adjunto, Chanceler, Mestre de Cerimônias, Mestre de Cerimônias Adjunto, Guarda do Templo Interno, Guarda do Templo Externo, Arquiteto, Bibliotecário, Hospitaleiro, Porta-Estandarte, Mestre de Harmonia, Mestre de Banquetes.
- **Estado civil**: Solteiro(a), Casado(a), Divorciado(a), Viúvo(a), União Estável.
- **Tipo sanguíneo**: A+, A-, B+, B-, AB+, AB-, O+, O-.
- **Situação do Membro**: Candidato, Ativo, Inativo.
- **Tipo de ingresso**: Iniciação, Regularização, Filiação.

Estas listas podem ser ajustadas antes de gerar o schema definitivo — foram propostas como ponto de partida.

## 7. Fora do escopo inicial

Adiados para fases posteriores, conforme o roadmap do projeto anterior:

- Tesouraria (mensalidades, receitas, despesas, PIX, boletos).
- Sessões com check-in por QR Code e confirmação de presença via app.
- Eventos (internos e públicos).
- Comunicação (feed, avisos, mensagens).
- Biblioteca.
- Hospitalaria.
- Landing page institucional.
- Dashboard executivo.
- App mobile Flutter completo (fica só planejado, não iniciado).
- Subdomínio próprio por Loja.
- Billing/planos SaaS (não é necessário — modelo é provisionamento manual, não self-service).

## 8. Boas práticas (herdadas do projeto anterior)

- PSR-12, Laravel Pint, PHPStan/Larastan.
- Testes de feature para endpoints, testes de autorização, testes de isolamento por Loja.
- Form Requests para validação, API Resources para respostas padronizadas, Policies para autorização por recurso.
- Commits objetivos (`feat:`, `fix:`, `docs:`, `test:`, `refactor:`).
- `tenant_id`/`lodge_id`, `created_at`, `updated_at`, `deleted_at` (soft delete) em todas as tabelas de domínio da Loja.

## Próximos Passos

1. Validar as listas fixas da seção 6 (Cargo e Tipo de Sessão foram propostas por padrão, não confirmadas pelo usuário GOSP real).
2. Modelar o schema de banco definitivo (Lojas, Administradores, Membros/Candidatos, Sessões, Balaústres, Usuários).
3. Construir o painel web: cadastro de Loja (wizard 2 passos) → login único → módulo Secretaria completo.
4. Só então avaliar o app mobile.
