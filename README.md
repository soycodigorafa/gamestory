# GameStory

> A cross-platform NPC dialogue flow editor — create NPCs, build branching conversation graphs with boolean flag conditions, simulate dialogue paths, and export to JSON, all offline-first.

---

## Table of Contents

1. [Overview](#overview)
2. [Key Features](#key-features)
3. [Platform Support](#platform-support)
4. [Architecture](#architecture)
5. [State Management](#state-management)
6. [Data Layer](#data-layer)
7. [Design Language](#design-language)
8. [Project Structure](#project-structure)
9. [Getting Started](#getting-started)
10. [Roadmap](#roadmap)
11. [Contributing](#contributing)

---

## Overview

GameStory is an offline-first tool for narrative designers and game developers to author NPC dialogue flows. You create NPCs on a free-form pan/zoom canvas, then open each NPC to build a branching conversation graph — nodes connected by player choices, with boolean flag requirements to gate paths and flag effects triggered on entering a node. A built-in simulation mode lets you walk any dialogue tree and see locked/unlocked paths in real time.

---

## Key Features

- **NPC canvas** — pan/zoom workspace showing all NPCs as draggable cards; long-press for edit/delete
- **Visual node editor** — structured flow of dialogue nodes connected by arrows; toggle vertical/horizontal layout
- **Long-press context actions** — hold any NPC card or dialogue node to get Edit / Delete (and Set as Start) options
- **Requirement flags** — gate player choices behind named flags (`flag_name = true/false`)
- **Reward flags** — set flag values when a node is entered, enabling progression logic
- **Playback / simulation** — in-memory dialogue walk-through; locked choices are dimmed with a lock indicator
- **Dark / light theme** — Material 3, dark by default, switchable with a single tap in the app bar
- **JSON export / import** — export any NPC's dialogue graph as a portable `.gsp` file; import to restore it on any device
- **CSV export** — export dialogue graph as a flat `.csv` for spreadsheet review
- **Offline-first** — all data persisted locally with Drift (SQLite); no account required

---

## Platform Support

| Platform | Target |
|---|---|
| iOS | iPhone (primary mobile target) |
| Android | Phone & tablet |
| macOS | Desktop (native Mac app) |
| Windows | Desktop (native Windows app) |

Web is scaffolded by Flutter but is **not** an official target for v1.

---

## Architecture

GameStory follows **MVVM** — each screen has a dedicated ViewModel implemented as a Riverpod `Notifier` or `AsyncNotifier`. Views are stateless `ConsumerWidget`s that read from providers and dispatch intents to the ViewModel. Business logic never lives in widgets.

```
View (ConsumerWidget)
  ↕  watches / calls
ViewModel (Riverpod AsyncNotifier)
  ↕  uses
Repository (abstract interface — domain layer)
  ↕  implemented by
DriftRepository (data layer — Drift DAO)
```

**Layer rules:**
- `lib/features/.../view/` and `widgets/` → may only import from `lib/shared/`, `lib/domain/`, and sibling `providers/`.
- `lib/features/.../providers/` → may only import from `lib/domain/`.
- `lib/data/` → may import from `lib/domain/` and Drift/external packages.
- `lib/domain/` → pure Dart only; zero Flutter or package imports.
- Never pass `WidgetRef` outside the widget layer.

---

## State Management

**Package:** `flutter_riverpod` + `riverpod_annotation` (code-gen)

| Pattern | When to use |
|---|---|
| `@riverpod` (`Provider`) | Stateless, derived, or async-loaded values |
| `@riverpod` (`Notifier`) | Mutable synchronous state (theme mode, layout direction, playback) |
| `@riverpod` (`AsyncNotifier`) | DB-backed mutable state (NPCs, nodes, choices, flags) |

**Conventions:**
- One provider file per feature at `lib/features/<name>/providers/<name>_provider.dart`.
- Provider names use the `<noun>Provider` suffix (e.g. `npcListProvider`, `dialogueGraphProvider`).
- `themeModeProvider` persists `ThemeMode` via `shared_preferences`; dark by default.
- Never pass `WidgetRef` outside the widget layer.

---

## Data Layer

**Package:** `drift` (SQLite ORM, all platforms)

### Schema

```
npcs
  id, name, description, canvasX, canvasY, colorHex, createdAt, updatedAt

dialogue_nodes
  id, npcId, speakerName, dialogueText, isStart, layoutX, layoutY

dialogue_choices
  id, fromNodeId, toNodeId, choiceText, sortOrder

requirement_flags                    -- gate a choice behind a flag value
  choiceId, flagName, requiredValue (bool)

reward_flags                         -- set a flag when a node is entered
  nodeId, flagName, setValue (bool)
```

### Local-first strategy

- Drift database lives in the app's documents directory on every platform.
- Repositories expose `Stream`-based APIs so the UI reactively updates on any DB write.
- Schema migrations are versioned: v1 (npcs) → v2 (nodes + choices) → v3 (requirement_flags) → v4 (reward_flags).

### Repository interfaces (domain layer)

```dart
abstract interface class NpcRepository {
  Stream<List<Npc>> watchAll();
  Future<Npc> create(CreateNpcInput input);
  Future<void> update(UpdateNpcInput input);
  Future<void> delete(String id);
}

abstract interface class DialogueNodeRepository {
  Stream<List<DialogueNode>> watchByNpc(String npcId);
  Future<DialogueNode> create(CreateNodeInput input);
  Future<void> update(UpdateNodeInput input);
  Future<void> setStart(String nodeId);
  Future<void> delete(String id);
}

abstract interface class DialogueChoiceRepository {
  Stream<List<DialogueChoice>> watchByNode(String fromNodeId);
  Future<DialogueChoice> create(CreateChoiceInput input);
  Future<void> update(UpdateChoiceInput input);
  Future<void> delete(String id);
}
```

All flag repositories follow the same `watch / create / delete` pattern.

---

## Design Language

GameStory uses **Material 3** with a dark/light switchable theme. Dark mode is default.

| Token (AppColors) | Dark value | Light value |
|---|---|---|
| `background` | `#0E0E12` | `#F5F5FA` |
| `surface` | `#1A1A22` | `#FFFFFF` |
| `surfaceVariant` | `#24242F` | `#EBEBF5` |
| `primary` | `#7B61FF` | `#5B3FE0` |
| `secondary` | `#00D9C0` | `#00A896` |
| `error` | `#FF4D6D` | `#D32F4F` |
| `onSurface` | `#E8E8F0` | `#1A1A22` |
| `muted` | `#6B6B80` | `#888899` |

**Component conventions:**
- Cards: `BorderRadius.circular(12)` + 1 px border in `surfaceVariant`.
- Interactive surfaces: `InkWell` with theme splash color.
- Icons: Flutter default
- Fonts: Flutter default
- Long-press → `showMenu` context popup (no custom bottom sheet needed).

---

## Project Structure

```
lib/
├── main.dart                          # ProviderScope → MaterialApp.router
├── app/
│   ├── app.dart                       # MaterialApp.router, theme wiring
│   ├── router.dart                    # go_router: /, /npc/:id, /npc/:id/play
│   └── theme/
│       ├── app_theme.dart             # ThemeData factory (dark + light)
│       └── app_colors.dart            # Color token constants
├── domain/
│   ├── entities/                      # Npc, DialogueNode, DialogueChoice, RequirementFlag, RewardFlag
│   └── repositories/                  # Abstract interfaces
├── data/
│   ├── database/
│   │   ├── app_database.dart          # Drift AppDatabase (versioned migrations)
│   │   ├── tables/                    # Drift table definitions
│   │   ├── daos/                      # Data Access Objects
│   │   └── migrations/               # Versioned migration steps
│   └── repositories/                  # DriftNpcRepository, DriftDialogueNodeRepository, etc.
├── features/
│   ├── canvas/                        # NPC canvas screen
│   │   ├── providers/
│   │   ├── view/
│   │   └── widgets/                   # NpcCard (draggable, long-press menu)
│   ├── dialogue_editor/               # Node flow editor per NPC
│   │   ├── providers/
│   │   ├── view/
│   │   └── widgets/                   # NodeCard, ChoiceRow, connection painter
│   ├── playback/                      # In-memory dialogue simulation
│   │   ├── providers/
│   │   ├── view/
│   │   └── widgets/
│   └── settings/                      # Theme toggle, about
│       ├── providers/                 # themeModeProvider
│       └── view/
└── shared/
    ├── widgets/                       # GsButton, GsCard, GsTextField, GsDialog, GsEmptyState
    └── utils/                         # Formatters, validators, helpers
```

---

## Getting Started

### Prerequisites

- Flutter SDK `^3.12.0`
- Dart SDK `^3.12.0`
- Xcode 15+ (for iOS / macOS targets)
- Android Studio / Android SDK (for Android targets)
- Visual Studio 2022 with C++ workload (for Windows target)

### Setup

```bash
git clone https://github.com/your-org/gamestory.git
cd gamestory
flutter pub get
```

### Run

```bash
# iOS simulator
flutter run -d iphone

# Android emulator
flutter run -d android

# macOS
flutter run -d macos

# Windows
flutter run -d windows
```

### Code generation (Drift + Riverpod)

```bash
dart run build_runner build --delete-conflicting-outputs
```

Run this after any change to Drift table definitions or `@riverpod` annotations.

### Tests

```bash
flutter test
```

---

## Roadmap

### M1 — Foundation *(complete)*
Get the app running with theme infrastructure and shared widgets.

- [x] `AppTheme` + `AppColors` (Material 3 dark + light `ColorScheme.fromSeed`)
- [x] `themeModeProvider` (`Notifier<ThemeMode>`, default dark, persisted via `shared_preferences`)
- [x] `app.dart` + `router.dart` (3 named routes, placeholder screens)
- [x] `main.dart` wired (`ProviderScope` → `MaterialApp.router`)
- [x] Theme toggle button in app bar (sun ↔ moon icon)
- [x] Shared widgets: `GsButton`, `GsCard`, `GsTextField`, `GsDialog`, `GsEmptyState`

### M2 — NPC Canvas *(complete)*
- [x] `Npc` entity + `NpcRepository` interface
- [x] `npcs` Drift table + DAO + `DriftNpcRepository` + `AppDatabase` v1
- [x] `npcListProvider` (`AsyncNotifier`)
- [x] `NpcCanvasScreen`: `InteractiveViewer` + `Stack` of draggable `NpcCard` widgets
- [x] Long-press `NpcCard` → context menu (Edit, Delete)
- [x] Create / rename / delete NPC flows

### M3 — Dialogue Node Editor *(complete)*
- [x] `DialogueNode`, `DialogueChoice` entities + repository interfaces
- [x] Drift tables + DAOs + `DriftDialogueNodeRepository` (DB migration v2)
- [x] `dialogueGraphProvider` (`AsyncNotifier`)
- [x] `DialogueEditorScreen`: scrollable node flow + `CustomPaint` arrows
- [x] Vertical / Horizontal layout toggle (state in provider)
- [x] Long-press node → context menu (Edit, Set as Start, Delete)
- [x] `NodeEditSheet`: speaker, text, manage outgoing choices
- [x] Node picker modal to connect choices to target nodes

### M4 — Requirement Flags *(complete)*
- [x] `RequirementFlag` entity + repository interface
- [x] `requirement_flags` Drift table + DAO (DB migration v3)
- [x] `RequirementFlagSheet`: add/remove `flagName = true/false` requirements on a choice
- [x] Visual lock badge on choices that have unmet requirements

### M5 — Reward Flags *(complete)*
- [x] `RewardFlag` entity + repository interface
- [x] `reward_flags` Drift table + DAO (DB migration v4)
- [x] `RewardFlagSheet`: add/remove flag set-on-enter effects on a node

### M6 — Playback / Simulation *(complete)*
- [x] `PlaybackState` (in-memory: currentNodeId, visitedNodes, flagMap)
- [x] `PlaybackNotifier` (`AsyncNotifier`, no DB writes)
- [x] `PlaybackScreen`: current node card, choices list (locked choices dimmed + lock icon), Back / Restart
- [x] "Play from start" FAB on `DialogueEditorScreen` (disabled when no nodes)
- [x] Dead-end screen (leaf node) with restart prompt
- [x] Flag debug panel (collapsible bottom panel, shows live flagMap)

### M7 — Export & Import *(complete)*
- [x] JSON export (NPC graph → `.gsp`) via `share_plus`
- [x] CSV export (dialogue graph → flat `.csv`) via `share_plus`
- [x] JSON import (restore NPC graph from `.gsp`)

### M8 — Animations *(complete)*
- [x] Node add / delete entrance & exit animations
- [x] NPC card appear animation on canvas

### M9 — Responsive Polish *(complete)*
- [x] Bottom navigation bar (phone)
- [x] Side navigation rail (tablet)
- [x] Navigation drawer (desktop)

### M10 — Project Management *(stretch)*
Introduce a first-class **project** concept so users can manage multiple story projects independently on-device.
- [x] `Project` domain entity (id, name, description, createdAt, updatedAt)
- [x] `projects` Drift table + DAO (DB migration v5); all existing tables gain a `projectId` foreign key
- [x] Projects screen: list, create, rename, delete projects
- [x] Active-project context propagated app-wide via a `currentProjectProvider`
- [x] Per-project export: save the whole project as a versioned `.gsp` file (JSON-based, with schema version field for forward compatibility) — see [docs/gsp-format.md](docs/gsp-format.md)
- [x] Import: restore a project from a `.gsp` file, handling schema version mismatches gracefully

### M11 — Account Support: Auth *(stretch)*
Add optional user accounts backed by a remote auth provider (e.g. Firebase Auth). The feature is **disabled by default** and toggled on via a compile-time env flag (`ENABLE_AUTH=true`). When disabled, no auth UI or dependencies are loaded. The app remains **fully functional offline** regardless of flag value.
- [ ] `ENABLE_AUTH` env flag: when `false`, all auth code is excluded from the build and Settings shows no account section
- [ ] Auth domain entities: `UserAccount` (uid, email, displayName, photoUrl)
- [ ] `AuthRepository` interface + Firebase Auth implementation (email/password + Google Sign-In)
- [ ] `authStateProvider` (stream-based); reacts to auth changes without app restart
- [ ] Account section inside the existing **Settings** screen (not a separate screen): sign-in / sign-up form, signed-in user profile (display name, email, avatar), sign-out action
- [ ] Form validation and inline error handling within the Settings account section

### M12 — Account Support: Cloud Sync *(stretch)*
Allow signed-in users to back up and sync projects via a **custom backend API**. Offline-first: local DB remains the source of truth; cloud is a secondary store.
- [ ] `SyncRepository` interface: push local project → remote API, pull remote project → local
- [ ] HTTP client abstraction for the custom backend (base URL configurable via env)
- [ ] Conflict resolution strategy: last-write-wins with `updatedAt` timestamp comparison
- [ ] Projects screen: sync status badge per project (synced / pending / error)
- [ ] Background sync trigger on app foreground (connectivity-aware)
- [ ] Manual "Sync now" action + sync progress indicator

### M13 — Other Formats *(stretch)*
- [ ] Ink (`.ink`) export
- [ ] Yarn Spinner (`.yarn`) export

---

## Contributing

### Branching

```
main           → stable, tagged releases
develop        → integration branch
feature/<name> → individual features
fix/<name>     → bug fixes
```

### PR Rules

1. All PRs target `develop`, never `main`.
2. Run `flutter analyze` (zero warnings) and `flutter test` before opening.
3. Run `dart run build_runner build` if generated files changed.
4. Each PR must include or update relevant unit/widget tests.
5. Keep PRs focused — one feature or fix per PR.

### Test Coverage Expectations

| Layer | Minimum coverage |
|---|---|
| `domain/` entities + logic | 90 % |
| `data/` repositories | 80 % |
| `features/` ViewModels | 70 % |
| `features/` Views (widget tests) | key user flows covered |
