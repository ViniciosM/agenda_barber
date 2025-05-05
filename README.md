# Agenda Barber

  **Agenda Barber** é um app para gerenciar os agendamentos do cliente, possuindo módulo para Administrador e Colaborador.

## ✨ Feito com

- [Flutter](https://flutter.dev/) — framework para desenvolvimento multiplataforma
- [Dart](https://dart.dev/) — linguagem de programação principal

## 🏗️ Arquitetura

O projeto segue uma arquitetura baseada em **MVVM**, com separação clara de responsabilidades:

- `models/` — define as classes de dados (DTOs, entidades)
- `viewmodels/` — gerenciamento de estado com Riverpod
- `repositories/` — responsáveis por comunicação com APIs e lógica de negócio
- `services/` — responsáveis por comunicação com APIs e lógica de negócio e auth
- `pages/` — telas e componentes de UI
- `ui/` — componentes reutilizáveis de interface


---

## 📦 Pacotes utilizados

- [`riverpod`](https://pub.dev/packages/riverpod) — gerenciamento de estado
- [`dio`](https://pub.dev/packages/dio) — requisições HTTP
- [`syncfusion_flutter_calendar`](https://pub.dev/packages/sync_fusion_calendar) — timeline calendário
- [`shared_preferences`](https://pub.dev/packages/shared_preferences) — armazenamento local para tokens
- [`intl`](https://pub.dev/packages/intl) — internacionalização e formatação de datas/números


