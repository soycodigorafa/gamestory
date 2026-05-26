# GameStory

> A cross-platform narrative authoring tool for game developers — structure dialogue trees, define item unlocks, set conversation requirements, and track milestone completeness, all from a single offline-first app.

---

## Table of Contents

1. [Overview](#overview)
2. [Key Features](#key-features)
3. [Platform Support](#platform-support)
4. [Architecture](#architecture)
5. [State Management](#state-management)
6. [Data Layer](#data-layer)
7. [Cloud Sync](#cloud-sync)
8. [Milestone System](#milestone-system)
9. [Export](#export)
10. [Design Language](#design-language)
11. [Project Structure](#project-structure)
12. [Getting Started](#getting-started)
13. [Roadmap](#roadmap)
14. [Contributing](#contributing)

---

## Overview

GameStory helps narrative designers and game developers author branching dialogue systems without leaving their devices. Projects contain dialogue trees organised as hierarchical node lists. Each node can carry speaker metadata, response branches, item unlock effects, and prerequisite conditions. A built-in milestone system surfaces how much of the project's unlock logic has been defined, giving the team a concrete sense of progress at every stage.

---

## Key Features

- **Dialogue tree editor** — hierarchical outline view with nested nodes; create, reorder, and link branches
- **Item unlocks** — attach items that become available when a dialogue node is reached
- **Condition requirements** — gate nodes behind inventory checks, flags, or stat comparisons
- **Milestone tracking** — completion percentage driven by how many items/conditions have fully-defined requirements
- **JSON export** — export any project as a portable JSON file consumable by any game engine
- **Offline-first** — all data lives locally; the app works with no internet connection
- **Optional cloud backup** *(future)* — sync projects across devices via a pluggable cloud backend

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
ViewModel (Riverpod Notifier)
  ↕  uses
Repository (abstract interface)
  ↕  implemented by
DataSource (Drift DAO  |  CloudService stub)
```

**Layer rules:**
- Views may only import from `presentation/`.
- ViewModels may only import from `domain/` (entities, repository interfaces).
- Repositories in `data/` implement domain interfaces and are injected via Riverpod providers.
- Nothing in `domain/` depends on Flutter or any external package.

---

## State Management

**Package:** `flutter_riverpod` + `riverpod_annotation` (code-gen)

| Pattern | When to use |
|---|---|
| `@riverpod` (`Provider`) | Stateless, derived, or async-loaded values |
| `@riverpod` (`Notifier`) | Mutable synchronous state (e.g. selected node, UI filters) |
| `@riverpod` (`AsyncNotifier`) | Mutable state loaded from DB or network |

**Conventions:**
- One provider file per feature, co-located in `feature/<name>/providers/`.
- Provider names use the `<noun>Provider` suffix (e.g. `dialogueTreeProvider`).
- Never pass `WidgetRef` outside of widget layer — pass data or callbacks instead.
- `riverpod_lint` rules are enforced via `analysis_options.yaml`.

---

## Data Layer

**Package:** `drift` (SQLite ORM, all platforms)

### Schema overview

```
projects
  id, name, description, createdAt, updatedAt

dialogue_nodes
  id, projectId, parentId, speakerName, dialogueText, sortOrder

items
  id, projectId, name, description

conditions
  id, projectId, expression, conditionType (flag | inventory | stat)

node_item_unlocks
  nodeId, itemId

node_conditions
  nodeId, conditionId, requirementType (requires | blocks)

milestones
  id, projectId, label, targetCount, completedAt
```

### Local-first strategy

- Drift database file lives in the app's documents directory on every platform.
- All writes go to Drift first; cloud sync (when enabled) treats Drift as the source of truth.
- Repositories expose `Stream`-based APIs so the UI reactively updates on any DB change.
- Migrations are versioned in `data/database/migrations/`.

### Repository interfaces (domain layer)

```dart
abstract interface class ProjectRepository {
  Stream<List<Project>> watchAll();
  Future<Project> create(CreateProjectInput input);
  Future<void> update(Project project);
  Future<void> delete(String id);
}

abstract interface class DialogueNodeRepository {
  Stream<List<DialogueNode>> watchByProject(String projectId);
  Future<DialogueNode> create(CreateNodeInput input);
  Future<void> move(String nodeId, {String? newParentId, int newSortOrder});
  Future<void> delete(String id);
}
```

All other repositories follow the same `watch / create / update / delete` pattern.

---

## Cloud Sync

Cloud backup is **deferred to Milestone 3**. The domain interface (`CloudSyncService`) is defined in MVP so that the data layer is not coupled to any backend.

```dart
abstract interface class CloudSyncService {
  Future<void> push(String projectId);
  Future<void> pull(String projectId);
  Stream<SyncStatus> watchStatus(String projectId);
}
```

The MVP ships a `NoOpCloudSyncService` implementation. Backend candidates for Milestone 3: **Firebase**, **Supabase**, or **Appwrite**.

---

## Milestone System

A milestone measures how complete a project's **unlock logic** is. Completeness is defined as:

> **% of dialogue nodes that have at least one fully-configured item unlock or condition requirement.**

### Rules

- A node is considered *complete* when it has ≥ 1 `node_item_unlock` **or** ≥ 1 `node_condition` with a valid, non-empty `expression`.
- A project's milestone progress = `completeNodes / totalNodes * 100`.
- Milestones are discrete thresholds defined per project (e.g. 25 %, 50 %, 75 %, 100 %).
- When a threshold is crossed, `milestones.completedAt` is stamped and a completion animation fires.
- Projects with zero nodes always show 0 % progress.

### UX

- A persistent progress bar is visible on the project detail screen.
- Completed milestones are listed with timestamp badges under a "Achievements" section.
- Unlocking all milestones marks the project as **Narrative Complete**.

---

## Export

### MVP — JSON

Menu: *Project → Export → JSON*

Produces a single `.gamestory.json` file containing the full project graph:

```jsonc
{
  "version": "1.0",
  "project": {
    "id": "...",
    "name": "My Game",
    "exportedAt": "2025-01-01T00:00:00Z"
  },
  "nodes": [
    {
      "id": "...",
      "parentId": null,
      "speaker": "NPC_Blacksmith",
      "text": "Welcome, traveller.",
      "sortOrder": 0,
      "unlocks": ["item_sword"],
      "requires": [{ "type": "flag", "expression": "quest_started == true" }]
    }
  ],
  "items": [{ "id": "item_sword", "name": "Iron Sword" }],
  "conditions": [{ "id": "...", "type": "flag", "expression": "quest_started == true" }]
}
```

### Future formats *(Milestone 2+)*

- **Ink** (`.ink`) — for Unity + Inkle workflows
- **Yarn Spinner** (`.yarn`) — for Unity + Godot workflows
- **CSV** — dialogue text rows for localization pipelines

---

## Design Language

GameStory uses a **dark, game-dev-aesthetic** custom theme built on top of Material 3 `ThemeData`.

| Token | Value |
|---|---|
| Background | `#0E0E12` |
| Surface | `#1A1A22` |
| Surface variant | `#24242F` |
| Primary accent | `#7B61FF` (electric violet) |
| Secondary accent | `#00D9C0` (teal) |
| Error | `#FF4D6D` |
| On-surface text | `#E8E8F0` |
| Muted text | `#6B6B80` |
| Font | `JetBrains Mono` (code feel) + `Inter` (body) |

**Component conventions:**
- All cards use `BorderRadius.circular(12)` and a `1 px` border in `surfaceVariant`.
- Interactive surfaces add `0.05` opacity white overlay on hover (desktop) and `InkWell` splash on mobile.
- Icons: `phosphor_flutter` package (consistent outline style).
- No platform-adaptive widgets in MVP — a single cross-platform dark theme everywhere.

---

## Project Structure

```
lib/
├── main.dart                    # App entry point, ProviderScope
├── app/
│   ├── app.dart                 # MaterialApp.router setup
│   ├── router.dart              # go_router route definitions
│   └── theme/
│       ├── app_theme.dart       # ThemeData factory
│       └── app_colors.dart      # Color token constants
├── domain/
│   ├── entities/                # Pure Dart models (Project, DialogueNode, Item, Condition, Milestone)
│   └── repositories/           # Abstract repository interfaces
├── data/
│   ├── database/
│   │   ├── app_database.dart    # Drift database class
│   │   ├── tables/              # Drift table definitions
│   │   ├── daos/                # Data Access Objects
│   │   └── migrations/          # Versioned schema migrations
│   ├── repositories/            # Drift implementations of domain repositories
│   └── sync/
│       └── no_op_cloud_sync.dart
├── features/
│   ├── projects/
│   │   ├── providers/
│   │   ├── view/
│   │   └── widgets/
│   ├── dialogue_tree/
│   │   ├── providers/
│   │   ├── view/
│   │   └── widgets/
│   ├── items/
│   │   ├── providers/
│   │   ├── view/
│   │   └── widgets/
│   ├── conditions/
│   │   ├── providers/
│   │   ├── view/
│   │   └── widgets/
│   └── milestones/
│       ├── providers/
│       ├── view/
│       └── widgets/
└── shared/
    ├── widgets/                 # Reusable UI components
    ├── extensions/              # Dart extension methods
    └── utils/                   # Formatters, validators, helpers
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

Run this after any change to Drift table definitions or Riverpod `@riverpod` annotations.

### Tests

```bash
flutter test
```

---

## Roadmap

### Milestone 1 — Component Library
Build every reusable UI primitive in isolation. The app must be runnable as a living catalogue (similar to Widgetbook) so each component can be inspected on all platforms before any real screen is composed.

- [ ] Dark theme setup (`AppTheme`, `AppColors`, typography tokens)
- [ ] `GsButton` — primary, secondary, ghost, destructive variants
- [ ] `GsTextField` — single-line, multiline, with label + error state
- [ ] `GsCard` — surface card with optional border and slot for actions
- [ ] `GsTreeNode` — expandable/collapsible outline row with indent level
- [ ] `GsBadge` — status chip (complete, incomplete, locked)
- [ ] `GsProgressBar` — labelled progress with milestone tick marks
- [ ] `GsEmptyState` — illustration + message + optional CTA
- [ ] `GsBottomSheet` — modal sheet wrapper
- [ ] `GsDialog` — confirmation + input dialog variants
- [ ] `GsIconButton` — icon-only action button
- [ ] Component catalogue screen (runs in debug/dev mode, lists every component with all its variants)

### Milestone 2 — Composed Views & Navigation
Wire components together into full screens and set up routing. No real data — all views driven by hardcoded stubs or in-memory state. Goal: navigate the entire app end-to-end.

- [x] `go_router` route map (all named routes defined)
- [x] Projects list screen (stub data)
- [x] Project detail screen — tabs: Tree / Items / Conditions / Milestones (stub data)
- [x] Dialogue tree screen — hierarchical `GsTreeNode` list (stub data)
- [x] Node detail bottom sheet — speaker, text, unlocks, conditions
- [x] Items screen — list + add/edit/delete sheet (stub data)
- [x] Conditions screen — list + expression editor (stub data)
- [x] Milestones screen — progress bar + achievement badges (stub data)
- [x] Responsive layout shell — bottom nav (mobile) / rail (tablet) / side drawer (desktop)
- [x] Smooth transitions and screen-level error/empty states

### Milestone 3 — Dialogue Play Mode
Add an interactive playback/preview mode that lets authors simulate a dialogue tree end-to-end using stub data. No real DB — all state is in-memory.

- [x] "Play" entry point on Project detail screen (plays from root node) and on any individual node in the tree (plays from that node)
- [x] Playback screen — shows current speaker + dialogue text, lists child branches as tappable choices
- [x] In-memory playback state — tracks current node, visited nodes, simulated triggered item unlocks and evaluated conditions (no real DB)
- [x] "Restart" and "Back" controls; dead-end screen when a leaf node is reached
- [x] Visual indicator for nodes that would be gated (condition not met) using stub flag values

### Milestone 4 — Data Layer & Business Logic
Replace all stub data with real persistence. Implement the full Drift schema, repositories, and Riverpod ViewModels.

- [ ] Drift database setup (`AppDatabase`, all 7 tables, migration v1)
- [ ] DAOs for all tables
- [ ] Drift implementations of all repository interfaces
- [ ] Riverpod providers wiring ViewModels to repositories
- [ ] Project CRUD connected to UI
- [ ] Dialogue tree CRUD + node reordering connected to UI
- [ ] Item CRUD connected to UI
- [ ] Condition CRUD + expression validation connected to UI
- [ ] Node ↔ item unlock linking connected to UI
- [ ] Node ↔ condition requirement linking connected to UI
- [ ] `NoOpCloudSyncService` wired into provider graph

### Milestone 5 — Progress & Export
- [ ] Milestone/achievement system with live progress tracking
- [ ] Completion animation on milestone unlock
- [ ] JSON export (full project → `.gamestory.json`)
- [ ] JSON import (restore a project from file)
- [ ] Responsive layout polish (phone vs tablet vs desktop breakpoints)

### Milestone 6 — Cloud & Extended Formats
- [ ] Cloud sync backend integration (Firebase / Supabase / Appwrite — TBD)
- [ ] Cross-device project sync
- [ ] Ink export (`.ink`)
- [ ] Yarn Spinner export (`.yarn`)
- [ ] CSV export for localization pipelines

---

## Contributing

### Branching

```
main          → stable, tagged releases
develop       → integration branch
feature/<name> → individual features
fix/<name>    → bug fixes
```

### PR Rules

1. All PRs target `develop`, never `main`.
2. Run `flutter analyze` and `flutter test` before opening a PR — no warnings allowed.
3. Run `dart run build_runner build` if any generated files changed.
4. Each PR must include or update relevant unit/widget tests.
5. Keep PRs focused — one feature or fix per PR.

### Test Coverage Expectations

| Layer | Minimum coverage |
|---|---|
| `domain/` entities + logic | 90 % |
| `data/` repositories | 80 % |
| `features/` ViewModels | 70 % |
| `features/` Views (widget tests) | key user flows covered |
