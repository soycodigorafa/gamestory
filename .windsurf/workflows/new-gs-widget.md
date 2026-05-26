---
description: Create a new shared Gs component following GameStory design conventions
---

Use this workflow whenever a new reusable UI primitive is needed.
Replace `<Widget>` with the PascalCase widget name (e.g. `GsButton`, `GsCard`).

## Steps

1. Create the file `lib/shared/widgets/<widget_snake_case>.dart`.

2. Implement the widget class named `Gs<Widget>` extending `StatelessWidget` (or `StatefulWidget` only if internal animation state is required).

3. Design token checklist — **never** use raw values; always reference constants:
   - Colors → `AppColors.<token>` (e.g. `AppColors.primary`, `AppColors.surface`)
   - Border radius for cards → `BorderRadius.circular(12)`
   - Card border → `Border.all(color: AppColors.surfaceVariant, width: 1)`
   - Icons → `phosphor_flutter` package, outline style
   - Fonts → `AppTheme.monoTextStyle` for code/mono, `AppTheme.bodyTextStyle` for body

4. Interactive surface rules:
   - Desktop hover: wrap with `MouseRegion` + `AnimatedContainer` at `Colors.white.withOpacity(0.05)`.
   - Mobile tap: use `InkWell` with `AppColors.primary` as `splashColor`.

5. Export the widget from `lib/shared/widgets/widgets.dart` barrel file (create it if it doesn't exist).

6. Add the component to the **component catalogue screen** (`lib/features/catalogue/view/catalogue_screen.dart`) with all its variants.

7. Add a widget test in `test/shared/widgets/<widget_snake_case>_test.dart`:
   - Cover all public variants/states.
   - Verify design token usage (e.g. correct color, border radius).
