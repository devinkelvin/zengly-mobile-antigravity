# ZENGLY SCREEN INVENTORY & ARCHITECTURE MAP (V2 AUDIT)

This document contains a complete inventory of every screen, component, and user journey across the Zengly mobile application.

---

## 1. Authentication & Onboarding Module
| Screen Name | File Path | Route Key | Current State | Target Redesign |
|---|---|---|---|---|
| **Splash Screen** | `lib/view/onboarding/splash_screen.dart` | `/` | Functional animated splash | Visual polish, branding alignment |
| **Onboarding Carousel** | `lib/view/onboarding/onboarding_screen.dart` | `/onboarding` | Basic 3s auto-switch, fixed buttons | Interactive swipeable PageView, progress indicators, Skip/Next/Get Started |
| **Choose Sign-Up / Auth Gate** | `lib/view/auth/choose_sign_up_screen.dart` | `/chooseSignUp` | Static buttons | Premium brand styling, social / email entry |
| **Sign-Up Screen** | `lib/view/auth/sign_up/sign_up_screen.dart` | `/signUp` | Standard text fields | Improved validation, input spacing, clear hierarchy |
| **Login Known Screen** | `lib/view/auth/login/login_known_screen.dart` | `/loginKnown` | Basic avatar + PIN/password | Modern greeting, biometric quick-tap, forgot PIN |
| **Login Unknown Screen** | `lib/view/auth/login/login_unknown_screen.dart` | `/loginUnknown` | Basic email/password | Refined inputs, password visibility toggle, clear recovery |
| **Reset Password** | `lib/view/auth/reset_password/reset_password_screen.dart` | `/resetPassword` | Basic form | Clean instructional layout, error handling |
| **OTP Verification** | `lib/view/auth/otp/otp_screen.dart` | `/otp` | Pinput field | Resend countdown timer, clear feedback, haptics |
| **New Password Setup** | `lib/view/auth/new_password/new_password_screen.dart` | `/newPassword` | 2 password fields | Real-time strength meter, confirm match validation |
| **Create Transaction PIN** | `lib/view/auth/transaction_pin/create_pin_screen.dart` | `/createPin` | 4-digit PIN pad | Custom numeric keypad, security reassurance |
| **Confirm Transaction PIN** | `lib/view/auth/transaction_pin/confirm_pin_screen.dart` | `/confirmPin` | 4-digit PIN pad | Match validation, error shake animation |
| **Biometrics Setup** | `lib/view/auth/biometrics/biometrics_screen.dart` | `/biometrics` | Enable / Skip buttons | FaceID / Fingerprint prompt, Skip and Enable CTAs |

---

## 2. Dashboard & Core Banking Module
| Screen Name | File Path | Route Key | Current State | Target Redesign |
|---|---|---|---|---|
| **Home Dashboard** | `lib/view/home/home_screen.dart` | `/dashboard` (Tab 0) | Overlap fixed, but balance card & quick actions need polish | Luxury balance card, functional Z-Coins button, symmetrical actions |
| **Available Balance Card** | `lib/view/home/widgets/account_card.dart` | Component | Plain grey box (`AccountCard2`) | Luxury metallic finish, currency formatting, eye toggle, Sterling account copy pill |
| **Z-Coins Screen** | `lib/view/home/screens/z_coins_screen.dart` | `zCoins` (NEW) | **MISSING (Static 450 Z-Coins pill)** | **Create dedicated Z-Coins Screen: balance, earning rules, perks, history, empty states** |
| **Transfer Hub (Full-Screen)** | `lib/view/transfer/pre_transfer_screen.dart` | `preTransfer` (Tab 1) | Replaces drawer | Unified full-screen destination for ALL Transfer entry points across app |
| **Select Recipient** | `lib/view/transfer/select_recipient_screen.dart` | `selectRecipient` | List with search | Recent contacts, Zengly tag search, bank account lookup |
| **Transfer Amount** | `lib/view/transfer/amount_screen.dart` | `amount` | Amount input | Numeric keypad, quick amount chips, balance warning |
| **Confirm Transfer** | `lib/view/transfer/confirm_transfer_screen.dart` | `confirmTransfer` | Review card | Fee breakdown (₦0.00), recipient details, PIN modal trigger |
| **Transfer Success** | `lib/view/transfer/transfer_success_screen.dart` | `transferSuccess` | Coin celebration | Rotating coin, share receipt, return home |
| **Transfer Receipt** | `lib/view/transfer/transfer_receipt_screen.dart` | `transferReceipt` | Digital slip | Download PDF / Share image, transaction reference |

---

