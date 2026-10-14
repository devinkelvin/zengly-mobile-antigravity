# ZENGLY APPLICATION — COMPLETE OVERHAUL CHECKLIST

This checklist tracks the screen-by-screen and flow-by-flow progress of the end-to-end Zengly UI/UX overhaul.

Legend:
- `[ ]` Not started / In progress
- `[x]` Audited, Redesigned, Implemented & Verified

---

## 1. System Foundation & Design Tokens
- [x] Design System Audit (Colors, Typography, Spacing, Radius, Elevation)
- [x] Preserve `#B57510` Gold brand identity & semantic dark/light gradients
- [x] Standardize button system (Primary, Secondary, Icon, Pill, Loading)
- [x] Standardize card and container border radii & subtle glassmorphism
- [x] Light Mode & Dark Mode token parity across all custom widgets

---

## 2. Critical Issue Resolutions

### 2.1 AI Insights Spending Calendar
- [x] Compact bottom-sheet calendar component created (`CompactCalendarSheet` in `lib/widgets/compact_calendar_sheet.dart`)
- [x] Single month view displayed at a time with smooth chevron navigation
- [x] Half-screen height constraint (no full-screen disruption)
- [x] Date range selection support with gold `#B57510` highlight
- [x] Quick preset filter pills (Today, 7D, 30D, This Month)
- [x] Apply and Cancel buttons with state preservation
- [x] Full Light Mode & Dark Mode theming
- [x] Connected to `InsightSpendingTab` and `InsightViewModel`

### 2.2 Unified Transfer Experience
- [x] Audit all Transfer entry points (Home ActionPanel, Bottom Nav Tab 1, Menu Screen)
- [x] Unified `PreTransferScreen` layout (clean header, balance pill, recent recipients tray, method tiles)
- [x] Upgraded `TransferOptionsSheet` sharing identical design hierarchy
- [x] Fixed empty AppBar issue when navigated via bottom navigation
- [x] Seamless flow through Recipient Selection -> Amount -> Review -> Pin -> Success -> Receipt

### 2.3 Home Screen Overhaul
- [x] Fixed "Unlock Your Zengly Experience" KYC banner text and icon collision
- [x] Eliminated image overlapping text across all screen widths and font scales
- [x] Redesigned `ActionPanel` quick-action buttons with consistent symmetrical sizing and alignment
- [x] Fixed "NEW" badge positioning and prevented clipping
- [x] Refined balance card with sensitive balance toggle and clean copy feedback
- [x] Balanced visual rhythm and content hierarchy

### 2.4 Data vs Airtime Routing Separation
- [x] Fixed routing so "Airtime" explicitly launches the Airtime journey
- [x] Fixed routing so "Data" explicitly launches the Data bundle journey
- [x] Dynamic AppBar title reflecting user selection ("Airtime Top-up" vs "Data Bundles")
- [x] Data flow connected directly to data plan selection (`select_data_plan_screen.dart`)
- [x] Both entry points in `ActionPanel` and `PreBillScreen` updated

---

## 3. Cards Module Complete Overhaul
- [x] State Management: Created reactive `cards_vm.dart` (`CardsNotifier`, `ZenglyCardData`, `CardTransactionItem`, `cardsProvider`)
- [x] Luxury Card Design (`zengly_card.dart`): EMV chip rendering, NFC contactless icon, sensitive info toggle, copy-to-clipboard, frozen card overlay
- [x] `VirtualCards` tab: Interactive card display, quick controls (Fund Card, Freeze/Unfreeze, Details), daily limit progress bar, card transaction history
- [x] `PhysicalCards` tab: Active NFC card state, PIN change flow, freeze toggle, lost/stolen reporting, debit card request flow
- [x] `FundCardScreen`: Live USD-to-NGN conversion (1 USD = ₦1,500), quick presets ($20, $50, $100, $250), zero-markup platform fee breakdown, instant funding modal
- [x] `CardDetailsScreen`: Verified PAN, Expiry, CVV reveal, and full US billing address required for international digital checkouts
- [x] `AllCardScreen`: Portfolio overview with total card balance across physical and virtual cards
- [x] `ConfirmCardDetailsScreen`: Replaced copy-pasted duplicate fee rows with authentic fintech disclosures (Usage & Acceptance, Rates & Conversion, Fees & Pricing)
- [x] Branded Card Creation Success (`card_success_widget.dart`): Replaced hardcoded red border with primary brand styling

---

