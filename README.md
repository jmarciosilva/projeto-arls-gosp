# Plataforma de Gestão — Lojas GOSP

Sistema de gestão administrativa para Lojas Maçônicas filiadas ao **GOSP**. Cada Loja é provisionada manualmente pelo administrador da plataforma e passa a operar sua própria área (Secretaria) através de um login dedicado.

Este repositório é uma reformulação do projeto anterior (`PROJETO_APP_ARLS`), com escopo reduzido a uma única Potência (GOSP) e modelo de onboarding controlado (não self-service). Ver [`ROADMAP.md`](ROADMAP.md) para o desenho completo do produto.

## Por que este projeto existe

O projeto anterior foi desenhado como SaaS multi-potência com auto-cadastro aberto de Loja (qualquer pessoa se cadastrava e virava administradora na hora). Esse modelo foi abandonado em favor de um fluxo mais controlado: a plataforma (você) cadastra cada Loja GOSP manualmente, define o administrador dela, e a Loja passa a usar o sistema a partir daí. Isso simplifica autenticação (sem necessidade de aprovação assíncrona de auto-cadastro) e reduz o escopo inicial a um único módulo funcional: **Secretaria**.

## Escopo desta primeira fase

- Cadastro de Loja (feito pelo administrador da plataforma), em 2 passos.
- Login único da plataforma, com seleção/busca da Loja (sem subdomínio dedicado).
- Módulo Secretaria com CRUD completo de:
  - Membros da Loja / Candidatos (mesma entidade, com campo de situação).
  - Sessões.
  - Balaústres.
  - Usuários (contas de acesso da Loja).

Módulos como Tesouraria, Eventos, Comunicação, Biblioteca, Hospitalaria, Landing Page e Dashboard executivo ficam para fases posteriores — ver seção "Fora do escopo inicial" do ROADMAP.

## Estrutura (planejada)

- `backend`: API REST + painel administrativo web em Laravel 12 + MySQL 8.
- `mobile`: aplicativo Flutter (fase posterior — consulta/uso do obreiro comum).

> Nenhum código foi gerado ainda. Este README e o ROADMAP servem como documento de partida para a primeira sessão de desenvolvimento.

## Setup

A definir assim que a Fase 1 (Fundação) for iniciada. Vai seguir o mesmo padrão do projeto anterior: Laravel 12, PHP 8.3, Composer, MySQL 8, Sanctum para autenticação.

## Próximos passos

1. Confirmar decisões assumidas no ROADMAP (seção "Decisões assumidas").
2. Modelar o schema de banco (Loja, Administrador, Membro/Candidato, Sessão, Balaústre, Usuário).
3. Construir o painel web (cadastro de Loja pelo admin da plataforma + login + módulo Secretaria).
4. Só então avaliar o app mobile.
