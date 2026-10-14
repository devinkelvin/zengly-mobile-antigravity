import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../controller/storage/storage.dart';
import '../data/data.dart';
import '../view/account/widgets/widgets.dart';
import '../view/home/widgets/widgets.dart';
import '../view/transfer/widgets/widgets.dart';
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
      barrierColor: Colors.black.withValues(alpha: 0.2),
      isScrollControlled: true,
      builder: (ctx) {
        return _blurredSheet(
          ctx,
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(34),
              topRight: Radius.circular(34),
            ),
            child: Container(
              color: Theme.of(context).colorScheme.surface,
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
  bool _approveTxToggle = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppImages.fingerPrint,
                width: 36,
                height: 36,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Enable Biometrics",
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "For a seamless and secure experience,\nenable Biometric Authentication",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Theme.of(context).colorScheme.scrim,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Login Instantly",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "No need to enter your password every time.",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.scrim,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Default",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.3),
                  height: 1,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Approve Transactions Faster",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Authorize payments with just a touch or glance.",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.scrim,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _approveTxToggle,
                      onChanged: (val) =>
                          setState(() => _approveTxToggle = val),
                      activeThumbColor:
                          Theme.of(context).colorScheme.onPrimary,
                      activeTrackColor:
                          Theme.of(context).colorScheme.tertiary,
                      inactiveThumbColor:
                          Theme.of(context).colorScheme.onPrimary,
                      inactiveTrackColor:
                          Theme.of(context).colorScheme.outline,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  onPressed: () => Navigator.pop(context),
                  actionText: "Maybe Later",
                  horizontalPadding: 0,
                  backgroundColor:
                      Theme.of(context).colorScheme.outlineVariant,
                  textColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.context.goNamed(AppRouter.biometrics);
                  },
                  actionText: "Enable Now",
                  horizontalPadding: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
