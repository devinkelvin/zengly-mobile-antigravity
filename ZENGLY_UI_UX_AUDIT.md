# ZENGLY MOBILE APPLICATION — UI/UX AUDIT REPORT
**Document Version:** 1.0.0  
**Project:** Zengly Social Fintech & Lifestyle Finance Mobile Application (Flutter)  
**Lead Auditor:** Elite Multidisciplinary Product Design & Engineering Team  
**Evaluation Date:** October 2026  

---

## 1. Executive Summary & Audit Overview

Zengly is a hybrid social fintech and lifestyle finance mobile application designed to merge everyday banking, bill settlements, peer-to-peer social finance, and cultural lifestyle moments (notably the signature *Vaniti* digital cash-spraying experience).

An exhaustive codebase inspection of the entire Flutter project (`zengly-mobile-main`) was conducted across:
- **Routing & Navigation Hierarchy:** `lib/utils/app_router.dart`, `lib/view/dashboard/`
- **Design Tokens & System:** `lib/utils/app_theme.dart`, `app_dimensions.dart`, `app_colors.dart`
- **Dashboard & Core Hub:** `lib/view/home/`
- **Financial Transactions:** `lib/view/transfer/`, `lib/view/bill_payments/`
- **Social & Special Features:** `lib/view/special_features/` (Vaniti, Split Bill, Ajo, Lending, Voice)
- **Financial Intelligence:** `lib/view/insight/`
- **Identity & Compliance:** `lib/features/kyc/`, `lib/view/user_verification/`

The audit confirmed high product potential with modern Flutter 3.7+ architecture, Riverpod state management, and GoRouter navigation. However, the audit revealed several critical usability and structural deficits that compromise the premium fintech standard required.

---

## 2. Comprehensive Screen & Navigation Inventory

