# ZENGLY V2 UI/UX AUDIT & GAP ANALYSIS

## Executive Findings

Following an exhaustive inspection of the entire codebase and verification against the V2 Master Directives, this audit establishes the exact gaps, broken interactions, and required redesigns across the application.

---

### Critical Gaps Identified in Second-Pass Audit

1. **Transfer Bottom Sheet vs Full-Screen Policy (Phase 4):**
   - **Defect:** `ActionPanel` in `lib/view/home/widgets/action_panel.dart` and `PreBillScreen` in `lib/view/bill_payments/pre_bill_screen.dart` still called `AppOverlays.transferOptionsSheet(context: context)` opening a bottom drawer.
   - **Resolution Required:** Eliminate the Transfer bottom drawer across the ENTIRE application. All Transfer buttons (Home, ActionPanel, Menu, Quick actions) must directly switch to or navigate to the shared full-screen `PreTransferScreen`.

2. **Home Screen Balance Card & Z-Coins Button (Phase 3):**
   - **Defect 1:** `AccountCard2` is a flat rectangular container with unstyled text and lacks premium visual sophistication (gradients, embossing, gold accents, Sterling account details).
   - **Defect 2:** `CoinWidget` (`lib/view/home/widgets/coin_widget.dart`) is a static non-clickable 32px pill displaying "450 Z-coins" with NO `onTap`, NO route, and NO destination screen.
   - **Resolution Required:** Redesign the balance card into a luxury fintech asset. Create a dedicated `ZCoinsScreen` displaying total Z-Coins balance, tier multiplier, earning actions (Transfers, Bill pay, Vaniti sprays), redemption catalog, and transaction history. Wire `CoinWidget` to this screen.

3. **Vaniti Spray Options Background & Send To Buttons (Phase 8):**
   - **Defect 1:** `SprayOptionsScreen` and `SprayCashScreen` use a harsh black background (`Color(0xFF161410)` / black) rather than Zengly's warm brand gradient and theme tokens.
   - **Defect 2:** In `SprayCashScreen` (lines 280-312), the 4 "Send To" buttons (*Scan QR, NFC Tap, Contacts, Username*) only set `_selectedSendMethod = "..."` without opening any real sheet, radar, or modal. Tapping "Start Spray" immediately prompted for PIN with NO recipient selected.
   - **Resolution Required:** Remove black backgrounds from `SprayOptionsScreen` and `SprayCashScreen`. Wire "Scan QR" to live QR scanner, "NFC Tap" to interactive radar sheet, "Contacts" to contact picker sheet, and "Username" to user search sheet. Pass recipient data into `SprayConfirmationScreen` and `AboutToSprayScreen`.

4. **Vaniti Leaderboard Overhaul (Phase 9):**
   - **Defect:** Leaderboard was previously rendered only as a generic bottom sheet with a basic list.
   - **Resolution Required:** Completely revamp into a high-energy celebratory podium experience with 1st, 2nd, and 3rd place visual podiums, badges, spray totals, user rank indicators, and real-time refresh.

5. **AI Assistant & "All" Tab (Phase 5 & 6):**
   - **Defect 1:** In `InsightScreen`, the **"All"** tab was a 25-line list displaying non-interactive links (`arrow_forward` icons with no click handlers).
   - **Defect 2:** The AI Assistant tab (`InsightChatTab`) had a static red "A" avatar, mock typing text, and rigid layout.
   - **Resolution Required:** Overhaul the "All" tab with search, category filtering (Savings, Fraud Alerts, Tax, Spending), date ranges, and interactive modals displaying full financial recommendations. Elevate `InsightChatTab` to Cash App/Revolut-grade intelligence companion with interactive prompt chips, styled user/AI bubbles, active message dispatch, and clearing.

6. **Onboarding, Sign-Up & Login Complete Revamp (Phase 2):**
   - **Defect 1:** `OnboardingScreen` was bound to an automatic 3-second timer without user-friendly swipe controls, missing interactive Skip and Next navigation pills.
   - **Defect 2:** Sign-up, login, and returning user screens need cohesive brand elevation, modern input styling, password visibility toggles, and seamless recovery.

7. **Account Screen Action Completeness (Phase 7):**
   - **Defect:** Every interactive control on the Account screen must be verified to ensure 100% operational integrity with back navigation.
