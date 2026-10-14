import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import 'electricity_vm.dart';

class ElectricityTransactionStatusScreen extends ConsumerStatefulWidget {
  const ElectricityTransactionStatusScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ElectricityTransactionStatusScreenState();
}

class _ElectricityTransactionStatusScreenState
    extends ConsumerState<ElectricityTransactionStatusScreen> {
  bool _isMuted = false;

  void _onDownloadReceipt() {
    AppOverlays.showToast(
      context: context,
      title: "Receipt Downloaded",
      message: "PDF Receipt successfully saved to your downloads folder",
      toastType: ToastificationType.success,
    );
  }

  void _onShare() {
    AppOverlays.showToast(
      context: context,
      title: "Receipt Link Copied",
      message: "Shareable official electricity receipt link copied to clipboard!",
      toastType: ToastificationType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(electricityVm);
    final isPrepaid = vm.selectedElectricityType == ElectricityType.prepaid;
    final amountStr = vm.amount.isNotEmpty ? "₦${vm.amount}" : "₦10,000";

    return Scaffold(
      backgroundColor: const Color(0xFF16140F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: GestureDetector(
          onTap: _onDownloadReceipt,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Download",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_downward_rounded,
                  size: 15,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        actions: [
          // Audio mute/unmute circle button
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
                _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Share pill button
          GestureDetector(
            onTap: _onShare,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.share_outlined,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Share",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Flying Green Banknote (Screenshot top visual)
              Center(
                child: Image.asset(
                  AppImages.flyingMoneyBill,
                  height: 64,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.payments_rounded,
                    size: 54,
                    color: Color(0xFF34C759),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Title
              Text(
                "Recharge sent successfully!",
                style: GoogleFonts.raleway(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),

              // Amount
              Text(
                amountStr,
                style: GoogleFonts.inter(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),

              // Subtitle
              Text(
                "sent to ${vm.meterNumber} (${vm.selectedDisco})",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 18),

              // Prepaid Token Card (if prepaid)
              if (isPrepaid) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF231E18),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFB57510).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.vpn_key_rounded,
                                size: 16,
                                color: Color(0xFFB57510),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Meter Token (20 Digits)",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.5,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: vm.generatedToken),
                              );
                              AppOverlays.showToast(
                                context: context,
                                title: "Token Copied",
                                message: "Electricity token copied to clipboard",
                                toastType: ToastificationType.success,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFB57510)
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.copy_rounded,
                                    size: 13,
                                    color: Color(0xFFB57510),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Copy",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11.5,
                                      color: const Color(0xFFB57510),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF17130E),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Text(
                          vm.generatedToken,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sourceCodePro(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            letterSpacing: 1.5,
                            color: const Color(0xFFB57510),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Leaderboard & Rank Up Card with View Receipt (Screenshot)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF231E18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "+2",
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFE5A93C),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "RANK UP",
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white60,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 32,
                            width: 1,
                            color: Colors.white12,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "#3",
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFE5A93C),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "LEADERBOARD",
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white60,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                    InkWell(
                      onTap: () {
                        final receipt = vm.getReceiptData();
                        context.pushNamed(
                          AppRouter.shareReceipt,
                          extra: receipt,
                        );
                      },
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20),
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

              const SizedBox(height: 28),

              // Centered Vibe Text "Money na water!" matching Screenshot
              Center(
                child: Text(
                  "Money na water!",
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // Button 1: "View On Leaderboard" above Go Home matching Screenshot
              GestureDetector(
                onTap: () {
                  AppOverlays.vanitiLeaderboardSheet(context);
                },
                child: Text(
                  "View On Leaderboard",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Button 2: "Go Home" (Solid Amber button from Screenshot)
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB57510),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    context.goNamed(AppRouter.dashboard);
                  },
                  child: Text(
                    "Go Home",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
