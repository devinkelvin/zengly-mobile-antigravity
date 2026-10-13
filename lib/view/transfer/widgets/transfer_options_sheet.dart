import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import './pre_transfer_tile.dart';

class TransferOptionsSheet extends StatelessWidget {
  const TransferOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1A17) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2E2A24)
                    : const Color(0xFFE2D6C5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Choose Transfer Method",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.close_rounded,
                  color: Theme.of(context).colorScheme.scrim,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 14),
          PreTransferTile(
            onTap: () {
              context.pop();
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
              context.pop();
              context.pushNamed(
                AppRouter.selectRecipient,
                pathParameters: AppRouter.selectRecipientParameters(
                  isZenglyTransfer: false,
                ),
              );
            },
            image: AppImages.swap,
            title: "Other Bank Transfer",
            subTitle: "Send to other commercial & microfinance banks",
          ),
          PreTransferTile(
            onTap: () {
              context.pop();
              AppOverlays.showToast(
                context: context,
                title: "QR Code",
                message: "QR code transfer demo mode active.",
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
            subTitle: "Scan recipient's QR or generate payment code",
          ),
          PreTransferTile(
            onTap: () {
              context.pop();
              AppOverlays.showToast(
                context: context,
                title: "Share Link",
                message: "Payment links feature is coming soon.",
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
            subTitle: "Send a secure link for someone to pay you",
          ),
        ],
      ),
    );
  }
}
