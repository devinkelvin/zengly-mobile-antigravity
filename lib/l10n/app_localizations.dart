import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @pleaseTryAgainOrCheckConnection.
  ///
  /// In en, this message translates to:
  /// **'Please try again or check your connection.'**
  String get pleaseTryAgainOrCheckConnection;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'I forgot my password'**
  String get forgotPassword;

  /// No description provided for @yourMoneyYourFreedom.
  ///
  /// In en, this message translates to:
  /// **'Your Money, Your Freedom, Your Zengly.'**
  String get yourMoneyYourFreedom;

  /// No description provided for @createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAnAccount;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @confirmDetailsToLogin.
  ///
  /// In en, this message translates to:
  /// **'Confirm your details to log into your account '**
  String get confirmDetailsToLogin;

  /// No description provided for @emailAddressCaps.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddressCaps;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @openAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Open an account'**
  String get openAnAccount;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @enterYour6DigitPasscode.
  ///
  /// In en, this message translates to:
  /// **'Enter your 6 digit passcode'**
  String get enterYour6DigitPasscode;

  /// No description provided for @incorrectPasscode.
  ///
  /// In en, this message translates to:
  /// **'Incorrect passcode, please try again'**
  String get incorrectPasscode;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @weJustSentOtp.
  ///
  /// In en, this message translates to:
  /// **'We just sent you a one-time password.'**
  String get weJustSentOtp;

  /// No description provided for @enterPinPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter pin'**
  String get enterPinPlaceholder;

  /// No description provided for @noOtpHelp.
  ///
  /// In en, this message translates to:
  /// **'No OTP? No worries! Check your spam folder or try resending it.'**
  String get noOtpHelp;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @enter6DigitOtpToProceed.
  ///
  /// In en, this message translates to:
  /// **'Enter 6 digit OTP to proceed'**
  String get enter6DigitOtpToProceed;

  /// No description provided for @didntGetCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get Code? '**
  String get didntGetCode;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendIn(int seconds);

  /// No description provided for @resendNow.
  ///
  /// In en, this message translates to:
  /// **'Resend now'**
  String get resendNow;

  /// No description provided for @tryAgainWhenTimerExpires.
  ///
  /// In en, this message translates to:
  /// **'Try again when the timer expires'**
  String get tryAgainWhenTimerExpires;

  /// No description provided for @otpResentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'OTP resent successfully'**
  String get otpResentSuccessfully;

  /// No description provided for @voila.
  ///
  /// In en, this message translates to:
  /// **'Great job! Welcome!'**
  String get voila;

  /// No description provided for @welcomeToZengly.
  ///
  /// In en, this message translates to:
  /// **'A small surprise is waiting for you—log in to claim it!'**
  String get welcomeToZengly;

  /// No description provided for @retrievePassword.
  ///
  /// In en, this message translates to:
  /// **'Retrieve Password'**
  String get retrievePassword;

  /// No description provided for @enterRegisteredEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your registered email address or username '**
  String get enterRegisteredEmail;

  /// No description provided for @emailAddressLower.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddressLower;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @resetYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Your Password'**
  String get resetYourPassword;

  /// No description provided for @provideRegisteredEmail.
  ///
  /// In en, this message translates to:
  /// **'Provide your registered email address.'**
  String get provideRegisteredEmail;

  /// No description provided for @onceVerifiedWeWillSendOtp.
  ///
  /// In en, this message translates to:
  /// **'Once verified, we\'ll send your OTP to this email.'**
  String get onceVerifiedWeWillSendOtp;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'name@mail.com'**
  String get emailPlaceholder;

  /// No description provided for @verifyingPleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Verifying... Please wait'**
  String get verifyingPleaseWait;

  /// No description provided for @takeTwoSecs.
  ///
  /// In en, this message translates to:
  /// **'Take 2 secs'**
  String get takeTwoSecs;

  /// No description provided for @emailAddressVerified.
  ///
  /// In en, this message translates to:
  /// **'Email Address Verified'**
  String get emailAddressVerified;

  /// No description provided for @otpVerification.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerification;

  /// No description provided for @enterOtpSentToYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP sent to your email: '**
  String get enterOtpSentToYourEmail;

  /// No description provided for @didntReceiveCodeResendIn.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code? Resend code in '**
  String get didntReceiveCodeResendIn;

  /// No description provided for @didntReceiveCodeResendNow.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code? '**
  String get didntReceiveCodeResendNow;

  /// No description provided for @resendCodeNow.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCodeNow;

  /// No description provided for @otpVerified.
  ///
  /// In en, this message translates to:
  /// **'OTP Verified'**
  String get otpVerified;

  /// No description provided for @newPasswordCreated.
  ///
  /// In en, this message translates to:
  /// **'New Password Created'**
  String get newPasswordCreated;

  /// No description provided for @proceedToSignInWithNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Proceed to sign in with your newly created password.'**
  String get proceedToSignInWithNewPassword;

  /// No description provided for @signInWithNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Sign in with new password'**
  String get signInWithNewPassword;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @secondsShort.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String secondsShort(int seconds);

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get createNewPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm  New Password'**
  String get confirmNewPassword;

  /// No description provided for @enterTheSamePassword.
  ///
  /// In en, this message translates to:
  /// **'Enter the same password'**
  String get enterTheSamePassword;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @awesomeAllSet.
  ///
  /// In en, this message translates to:
  /// **'Awesome!, You\'re all set.'**
  String get awesomeAllSet;

  /// No description provided for @oops.
  ///
  /// In en, this message translates to:
  /// **'Oops'**
  String get oops;

  /// No description provided for @passcodeLockedAndLoaded.
  ///
  /// In en, this message translates to:
  /// **'Your passcode is locked and loaded — time to take charge of your finances!'**
  String get passcodeLockedAndLoaded;

  /// No description provided for @setYourPasscode.
  ///
  /// In en, this message translates to:
  /// **'Set Your Passcode 🔐'**
  String get setYourPasscode;

  /// No description provided for @create6DigitPin.
  ///
  /// In en, this message translates to:
  /// **'Create a 6-digit Passcode for your login'**
  String get create6DigitPin;

  /// No description provided for @pleaseEnterComplete6DigitPin.
  ///
  /// In en, this message translates to:
  /// **'Please enter a complete 6-digit Passcode.'**
  String get pleaseEnterComplete6DigitPin;

  /// No description provided for @greatNowConfirmPin.
  ///
  /// In en, this message translates to:
  /// **'Great! Now Confirm Passcode'**
  String get greatNowConfirmPin;

  /// No description provided for @pinsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Pins do not match'**
  String get pinsDoNotMatch;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTitle;

  /// No description provided for @tier1.
  ///
  /// In en, this message translates to:
  /// **'Tier 1'**
  String get tier1;

  /// No description provided for @biometricsTitle.
  ///
  /// In en, this message translates to:
  /// **'Biometrics'**
  String get biometricsTitle;

  /// No description provided for @fingerprintOrFaceId.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint or face ID'**
  String get fingerprintOrFaceId;

  /// No description provided for @profileAndAccount.
  ///
  /// In en, this message translates to:
  /// **'Profile & Account'**
  String get profileAndAccount;

  /// No description provided for @manageYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage your account'**
  String get manageYourAccount;

  /// No description provided for @verificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verificationTitle;

  /// No description provided for @kycVerification.
  ///
  /// In en, this message translates to:
  /// **'KYC verification'**
  String get kycVerification;

  /// No description provided for @transactionLimit.
  ///
  /// In en, this message translates to:
  /// **'Transaction Limit'**
  String get transactionLimit;

  /// No description provided for @viewAccountTransactionLimits.
  ///
  /// In en, this message translates to:
  /// **'View account transaction limits'**
  String get viewAccountTransactionLimits;

  /// No description provided for @reportABug.
  ///
  /// In en, this message translates to:
  /// **'Report a Bug'**
  String get reportABug;

  /// No description provided for @helpMakeUsBetter.
  ///
  /// In en, this message translates to:
  /// **'Help make us better'**
  String get helpMakeUsBetter;

  /// No description provided for @referAndEarn.
  ///
  /// In en, this message translates to:
  /// **'Refer & Earn'**
  String get referAndEarn;

  /// No description provided for @makeSomeExtraCash.
  ///
  /// In en, this message translates to:
  /// **'Make some extra cash'**
  String get makeSomeExtraCash;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @managePasswordAndPin.
  ///
  /// In en, this message translates to:
  /// **'Manage Password and PIN '**
  String get managePasswordAndPin;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @talkWithCustomerService.
  ///
  /// In en, this message translates to:
  /// **'Talk with a customer service'**
  String get talkWithCustomerService;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @personalizeVisualExperience.
  ///
  /// In en, this message translates to:
  /// **'Personalize your visual experience across the app'**
  String get personalizeVisualExperience;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @defaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultLabel;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get navInsights;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get personalInfo;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @currentState.
  ///
  /// In en, this message translates to:
  /// **'Current State'**
  String get currentState;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
