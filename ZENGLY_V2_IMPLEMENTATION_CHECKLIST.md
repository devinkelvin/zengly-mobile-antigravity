# ZENGLY V2 IMPLEMENTATION CHECKLIST

This checklist tracks the second-pass overhaul execution and verification across all phases.

Legend:
- `[ ]` Pending
- `[~]` In Progress
- `[x]` Implemented & Verified on Device

---

## Phase 1: Audit & Discovery
- [x] Complete codebase inspection and gap identification
- [x] Reopened previous checklist and confirmed missing/incomplete screens
- [x] Generated `ZENGLY_SCREEN_INVENTORY.md`
- [x] Generated `ZENGLY_V2_UI_UX_AUDIT.md`
- [x] Generated `ZENGLY_REMAINING_FIXES.md`
- [x] Generated `ZENGLY_V2_IMPLEMENTATION_CHECKLIST.md`

---

## Phase 2: Onboarding & Auth Transformation
- [x] Refactor `OnboardingScreen` with interactive swipeable PageView
- [x] Add smooth progress indicators, Skip, Next, and Get Started actions
- [x] Audit and polish Sign-Up screens (`ChooseSignUpScreen`, `SignUpScreen`)
- [x] Audit and polish Login screens (`LoginKnownScreen`, `LoginUnknownScreen`)
- [x] Audit OTP, Reset Password, New Password, and PIN screens
- [x] Verify Light and Dark mode on all auth screens

---

## Phase 3: Home Screen & Z-Coins Overhaul
- [x] Redesign Available Balance Card with luxury fintech surface & Sterling account copy pill
- [x] Standardize ActionPanel quick-action button sizing, spacing, and icon alignment
- [x] Build dedicated `ZCoinsScreen` (`lib/view/home/screens/z_coins_screen.dart`)
- [x] Register `zCoins` route in `AppRouter`
- [x] Make `CoinWidget` an interactive button navigating to `zCoins`
- [x] Verify zero overlapping or clipped elements on Home screen

---

## Phase 4: Full-Screen Transfer Unification
- [x] Remove `transferOptionsSheet` invocation from `ActionPanel` (navigate to full-screen `preTransferScreen`)
- [x] Remove `transferOptionsSheet` invocation from `PreBillScreen` (navigate to `preTransferScreen`)
- [x] Redirect `AppOverlays.transferOptionsSheet` to full-screen `PreTransferScreen`
- [x] Verify that EVERY transfer entry point in the entire app routes to full-screen `PreTransferScreen`

---

## Phase 5: Zengly AI Assistant Tab Redesign
- [x] Redesign `InsightChatTab` header, branding, and status indicator
- [x] Replace red "A" avatar with animated Gold AI companion orb
- [x] Upgrade prompt chips with interactive dispatch
- [x] Style user and AI message bubbles with proper elevation and timestamps
- [x] Elevate input field with send and action triggers

---

## Phase 6: Complete the "All" Tab
- [x] Add category filter pills to `InsightAllTab`
- [x] Add search bar and filter lookup
- [x] Make card links and bodies interactive, opening comprehensive detail bottom sheet
- [x] Provide empty states for filters with no results and reset button

---

## Phase 7: Complete Account Screen & Every Button
- [x] Audit and wire all 10+ options in `AccountScreen`
- [x] Connect profile photo change action with `profilePhotoPickerSheet`
- [x] Wire Tier 1 badge to `transactionLimitsSheet`
- [x] Verify `personalInfo`, `preVerification`, `appearance`, and sheets
- [x] Ensure 100% of buttons respond with back navigation and zero dead ends

---

## Phase 8: Complete Vaniti Overhaul
- [x] **Remove black background from `SprayOptionsScreen`, `SprayCashScreen`, and `AboutToSprayScreen`**
- [x] Implement theme-aware surfaces with subtle warm luxury gradients
- [x] Redesign spray style cards and selection layout with gold checkmarks
- [x] **Fix ALL "Send To" buttons**:
  - [x] "Scan QR": opens live `qrScanner` route and updates target recipient
  - [x] "NFC Tap": opens interactive NFC radar modal with target pairing
  - [x] "Contacts": opens contact search sheet with quick select
  - [x] "Username": opens Zengly tag lookup sheet with suggestions & validation
- [x] Connect recipient selection into `SprayConfirmationScreen` and `AboutToSprayScreen`

---

## Phase 9: Vaniti Leaderboard Podium Revamp
- [x] Redesign `VanitiLeaderboardSheet` with top 3 visual celebratory podium (1st, 2nd, 3rd)
- [x] Add ranked list for 4th to 10th sprayers with badges and amounts
- [x] Add current user ranking sticky bar at the bottom with "Spray More" action

---

## Phase 10-14: System-wide Standardization & Physical Device QA
- [x] Design system tokens pass (Colors, Typography, Buttons, Theme consistency)
- [x] Resolved lint/compile issues (`Colors.black87`, etc.)
- [x] Hot reload verified on physical Samsung SM-G973F (`RF8M530EGGA`)
- [x] Verify Light Mode & Dark Mode across all updated screens
- [x] Final implementation report ready

