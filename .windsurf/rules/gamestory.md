---
trigger: always_on
---

# GameStory — AI Rules

## Architecture (MVVM)

- Views are stateless `ConsumerWidget`s. They **only** watch providers and call ViewModel methods — no business logic inside widgets.
- ViewModels are Riverpod `Notifier` or `AsyncNotifier` classes. They coordinate between the UI and domain repositories.
- Repositories in `data/` implement abstract interfaces defined in `domain/repositories/`. The domain layer must never depend on Flutter or any external package.
- **Layer import rules** (strictly enforced):
  - `lib/features/.../view/` and `lib/features/.../widgets/` → may only import from `lib/shared/`, `lib/domain/`, and sibling `providers/`.
  - `lib/features/.../providers/` → may only import from `lib/domain/`.
  - `lib/data/` → may import from `lib/domain/` and Drift/external packages.
  - `lib/domain/` → pure Dart only; zero Flutter or package imports.
- Never pass `WidgetRef` outside the widget layer. Pass data or callbacks instead.

## State Management (Riverpod)

- Use `@riverpod` code-gen annotations exclusively — no manual `Provider(...)` constructors.
- Provider naming: `<noun>Provider` suffix, e.g. `dialogueTreeProvider`, `projectListProvider`.
- One provider file per feature, located at `lib/features/<name>/providers/<name>_provider.dart`.
- Use `Provider` for stateless/derived/async-loaded values, `Notifier` for mutable sync state, `AsyncNotifier` for DB- or network-backed mutable state.
- After any `@riverpod` annotation change run: `dart run build_runner build --delete-conflicting-outputs`.

## Data Layer (Drift)

- All Drift table definitions live in `lib/data/database/tables/`.
- Each table has its own DAO in `lib/data/database/daos/`.
- Repositories expose **Stream-based APIs** for reactive UI updates — never return a plain `Future<List<T>>` for watched collections.
- Schema changes require a new numbered migration in `lib/data/database/migrations/` and a version bump in `AppDatabase`.
- After any Drift table change run: `dart run build_runner build --delete-conflicting-outputs`.

## Design Language

### Color tokens (use `AppColors` constants, never raw hex)

| Token constant | Hex |
|---|---|
| `AppColors.background` | `#0E0E12` |
| `AppColors.surface` | `#1A1A22` |
| `AppColors.surfaceVariant` | `#24242F` |
| `AppColors.primary` | `#7B61FF` |
| `AppColors.secondary` | `#00D9C0` |
| `AppColors.error` | `#FF4D6D` |
| `AppColors.onSurface` | `#E8E8F0` |
| `AppColors.muted` | `#6B6B80` |

### Component conventions

- All cards: `BorderRadius.circular(12)` + `1 px` border in `AppColors.surfaceVariant`.
- Interactive surfaces: `0.05` opacity white overlay on hover (desktop), `InkWell` splash on mobile.
- Icons: `phosphor_flutter` package only — consistent outline style.
- Fonts: `JetBrains Mono` for code/monospace contexts, `Inter` for body text.
- **No platform-adaptive widgets in MVP** — one unified dark theme for all platforms.

### Shared Gs components

- All reusable primitives live in `lib/shared/widgets/` and follow the `Gs` prefix: `GsButton`, `GsCard`, `GsTextField`, etc.
- Never inline design tokens directly in feature widgets — always use `AppColors`, `AppTheme` values, or a `Gs` component.

## Naming Conventions

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Providers: `camelCaseProvider`
- Entities (domain): plain noun, e.g. `Project`, `DialogueNode`, `Item`, `Condition`, `Milestone`
- Input DTOs: `Create<Entity>Input`, `Update<Entity>Input`
- Repository interfaces: `<Entity>Repository` in `lib/domain/repositories/`
- Drift implementations: `Drift<Entity>Repository` in `lib/data/repositories/`

## Testing

| Layer | Minimum coverage |
|---|---|
| `domain/` entities + logic | 90 % |
| `data/` repositories | 80 % |
| `features/` ViewModels | 70 % |
| `features/` Views (widget tests) | key user flows covered |

- Never delete or weaken an existing test without explicit direction.
- Write or update tests **before** implementing changes to repositories and ViewModels.

## PR / Git Rules

- Branches: `feature/<name>` for features, `fix/<name>` for bugs. PRs target `develop`, never `main`.
- Before opening a PR: run `flutter analyze` (zero warnings), `flutter test`, and `dart run build_runner build` if generated files changed.
- One feature or fix per PR — keep scope focused.
