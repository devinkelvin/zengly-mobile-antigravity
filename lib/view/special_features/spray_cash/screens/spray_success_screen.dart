import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';
import '../../../transfer/transfer_receipt_screen.dart';

class SpraySuccessScreen extends ConsumerStatefulWidget {
  final SprayItem? item;
  final String? recipient;

  const SpraySuccessScreen({super.key, this.item, this.recipient});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SpraySuccessScreenState();
}

class _SpraySuccessScreenState extends ConsumerState<SpraySuccessScreen> {
  bool _isMuted = false;

  void _onViewReceipt() {
    final amt = widget.item?.amount ?? 50000.0;
    final rName = widget.recipient ?? "Tiwa Savage";
    final now = DateTime.now();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TransferReceiptScreen(
          transfer: TransferResult(
            amount: amt > 0 ? amt : 50000.0,
            fee: 1000.0,
            recipientName: rName,
            recipientAccountNumber: "5673658653",
            recipientBank: "GTBANK",
            sourceBank: "Sterling Bank",
            sourceAccountNumber: "0287646370",
            note: "Vaniti Spray Cash",
            date: now,
            transactionReference: "SPY${now.millisecondsSinceEpoch}",
            providerReference: "TRF|ZNG|${now.millisecondsSinceEpoch}",
          ),
        ),
      ),
    );
  }

  void _toast(String title, String message) {
    AppOverlays.showToast(
      context: context,
      title: title,
      message: message,
      toastType: ToastificationType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayAmount = widget.item != null
        ? (widget.item!.amount > 0
            ? "₦${NumberFormat("#,##0.00").format(widget.item!.amount)}"
            : widget.item!.displayAmount)
        : "₦50,000.00";
    final recipientName = widget.recipient ?? "Tiwa Savage";
    final itemName = widget.item?.name ?? "Cash Bundle";

    return Scaffold(
      backgroundColor: const Color(0xFF14120E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: _PillButton(
          icon: Icons.receipt_long_rounded,
          label: "View Receipt",
          onTap: _onViewReceipt,
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              setState(() => _isMuted = !_isMuted);
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isMuted
                    ? Icons.volume_off_rounded
                    : Icons.volume_up_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          _PillButton(
            icon: Icons.share_rounded,
            label: "Share",
            onTap: () => _toast("Share", "Spray payment receipt link copied!"),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // 3D Coin Rotating Celebration Icon
              const Center(
                child: RotatingCoinIcon(size: 110),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                "Gift Sprayed Successfully!",
                style: GoogleFonts.raleway(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),

              // Amount
              Text(
                displayAmount,
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFB57510),
                ),
              ),
              const SizedBox(height: 6),

              // Subtitle
              Text(
                "$itemName sent to $recipientName",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 24),

              // Breakdown & Stats Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF221D17),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _StatColumn(
                              value: widget.item?.category ?? "Baller",
                              label: "TIER",
                            ),
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.white12,
                          ),
                          Expanded(
                            child: _StatColumn(
                              value: "₦1,000",
                              label: "SERVICE FEE",
                            ),
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.white12,
                          ),
                          Expanded(
                            child: _StatColumn(
                              value: "Instant",
                              label: "STATUS",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                    InkWell(
                      onTap: _onViewReceipt,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "View Official Receipt",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFB57510),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 13,
                              color: Color(0xFFB57510),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Action Buttons: Spray Again & Go Home
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFB57510),
                        side: const BorderSide(color: Color(0xFFB57510)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Spray Again",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.goNamed(AppRouter.dashboard),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB57510),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Done",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;

  const _StatColumn({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFB57510),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }
}

class _PillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PillButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