| # | Screen Name | Codebase Location | Route Identifier | Category | Current Status | Issues Identified & Required Fix |
|---|---|---|---|---|---|---|
| 01 | Splash Screen | `lib/view/onboarding/splash_screen.dart` | `/` | Onboarding | Existing & Acceptable | Ensure smooth branded transition to Onboarding/Dashboard. |
| 02 | Onboarding Carousel | `lib/view/onboarding/onboarding_screen.dart` | `/onboarding` | Onboarding | Existing - Needs Polish | Review pagination indicators, responsive padding on small devices. |
| 03 | Choose Sign Up / Login | `lib/view/auth/choose_sign_up_screen.dart` | `/chooseSignUp` | Auth | Existing - Needs Polish | Consistent button hierarchy, dark/light contrast. |
| 04 | Login Screen | `lib/view/auth/login/` | `/loginKnown`, `/loginUnknown` | Auth | Existing - Needs Polish | Password visibility toggle, biometric prompt styling. |
| 05 | Sign Up & Verification | `lib/view/auth/sign_up/` | `/signUp`, `/otp` | Auth | Existing - Acceptable | Form validation styling and OTP input spacing. |
| 06 | Home Dashboard | `lib/view/home/home_screen.dart` | `/dashboard` (Tab 0) | Core | **Critically Defective** | **Text overlap on "Unlock your Zengly experience" with hand icon; Quick-action grid misaligned; uneven button sizes; balance card clutter.** |
| 07 | Pre-Transfer Hub | `lib/view/transfer/pre_transfer_screen.dart` | `/preTransfer` (Tab 1) | Financial | **Inconsistent** | **Dual entry point discrepancy (Tab opens full screen with empty appbar; Home quick action opens bottom sheet). Inconsistent styling.** |
| 08 | Recipient Selection | `lib/view/transfer/select_recipient_screen.dart` | `/selectRecipient` | Financial | Existing - Needs Polish | Search responsiveness, recent recipient avatars, bank list styling. |
| 09 | Amount Entry | `lib/view/transfer/amount_screen.dart` | `/amount` | Financial | Existing - Needs Polish | Dynamic keypad styling, balance sufficiency warning, currency formatting. |
| 10 | Confirm Transfer | `lib/view/transfer/confirm_transaction_screen.dart` | `/confirmTransfer` | Financial | Existing - Needs Polish | Fee transparency breakdown, recipient confirmation card, PIN modal. |
| 11 | Transfer Success & Receipt | `lib/view/transfer/transfer_success_screen.dart` | `/transferSuccess`, `/transferReceipt` | Financial | Existing - Needs Polish | Download/share receipt format, clean receipt scalloped edges. |
| 12 | AI Insights Dashboard | `lib/view/insight/insight_screen.dart` | `/dashboard` (Tab 3) | Financial AI | Existing - Good Visuals | Spending analytics charts are visually clean; calendar requires fix. |
| 13 | AI Insights Spending Tab | `lib/view/insight/widgets/insight_spending_tab.dart` | Embedded Tab | Financial AI | **Critically Defective** | **Date picker triggers full-screen Material date range picker displaying 2 months simultaneously. Must be replaced with compact single-month bottom sheet.** |
| 14 | Airtime & Data Screen | `lib/view/bill_payments/airtime/airtime_data_screen.dart` | `/airtimeData` | Utilities | **Functionally Broken Routing** | **Both "Data" and "Airtime" buttons open this screen defaulted to Tab 0 (Airtime). Data journey is bypassed unless user manually flips tab. Must separate into dedicated journeys.** |
| 15 | Select Data Plan Screen | `lib/view/bill_payments/airtime/select_data_plan_screen.dart` | `/selectDataPlan` | Utilities | Existing - Needs Polish | Data plans list styling (daily, weekly, monthly tabs), plan card layout. |
| 16 | Electricity Bill Screen | `lib/view/bill_payments/electricity/` | `/electricity` | Utilities | Existing - Needs Polish | Meter type selector, disc provider icons, token copy feedback. |
| 17 | Menu Screen | `lib/view/bill_payments/pre_bill_screen.dart` | `/preBills` | Navigation | **Critically Defective** | **Basic card styling, generic layout, dead-end toast notifications for Ajo 2.0, P2P Lending, and Voice Banking.** |
| 18 | Vaniti Hub | `lib/view/special_features/pre_special_features_screen.dart` | `/preSpecialFeatures` (Tab 2)| Social Finance | Existing - Needs Polish | Balance pill contrast in light mode, spray money button responsiveness, host event flow. |
| 19 | Vaniti Spray Cash | `lib/view/special_features/spray_cash/` | `/sprayCash` | Social Finance | Existing - Needs Polish | Bill denomination selector, gesture feedback, sound/haptic hooks. |
| 20 | Split Bill Hub | `lib/view/special_features/split_bill/` | `/splitBill` | Social Finance | Existing - Needs Polish | Create split, participant chips, custom share math, payment status badges. |
| 21 | Ajo 2.0 Experience | `lib/view/special_features/ajo/` | `/ajoHub` (To be created) | Social Finance | **Missing Flow (Dead End)** | **Currently only displays a toast "Ajo 2.0 is coming soon!". Complete group savings journey required (create, join, details, schedule).** |
| 22 | Peer-to-Peer Lending | `lib/view/special_features/lending/` | `/p2pLending` (To be created) | Social Finance | **Missing Flow (Dead End)** | **Currently only displays a toast "P2P Lending is coming soon!". Complete borrow/lend journey required (calculator, terms, repayment schedule).** |
| 23 | Voice Banking | `lib/view/special_features/voice_banking/` | `/voiceBanking` (To be created) | Smart AI | **Missing Flow (Dead End)** | **Currently only displays a toast "Voice Banking is coming soon!". Complete voice banking journey required (mic permission, waveform, parsing, confirmation).** |
| 24 | Cards Management | `lib/view/cards/cards_screen.dart` | `/cardScreen` | Banking | Existing - Needs Polish | Virtual card carousel, freeze toggle, reveal CVV modal, create card. |
| 25 | Account / Profile Screen| `lib/view/account/account_screen.dart` | `/dashboard` (Tab 4) | Settings | Existing - Needs Polish | KYC status badge, security settings, biometric switch, theme toggle, logout modal. |
| 26 | KYC Verification Flow | `lib/screen/kyc/` | `/preVerification`, `/ninScreen` | Compliance | Existing - Needs Polish | Step tracker, camera capture preview, document validation errors. |

---

## 3. Detailed Analysis of Critical Issues

### 3.1 AI Insights Spending Calendar
- **Defect:** `_showCustomDatePicker` in `insight_spending_tab.dart` calls the default Flutter `showDateRangePicker()`. This opens a modal spanning the entire screen width and height, displaying two months simultaneously in an unstyled Material dialog.
- **Impact:** Disorients the user, disrupts the sleek dark/gold aesthetic of the Insights dashboard, and feels like leaving the app.
- **Solution:** Implement `CompactDatePickerSheet`—a custom bottom sheet displaying exactly one month at a time with smooth chevron navigation, range selection highlights in `#B57510`, quick preset pills (Today, 7D, 30D, This Month), and Apply/Cancel controls.

