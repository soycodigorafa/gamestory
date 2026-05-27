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
- **Boolean flag conditions** — gate player choices behind named flags (`flag_name = true/false`)
- **Flag effects** — set flag values when a node is entered, enabling progression logic
- **Playback / simulation** — in-memory dialogue walk-through; locked choices are dimmed with a lock indicator
- **Dark / light theme** — Material 3, dark by default, switchable with a single tap in the app bar
- **JSON export** — export any NPC's dialogue graph as a portable `.gamestory.json` file
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

choice_flags                         -- gate a choice behind a flag value
  choiceId, flagName, requiredValue (bool)

node_flag_effects                    -- set a flag when a node is entered
  nodeId, flagName, setValue (bool)
```

### Local-first strategy

- Drift database lives in the app's documents directory on every platform.
- Repositories expose `Stream`-based APIs so the UI reactively updates on any DB write.
- Schema migrations are versioned: v1 (npcs) → v2 (nodes + choices) → v3 (flags).

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
│   ├── entities/                      # Npc, DialogueNode, DialogueChoice, ChoiceFlag, NodeFlagEffect
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

### M3 — Dialogue Node Editor
- [ ] `DialogueNode`, `DialogueChoice` entities + repository interfaces
- [ ] Drift tables + DAOs + `DriftDialogueNodeRepository` (DB migration v2)
- [ ] `dialogueGraphProvider` (`AsyncNotifier`)
- [ ] `DialogueEditorScreen`: scrollable node flow + `CustomPaint` arrows
- [ ] Vertical / Horizontal layout toggle (state in provider)
- [ ] Long-press node → context menu (Edit, Set as Start, Delete)
- [ ] `NodeEditSheet`: speaker, text, manage outgoing choices
- [ ] Node picker modal to connect choices to target nodes

### M4 — Flag Requirements & Effects
- [ ] `ChoiceFlag`, `NodeFlagEffect` entities + repository interfaces
- [ ] Drift tables + DAOs (DB migration v3)
- [ ] `ChoiceFlagSheet`: add/remove `flagName = true/false` requirements on a choice
- [ ] `NodeFlagEffectSheet`: add/remove flag set-on-enter effects
- [ ] Visual lock badge on choices that have unmet requirements

### M5 — Playback / Simulation
- [ ] `PlaybackState` (in-memory: currentNodeId, visitedNodes, flagMap)
- [ ] `PlaybackNotifier` (`Notifier`, no DB)
- [ ] `PlaybackScreen`: current node card, choices list (locked choices dimmed), Back / Restart
- [ ] "Play from start" FAB on `DialogueEditorScreen`
- [ ] Dead-end screen (leaf node) with restart prompt

### M6 — Export & Polish
- [ ] JSON export (NPC graph → `.gamestory.json`) via `share_plus`
- [ ] JSON import (restore from file)
- [ ] Animations: node add/delete, NPC card appear
- [ ] Responsive polish: bottom nav (phone) / side rail (tablet) / drawer (desktop)
- [ ] Ink (`.ink`) export *(stretch)*
- [ ] Yarn Spinner (`.yarn`) export *(stretch)*

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
