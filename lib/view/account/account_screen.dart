import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../data/data.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'account_vm.dart';
import 'about_zengly_screen.dart';
import 'legal_privacy_hub_screen.dart';
import 'security_screen.dart';
import 'support_screen.dart';
import 'transaction_limits_screen.dart';
import 'report_bug_screen.dart';
import 'widgets/widgets.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final accountState = ref.watch(accountProvider);
    final coverEffect = accountState.coverEffect;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.accountTitle,
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => AppOverlays.transactionLimitsSheet(context: context),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: primaryColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppImages.tier1, width: 18),
                  const SizedBox(width: 4),
                  Text(
                    accountState.tier,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: AppDimensions.viewPadding,
        child: Column(
          children: [
            // Cover Banner & Profile Avatar Stack
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Editable Cover Banner
                GestureDetector(
                  onTap: () => AppOverlays.profileCoverSheet(context: context),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Custom Image or Gradient
                          if (coverEffect.customImagePath != null)
                            Image.file(
                              File(coverEffect.customImagePath!),
                              fit: BoxFit.cover,
                            )
                          else
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: coverEffect.colors,
                                ),
                              ),
                            ),

                          // Avatar Frosted Melt Layer
                          if (coverEffect.enableAvatarBlur &&
                              coverEffect.customImagePath == null)
                            Positioned(
                              right: -30,
                              top: -30,
                              bottom: -30,
                              width: 260,
                              child: Opacity(
                                opacity: 0.75,
                                child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(
                                    sigmaX: 40,
                                    sigmaY: 40,
                                  ),
                                  child: accountState.customAvatarPath != null
                                      ? Image.file(
                                          File(accountState.customAvatarPath!),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          AppImages.profilePicture,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),

                          // "Edit Background" Glassmorphism Badge
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.55),
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.25),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.palette_outlined,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Edit Cover",
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Overlapping Centered Avatar
                Positioned(
                  bottom: -44,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                          onTap: () => AppOverlays.profilePhotoPickerSheet(
                            context: context,
                          ),
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF14120E)
                                    : const Color(0xFFFAF7F2),
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: accountState.customAvatarPath != null
                                  ? Image.file(
                                      File(accountState.customAvatarPath!),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      AppImages.profilePicture,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),

                        // Camera change icon badge
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => AppOverlays.profilePhotoPickerSheet(
                              context: context,
                            ),
                            child: Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                                border: Border.all(
                                  color: isDark ? const Color(0xFF14120E) : Colors.white,
                                  width: 2.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 54),

            // User Identity & Details
            Text(
              accountState.fullName,
              style: GoogleFonts.raleway(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  accountState.username,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.verified_rounded, size: 16, color: primaryColor),
              ],
            ),

            const SizedBox(height: 10),

            // Account Number Copy Pill
            GestureDetector(
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: accountState.accountNumber),
                );
                AppOverlays.showToast(
                  context: context,
                  title: "Copied!",
                  message: "Account number copied: ${accountState.accountNumber}",
                  toastType: ToastificationType.success,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF262017)
                      : const Color(0xFFF3ECE0),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: isDark ? Colors.white12 : const Color(0xFFE2D6C5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${accountState.bankName} • ${accountState.accountNumber}",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : const Color(0xFF4A3E31),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.copy_rounded, size: 13, color: primaryColor),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Profile Action Buttons (Edit Profile & Change Cover)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text("Edit Profile"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    side: BorderSide(
                      color: isDark ? Colors.white24 : const Color(0xFFD4C8B5),
                    ),
                  ),
                  onPressed: () {
                    context.pushNamed(AppRouter.personalInfo);
                  },
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.palette_outlined, size: 16),
                  label: const Text("Change Cover"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () => AppOverlays.profileCoverSheet(context: context),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Menu Options
            AccountListTile(
              icon: AppImages.accountCircle,
              title: l10n.profileAndAccount,
              subTitle: l10n.manageYourAccount,
              onPressed: () {
                context.pushNamed(AppRouter.personalInfo);
              },
            ),
            AccountListTile(
              icon: AppImages.verifications,
              title: "Identity & Verification",
              subTitle: "Upgrade to Tier 3 for unlimited transfers & spray",
              onPressed: () {
                context.pushNamed(AppRouter.preVerification);
              },
            ),
            AccountListTile(
              icon: AppImages.biometrics,
              title: l10n.biometricsTitle,
              subTitle: l10n.fingerprintOrFaceId,
              isBiometrics: true,
              switchValue: accountState.isBiometricEnabled,
              onSwitchChanged: (val) {
                ref.read(accountProvider.notifier).toggleBiometrics();
              },
              onPressed: () {
                ref.read(accountProvider.notifier).toggleBiometrics();
              },
            ),
            AccountListTile(
              icon: AppImages.transaction,
              title: l10n.transactionLimit,
              subTitle: l10n.viewAccountTransactionLimits,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const TransactionLimitsScreen(),
                  ),
                );
              },
            ),
            AccountListTile(
              icon: AppImages.security,
              title: l10n.security,
              subTitle: l10n.managePasswordAndPin,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SecurityScreen(),
                  ),
                );
              },
            ),
            AccountListTile(
              iconData: Icons.brightness_6_outlined,
              title: l10n.appearance,
              subTitle: l10n.personalizeVisualExperience,
              onPressed: () => context.pushNamed(AppRouter.appearance),
            ),
            AccountListTile(
              icon: AppImages.support,
              title: l10n.support,
              subTitle: l10n.talkWithCustomerService,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SupportScreen(),
                  ),
                );
              },
            ),
            AccountListTile(
              icon: AppImages.bug,
              title: l10n.reportABug,
              subTitle: l10n.helpMakeUsBetter,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ReportBugScreen(),
                  ),
                );
              },
            ),
            AccountListTile(
              iconData: Icons.gavel_outlined,
              title: "Legal & Privacy",
              subTitle: "Agreements, privacy centre & account closure",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LegalPrivacyHubScreen(),
                  ),
                );
              },
            ),
            AccountListTile(
              iconData: Icons.info_outline_rounded,
              title: "About Zengly",
              subTitle: "Lynexa Innovations Ltd. & regulatory disclosures",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AboutZenglyScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            AccountListTile(
              icon: AppImages.logout,
              title: l10n.logout,
              isLogOut: true,
              subTitle: "",
              onPressed: () {
                AppOverlays.logoutSheet(
                  context: context,
                  onConfirm: () async {
                    await ref
                        .read(authNotifierProvider.notifier)
                        .clearCurrentUser();
                    if (!context.mounted) return;
                    context.goNamed(AppRouter.chooseSignUp);
                  },
                );
              },
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}
