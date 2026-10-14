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
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vm = ref.watch(electricityVm);
    final isPrepaid = vm.selectedElectricityType == ElectricityType.prepaid;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.goNamed(AppRouter.dashboard);
          },
          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          icon: const Icon(Icons.close_rounded),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const RotatingCoinIcon(size: 110),
            const SizedBox(height: 20),
            Text(
              "Recharge Successful!",
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF1E1A14),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isPrepaid
                  ? "Your 20-digit prepaid meter token is ready. Load it directly into your meter keypad."
                  : "Your postpaid electricity bill payment has been processed and settled with ${vm.selectedDisco}.",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white60 : Colors.black54,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Token or Payment Confirmation Card
            if (isPrepaid) ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isDark ? const Color(0xFF221D17) : Colors.white,
                  border: Border.all(
                    color: const Color(0xFFB57510).withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          const Color(0xFFB57510).withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
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
                              size: 18,
                              color: Color(0xFFB57510),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Meter Token (20 Digits)",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: vm.generatedToken),
                            );
                            AppOverlays.showToast(
                              context: context,
                              title: "Token Copied",
                              message:
                                  "Electricity token copied to clipboard",
                              toastType: ToastificationType.success,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB57510)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.copy_rounded,
                                  size: 14,
                                  color: Color(0xFFB57510),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Copy",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: const Color(0xFFB57510),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF17130E)
                            : const Color(0xFFF7F2E7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.white10 : const Color(0xFFE5DEC8),
                        ),
                      ),
                      child: Text(
                        vm.generatedToken,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceCodePro(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          letterSpacing: 1.5,
                          color: const Color(0xFFB57510),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Estimated Power: ${vm.estimatedUnits}",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white54 : Colors.black54,
                          ),
                        ),
                        Text(
                          "Meter: ${vm.meterNumber}",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white54 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isDark ? const Color(0xFF221D17) : Colors.white,
                  border: Border.all(
                    color: const Color(0xFF2B8A3E).withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 40,
                      color: Color(0xFF2B8A3E),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Settlement Confirmed",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF1E1A14),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Payment of ₦${vm.amount}.00 received and credited to Account ${vm.meterNumber}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 28),

            // Download Receipt and Share Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final receipt = vm.getReceiptData();
                      context.pushNamed(
                        AppRouter.shareReceipt,
                        extra: receipt,
                      );
                    },
                    icon: const Icon(Icons.receipt_outlined, size: 18),
                    label: const Text("View Receipt"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFB57510),
                      side: const BorderSide(color: Color(0xFFB57510)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.goNamed(AppRouter.dashboard);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB57510),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Back to Home",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
