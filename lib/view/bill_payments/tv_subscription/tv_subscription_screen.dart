import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../../view.dart';

class TvSubscriptionScreen extends ConsumerStatefulWidget {
  const TvSubscriptionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TvSubscriptionScreenState();
}

class _TvSubscriptionScreenState extends ConsumerState<TvSubscriptionScreen> {
  final _smartNumberController = TextEditingController();

  @override
  void initState() {
    final vm = ref.read(tvSubscriptionVm);
    vm.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _smartNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(tvSubscriptionVm);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "TV Subscription",
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
            Text(
              "Purchase TV Subscriptions",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                AppOverlays.tvSheet(context: context);
              },
              radius: 15,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 19, horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    vm.selectedProvider == null
                        ? Text(
                          "Select Service Provider",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                          ),
                        )
                        : Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(50),
                              child: Image.asset(
                                vm.selectedProvider!.image,
                                width: 36,
                                height: 36,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(vm.selectedProvider!.name),
                          ],
                        ),
                    Spacer(),
                    Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ],
                ),
              ),
            ),
            vm.selectedProvider == null
                ? SizedBox()
                : Column(
                  children: [
                    SizedBox(height: 16),
                    AppTextField(
                      controller: _smartNumberController,
                      labelText: "Smartcard/ IUC Number",
                      labelColor: Theme.of(context).colorScheme.onSurface,
                    ),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        AppOverlays.tvPlans(context: context);
                      },
                      radius: 15,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 19,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Select Package",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: Theme.of(context).colorScheme.scrim,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
