import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';
import '../../../transfer/transfer_receipt_screen.dart';

class SpraySuccessScreen extends ConsumerStatefulWidget {
  const SpraySuccessScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SpraySuccessScreenState();
}

class _SpraySuccessScreenState extends ConsumerState<SpraySuccessScreen> {
  bool _isMuted = false;

  void _onViewReceipt() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TransferReceiptScreen(
          transfer: TransferResult(
            amount: 4000000.0,
            fee: 1000.0,
            recipientName: "Ability Elijah",
            recipientAccountNumber: "5673658653",
            recipientBank: "GTBANK",
            sourceBank: "GTBank",
            sourceAccountNumber: "0123456789",
            note: "Hey",
            date: DateTime.now(),
            transactionReference: "2602250901005373281890",
            providerReference: "TRF| 2MPT8re99|260225090123",
          ),
        ),
      ),
    );
  }


  void _comingSoon(String message) {
    AppOverlays.showToast(
      context: context,
      title: "Notice",
      message: message,
      toastType: ToastificationType.custom(
        "Notice",
        Theme.of(context).colorScheme.primary,
        Icons.warning_amber_outlined,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161410),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: _PillButton(
            icon: Icons.arrow_downward,
            label: "Download",
            onTap: () => _comingSoon("Receipt downloaded"),
          ),
        ),
        centerTitle: true,
        actions: [
          // Volume toggle
          GestureDetector(
            onTap: () {
              setState(() => _isMuted = !_isMuted);
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isMuted ? Icons.volume_off_outlined : Icons.volume_up_outlined,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Share pill
          _PillButton(
            icon: Icons.share_outlined,
            label: "Share",
            onTap: () => _comingSoon("Share link copied"),
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

              // 3D Lottie Success Animation
              const Center(
                child: SizedBox(
                  height: 120,
                  child: RotatingCoinIcon(size: 120),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                "Gift sent successfully!",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),

              // Amount
              Text(
                "₦4M",
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),

              // Subtitle
              Text(
                "sent to Ability Elijah",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 24),

              // Stats + View Receipt Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF26211B),
                  borderRadius: BorderRadius.circular(18),
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
                              value: "+2",
                              label: "RANK UP",
                            ),
                          ),
                          Container(
                            height: 28,
                            width: 1,
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                          Expanded(
                            child: _StatColumn(
                              value: "#3",
                              label: "LEADERBOARD",
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
                        bottom: Radius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Center(
                          child: Text(
                            "View Receipt",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Catchphrase
              Text(
                "Money na water!",
                style: GoogleFonts.raleway(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              const Spacer(flex: 2),

              // View On Leaderboard
              GestureDetector(
                onTap: () {
                  context.pushNamed(AppRouter.sprayCash);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "View On Leaderboard",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Go Home button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.goNamed(AppRouter.dashboard),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB57510),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "Go Home",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
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
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFC87D0E),
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
          color: Colors.black.withValues(alpha: 0.5),
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
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 5),
            Icon(icon, size: 14, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
