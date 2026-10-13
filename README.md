# Zengly

Zengly is a Flutter consumer fintech app (Nigeria-focused) covering wallet funding, transfers, bill payments (airtime/data/electricity/TV), virtual cards, spend insights, and social money features (spray cash, split bill, gift cards), plus a BVN/NIN/selfie KYC flow.

## Tech stack

- **Flutter** (SDK `^3.7.0`), Dart, Material3, dark-only theme
- **State management**: Riverpod — see [State management](#state-management-mixed-migration-in-progress) below
- **Navigation**: `go_router`, 50+ named routes (`lib/utils/app_router.dart`)
- **HTTP**: `dio`, wrapped by a custom `ApiClient` with bearer-token injection and automatic 401 → refresh-token retry
- **Secure storage**: `flutter_secure_storage`, wrapped by `LocalStorage`
- **Biometrics**: `local_auth`
- **Models**: `freezed` + `json_serializable` for new code; code generation via `build_runner` / `riverpod_generator`
- **Flavors**: `dev` and `prod` via `flutter_flavorizr` (see `lib/flavors.dart`)
- **Localization**: `flutter_localizations` + `intl`, English + French, live switching (in progress — see below)

## Commands

```bash
# Install dependencies
flutter pub get

# Run with flavor (required)
flutter run -t lib/main.dart --flavor dev
flutter run -t lib/main.dart --flavor prod

# Build
flutter build apk --flavor dev
flutter build apk --flavor prod
flutter build ipa --flavor prod

# Tests
flutter test
flutter test test/path/to/test_file.dart

# Code generation (after touching freezed/riverpod-annotated models)
flutter pub run build_runner build --delete-conflicting-outputs

# Regenerate localized strings after editing the .arb files
flutter gen-l10n
```

## Architecture

The app is **mid-migration** from a layer-first structure to a feature-first one, so two patterns currently coexist.

### Folder structure

```
lib/
├── core/                  # NEW — shared infra for the feature-first migration
│   ├── network/           # ApiClient (Dio), ApiResponse<T> (freezed sealed class)
│   └── env/                # Environment / flavor config
├── features/              # NEW — feature-first slices (auth, kyc, transaction_pin so far)
│   └── [feature]/
│       ├── data/
│       │   ├── models/     # freezed models
│       │   └── services/   # replaces old *_repo.dart — talks to ApiClient
│       └── providers/      # replaces old *_controller.dart — @riverpod notifiers
├── screen/                 # NEW — screens belonging to migrated features (e.g. screen/kyc/*)
├── controller/             # LEGACY — ChangeNotifier controllers + repos, feature folders being phased out
├── data/
│   ├── models/             # api_models/ and local_models/
├── view/                   # LEGACY-pattern screens, organized by domain
│   └── [feature]/
│       ├── *_screen.dart
│       ├── *_vm.dart       # ChangeNotifier ViewModel
│       └── widgets/
├── widgets/                # Shared reusable UI components
├── l10n/                   # app_en.arb / app_fr.arb + generated AppLocalizations
└── utils/                  # Router, theme, validators, dimensions, logger
```

### State management (mixed — migration in progress)

1. **Legacy pattern** — still used by most screens: `home`, `dashboard`, `airtime`, `electricity`, `tv_subscription`, `gift_cards`, `spray_cash`, `insight`, `onboarding`. Manual `ChangeNotifier` classes exposed via `ChangeNotifierProvider`, consumed by `ConsumerWidget`s. Business logic and API calls live together in `lib/controller/[feature]/[feature]_controller.dart` + `[feature]_repo.dart`.
2. **New pattern** — adopted for `auth`, `kyc`, and `transaction_pin`. Riverpod code generation (`@riverpod`, generating `*.g.dart` via `riverpod_generator`), with `AsyncNotifier`-style classes holding `AsyncData` / `AsyncError` / `AsyncLoading` directly instead of manual loading/error flags.

| Feature | Status |
|---|---|
| Auth | Migrated to feature-first / `@riverpod` |
| KYC | Migrated to feature-first / `@riverpod` |
| Transaction PIN | Migrated to feature-first / `@riverpod` |
| Home, Dashboard, Airtime, Airtime-to-Cash, Electricity, TV Subscription, Gift Cards, Spray Cash, Insight, Onboarding | On legacy `ChangeNotifierProvider` pattern, wired with real logic |
| Cards, Transfer, History, Split Bill, Notifications, Personal Info, Account, User Verification | UI scaffolds only — `*_vm.dart` exist but are empty stubs (0–1 lines); screens use `ConsumerWidget`/`ConsumerStatefulWidget` shells with no provider actually wired up yet |

Verified by grepping for `ChangeNotifierProvider` vs `@riverpod` across `lib/controller` and `lib/view`, and checking line counts on every `*_vm.dart` file — the table above reflects actual code, not just planning notes.

**Key technical changes accompanying the migration:**
- `ApiResponse<T>` is now a `freezed` sealed class (`ApiSuccess<T>` / `ApiError<T>`) instead of a plain class with a status flag; call sites use exhaustive `switch` pattern matching.
- `ApiClient` itself is functionally unchanged (Dio, bearer-token injection, 401 → refresh-token retry) — just relocated from `lib/data/api/` to `lib/core/network/`.
- The old `lib/controller/auth`, `lib/controller/kyc`, `lib/controller/user` controllers/repos and the original `lib/data/api/` (`ApiClient`/`ApiResponse`) have been deleted; `lib/features/auth`, `lib/features/kyc`, `lib/features/transaction_pin` are their replacements.
- **WIP / known gap**: `lib/features/auth/data/services/auth_service.dart` currently has all real network calls commented out and returns mock success responses, pending backend integration. Treat auth as not wired to a live backend yet.

### Unchanged through the migration

- Routing: `go_router`, 50+ named routes
- Theming: dark-only Material3
- Secure storage wrapper (`LocalStorage`)
- Biometrics flow
- Overall navigation: Splash → Onboarding → Auth → Dashboard (tab-based, nested routes per feature)

### Repository pattern (legacy code still using it)

Controllers delegate API calls to `*Repo` classes → `ApiClient` (Dio). New feature-first code replaces this with `*Service` classes called directly from `@riverpod` providers.

## Localization (in progress)

Migrating from hardcoded strings to `flutter_localizations` + `intl` (English + French), with live language switching (no app restart).

**Infra (done):**
- `l10n.yaml` + `lib/l10n/app_en.arb` / `app_fr.arb` → generates `lib/l10n/app_localizations*.dart` via `flutter gen-l10n` (runs automatically on `flutter pub get`/build since `generate: true` is set in `pubspec.yaml`).
- `lib/controller/locale/locale_controller.dart` — `localeProvider` (Riverpod `StateNotifier<Locale>`), persists choice in `LocalStorage.locale`.
- `lib/app.dart` — `MaterialApp.router` watches `localeProvider` and rebuilds live.
- `lib/view/language/language_screen.dart` — language picker drives `localeProvider.setLanguage(...)` for real.

**Pattern for each new screen:**
1. Add the English string to `lib/l10n/app_en.arb`; add the matching French translation under the same key in `lib/l10n/app_fr.arb`.
2. Run `flutter gen-l10n` (or `flutter pub get`) to regenerate.
3. In the widget: `final l10n = AppLocalizations.of(context);` (no `!` needed — `nullable-getter: false` in `l10n.yaml`), then swap the literal for `l10n.keyName`.

**Screens done so far** (verified via `grep -rl "AppLocalizations.of" lib/view lib/widgets`): onboarding choice (`choose_sign_up_screen.dart`), login known/unknown, OTP, reset/new password, create/confirm PIN, biometrics screen, `home_screen.dart`, `account_screen.dart`, `personal_info_screen.dart`, dashboard bottom nav labels, `appp_error_widget.dart`, `login_bottom.dart`, `language_screen.dart`.

**Not done yet (~130 files, ~1000 string literals remain):** bill payments (airtime/data/electricity), transfers, cards, insights, spray cash / split bill / special features, gift cards, notifications, KYC screens, onboarding slide copy (currently lives in `onboarding_model.dart` as a static const list — needs restructuring to read from `AppLocalizations` via context instead). Continue screen-by-screen using the pattern above, prioritizing by user traffic.

## Notable dependencies

- `go_router` — routing
- `flutter_riverpod` / `riverpod_annotation` + `riverpod_generator` — state management
- `dio` — HTTP client
- `freezed_annotation` / `json_annotation` — immutable models + JSON codegen
- `flutter_secure_storage` — token/user data storage
- `local_auth` — biometric authentication
- `pinput` — OTP/PIN input
- `camera` / `image_picker` — KYC photo capture
- `toastification` — toast notifications
- `skeletonizer` — loading skeleton UI
- `fl_chart` — insights/spend charts
- `lottie` / `video_player` — animations and spray-cash video flows
