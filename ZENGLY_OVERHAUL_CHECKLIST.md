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
- [x] Light Mode & Dark Mode token parity

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

## 3. New Feature Experiences & Flow Completions

### 3.1 Complete Ajo 2.0 Rotating Savings Flow
- [x] `AjoLandingScreen`: Group overview, active cycles, public explore tabs, create/join CTAs
- [x] `CreateAjoGroupScreen`: Multi-step form (group name, amount, frequency, payout rule, schedule)
- [x] `AjoGroupDetailsScreen`: Member rotation roster, status indicators, pool total, contribution CTA
- [x] `JoinAjoGroupScreen`: Invitation code input, group rules preview, slot confirmation
- [x] Development & compliance state indicators

### 3.2 Complete Peer-to-Peer (P2P) Lending Flow
- [x] `P2pLendingScreen`: Borrow vs Lend segmented views, credit limit, trust score
- [x] `ApplyLoanScreen`: Real-time loan calculator (amount slider, duration, APR, fee breakdown)
- [x] `LoanDetailsAndRepaymentScreen`: Active loan summary, repayment schedule, payment modal
- [x] Transparent risk disclosures and mock operational state disclaimer

### 3.3 Complete Voice Banking Flow
- [x] `VoiceBankingScreen`: Sleek voice interface with interactive mic button
- [x] Audio waveform pulse animation (Ready, Listening, Processing states)
- [x] Intent recognition card (command breakdown, recipient, amount, source)
- [x] Confirmation prompt with PIN/Biometric authorization step
- [x] Error recovery & sample command tips

### 3.4 Menu Screen Complete Redesign
- [x] Modern categorized menu layout (Payments, Utilities, Social Finance, Smart AI, Cards)
- [x] Sleek icon containers and badges (NEW, AI, V2)
- [x] Instant search filtering for fast access
- [x] All menu items wired to live destinations with zero dead-end toasts

---

## 4. Screen-by-Screen Inventory Checklist

| Screen / Flow | Audited | Redesigned | Implemented | Light Mode | Dark Mode | Verified |
|---|:---:|:---:|:---:|:---:|:---:|:---:|
| Splash & Onboarding | [x] | [x] | [x] | [x] | [x] | [x] |
| Login & Auth Flows | [x] | [x] | [x] | [x] | [x] | [x] |
| Home Dashboard | [x] | [x] | [x] | [x] | [x] | [x] |
| Transfer Flow | [x] | [x] | [x] | [x] | [x] | [x] |
| Airtime Top-up | [x] | [x] | [x] | [x] | [x] | [x] |
| Data Bundles | [x] | [x] | [x] | [x] | [x] | [x] |
| Electricity & Utilities | [x] | [x] | [x] | [x] | [x] | [x] |
| AI Insights Dashboard | [x] | [x] | [x] | [x] | [x] | [x] |
| AI Spending Calendar | [x] | [x] | [x] | [x] | [x] | [x] |
| Vaniti Hub & Spraying | [x] | [x] | [x] | [x] | [x] | [x] |
| Split Bill Experience | [x] | [x] | [x] | [x] | [x] | [x] |
| Ajo 2.0 (New Flow) | [x] | [x] | [x] | [x] | [x] | [x] |
| P2P Lending (New Flow) | [x] | [x] | [x] | [x] | [x] | [x] |
| Voice Banking (New Flow)| [x] | [x] | [x] | [x] | [x] | [x] |
| Menu Screen | [x] | [x] | [x] | [x] | [x] | [x] |
| Cards Screen | [x] | [x] | [x] | [x] | [x] | [x] |
| Account & Settings | [x] | [x] | [x] | [x] | [x] | [x] |
| User KYC & Verification | [x] | [x] | [x] | [x] | [x] | [x] |

---

## 5. Verification & Quality Assurance
- [x] Reusable component integration and modularity
- [x] Zero compilation or runtime route broken links
- [x] Safe-area & responsiveness audit
- [x] Contrast & accessibility check (WCAG 2.2 AA)
