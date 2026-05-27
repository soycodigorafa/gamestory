# GameStory — Windsurf Agent Rules

> These rules apply to every agent action in this repository. Read and follow all sections before making any change.

---

## 1. Project Identity

GameStory is a **cross-platform, offline-first NPC dialogue flow editor** built with Flutter.
Official targets: **iOS** (primary mobile), **Android** (phone + tablet), **macOS**, **Windows**.
Web is scaffolded but is **not** an official target for v1 — do not introduce web-only dependencies.

---

## 2. Architecture — MVVM

Every screen follows strict MVVM. Never deviate.

```
View (ConsumerWidget)
  ↕  watches / calls
ViewModel (Riverpod AsyncNotifier / Notifier)
  ↕  uses
Repository (abstract interface — domain layer)
  ↕  implemented by
DriftRepository (data layer — Drift DAO)
```

### Layer import rules (enforced, never violate)

| Layer | May import from |
|---|---|
| `lib/features/.../view/` & `widgets/` | `lib/shared/`, `lib/domain/`, sibling `providers/` |
| `lib/features/.../providers/` | `lib/domain/` only |
| `lib/data/` | `lib/domain/`, Drift, external packages |
| `lib/domain/` | Pure Dart only — **zero Flutter or third-party imports** |

- **Never** pass `WidgetRef` outside the widget layer.
- Business logic **never** lives in widgets.
- Views are **stateless** `ConsumerWidget`s; they only read providers and dispatch intents.

---

## 3. State Management — Riverpod

Package: `flutter_riverpod` + `riverpod_annotation` (code-gen via `@riverpod`).

| Pattern | When to use |
|---|---|
| `@riverpod` (`Provider`) | Stateless, derived, or async-loaded values |
| `@riverpod` (`Notifier`) | Mutable synchronous state (theme mode, layout direction, playback) |
| `@riverpod` (`AsyncNotifier`) | DB-backed mutable state (NPCs, nodes, choices, flags) |

### Naming & file conventions

- One provider file per feature: `lib/features/<name>/providers/<name>_provider.dart`.
- Provider class names: `<Noun>Notifier` / `<Noun>AsyncNotifier`.
- Provider variable names: `<noun>Provider` suffix (e.g. `npcListProvider`, `dialogueGraphProvider`).
- `themeModeProvider` is a `Notifier<ThemeMode>`, dark by default, persisted via `shared_preferences`.

### After any `@riverpod` annotation change

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 4. Data Layer — Drift (SQLite)

Package: `drift` (all platforms via SQLite).

### Schema (source of truth)

```
npcs               — id, name, description, canvasX, canvasY, colorHex, createdAt, updatedAt
dialogue_nodes     — id, npcId, speakerName, dialogueText, isStart, layoutX, layoutY
dialogue_choices   — id, fromNodeId, toNodeId, choiceText, sortOrder
choice_flags       — choiceId, flagName, requiredValue (bool)   [gate a choice behind a flag]
node_flag_effects  — nodeId, flagName, setValue (bool)          [set a flag on node enter]
```

### Drift rules

- Table definitions live in `lib/data/database/tables/`.
- DAOs live in `lib/data/database/daos/`.
- `AppDatabase` is in `lib/data/database/app_database.dart` with **versioned migrations**.
- Migration history: v1 (npcs) → v2 (nodes + choices) → v3 (flags). Every schema change **must** add a new migration step; never alter existing ones.
- Repository implementations live in `lib/data/repositories/` and implement the domain interfaces.
- All repository methods that feed the UI **must** return `Stream<…>` so the UI reacts to DB writes.

### After any Drift table/DAO change

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Repository interface pattern (domain layer)

```dart
abstract interface class XRepository {
  Stream<List<X>> watchAll();   // or watchByParentId(String id)
  Future<X>    create(CreateXInput input);
  Future<void> update(UpdateXInput input);
  Future<void> delete(String id);
}
```

---

## 5. Project Structure

