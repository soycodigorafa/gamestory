---
description: Run Drift + Riverpod code generation (build_runner)
---

Run this workflow after any change to:
- Drift table definitions (`lib/data/database/tables/`)
- Riverpod `@riverpod` annotations in any provider file

## Steps

1. Run code generation:
```bash
dart run build_runner build --delete-conflicting-outputs
```

2. Verify there are no analysis errors:
```bash
flutter analyze
```

3. If errors exist, fix them before continuing — generated files must compile cleanly.