### 3.2 Inconsistent Transfer Journey
- **Defect:** 
  1. Tapping "Transfer" from the Home `ActionPanel` opens `AppOverlays.transferOptionsSheet()` (a bottom sheet).
  2. Selecting Tab 1 from the bottom navigation bar loads `PreTransferScreen()` (a full-screen view with an empty app bar that cannot pop).
  3. The two entry points have distinct layouts, leading to confusion about which is the canonical transfer entry point.
- **Solution:** Unify the transfer experience:
  - Redesign `PreTransferScreen` into a high-end, dedicated Transfer Hub featuring unified method cards, quick recipient avatars, and clear back behavior when pushed.
  - Upgrade `TransferOptionsSheet` to share identical design tokens and visual hierarchy as the full screen.
  - Ensure all routes transition seamlessly into `SelectRecipientScreen` -> `AmountScreen` -> `ConfirmTransactionScreen` -> `TransferSuccessScreen`.

### 3.3 Home Screen Alignment & Spacing Deficiencies
- **Defect 1:** Banner "Unlock Your Zengly Experience 🎁" uses a fixed `Stack` with `right: -4, bottom: 0, height: 110` for `AppImages.handHold`. On standard screens, this image renders underneath and collides with the heading and body copy.
- **Defect 2:** Quick action buttons inside `ActionPanel` use fixed aspect ratios (`85 / 106`) with uncentered `NEW` badges (`top: -6, right: -14`) that clip on narrower viewports.
- **Defect 3:** Hardcoded dark background colors in cards prevent clean rendering in Light Mode.
- **Solution:** 
  - Restructure the KYC incentive banner into a responsive flex layout with guaranteed non-overlapping illustration placement and adaptive typography.
  - Refine the quick action grid with uniform 56dp circular containers, subtle elevation/borders, standardized typography, and balanced badge geometry.

### 3.4 Data vs Airtime Routing Flaw
- **Defect:** In `ActionPanel` and `PreBillScreen`, tapping "Data" navigates to `AppRouter.airtimeData`, exactly like "Airtime". Because `AirtimeDataScreen` initialized `_tabController` to index 0, selecting "Data" inexplicably opened the Airtime form.
- **Solution:** 
  - Add explicit routing/initialization: `AirtimeDataScreen(initialTab: 0)` for Airtime and `AirtimeDataScreen(initialTab: 1)` for Data.
  - Dynamically set the AppBar title ("Airtime Top-up" vs "Data Bundles") to reflect user intent.
  - Ensure seamless navigation from Data directly to `select_data_plan_screen.dart`.

### 3.5 Menu Screen & Dead-End Flows (Ajo 2.0, P2P Lending, Voice Banking)
- **Defect:** The Menu screen (`pre_bill_screen.dart`) previously contained dead-end tiles triggering toast popups ("coming soon!").
- **Solution:**
  - Redesign `PreBillScreen` into an executive fintech category browser with grouped cards, search bar, and badge indicators.
  - Build full end-to-end interactive experiences for **Ajo 2.0**, **Peer-to-Peer Lending**, and **Voice Banking** with realistic state machines and clear development/compliance disclaimers.

---

## 4. Design System Standards Established

### 4.1 Color System
- **Primary Brand Gold:** `#B57510`
- **Primary Light Container:** `#DB7600`
- **Dark Background Gradient:** `LinearGradient(colors: [Color(0xFF332408), Color(0xFF211B12), Color(0xFF161616)])`
- **Light Background Gradient:** `LinearGradient(colors: [Color(0xFFFFF3DC), Color(0xFFFAF0E4), Color(0xFFF5EDE0)])`
- **Dark Surface:** `#1E1E1E` / `#252525`
- **Light Surface:** `#FFFFFF` / `#F8F6F2`
- **Borders & Dividers:** Dark `#2E3336`, Light `#E0D8D0`
- **Feedback:** Success `#34C759`, Warning `#FF9500`, Error `#FF3B30`

### 4.2 Typography
- **Headings & Brand Titles:** `GoogleFonts.raleway()` (Bold / SemiBold)
- **Body, Numbers & Inputs:** `GoogleFonts.inter()` (Medium / Regular / SemiBold)
- **Financial Balances:** Strict tabular figure scanning, prominent font size (24–32sp), clear currency symbol (`₦` / `$`).

### 4.3 Spacing & Radius
- **Base Grid:** 4pt / 8pt scale (`4, 8, 12, 16, 20, 24, 32`)
- **Card Radius:** 16px – 20px
- **Pill / Button Radius:** 100px (full pill) or 12px (form button)
- **Modal Sheet Radius:** 24px top rounded corners
