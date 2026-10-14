# ZENGLY REMAINING FIXES & TASK SPECIFICATION

This document details the targeted code repairs and implementations to execute during the V2 Overhaul.

---

### Task 1: Complete Onboarding & Auth Transformation (Phase 2)
1. **Interactive Onboarding Carousel:**
   - Replace auto-switching timer with swipeable `PageView`.
   - Add top or bottom `SmoothPageIndicator` or custom progress capsules.
   - Implement "Skip" (navigates to `/loginUnknown` or `/chooseSignUp`), "Next" (advances slide), and "Get Started" (on final slide).
   - Ensure light & dark mode gradients match brand identity.
2. **Sign-Up & Login Screens Polish:**
   - Elevate inputs in `lib/view/auth/sign_up/sign_up_screen.dart`, `lib/view/auth/login/login_unknown_screen.dart`, and `lib/view/auth/login/login_known_screen.dart`.
   - Ensure clean password toggle, error states, and responsive spacing.

---

### Task 2: Home Screen Balance Card & Z-Coins Screen (Phase 3)
1. **Redesign Available Balance Card (`AccountCard` / `AccountCard2`):**
   - Sleek dark metallic / warm amber gradient surface with subtle border.
   - Currency typography: `₦2,000,000.00` in `GoogleFonts.inter` (weight 800, letterSpacing -0.5).
   - Eye icon for toggling balance concealment (`₦••••••`).
   - Sterling Bank virtual account pill with one-tap copy and haptic feedback.
   - Cashback indicator pill (`+₦12,450.50 Cashback Available`).
2. **Implement Dedicated Z-Coins Screen (`ZCoinsScreen`):**
   - Create `lib/view/home/screens/z_coins_screen.dart`.
   - Large Z-Coins balance header with 3D coin illustration.
   - Tier multiplier badge ("Tier 1 • 1.2x Earn Rate").
   - Earning opportunities list (Referrals, Vaniti sprays, Bill payments, Airtime top-ups).
   - Rewards catalog (Airtime discounts, Zero-fee card loads, Vaniti badge unlocks).
   - Rewards transaction history list.
   - Register route `zCoins` in `AppRouter`.
   - Update `CoinWidget` to be an interactive button navigating to `zCoins`.

---

### Task 3: Complete Transfer Bottom Sheet Elimination (Phase 4)
1. **Remove `transferOptionsSheet` invocation across app:**
   - In `lib/view/home/widgets/action_panel.dart`: Change Transfer button onTap to `ref.read(dashboardVm).switchPage(1)` or `context.pushNamed(AppRouter.preTransferScreen)`.
   - In `lib/view/bill_payments/pre_bill_screen.dart`: Change Transfer tile to `context.pushNamed(AppRouter.preTransferScreen)`.
   - Deprecate or redirect `AppOverlays.transferOptionsSheet` so it navigates to full-screen `PreTransferScreen`.

---

### Task 4: Redesign Zengly AI Assistant & Complete the "All" Tab (Phases 5 & 6)
1. **Overhaul AI Assistant Tab (`InsightChatTab`):**
   - Refined header with live AI status indicator.
   - Replace static red "A" avatar with brand-gold animated AI orb icon.
   - Interactive quick prompt chips (e.g., "Analyze my food spending", "How much did I spray this week?", "Forecast next month budget").
   - Responsive message bubbles with timestamp, copy action, and markdown support.
   - Active input bar with microphone icon, clear button, and animated send button.
2. **Complete the "All" Tab (`InsightAllTab`):**
   - Add search and category filter bar (All, Spending, Fraud Alerts, Budgeting, Rewards).
   - Add date range selector.
   - Wire cards so tapping link or card body opens detailed modal/sheet with full breakdown and action buttons.

---

### Task 5: Account Screen Complete Button Audit (Phase 7)
1. Audit all 10+ options in `AccountScreen`:
   - Profile picture tap: photo picker / avatar sheet.
   - Personal info: navigates to `personalInfo`.
   - Verification: navigates to `preVerification`.
   - Transaction limits: opens `TransactionLimitsSheet`.
   - Security: opens `SecuritySettingsSheet` (Change PIN, Reset Password, Biometrics).
   - Report a bug: opens `ReportBugSheet`.
   - Support: opens `SupportHelpSheet`.
   - Appearance: navigates to `appearance`.
   - Logout: opens `logoutSheet`.
   - Ensure 100% of actions respond with zero dead ends.

---

### Task 6: Complete Vaniti Redesign (Phases 8 & 9)
1. **Remove Black Background from Spray Options (`SprayOptionsScreen` & `SprayCashScreen`):**
   - Replace hardcoded black backgrounds with theme-aware `AppTheme.backgroundGradient` and `AppTheme.lightBackgroundGradient`.
   - Modernize card styles, borders, and selection highlights.
2. **Fix All "Send To" Buttons (`SprayCashScreen`):**
   - "Scan QR": opens live `qrScanner` route.
   - "NFC Tap": opens interactive NFC scanning radar modal.
   - "Contacts": opens contact search & recipient selection sheet.
   - "Username": opens Zengly @username lookup sheet.
   - Save selected recipient into state and pass into confirmation & spray flows.
3. **Revamp Vaniti Leaderboard (`VanitiLeaderboardSheet`):**
   - Top 3 celebratory podium layout (Gold 1st, Silver 2nd, Bronze 3rd with avatars, badges, and spray totals).
   - Ranked list for 4th to 10th places.
   - Current user ranking highlight bar at the bottom.
