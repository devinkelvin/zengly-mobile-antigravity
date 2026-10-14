import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/data.dart';
import '../screen/kyc/bvn_verification_screen.dart';
import '../screen/kyc/pre_verification_screen.dart';
import '../screen/kyc/selfie_capture_screen.dart';
import '../view/view.dart';

class AppRouter {
  static const String splash = "/";
  static const String onboarding = "/onboarding";
  static const String chooseSignUp = "/chooseSignUp";
  static const String signUp = "/signUp";
  static const String loginKnown = "/loginKnown";
  static const String loginUnknown = "/loginUnknown";
  static const String loginPin = "/loginPin";
  static const String resetPassword = "/resetPassword";
  static const String otp = "/otp";
  static const String newPassword = "/newPassword";
  static const String createPin = "/createPin";
  static const String confirmPin = "/confirmPin";
  static const String biometrics = "/biometrics";
  static const String dashboard = "/dashboard";
  static const String personalInfo = "personalInfo";
  static const String language = "language";
  static const String appearance = "appearance";
  static const String selectDataPlan = "selectDataPlan";
  static const String purchaseSuccess = "purchaseSuccess";
  static const String purchaseReceipt = "purchaseReceipt";
  static const String history = "history";
  static const String transactionFilter = "transactionFilter";
  static const String requestDetails = "requestDetails";
  static const String shareReceipt = "shareReceipt";
  static const String notification = "notification";
  static const String preVerification = "preVerification";
  static const String selfieVerificationScreen = "selfieVerificationScreen";
  static const String bvnScreen = "bvnScreen";
  static const String ninScreen = "ninScreen";
  static const String addressScreen = "addressScreen";
  static const String profileCompletion = "profileCompletionScreen";
  static const String amountScreen = "amount";
  static const String confirmTransfer = "confirmTransfer";
  static const String preTransferScreen = "preTransfer";
  static const String selectRecipient = "selectRecipient";
  static const String transferReceipt = "transferReceipt";
  static const String transferSuccess = "transferSuccess";
  static const String preBill = "preBills";
  static const String airtimeData = "airtimeData";
  static const String airtimeToCash = "airtimeToCash";
  static const String electricity = "electricity";
  static const String electricityConfirmation = "electricityConfirmation";
  static const String electricityTransactionStatusScreen =
      "electricityTransactionStatusScreen";
  static const String tvSubscription = "tvSubscription";
  static const String giftCard = "giftCard";
  static const String preSpecialFeatures = "preSpecialFeatures";
  static const String splitBill = "splitBill";
  static const String splitBillHistory = "splitBillHistory";
  static const String createBill = "createBill";
  static const String inputSplitScreen = "inputSplitScreen";
  static const String splitBillDetailScreen = "splitBillDetailScreen";
  static const String sprayCash = "sprayCash";
  static const String sprayOptions = "sprayOptions";
  static const String sprayConfirmation = "sprayConfirmation";
  static const String sprayRadar = "sprayRadar";
  static const String aboutToSpray = "aboutToSpray";
  static const String sprayVideo = "sprayVideo";
  static const String spraySuccess = "spraySuccess";

  static const String cardScreen = "cardScreen";
  static const String cardCreatedStatus = "cardCreatedStatus";
  static const String confirmCardDetail = "confirmCardDetail";
  static const String selectCardType = "selectCardType";
  static const String fundCard = "fundCard";
  static const String cardDetails = "cardDetails";
  static const String allCards = "allCards";
  static const String enterTransactionPin = "/enterTransactionPin";
  static const String qrScanner = "/qrScanner";
  static const String ajoHub = "ajoHub";
  static const String p2pLending = "p2pLending";
  static const String voiceBanking = "voiceBanking";
  static const String zCoins = "zCoins";

  static final navigatorKey = GlobalKey<NavigatorState>();

  static Map<String, String> otpParameters({
    required String verificationId,
    required String email,
    required bool isSignUp,
  }) {
    return {
      "verificationId": verificationId,
      "email": email,
      "isSignUp": isSignUp ? "yes" : "no",
    };
  }