```
lib/
├── main.dart                         # ProviderScope → MaterialApp.router
├── app/
│   ├── app.dart                      # MaterialApp.router, theme wiring
│   ├── router.dart                   # go_router: /, /npc/:id, /npc/:id/play
│   └── theme/
│       ├── app_theme.dart            # ThemeData factory (dark + light)
│       └── app_colors.dart           # AppColors constants
├── domain/
│   ├── entities/                     # Npc, DialogueNode, DialogueChoice, ChoiceFlag, NodeFlagEffect
│   └── repositories/                 # Abstract interfaces only
├── data/
│   ├── database/
│   │   ├── app_database.dart
│   │   ├── tables/
│   │   ├── daos/
│   │   └── migrations/
│   └── repositories/                 # Drift implementations
├── features/
│   ├── canvas/                       # NPC canvas (InteractiveViewer + draggable NpcCards)
│   │   ├── providers/
│   │   ├── view/
│   │   └── widgets/
│   ├── dialogue_editor/              # Node flow editor per NPC
│   │   ├── providers/
│   │   ├── view/
│   │   └── widgets/
│   ├── playback/                     # In-memory dialogue simulation
│   │   ├── providers/
│   │   ├── view/
│   │   └── widgets/
│   └── settings/                     # Theme toggle, about
│       ├── providers/
│       └── view/
└── shared/
    ├── widgets/                      # GsButton, GsCard, GsTextField, GsDialog, GsEmptyState
    └── utils/                        # Formatters, validators, helpers
```

- **Never** create files outside this structure without a clear reason.
- Shared widgets are prefixed `Gs` (e.g. `GsButton`, `GsCard`).
- Routing is handled exclusively via `go_router` in `router.dart`.

---

## 6. Design Language — Material 3

- Theme: **Material 3**, dark by default, switchable via `themeModeProvider`.
- All colors must come from `AppColors` — never use raw `Color(0x…)` literals in widgets.

### Color tokens

| Token | Dark | Light |
|---|---|---|
| `background` | `#0E0E12` | `#F5F5FA` |
| `surface` | `#1A1A22` | `#FFFFFF` |
| `surfaceVariant` | `#24242F` | `#EBEBF5` |
| `primary` | `#7B61FF` | `#5B3FE0` |
| `secondary` | `#00D9C0` | `#00A896` |
| `error` | `#FF4D6D` | `#D32F4F` |
| `onSurface` | `#E8E8F0` | `#1A1A22` |
| `muted` | `#6B6B80` | `#888899` |

### Component conventions

- Cards: `BorderRadius.circular(12)` + 1 px border using `surfaceVariant`.
- Interactive surfaces: `InkWell` with the theme's splash color.
- Context menus: `showMenu` triggered by long-press — **no custom bottom sheets** for simple actions.
- Icons: Flutter default (`Icons.*`).
- Fonts: Flutter default (no custom font unless explicitly requested).

---

## 7. Testing

Run tests with:

```bash
flutter test
```

### Coverage expectations (minimum)

| Layer | Minimum |
|---|---|
| `domain/` entities + logic | 90% |
| `data/` repositories | 80% |
| `features/` ViewModels | 70% |
| `features/` Views (widget tests) | Key user flows covered |

- Every new feature or bug fix **must** include or update relevant unit/widget tests.
- Never delete or weaken existing tests without explicit instruction.
- Test files mirror the `lib/` structure under `test/`.

---

## 8. Code Generation

After **any** of the following, run code-gen before committing:

- New or modified Drift table definitions or DAOs.
- New or modified `@riverpod` annotations.

```bash
dart run build_runner build --delete-conflicting-outputs
```

Never commit `.g.dart` or `.drift.dart` files in a broken/stale state.

---

## 9. Git & PR Rules

### Branch naming

```
main           → stable, tagged releases (never target directly)
develop        → integration branch (all PRs target this)
feature/<name> → individual features
fix/<name>     → bug fixes
```

### Before opening a PR

1. `flutter analyze` — must report **zero warnings**.
2. `flutter test` — all tests must pass.
3. `dart run build_runner build --delete-conflicting-outputs` — if generated files changed.
4. PR must include or update relevant tests.
5. One feature or fix per PR — keep scope focused.

---

## 10. General Agent Behaviour

- **Prefer minimal, targeted edits.** Do not refactor unrelated code.
- **Never introduce new dependencies** without confirming they support iOS, Android, macOS, and Windows.
- **Do not use `WidgetRef` outside widgets** under any circumstance.
- **Do not place logic in `View` files.** All logic belongs in the ViewModel (provider).
- **Always use `AppColors` tokens** — never hardcode colors.
- **Always add versioned migrations** when changing the Drift schema — never drop or alter existing migration steps.
- **Run `flutter analyze` mentally** before finalising any Dart edit; fix any issues introduced.
- When scaffolding a new feature, follow the `canvas/` or `dialogue_editor/` feature structure exactly.
- Export format is **JSON only** in MVP (`.gamestory.json` via `share_plus`). Do not implement other export formats unless the milestone explicitly calls for it.
