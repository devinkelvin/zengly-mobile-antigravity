import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../data/data.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'widgets/widgets.dart';

class PreTransferScreen extends ConsumerStatefulWidget {
  const PreTransferScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PreTransferScreenState();
}

class _PreTransferScreenState extends ConsumerState<PreTransferScreen> {
  final List<Map<String, String>> _recentRecipients = [
    {"name": "Tunde Ade", "tag": "@tunde", "bank": "Zengly"},
    {"name": "Chioma Okonkwo", "tag": "0123456789", "bank": "GTBank"},
    {"name": "Ibrahim Musa", "tag": "@ibrahim", "bank": "Zengly"},
    {"name": "Folake Adeleke", "tag": "9876543210", "bank": "Access"},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary; // 0xFFB57510
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary =
        isDark ? const Color(0xFF9E9E9E) : const Color(0xFF757575);
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: canPop
            ? IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Icons.arrow_back, color: textPrimary),
              )
            : null,
        title: Text(
          "Send Money",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: textPrimary,
          ),
        ),
        actions: [
          // Balance pill
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF26211A)
                  : const Color(0xFFF3ECE0),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF382F22)
                    : const Color(0xFFE2D6C5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Balance: ",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: textSecondary,
                  ),
                ),
                Text(
                  "₦2,000,000.00",
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instant & Zero Fee Promo Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF382709), const Color(0xFF211B12)]
                      : [const Color(0xFFFBF4E8), const Color(0xFFF4EAD9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.bolt_rounded,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Instant & Free Transfers",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "Transfers to any Zengly user are 100% free and settle in seconds.",
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: textSecondary,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Recent Recipients Quick Tray
            Text(
              "Recent Transfers",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textSecondary,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _recentRecipients.length,
                separatorBuilder: (context, _) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final recipient = _recentRecipients[index];
                  final isZengly = recipient["bank"] == "Zengly";
                  return InkWell(
                    onTap: () {
                      context.pushNamed(
                        AppRouter.selectRecipient,
                        pathParameters: AppRouter.selectRecipientParameters(
                          isZenglyTransfer: isZengly,
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: isDark
                              ? const Color(0xFF2E271D)
                              : const Color(0xFFEBE3D7),
                          child: Text(
                            recipient["name"]![0],
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 68,
                          child: Text(
                            recipient["name"]!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                              color: textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Primary Transfer Channels Section
            Text(
              "Transfer Methods",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textSecondary,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 12),

            PreTransferTile(
              onTap: () {
                context.pushNamed(
                  AppRouter.selectRecipient,
                  pathParameters: AppRouter.selectRecipientParameters(
                    isZenglyTransfer: true,
                  ),
                );
              },
              image: AppImages.accountBalance,
              title: "Send to Zengly User",
              subTitle: "Free instant transfers via username or phone",
            ),
            PreTransferTile(
              onTap: () {
                context.pushNamed(
                  AppRouter.selectRecipient,
                  pathParameters: AppRouter.selectRecipientParameters(
                    isZenglyTransfer: false,
                  ),
                );
              },
              image: AppImages.swap,
              title: "Other Bank Transfer",
              subTitle: "Send to 50+ Nigerian commercial & microfinance banks",
            ),
            PreTransferTile(
              onTap: () {
                AppOverlays.showToast(
                  context: context,
                  title: "QR Code Payment",
                  message:
                      "QR scanning is currently in demonstration mode.",
                  toastType: ToastificationType.custom(
                    "QR Code",
                    primaryColor,
                    Icons.qr_code_scanner_rounded,
                  ),
                );
              },
              image: AppImages.scan,
              title: "Pay with QR Code",
              isComingSoon: false,
              subTitle: "Scan recipient's QR or generate your payment code",
            ),
            PreTransferTile(
              onTap: () {
                AppOverlays.showToast(
                  context: context,
                  title: "Payment Link",
                  message:
                      "Shareable payment link generation is coming soon.",
                  toastType: ToastificationType.custom(
                    "Share Link",
                    primaryColor,
                    Icons.link_rounded,
                  ),
                );
              },
              image: AppImages.createLink,
              title: "Share Payment Link",
              isComingSoon: true,
              subTitle: "Generate a secure link for anyone to pay you",
            ),
            PreTransferTile(
              onTap: () {
                AppOverlays.showToast(
                  context: context,
                  title: "International Transfer",
                  message:
                      "Cross-border remittance will be enabled in next release.",
                  toastType: ToastificationType.custom(
                    "Notice",
                    primaryColor,
                    Icons.public_rounded,
                  ),
                );
              },
              image: AppImages.location,
              title: "International Transfer",
              isComingSoon: true,
              subTitle: "Send money to UK, US, and across Africa",
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
