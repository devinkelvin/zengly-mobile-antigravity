import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../controller/storage/storage.dart';
import '../data/data.dart';
import '../view/account/widgets/widgets.dart';
import '../view/home/widgets/widgets.dart';
import '../view/view.dart';
import '../utils/utils.dart';
import 'widgets.dart';

class AppOverlays {
  // Wraps modal content with a full-screen blurred backdrop. showModalBottomSheet
  // only sizes itself to the sheet's content, so the blur must be painted behind
  // it via a Stack rather than relying on the route's default barrier.
  static Widget _blurredSheet(BuildContext context, Widget sheetContent) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: const SizedBox.expand(),
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: sheetContent),
        ],
      ),
    );
  }

  static void _bottomSheetTemplate({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.2),
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      builder: (newContext) {
        return _blurredSheet(
          newContext,
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(34),
              topRight: Radius.circular(34),
            ),
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: SafeArea(
                child: Padding(
                  padding: AppDimensions.viewPadding,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Shrink-wrap content
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        height: 4,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceTint,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      child,
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // static void _bottomSheetTemplate({
  //   required BuildContext context,
  //   required Widget child,
  //   // required double height,
  //   bool isDismissible = true,
  //   double? maxHeightRatio,

  //   bool? isScrollControlled,
  // }) {
  //   // final ratio = height
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Theme.of(context).colorScheme.surface,
  //     isScrollControlled: isScrollControlled ?? false,
  //     isDismissible: isDismissible,
  //     enableDrag: isDismissible,
  //     scrollControlDisabledMaxHeightRatio:
  //         maxHeightRatio == null
  //             ? (Responsive.height(context) * 0.9) / Responsive.height(context)
  //             : (Responsive.height(context) * maxHeightRatio) /
  //                 Responsive.height(context),
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(10),
  //         topRight: Radius.circular(10),
  //       ),
  //     ),
  //     builder: (newContext) {
  //       return Padding(
  //         padding: AppDimensions.viewPadding,
  //         child: Column(
  //           children: [
  //             SizedBox(height: 8, width: double.infinity),
  //             Container(
  //               height: 4,
  //               width: 50,
  //               decoration: BoxDecoration(
  //                 color: Theme.of(context).colorScheme.surfaceTint,
  //                 borderRadius: BorderRadius.circular(6),
  //               ),
  //             ),
  //             SizedBox(height: 8),
  //             child,
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  static void transferOptionsSheet({required BuildContext context}) {
    context.pushNamed(AppRouter.preTransferScreen);
  }

  static void securitySettingsSheet({required BuildContext context}) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: const SecuritySettingsSheet(),
    );
  }

  static void transactionLimitsSheet({required BuildContext context}) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: const TransactionLimitsSheet(),
    );
  }

  static void supportHelpSheet({required BuildContext context}) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: const SupportHelpSheet(),
    );
  }

  static void reportBugSheet({required BuildContext context}) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: const ReportBugSheet(),
    );
  }

  static void profilePhotoPickerSheet({required BuildContext context}) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Change Profile Picture",
            style: GoogleFonts.raleway(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Select how you would like to update your avatar",
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Theme.of(context).colorScheme.scrim,
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFB57510).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.camera_alt_rounded, color: Color(0xFFB57510), size: 20),
            ),
            title: Text("Take Photo", style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
            subtitle: Text("Use camera to snap a new selfie", style: GoogleFonts.inter(fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () {
              Navigator.pop(context);
              showToast(
                context: context,
                title: "Camera Updated",
                message: "Profile photo captured successfully",
                toastType: ToastificationType.success,
              );
            },
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.photo_library_rounded, color: Color(0xFF3B82F6), size: 20),
            ),
            title: Text("Choose from Gallery", style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
            subtitle: Text("Select an image from device gallery", style: GoogleFonts.inter(fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () {
              Navigator.pop(context);
              showToast(
                context: context,
                title: "Gallery Image",
                message: "Photo selected and updated",
                toastType: ToastificationType.success,
              );
            },
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.face_retouching_natural_rounded, color: Color(0xFF10B981), size: 20),
            ),
            title: Text("Avatar Presets", style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
            subtitle: Text("Pick from curated Zengly 3D avatars", style: GoogleFonts.inter(fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () {
              Navigator.pop(context);
              showToast(
                context: context,
                title: "Avatar Preset",
                message: "New 3D avatar applied",
                toastType: ToastificationType.success,
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  static void profileCoverSheet({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const ProfileCoverSheet(),
    );
  }

  static void fullAnalyticsSheet({required BuildContext context}) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: FullAnalyticsSheet(
          onNotify: () {
            context.pop();
            showToast(
              context: context,
              title: "Notice",
              message: "We'll notify you when this feature is ready",
              toastType: ToastificationType.success,
            );
          },
        ),
      ),
    );
  }

  static Future<BankAccountOption?> selectBankSheet({
    required BuildContext context,
  }) {
    return showModalBottomSheet<BankAccountOption>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.2),
      isScrollControlled: true,
      builder: (newContext) {
        return _blurredSheet(
          newContext,
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(34),
              topRight: Radius.circular(34),
            ),
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: AppDimensions.pagePadding,
                    right: AppDimensions.pagePadding,
                    top: 8,
                    bottom:
                        MediaQuery.of(context).viewInsets.bottom +
                        AppDimensions.pagePadding,
                  ),
                  child: const SelectBankSheet(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void showLoadingDialog({required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(canPop: false, child: AppLoader()),
    );
  }

  /// Shows the Vaniti announcement modal, unless the user has already ticked
  /// "Hide this". Either way [onProceed] is what ultimately opens Vaniti.
  static Future<void> vanitiIntroDialog({
    required BuildContext context,
    required VoidCallback onProceed,
  }) async {
    final hidden = await LocalStorage().readData(LocalStorage.hideVanitiIntro);
    if (hidden == 'true') {
      onProceed();
      return;
    }
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.2),
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: VanitiIntroDialog(onTryNow: onProceed),
      ),
    );
  }

  static void kycPromptDialog({
    required BuildContext context,
    required VoidCallback onVerify,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.2),
      builder: (newContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: KycPromptCard(
                onVerify: () {
                  context.pop();
                  onVerify();
                },
                onDismiss: () => context.pop(),
              ),
            ),
          ),
        );
      },
    );
  }

  static void receiveDialog({required BuildContext context}) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(height: 440, child: ReceiveBottomSheet()),
      ),
    );
  }

  static void networkSheet({required BuildContext context}) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(height: 330, child: NetworkBottomSheet()),
      ),
    );
  }

  static void tvSheet({required BuildContext context}) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(height: 330, child: TvBottomSheet()),
      ),
    );
  }

  static void selectSprayCurrencySheet({required BuildContext context}) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const SelectCurrencyBottomSheet(),
      ),
    );
  }

  static void selectSprayDenominationSheet({required BuildContext context}) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const DenominationBottomSheet(),
      ),
    );
  }

  static void selectSprayAnimationSheet({required BuildContext context}) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const SprayAnimationBottomSheet(),
      ),
    );
  }

  static void openFoundDeviceSheet({required BuildContext context}) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(height: 420, child: FoundDeviceBottomSheet()),
      ),
    );
  }

  static void tvPlans({required BuildContext context}) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: Responsive.height(context) * 0.85,
          child: TvPlanSheet(),
        ),
      ),
    );
  }

  static void giftCardOptions({
    required BuildContext context,
    required String title,
    required List<GiftCardChoiceModel> options,
    required GiftCardChoiceModel? selectedOption,
    required void Function(String) onPressed,
  }) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height:
              Responsive.height(context) > 750
                  ? 675
                  : Responsive.height(context) * 0.7,
          child: GiftCardBottomSheetList(
            title: title,
            options: options,
            onPressed: onPressed,
            selectedOption: selectedOption,
          ),
        ),
      ),
    );
  }

  static void confirmGiftcard({required BuildContext context}) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(height: 375, child: ConfirmGiftcardSheet()),
      ),
    );
  }

  static Future<int?> selectSplitFriendsSheet({required BuildContext context}) {
    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.2),
      isScrollControlled: true,
      builder: (newContext) {
        return _blurredSheet(
          newContext,
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(34),
              topRight: Radius.circular(34),
            ),
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: AppDimensions.pagePadding,
                    right: AppDimensions.pagePadding,
                    top: 8,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: const SelectSplitFriendsSheet(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void sharePinHelpSheet({
    required BuildContext context,
    required String networkName,
  }) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SharePinHelpSheet(networkName: networkName),
      ),
    );
  }

  static void contactSheet({required BuildContext context}) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(child: ContactsBottomSheet()),
      ),
    );
  }

  static void otpBottomSheet({
    required BuildContext context,
    required TextEditingController controller,
    required int length,
    required int seconds,
    required OtpChannel channel,
    required String maskedTarget,
    required VoidCallback onVerify,
  }) {
    _bottomSheetTemplate(
      context: context,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: OtpBottomSheetBody(
          controller: controller,
          length: length,
          initialSeconds: seconds,
          channel: channel,
          maskedTarget: maskedTarget,
          onVerify: onVerify,
        ),
      ),
    );
  }

  static void bottomSheet({
    required BuildContext context,
    required bool isSuccess,
    required VoidCallback action,
    String? title,
    String? content,
    String? actionText,
    String? animationAsset,
  }) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: !isSuccess,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          child: BottomSheetContent(
            isSuccess: isSuccess,
            title: title,
            action: action,
            content: content,
            actionText: actionText,
            animationAsset: animationAsset,
          ),
        ),
      ),
    );
  }

  static void transactionPinSheet({
    required BuildContext context,
    required void Function(String pin) onConfirm,
  }) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: TransactionPinSheet(onConfirm: onConfirm),
      ),
    );
  }

  static void languageSwitchSheet({
    required BuildContext context,
    required String currentFlag,
    required String newFlag,
    required String newLanguageName,
    required VoidCallback onConfirm,
  }) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: LanguageSwitchSheet(
          currentFlag: currentFlag,
          newFlag: newFlag,
          newLanguageName: newLanguageName,
          onConfirm: onConfirm,
        ),
      ),
    );
  }

  static void logoutSheet({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    _bottomSheetTemplate(
      context: context,
      isDismissible: true,
      child: LogoutConfirmSheet(onConfirm: onConfirm),
    );
  }

  static void showToast({
    required BuildContext context,
    required String message,
    ToastificationType? toastType = ToastificationType.info,
    String? title,
  }) {
    final toastTitle =
        title ??
        (toastType == ToastificationType.info
            ? "Info"
            : toastType == ToastificationType.success
            ? "Success"
            : toastType == ToastificationType.error
            ? "Error"
            : "Warning");
    toastification.show(
      context: context,
      type: toastType,
      style: ToastificationStyle.fillColored,
      showProgressBar: false,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 4),
      icon:
          toastType == ToastificationType.error
              ? Image.asset(AppImages.errorGif, width: 24, height: 24)
              : null,
      //  style: ToastificationStyle.fillColored
      title: RichText(
        text: TextSpan(
          text: toastTitle,
          style: GoogleFonts.raleway(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            // color: titleColor,
          ),
        ),
      ),
      description: RichText(
        text: TextSpan(
          text: message,
          style: GoogleFonts.raleway(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  static void infoDialog({
    required BuildContext context,
    required String message,
    VoidCallback? onPressed,
    bool hasCancel = false,
    bool doublePop = false,
    bool isPrice = false,
    bool? barrierDismissible,
    String? actionText,
    String? title,
    OverlayType overlayType = OverlayType.info,
  }) {
    final dialogTitle =
        title ??
        (overlayType == OverlayType.info
            ? 'Notice'
            : overlayType == OverlayType.success
            ? "Successful"
            : "Error");
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible ?? true,
      builder:
          (newContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            title: Row(children: [Text(dialogTitle)]),
            titleTextStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            content: Text(message),
            contentTextStyle: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),

            actions: [
              if (hasCancel)
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              TextButton(
                onPressed: () {
                  if (onPressed != null) {
                    onPressed();
                  } else {
                    context.pop();
                  }
                },
                child: Text(
                  actionText ?? "Continue",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  static void showEnableBiometricsSheet({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      isScrollControlled: true,
      builder: (ctx) {
        return _blurredSheet(
          ctx,
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            child: Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1E1A14)
                  : const Color(0xFFFCF9F5),
              child: SafeArea(
                child: _EnableBiometricsSheetContent(context: context),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EnableBiometricsSheetContent extends StatefulWidget {
  final BuildContext context;
  const _EnableBiometricsSheetContent({required this.context});

  @override
  State<_EnableBiometricsSheetContent> createState() =>
      _EnableBiometricsSheetContentState();
}

class _EnableBiometricsSheetContentState
    extends State<_EnableBiometricsSheetContent> {
  bool _approveTxToggle = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const goldColor = Color(0xFFB57510);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? Colors.white70 : const Color(0xFF6B7280);

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 4.5,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : const Color(0xFFD4C8B5),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          const SizedBox(height: 24),

          // Glowing Biometric Hero Emblem
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF3D2E14), const Color(0xFF20170A)]
                    : [const Color(0xFFFFF6E6), const Color(0xFFF7E8CE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: goldColor.withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: goldColor.withValues(alpha: 0.22),
                  blurRadius: 22,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                AppImages.fingerPrint,
                width: 42,
                height: 42,
                colorFilter: const ColorFilter.mode(
                  goldColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title & Subtitle
          Text(
            "Enable Biometrics",
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.w800,
              fontSize: 22,
              letterSpacing: -0.3,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Experience seamless, lightning-fast authentication and protect your Zengly transactions with hardware security.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              height: 1.45,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // Feature Highlights Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF262017) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFFEADBCE),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Row 1: Login instantly
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: goldColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.bolt_rounded,
                        color: goldColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "1-Tap Instant Unlock",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Bypass passwords with Face ID or fingerprint.",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF34C759).withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        "Default",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF34C759),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Divider(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : const Color(0xFFF0EBE1),
                    height: 1,
                  ),
                ),
                // Row 2: Payment Authorization
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF34C759).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        color: Color(0xFF34C759),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Authorize Transactions",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Quick approval for transfers & bill payments.",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: _approveTxToggle,
                      onChanged: (val) {
                        HapticFeedback.lightImpact();
                        setState(() => _approveTxToggle = val);
                      },
                      activeTrackColor: goldColor,
                      activeColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),

          // Standardized Unified Buttons
          Row(
            children: [
              Expanded(
                child: AppButton.outline(
                  onPressed: () => Navigator.pop(context),
                  actionText: "Maybe Later",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton.primary(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.context.goNamed(AppRouter.biometrics);
                  },
                  actionText: "Enable Now",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
