import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../data/data.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class TransferSuccessScreen extends ConsumerStatefulWidget {
  final TransferResult transfer;

  const TransferSuccessScreen({super.key, required this.transfer});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransferSuccessScreenState();
}

class _TransferSuccessScreenState extends ConsumerState<TransferSuccessScreen> {
  bool _saveBeneficiary = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: _PillButton(
            imageIcon: AppImages.arrowDownloadIcon,
            label: "Download",
            onTap: () {
              AppOverlays.showToast(
                context: context,
                title: "Receipt Downloaded",
                message: "PDF Receipt successfully saved to your downloads folder",
                toastType: ToastificationType.success,
              );
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: _PillButton(
              imageIcon: AppImages.shareAndroidIcon,
              label: "Share",
              onTap: () {
                AppOverlays.showToast(
                  context: context,
                  title: "Receipt Link Copied",
                  message: "Shareable official transfer receipt link copied to clipboard!",
                  toastType: ToastificationType.success,
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          children: [
            const SizedBox(height: 24),
            const RotatingCoinIcon(size: 140),
            const SizedBox(height: 20),
            Text(
              "Transfer Successful!",
              style: GoogleFonts.raleway(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "₦${NumberFormat("#,##0.00").format(widget.transfer.amount)}",
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFB57510),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Successfully sent to ${widget.transfer.recipientName} (${widget.transfer.recipientBank})",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.scrim,
              ),
            ),
            const SizedBox(height: 28),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF221D16)
                    : Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white10
                      : const Color(0xFFE8E0D2),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Save this beneficiary",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Switch(
                          value: _saveBeneficiary,
                          activeThumbColor: Colors.white,
                          activeTrackColor: const Color(0xFFB57510),
                          onChanged:
                              (value) =>
                                  setState(() => _saveBeneficiary = value),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white10
                        : Colors.black.withValues(alpha: 0.06),
                  ),
                  InkWell(
                    onTap:
                        () => context.pushNamed(
                          AppRouter.transferReceipt,
                          extra: widget.transfer,
                        ),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.receipt_long_rounded, size: 18, color: Color(0xFFB57510)),
                          const SizedBox(width: 8),
                          Text(
                            "View Official Receipt",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFB57510),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => context.goNamed(AppRouter.dashboard),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB57510),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  "Done & Back to Home",
                  style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () => context.pushNamed(AppRouter.preTransferScreen),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFB57510)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  "Make Another Transfer",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: const Color(0xFFB57510),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String imageIcon;
  final String label;
  final VoidCallback onTap;

  const _PillButton({
    required this.imageIcon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 6),
            Image.asset(imageIcon, width: 14, height: 14),
          ],
        ),
      ),
    );
  }
}