## 4. Account, Profile & Settings Overhaul
- [x] `AccountScreen`: Transparent header, verified Tier 1 status pill, profile banner, reactive biometrics toggle switch
- [x] `account_vm.dart`: Created reactive state management for user profile, biometric authentication state, and alert preferences
- [x] Account Sheets (`account_sheets.dart`): Verified SecuritySettingsSheet, TransactionLimitsSheet, ReportBugSheet, SupportHelpSheet
- [x] `PersonalInfoScreen` & `personal_info_vm.dart`: Form validation, pre-populated controller state from provider, avatar selection, and save feedback
- [x] `NotificationScreen` & `notification_vm.dart`: Category filter chips (All, Unread, Transfers & Perks), mark-all-read action, authentic Zengly notifications
- [x] `HistoryScreen` & `history_vm.dart`: Unified transaction history state notifier, multi-parameter search/filters, receipt sharing

---

## 5. Social Finance & Smart Features
- [x] Ajo 2.0 Rotating Savings (`AjoLandingScreen`, `CreateAjoGroupScreen`, `AjoGroupDetailsScreen`, `JoinAjoGroupScreen`)
- [x] P2P Lending Flow (`P2pLendingScreen`, `ApplyLoanScreen`, loan schedule & APR disclosures)
- [x] Voice Banking Flow (`VoiceBankingScreen`, animated waveform, intent parsing, authorization modal)
- [x] Vaniti Social Spraying & Leaderboard (`VanitiLeaderboardSheet`, `VanitiHostEventSheet`, sprayer rankings)
- [x] Menu Hub: Modern service grid with live real-time filtering and zero placeholder dead ends

---

## 6. Screen-by-Screen Inventory Checklist

| Screen / Flow | Audited | Redesigned | Implemented | Light Mode | Dark Mode | Verified |
|---|:---:|:---:|:---:|:---:|:---:|:---:|
| Splash & Onboarding | [x] | [x] | [x] | [x] | [x] | [x] |
| Login & Auth Flows | [x] | [x] | [x] | [x] | [x] | [x] |
| Home Dashboard | [x] | [x] | [x] | [x] | [x] | [x] |
| Transfer Hub & Flow | [x] | [x] | [x] | [x] | [x] | [x] |
| Airtime Top-up | [x] | [x] | [x] | [x] | [x] | [x] |
| Data Bundles | [x] | [x] | [x] | [x] | [x] | [x] |
| Electricity & Utilities | [x] | [x] | [x] | [x] | [x] | [x] |
| AI Insights Spending | [x] | [x] | [x] | [x] | [x] | [x] |
| AI Spending Calendar | [x] | [x] | [x] | [x] | [x] | [x] |
| Vaniti Hub & Spraying | [x] | [x] | [x] | [x] | [x] | [x] |
| Vaniti Host & Leaderboard| [x] | [x] | [x] | [x] | [x] | [x] |
| Split Bill Experience | [x] | [x] | [x] | [x] | [x] | [x] |
| Ajo 2.0 Hub & Circles | [x] | [x] | [x] | [x] | [x] | [x] |
| P2P Lending & Borrow | [x] | [x] | [x] | [x] | [x] | [x] |
| Voice Banking | [x] | [x] | [x] | [x] | [x] | [x] |
| Menu Service Hub | [x] | [x] | [x] | [x] | [x] | [x] |
| Cards Hub (Virtual/Phys)| [x] | [x] | [x] | [x] | [x] | [x] |
| Fund Card Screen | [x] | [x] | [x] | [x] | [x] | [x] |
| Card Details Screen | [x] | [x] | [x] | [x] | [x] | [x] |
| All Cards Overview | [x] | [x] | [x] | [x] | [x] | [x] |
| Card Terms & Pricing | [x] | [x] | [x] | [x] | [x] | [x] |
| Account & Security | [x] | [x] | [x] | [x] | [x] | [x] |
| Personal Info Profile | [x] | [x] | [x] | [x] | [x] | [x] |
| Notifications Hub | [x] | [x] | [x] | [x] | [x] | [x] |
| History & Receipts | [x] | [x] | [x] | [x] | [x] | [x] |
| User KYC & Verification | [x] | [x] | [x] | [x] | [x] | [x] |

---

## 7. Quality Assurance & Physical Device Verification
- [x] Zero compilation errors across all modified libraries
- [x] Live hot reload verified on physical Samsung SM-G973F (`RF8M530EGGA`): **200 of 2912 libraries reloaded in 6,296ms**
- [x] AppRouter: All routes tested and linked with proper parameter and extra object propagation
- [x] Contrast, typography, and responsive padding conforming to Zengly design system
