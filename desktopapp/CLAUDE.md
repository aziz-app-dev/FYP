# Project guidance

## Standing UI/UX design skills (always active)

For **all** UI work in this project, treat these three skills as standing guidance — apply them automatically, no explicit activation needed:

- **material-3** — MD3 tokens, components, theming, color/typography for every screen.
- **mobile-app-ui-design** — screen layout, flows, navigation, mobile-first.
- **ui-ux-pro-max** — design-system decisions: palettes, font pairings, spacing, interaction states, accessibility.

How to apply them here:
- Don't redesign screens proactively. The user names the screen(s) to update.
- MD3 adoption level is your call per screen; flag the tradeoff.
- Reuse the existing design system rather than inventing new primitives:
  - Components: `lib/res/components/` (`CustomTextField`, `AppDropdown`, `AppButton`, `AppBarWidget`, `AppFlushbar`, `AppIcon`).
  - Colors: `lib/res/colors/app_color.dart`. Brand/primary is orange `0xFFff6701`.
  - Sizing: `flutter_screenutil`. **Use `.spMin` for sizes and gaps** (the user's preference).

## Tech stack notes

- State management: **Riverpod** (`StateNotifierProvider`; providers in `lib/view_models/providers/`, states in `lib/view_models/states/`).
- Persistence: **Hive** (boxes + manual `toMap`/`fromMap`), wrapped by `DatabaseService`/`HiveService` in `lib/view_models/services/database/database_services.dart`.
- Responsive breakpoints: `AppSizes.isMobile` (<600), `isTablet` (600–1100), `isDesktop` (≥1100) in `lib/utils/app_sizes.dart`.

### flutter_screenutil sizing pitfalls (important)

`designSize` is **360×690**. So:
- `.w` scales by width ratio (~5.3× on a 1080p desktop) — using it for fixed widths like a list pane blows the layout out and causes overflow (the yellow/black stripe). **Avoid `.w` for large fixed dimensions on desktop.**
- `.spMin` scales by the smaller axis ratio (~1.56× on 1080p) — safe for sizes and gaps. Prefer it.
- Don't put a `ListView` inside `Align`/`Center` (loosens height → list collapses, only trailing widgets show). Don't wrap form sections in `IntrinsicHeight` + `Row` of `Expanded` cards inside a scroll view — it can collapse fields to zero height. Keep scrolled forms as a plain single-column `ListView`; center on wide screens via dynamic horizontal padding.
