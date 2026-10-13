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
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        title: Text(
          "Buy Electricity",
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
        centerTitle: false,
        actions: [BalanceWidget()],
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
