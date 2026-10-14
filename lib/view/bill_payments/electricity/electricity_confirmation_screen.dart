import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import 'electricity_vm.dart';
import 'widgets/widgets.dart';

class ElectricityConfirmationScreen extends ConsumerWidget {
  final String? meterNumber;
  final double? amount;
  final String? meterType;

  const ElectricityConfirmationScreen({
    super.key,
    this.meterNumber,
    this.amount,
    this.meterType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vm = ref.watch(electricityVm);
    final effectiveAmount = amount ??
        (double.tryParse(vm.amount.replaceAll(',', '')) ?? 10000.0);
    final totalAmount = effectiveAmount + vm.fee;
    final effectiveMeter = meterNumber ?? vm.meterNumber;
    final effectiveType = meterType ?? (vm.selectedElectricityType == ElectricityType.prepaid ? "Prepaid" : "Postpaid");

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 19,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        title: Text(
          "Review & Confirm",
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              "Please review your transaction details before payment authorization",
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
            const SizedBox(height: 16),

            // Luxury Receipt Card
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF221D17) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.white10 : const Color(0xFFE2D6C5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  // Header icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB57510).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bolt_rounded,
                      color: Color(0xFFB57510),
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "₦${vm.amount}.00",
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF1E1A14),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vm.selectedElectricityType == ElectricityType.prepaid
                        ? "Prepaid Power Recharge"
                        : "Postpaid Bill Settlement",
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    color: isDark ? Colors.white10 : const Color(0xFFEDE4D4),
                  ),
                  const SizedBox(height: 12),

                  ElectricityTile(
                    title: "Distribution Company",
                    content: vm.selectedDisco,
                  ),
                  ElectricityTile(
                    title: "Meter Type",
                    content:
                        vm.selectedElectricityType == ElectricityType.prepaid
                            ? "Prepaid"
                            : "Postpaid",
                  ),
                  ElectricityTile(
                    title: "Meter Number",
                    content: vm.meterNumber,
                  ),
                  ElectricityTile(
                    title: "Customer Name",
                    content: vm.customerName,
                  ),
                  ElectricityTile(
                    title: "Service Address",
                    content: vm.meterAddress,
                  ),
                  if (vm.selectedElectricityType == ElectricityType.prepaid)
                    ElectricityTile(
                      title: "Estimated Power",
                      content: vm.estimatedUnits,
                    ),
                  ElectricityTile(
                    title: "Service Fee",
                    content: "₦${vm.fee.toStringAsFixed(2)}",
                  ),
                  const SizedBox(height: 6),
                  Divider(
                    color: isDark ? Colors.white10 : const Color(0xFFEDE4D4),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Debit",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        "₦${NumberFormat("#,##0.00").format(totalAmount)}",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFB57510),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Authorize Payment Button
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: () async {
                  final pin = await TransactionPinBottomSheet.show(
                    context,
                    title: "Authorize Electricity Recharge",
                    amountSummary: "₦${NumberFormat("#,##0.00").format(totalAmount)} • ${vm.selectedDisco}",
                  );
                  if (pin == null || !context.mounted) return;

                  AppOverlays.showLoadingDialog(context: context);
                  await Future.delayed(const Duration(seconds: 2));
                  if (!context.mounted) return;
                  context.pop(); // close loader

                  context.goNamed(AppRouter.electricityTransactionStatusScreen);
                },
                actionText: "Authorize Payment",
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
