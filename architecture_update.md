# Zengly App — Architecture Update

## Summary

We are mid-migration of the Flutter app's architecture from a layer-first MVC-ish setup to a feature-first structure with Riverpod code generation. The migration is in progress on `main` (uncommitted in the working tree) and is not yet complete across all features.

## State management

Riverpod, transitioning between two patterns:

1. **Legacy pattern** — still used by most screens (e.g. `home`, `dashboard`, `airtime`, `electricity`, `tv_subscription`, `gift_cards`, `spray_cash`, `insight`, `onboarding`). Manual `ChangeNotifier` classes exposed via `ChangeNotifierProvider`, consumed by `ConsumerWidget`s. Business logic and API calls lived together in `lib/controller/[feature]/[feature]_controller.dart` + `[feature]_repo.dart`.

2. **New pattern** — adopted so far for `auth`, `kyc`, and `transaction_pin`. Uses Riverpod's code generation (`@riverpod` annotation, generating `*.g.dart` via `riverpod_generator`) with `AsyncNotifier`-style classes that hold `AsyncData` / `AsyncError` / `AsyncLoading` state directly, removing the need for manual loading/error boolean flags.

## Folder structure

Moving from layer-first to feature-first:

```
lib/
├── core/
│   ├── network/        # ApiClient (Dio), ApiResponse<T>
│   └── env/             # Environment / flavor config
├── features/
│   └── [feature]/
│       ├── data/
│       │   ├── models/      # freezed models (auth_session, user_model, kyc_status_model, etc.)
│       │   └── services/    # replaces old *_repo.dart — talks to ApiClient
│       └── providers/       # replaces old *_controller.dart — @riverpod notifiers
```

This replaces the old `lib/controller/[feature]/{controller,repo}.dart` + `lib/data/api/` split. The old `auth`, `kyc`, and `user` controllers/repos and the original `ApiClient`/`ApiResponse` have already been deleted from the repo; `features/auth`, `features/kyc`, and `features/transaction_pin` are their rebuilt replacements.

## Key technical changes

- `ApiResponse<T>` is now a `freezed` sealed class (`ApiSuccess<T>` / `ApiError<T>`) instead of a plain class with a status flag. Call sites use exhaustive `switch` pattern matching on the response.
- `ApiClient` still wraps Dio with bearer-token injection and automatic 401 → refresh-token retry, unchanged in behavior, just relocated to `core/network/`.
- **WIP note:** `features/auth/data/services/auth_service.dart` currently has all real network calls commented out and returns mock success responses. This is explicitly flagged in-code as temporary, pending backend integration.

## Migration status

| Feature | Status |
|---|---|
| Auth | Migrated to feature-first / `@riverpod` |
| KYC | Migrated to feature-first / `@riverpod` |
| Transaction PIN | Migrated to feature-first / `@riverpod` |
| Home, Dashboard, Airtime, Electricity, TV Subscription, Gift Cards, Spray Cash, Insight, Onboarding | Still on legacy `ChangeNotifierProvider` pattern |

The codebase is currently in a mixed/transitional state — both patterns coexist while the remaining features are migrated over.

## Unchanged

- Routing: GoRouter, 50+ named routes
- Theming: dark-only Material3
- Secure storage wrapper (`LocalStorage`)
- Biometrics flow
- Overall navigation flow (Splash → Onboarding → Auth → Dashboard)
