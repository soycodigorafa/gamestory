---
description: Scaffold a new feature following the GameStory MVVM structure
---

Use this workflow when adding a new feature (e.g. `items`, `conditions`, `milestones`).
Replace `<feature>` with the snake_case name and `<Entity>` with the PascalCase entity name.

## Steps

1. Create the feature folder structure:
```
lib/features/<feature>/
  providers/
    <feature>_provider.dart
  view/
    <feature>_screen.dart
  widgets/
    (feature-specific widgets)
```

2. Define the domain entity in `lib/domain/entities/<entity>.dart`:
   - Pure Dart class, zero Flutter/package imports.
   - Include `Create<Entity>Input` and `Update<Entity>Input` DTOs in the same file or a sibling `<entity>_input.dart`.

3. Define the repository interface in `lib/domain/repositories/<entity>_repository.dart`:
   - Follow the `watch / create / update / delete` pattern.
   - `watch*` methods return `Stream<...>`, never a plain `Future<List<T>>`.

4. Create the Drift implementation in `lib/data/repositories/drift_<entity>_repository.dart`:
   - Implement the domain interface.
   - Inject the relevant DAO via constructor.

5. Create the Riverpod provider file `lib/features/<feature>/providers/<feature>_provider.dart`:
   - Use `@riverpod` code-gen annotation only.
   - Use `AsyncNotifier` if state is DB-backed; `Notifier` for pure UI state.
   - Provider name: `<noun>Provider` suffix (e.g. `itemListProvider`).

6. Create the screen widget in `lib/features/<feature>/view/<feature>_screen.dart`:
   - Extend `ConsumerWidget` — stateless.
   - Watch providers and call ViewModel methods only; zero business logic.

7. Register the route in `lib/app/router.dart` with a named route constant.

8. Run code generation:
```bash
dart run build_runner build --delete-conflicting-outputs
```

9. Add or update tests:
   - `test/domain/<entity>_test.dart` — entity logic (≥ 90 % coverage target).
   - `test/data/<entity>_repository_test.dart` — repository (≥ 80 %).
   - `test/features/<feature>/<feature>_provider_test.dart` — ViewModel (≥ 70 %).

## Shared Gs Components

Import all via: `import 'package:gamestory/shared/widgets/gs_widgets.dart';`

| Component | Key props / variants | Use |
|---|---|---|
| `AppShell` | `child` | Responsive nav wrapper (mobile / tablet / desktop) — used in router, not in feature widgets |
| `GsBadge` | `status` (`complete` / `incomplete` / `locked`), `label?` | Status chips on list items |
| `GsBottomSheet` | `title`, `child` · static `.show(context, title, child)` | Modal bottom sheets for forms / actions |
| `GsButton` | `label`, `onPressed`, `variant` (`primary` / `secondary` / `ghost` / `destructive`), `icon?`, `isLoading?` | All CTA buttons |
| `GsCard` | `child`, `actions?`, `showBorder?`, `onTap?`, `padding?` | List cards / detail panels |
| `GsDialog` | static `.showConfirm(context, title, body?)` / `.showInput(context, title, inputLabel?, inputHint?)` | Confirm prompts and single-field input dialogs |
| `GsEmptyState` | `title`, `subtitle?`, `icon?`, `ctaLabel?`, `onCta?` | Zero-data / loading-failed screens |
| `GsIconButton` | `icon`, `onPressed`, `tooltip?`, `size` (`small` / `medium` / `large`), `color?` | Icon-only actions in toolbars / list rows |
| `GsProgressBar` | `progress` (0–1), `label?`, `milestoneThresholds?`, `height?` | Milestone / completion progress bars |
| `GsTextField` | `label?`, `hint?`, `error?`, `controller?`, `onChanged?`, `multiline?`, `autofocus?`, `enabled?` | All text inputs in forms |
| `GsTreeNode` | `label`, `indentLevel?`, `isExpanded?`, `hasChildren?`, `onToggle?`, `onTap?`, `trailing?`, `isSelected?` | Hierarchical outline / dialogue tree rows |
