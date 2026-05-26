---
description: Add a new Drift table with DAO, domain repository interface, and migration
---

Use this workflow when extending the database schema with a new table.
Replace `<Table>` with the PascalCase table name and `<entity>` with the snake_case entity name.

## Steps

1. Define the Drift table in `lib/data/database/tables/<entity>s_table.dart`:
   - Class name: `<Table>sTable` (Drift convention uses plural).
   - Annotate with `@DataClassName('<Entity>')` to control the generated row class name.

2. Register the table in `lib/data/database/app_database.dart`:
   - Add to the `@DriftDatabase(tables: [...])` annotation list.
   - **Bump the `schemaVersion`** integer.

3. Write the versioned migration in `lib/data/database/migrations/migration_v<N>.dart`:
   - Implement as a `MigrationStrategy` step using `m.createTable(...)`.
   - Register it inside `AppDatabase.migration` under the appropriate `from` version.

4. Create the DAO in `lib/data/database/daos/<entity>s_dao.dart`:
   - Annotate with `@DriftAccessor(tables: [<Table>sTable])`.
   - Expose `watch*` methods returning `Stream<...>` for reactive UI.
   - Expose `insert`, `update`, `delete` methods.

5. Register the DAO in `AppDatabase` (`daos:` list in the `@DriftDatabase` annotation).

6. Define the domain repository interface in `lib/domain/repositories/<entity>_repository.dart`:
   - Pure Dart interface — zero Flutter/Drift imports.
   - Follow `watch / create / update / delete` pattern with `Stream`-based watch methods.

7. Implement the repository in `lib/data/repositories/drift_<entity>_repository.dart`:
   - Inject the DAO; map Drift row types ↔ domain entity types.

8. Register the repository implementation in the Riverpod provider graph (typically a `Provider` in the relevant feature's provider file).

9. Run code generation:
```bash
dart run build_runner build --delete-conflicting-outputs
```

10. Verify schema and tests:
```bash
flutter analyze
flutter test
```