## 3. Vaniti & Social Finance Module
| Screen Name | File Path | Route Key | Current State | Target Redesign |
|---|---|---|---|---|
| **Vaniti Landing Screen** | `lib/view/special_features/pre_special_features_screen.dart` | `preSpecialFeatures` (Tab 2) | Overview cards & host action | Luxury social fintech hub, currency toggle, top sprayers preview |
| **Spray Options Screen** | `lib/view/special_features/spray_cash/screens/spray_options_screen.dart` | `sprayOptions` | **HARSH BLACK BG** | **CRITICAL: Eliminate black background; use refined theme surfaces, brand gold accents, styled spray cards** |
| **Vaniti Spray Cash Flow** | `lib/view/special_features/spray_cash/screens/spray_cash_screen.dart` | `sprayCash` | **Broken "Send To" buttons (NFC, Contacts, Username)** | **FIX ALL SEND TO BUTTONS: wire to NFC radar, contacts sheet, username lookup; preserve state** |
| **Interactive Spray Screen** | `lib/view/special_features/spray_cash/screens/about_to_spray_screen.dart` | `aboutToSpray` | Swipe gesture | Fluid swipe motion, stack reduction, dynamic cash counter |
| **Vaniti Leaderboard Screen** | `lib/view/special_features/widgets/vaniti_leaderboard_sheet.dart` | Component / Modal | Bottom sheet | **Revamp into celebratory podium experience (1st, 2nd, 3rd podium + ranking list)** |
| **QR Scanner** | `lib/view/special_features/spray_cash/screens/qr_scanner_screen.dart` | `/qrScanner` | Camera scanner | Scanner reticle, torch toggle, manual code input fallback |
| **Spray Success** | `lib/view/special_features/spray_cash/screens/spray_success_screen.dart` | `spraySuccess` | Receipt + rating | Celebration animations, leaderboard position highlight |

---

## 4. AI Insights & Assistant Module
| Screen Name | File Path | Route Key | Current State | Target Redesign |
|---|---|---|---|---|
| **AI Insights Hub** | `lib/view/insight/insight_screen.dart` | Tab 3 | Multi-tab container | Unified header, fluid tab selector, back navigation |
| **"All" Tab** | `lib/view/insight/widgets/insight_all_tab.dart` | Tab 3 (All) | **Incomplete list with non-interactive links** | **Complete All Tab: category filters, search, tap-to-open detail modal, real financial intelligence** |
| **AI Assistant Chat** | `lib/view/insight/widgets/insight_chat_tab.dart` | Tab 3 (Assistant) | Static red "A" avatar, mock typing | Premium AI companion UI, suggested prompt chips, message bubbles, active input & send |
| **Spending Analytics** | `lib/view/insight/widgets/insight_analytics_tab.dart` | Tab 3 (Analytics) | Chart points | Line/bar chart with period toggles (Week, Month, Year) |
| **Spending Categories** | `lib/view/insight/widgets/insight_spending_tab.dart` | Tab 3 (Spending) | Donut breakdown | CompactCalendarSheet integration, category breakdown |

---

## 5. Account, Profile & Settings Module
| Screen Name | File Path | Route Key | Current State | Target Redesign |
|---|---|---|---|---|
| **Account Screen** | `lib/view/account/account_screen.dart` | Tab 4 | Basic list tiles | Every button made fully functional, clean card groupings, Tier badge |
| **Personal Info Screen** | `lib/view/personal_info/personal_info_screen.dart` | `personalInfo` | Profile form | Photo upload, reactive provider update, toast feedback |
| **Appearance / Theme** | `lib/view/account/appearance_screen.dart` | `appearance` | Theme selector | Light / Dark / System device settings |
| **Transaction Limits** | `lib/view/account/widgets/account_sheets.dart` | Modal | Tier limits sheet | Daily / Monthly limit bars, upgrade tier CTA |
| **Security Settings** | `lib/view/account/widgets/account_sheets.dart` | Modal | Security sheet | Change PIN, Reset Password, Biometric toggle |
| **Report a Bug** | `lib/view/account/widgets/account_sheets.dart` | Modal | Feedback form | Category selector, description input, submit toast |
| **Help & Support** | `lib/view/account/widgets/account_sheets.dart` | Modal | Support hub | Live chat, WhatsApp, Email, FAQ links |
| **Notifications Hub** | `lib/view/notifications/notification_screen.dart` | `notification` | Notifications list | Filter chips (All, Unread, Transfers & Perks), mark all read |

---

## 6. Cards & Lifestyle Finance Module
| Screen Name | File Path | Route Key | Current State | Target Redesign |
|---|---|---|---|---|
| **Cards Hub** | `lib/view/cards/screens/cards_screen.dart` | `cardScreen` | Tabbed Virtual/Physical | Luxury metallic card, reveal CVV/PAN, freeze/unfreeze |
| **Fund Card Screen** | `lib/view/cards/screens/fund_card_screen.dart` | `fundCard` | FX calculator | Real-time exchange rate, quick presets, zero fee |
| **Card Details Screen** | `lib/view/cards/screens/card_details_screen.dart` | `cardDetails` | Credentials list | Copyable PAN/CVV, verified US billing address |
| **All Cards Overview** | `lib/view/cards/screens/all_card_screen.dart` | `allCards` | List view | Total balance portfolio across cards |
| **Card Terms & Pricing**| `lib/view/cards/screens/confirm_card_details_screen.dart` | `confirmCardDetail` | Authentic disclosures | Clear fees, rates, usage rules, primary checkbox |
| **Menu Services Hub** | `lib/view/bill_payments/pre_bill_screen.dart` | `preBills` | Categorized grid | Real-time search, Transfer navigates to full-screen |
| **Ajo 2.0 Savings** | `lib/view/special_features/ajo/` | `ajoHub` | 4-screen flow | Rotating savings, roster, cycle progress, join code |
| **P2P Lending** | `lib/view/special_features/lending/` | `p2pLending` | Lending & loan apply | Loan calculator, APR disclosures, credit limit |
| **Voice Banking** | `lib/view/special_features/voice_banking/` | `voiceBanking` | Voice screen | Audio waveform, intent parsing, PIN confirmation |