  static Map<String, String> newPasswordParameters({
    required String verificationId,
    required String otp,
  }) {
    return {"verificationId": verificationId, "otp": otp};
  }

  static Map<String, String> selectRecipientParameters({
    required bool isZenglyTransfer,
  }) {
    return {"isZenglyTransfer": isZenglyTransfer ? "yes" : "no"};
  }

  static Map<String, String> selfieParameters({required String nin}) {
    return {"nin": nin};
  }

  static Map<String, String> confirmPinParameters({required String pin}) {
    return {"pin": pin};
  }

  static final GoRouter _router = GoRouter(
    navigatorKey: navigatorKey,
    routes: <RouteBase>[
      GoRoute(path: splash, builder: (context, state) => SplashScreen()),
      GoRoute(
        path: onboarding,
        name: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: chooseSignUp,
        name: chooseSignUp,
        builder: (context, state) => const ChooseSignUpScreen(),
      ),
      GoRoute(
        path: signUp,
        name: signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: loginKnown,
        name: loginKnown,
        builder: (context, state) => const LoginKnownScreen(),
      ),
      GoRoute(
        path: loginUnknown,
        name: loginUnknown,
        builder: (context, state) => const LoginUnknownScreen(),
      ),
      GoRoute(
        path: loginPin,
        name: loginPin,
        builder: (context, state) => const LoginPinScreen(),
      ),
      GoRoute(
        path: resetPassword,
        name: resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: "$otp/:email/:verificationId/:isSignUp",
        name: otp,
        builder:
            (context, state) => OtpScreen(
              verificationId: state.pathParameters["verificationId"]!,
              email: state.pathParameters["email"]!,
              isSignUp: state.pathParameters["isSignUp"]!,
            ),
      ),
      GoRoute(
        path: "$newPassword/:verificationId/:otp",
        name: newPassword,
        builder:
            (context, state) => NewPasswordScreen(
              verificationId: state.pathParameters["verificationId"]!,
              otp: state.pathParameters["otp"]!,
            ),
      ),
      GoRoute(
        path: createPin,
        name: createPin,
        builder: (context, state) => const CreatePinScreen(),
      ),
      GoRoute(
        path: "$confirmPin/:pin",
        name: confirmPin,
        builder:
            (context, state) =>
                ConfirmPinScreen(enteredPin: state.pathParameters["pin"]!),
      ),
      GoRoute(
        path: biometrics,
        name: biometrics,
        builder: (context, state) => const BiometricsScreen(),
      ),
      GoRoute(
        path: enterTransactionPin,
        builder: (context, state) => const EnterTransactionPinScreen(),
      ),
      GoRoute(
        path: qrScanner,
        builder: (context, state) => const QrScannerScreen(),
      ),
      GoRoute(
        path: dashboard,
        name: dashboard,
        builder: (context, state) => const DashboardScreen(),
        routes: [
          GoRoute(
            path: personalInfo,
            name: personalInfo,
            builder: (context, state) => const PersonalInfoScreen(),
          ),
          GoRoute(
            path: language,
            name: language,
            builder: (context, state) => const LanguageScreen(),
          ),
          GoRoute(
            path: appearance,
            name: appearance,
            builder: (context, state) => const AppearanceScreen(),
          ),
          GoRoute(
            path: selectDataPlan,
            name: selectDataPlan,
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>;
              return SelectDataPlanScreen(
                network: extra["network"] as NetworkModel,
                onSelected: extra["onSelected"] as void Function(DataPlanModel),
              );
            },
          ),
          GoRoute(
            path: purchaseSuccess,
            name: purchaseSuccess,
            builder: (context, state) {
              return PurchaseSuccessScreen(
                receipt: state.extra as PurchaseReceiptData,
              );
            },
          ),
          GoRoute(
            path: purchaseReceipt,
            name: purchaseReceipt,
            builder: (context, state) {
              return PurchaseReceiptScreen(
                receipt: state.extra as PurchaseReceiptData,
              );
            },
          ),
          GoRoute(
            path: history,
            name: history,
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: transactionFilter,
            name: transactionFilter,
            builder: (context, state) => const TransactionFilterScreen(),
          ),
          GoRoute(
            path: requestDetails,
            name: requestDetails,
            builder: (context, state) {
              return RequestDetailsScreen(
                transaction: state.extra as TransactionHistoryModel,
              );
            },
          ),
          GoRoute(
            path: shareReceipt,
            name: shareReceipt,
            builder: (context, state) {
              return ShareReceiptScreen(
                receipt: state.extra as ElectricityReceiptData,
              );
            },
          ),
          GoRoute(
            path: notification,
            name: notification,
            builder: (context, state) => const NotificationScreen(),
          ),
          GoRoute(
            path: preVerification,
            name: preVerification,
            builder: (context, state) => const PreVerificationScreen(),
          ),
          GoRoute(
            path: "$selfieVerificationScreen/:nin",
            name: selfieVerificationScreen,
            builder:
                (context, state) =>
                    SelfieCapturePage(nin: state.pathParameters["nin"]!),
          ),
          GoRoute(
            path: bvnScreen,
            name: bvnScreen,
            builder: (context, state) => const BvnVerificationScreen(),
          ),
          GoRoute(
            path: ninScreen,
            name: ninScreen,
            builder: (context, state) => const NinVerificationScreen(),
          ),
          GoRoute(
            path: addressScreen,
            name: addressScreen,
            builder: (context, state) => const AddressVerificationScreen(),
          ),
          GoRoute(
            path: profileCompletion,
            name: profileCompletion,
            builder: (context, state) => const ProfileCompletionScreen(),
          ),
          GoRoute(
            path: amountScreen,
            name: amountScreen,
            builder:
                (context, state) =>
                    AmountScreen(transfer: state.extra as TransferResult?),
          ),
          GoRoute(
            path: confirmTransfer,
            name: confirmTransfer,
            builder:
                (context, state) => ConfirmTransactionScreen(
                  transfer: state.extra as TransferResult,
                ),
          ),
          GoRoute(
            path: preTransferScreen,
            name: preTransferScreen,
            builder: (context, state) => const PreTransferScreen(),
          ),
          GoRoute(
            path: "$selectRecipient/:isZenglyTransfer",
            name: selectRecipient,
            builder:
                (context, state) => SelectRecipientScreen(
                  isZenglyTransfer:
                      state.pathParameters["isZenglyTransfer"] == "yes",
                ),
          ),
          GoRoute(
            path: transferReceipt,
            name: transferReceipt,
            builder:
                (context, state) => TransferReceiptScreen(
                  transfer: state.extra as TransferResult,
                ),
          ),
          GoRoute(
            path: transferSuccess,
            name: transferSuccess,
            builder:
                (context, state) => TransferSuccessScreen(
                  transfer: state.extra as TransferResult,
                ),
          ),
          GoRoute(
            path: preBill,
            name: preBill,
            builder: (context, state) => const PreBillScreen(),
          ),
          GoRoute(
            path: airtimeData,
            name: airtimeData,
            builder: (context, state) {
              final initialTab = (state.extra is int) ? state.extra as int : 0;
              return AirtimeDataScreen(initialTabIndex: initialTab);
            },
          ),
          GoRoute(
            path: airtimeToCash,
            name: airtimeToCash,
            builder: (context, state) => const AirtimeToCashScreen(),
          ),
          GoRoute(
            path: electricity,
            name: electricity,
            builder: (context, state) => const ElectricityScreen(),
          ),
          GoRoute(
            path: electricityConfirmation,
            name: electricityConfirmation,
            builder: (context, state) => const ElectricityConfirmationScreen(),
          ),
          GoRoute(
            path: electricityTransactionStatusScreen,
            name: electricityTransactionStatusScreen,
            builder:
                (context, state) => const ElectricityTransactionStatusScreen(),
          ),
          GoRoute(
            path: tvSubscription,
            name: tvSubscription,
            builder: (context, state) => const TvSubscriptionScreen(),
          ),
          GoRoute(
            path: giftCard,
            name: giftCard,
            builder: (context, state) => const GiftCardScreen(),
          ),
          GoRoute(
            path: preSpecialFeatures,
            name: preSpecialFeatures,
            builder: (context, state) => const PreSpecialFeaturesScreen(),
          ),
          GoRoute(
            path: splitBill,
            name: splitBill,
            builder: (context, state) => const SplitBillScreen(),
          ),
          GoRoute(
            path: splitBillHistory,
            name: splitBillHistory,
            builder: (context, state) => const SplitBillHistoryScreen(),
          ),
          GoRoute(
            path: createBill,
            name: createBill,
            pageBuilder:
                (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const CreateBillScreen(),
                  transitionsBuilder: (context, animation, _, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                      child: child,
                    );
                  },
                ),
          ),
          GoRoute(
            path: inputSplitScreen,
            name: inputSplitScreen,
            builder: (context, state) => const InputSplitScreen(),
          ),
          GoRoute(
            path: splitBillDetailScreen,
            name: splitBillDetailScreen,
            builder: (context, state) => const SplitBillDetailScreen(),
          ),
          GoRoute(
            path: sprayCash,
            name: sprayCash,
            builder: (context, state) => const SprayCashScreen(),
          ),
          GoRoute(
            path: sprayOptions,
            name: sprayOptions,
            builder: (context, state) => const SprayOptionsScreen(),
          ),
          GoRoute(
            path: sprayConfirmation,
            name: sprayConfirmation,
            builder: (context, state) => const SprayConfirmationScreen(),
          ),

          GoRoute(
            path: sprayRadar,
            name: sprayRadar,
            builder: (context, state) => const SprayRadarScreen(),
          ),
          GoRoute(
            path: aboutToSpray,
            name: aboutToSpray,
            builder: (context, state) => const AboutToSprayScreen(),
          ),
          GoRoute(
            path: sprayVideo,
            name: sprayVideo,
            builder: (context, state) => const SprayVideoScreen(),
          ),
          GoRoute(
            path: spraySuccess,
            name: spraySuccess,
            builder: (context, state) => const SpraySuccessScreen(),
          ),
          GoRoute(
            path: cardScreen,
            name: cardScreen,
            builder: (context, state) => const CardsScreen(),
          ),
          GoRoute(
            path: cardCreatedStatus,
            name: cardCreatedStatus,
            builder: (context, state) => const CardCreatedScreen(),
          ),
          GoRoute(
            path: confirmCardDetail,
            name: confirmCardDetail,
            builder: (context, state) => const ConfirmCardDetailsScreen(),
          ),
          GoRoute(
            path: selectCardType,
            name: selectCardType,
            builder: (context, state) => const SelectCardType(),
          ),
          GoRoute(
            path: fundCard,
            name: fundCard,
            builder: (context, state) => FundCardScreen(
              cardId: (state.extra as String?) ?? "card_v_01",
            ),
          ),
          GoRoute(
            path: cardDetails,
            name: cardDetails,
            builder: (context, state) => CardDetailsScreen(
              cardId: (state.extra as String?) ?? "card_v_01",
            ),
          ),
          GoRoute(
            path: allCards,
            name: allCards,
            builder: (context, state) => const AllCardScreen(),
          ),
          GoRoute(
            path: ajoHub,
            name: ajoHub,
            builder: (context, state) => const AjoLandingScreen(),
          ),
          GoRoute(
            path: p2pLending,
            name: p2pLending,
            builder: (context, state) => const P2pLendingScreen(),
          ),
          GoRoute(
            path: voiceBanking,
            name: voiceBanking,
            builder: (context, state) => const VoiceBankingScreen(),
          ),
          GoRoute(
            path: zCoins,
            name: zCoins,
            builder: (context, state) => const ZCoinsScreen(),
          ),
        ],
      ),
    ],
  );

  static GoRouter get appRouterConfig => _router;
}
