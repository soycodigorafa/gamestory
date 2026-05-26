---
description: Pre-PR checklist — analyze, test, and codegen before opening a pull request
---

Run this workflow before opening any PR. All steps must pass with zero errors/warnings.

## Steps

1. If any Drift tables or `@riverpod` annotations changed, regenerate:
```bash
dart run build_runner build --delete-conflicting-outputs
```

2. Run static analysis — must produce **zero warnings**:
```bash
flutter analyze
```

3. Run the full test suite:
```bash
flutter test
```

4. Review coverage targets:
   - `domain/` entities + logic → ≥ 90 %
   - `data/` repositories → ≥ 80 %
   - `features/` ViewModels → ≥ 70 %
   - Key widget flows → covered

5. Confirm branch naming:
   - New feature → `feature/<name>`
   - Bug fix → `fix/<name>`
   - PR targets `develop`, **never** `main`.

6. Confirm PR scope — one feature or fix per PR. Split if needed.
