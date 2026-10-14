import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../../view.dart';

class ElectricityScreen extends ConsumerStatefulWidget {
  const ElectricityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ElectricityScreenState();
}

class _ElectricityScreenState extends ConsumerState<ElectricityScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(electricityVm);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: textPrimary,
          ),
        ),
        title: Text(
          "Buy Electricity",
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
            color: textPrimary,
          ),
        ),
        centerTitle: false,
        actions: const [BalanceWidget()],
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            PromoBanner(
              title: "Electricity made simple",
              subtitle: "Buy for yourself and others",
              image: AppImages.creativeIdea,
              imageWidth: 80,
            ),
            SizedBox(height: 16),
            Text(
              "Convenient, fast, and secure power top-ups",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
                color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SelectElectricityType(
                    isSelected:
                        vm.selectedElectricityType == ElectricityType.prepaid,
                    onTap: () {
                      vm.selectElectricityType(ElectricityType.prepaid);
                    },
                    type: "Prepaid",
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: SelectElectricityType(
                    type: "Postpaid",
                    onTap: () {
                      vm.selectElectricityType(ElectricityType.postpaid);
                    },
                    isSelected:
                        vm.selectedElectricityType == ElectricityType.postpaid,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            vm.selectedElectricityType == ElectricityType.prepaid
                ? PrepaidBody()
                : vm.selectedElectricityType == ElectricityType.postpaid
                ? PostpaidBody()
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
