import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/kyc/providers/kyc_provider.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class PreVerificationScreen extends ConsumerStatefulWidget {
  const PreVerificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PreVerificationScreenState();
}

class _PreVerificationScreenState extends ConsumerState<PreVerificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(kycNotifierProvider.notifier).fetchStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final kycStatus = ref.watch(kycNotifierProvider).valueOrNull;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final isBvnDone = kycStatus?.isBvnVerified ?? true; // demo default true
    final isNinDone = kycStatus?.isNinVerified ?? false;
    final isAddressDone = kycStatus?.isAddressVerified ?? false;
    final isSelfieDone = kycStatus?.isSelfieVerified ?? false;

    int completedSteps = (isBvnDone ? 1 : 0) +
        (isNinDone ? 1 : 0) +
        (isAddressDone ? 1 : 0) +
        (isSelfieDone ? 1 : 0);
    double progress = completedSteps / 4.0;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Identity & KYC",
          style: GoogleFonts.raleway(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: AppDimensions.viewPadding,
          width: double.infinity,
          child: AppButton.outline(
            onPressed: () => context.pop(),
            actionText: "Return to Home",
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Executive Tier Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF382709), const Color(0xFF1E1810)]
                      : [const Color(0xFFFBF4E8), const Color(0xFFF4EAD9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.35),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.1),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.shield_rounded, color: primaryColor, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Account Level",
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: isDark ? Colors.white60 : Colors.black54,
                                ),
                              ),
                              Text(
                                "Tier 1: Starter (₦50k/day)",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          "Target: Tier 3",
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.08),
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$completedSteps of 4 requirements completed",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      Text(
                        "${(progress * 100).toInt()}%",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Verification Steps",
              style: GoogleFonts.raleway(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 12),

            // Step 1: BVN
            _kycStepCard(
              title: "Bank Verification Number (BVN)",
              subtitle: "Instant identity verification linked to your account",
              icon: Icons.fingerprint_rounded,
              isCompleted: isBvnDone,
              isDark: isDark,
              primaryColor: primaryColor,
              onTap: () => context.pushNamed(AppRouter.bvnScreen),
            ),

            // Step 2: NIN
            _kycStepCard(
              title: "National Identity (NIN)",
              subtitle: "Government ID linking via your 11-digit NIN",
              icon: Icons.badge_rounded,
              isCompleted: isNinDone,
              isDark: isDark,
              primaryColor: primaryColor,
              onTap: () => context.pushNamed(AppRouter.ninScreen),
            ),

            // Step 3: Proof of Address
            _kycStepCard(
              title: "Proof of Address (Utility Bill)",
              subtitle: "Electricity, water bill, or bank statement",
              icon: Icons.home_work_rounded,
              isCompleted: isAddressDone,
              isDark: isDark,
              primaryColor: primaryColor,
              onTap: () => context.pushNamed(AppRouter.addressScreen),
            ),

            // Step 4: Selfie & Profile
            _kycStepCard(
              title: "Biometric Liveness & Profile",
              subtitle: "Fast camera selfie for facial recognition & next of kin",
              icon: Icons.face_retouching_natural_rounded,
              isCompleted: isSelfieDone,
              isDark: isDark,
              primaryColor: primaryColor,
              onTap: () => context.pushNamed(AppRouter.profileCompletion),
            ),

            const SizedBox(height: 24),

            // Tier 3 Perks
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.workspace_premium_rounded, color: primaryColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "Unlocked Upon Tier 3 Verification",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _perkRow("Unlimited Daily & Monthly Transfers", isDark),
                  _perkRow("Unlimited Vaniti Event Real-Time Cash Spraying", isDark),
                  _perkRow("Virtual USD Card & International Subscriptions", isDark),
                  _perkRow("P2P Lending & Interest-Earning Pools", isDark),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _kycStepCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isCompleted,
    required bool isDark,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF211D16) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFF34C759).withValues(alpha: 0.3)
              : (isDark ? Colors.white12 : const Color(0xFFEADBCE)),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isCompleted
                ? const Color(0xFF34C759).withValues(alpha: 0.15)
                : primaryColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isCompleted ? const Color(0xFF34C759) : primaryColor,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF1E1A14),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ),
        trailing: isCompleted
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF34C759).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check, size: 12, color: Color(0xFF28A745)),
                    const SizedBox(width: 4),
                    Text(
                      "Verified",
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF28A745),
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  "Verify",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ),
        onTap: onTap,
      ),
    );
  }

  Widget _perkRow(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              color: Color(0xFF34C759), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
