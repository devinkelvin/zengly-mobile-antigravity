import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';
import '../../../view.dart';

class TvPlanSheet extends ConsumerStatefulWidget {
  const TvPlanSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TvPlanSheetState();
}

class _TvPlanSheetState extends ConsumerState<TvPlanSheet> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = ref.read(tvSubscriptionVm);
    return Column(
      children: [
        Text(
          vm.selectedProvider == null
              ? "No Provider Selected"
              : "Select ${vm.selectedProvider!.name} Provider",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: 16),
        Column(
          children: [
            AppTextField(
              controller: _searchController,
              labelText: "Search",
              prefixIcon: SvgPicture.asset(
                AppImages.search,
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.scrim,
                  BlendMode.srcIn,
                ),
              ),
              prefixContraints: BoxConstraints(maxWidth: 42, maxHeight: 42),
            ),
            SizedBox(height: 16),
            vm.selectedProvider == null
                ? SizedBox()
                : SizedBox(
                  height: Responsive.height(context) * 0.85 - 112,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: vm.selectedProvider!.plans.length,
                    itemBuilder: (context, i) {
                      final plan = vm.selectedProvider!.plans[i];
                      return TvPlanSelector(
                        plan: plan,
                        provider: vm.selectedProvider!,
                      );
                    },
                  ),
                ),
          ],
        ),
      ],
    );
  }
}

class TvBottomSheet extends ConsumerWidget {
  const TvBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(tvSubscriptionVm);
    return Column(
      children: [
        Text(
          "Select Service Provider",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: vm.tvProviders.length,
          itemBuilder: (context, i) {
            final provider = vm.tvProviders[i];
            return TvProviderSelector(
              isSelected: vm.selectedProvider == provider,
              model: provider,
              index: i,
            );
          },
        ),
      ],
    );
  }
}

class TvProviderSelector extends ConsumerWidget {
  final bool isSelected;
  final TvProviderModel model;
  final int index;
  const TvProviderSelector({
    super.key,
    required this.isSelected,
    required this.model,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final vm = ref.read(tvSubscriptionVm);
        vm.updateTvProvider(index: index);
        context.pop();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.outlineVariant,
          border:
              isSelected
                  ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                  )
                  : Border.all(width: 0),
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inverseSurface,
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(50),
                child: Image.asset(
                  model.image,
                  width: 48,
                  height: 48,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(model.name),
            Spacer(),
            if (isSelected)
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Icon(
                  Icons.check,
                  size: 16,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class TvPlanSelector extends ConsumerWidget {
  final TvPlanModel plan;
  final TvProviderModel provider;
  const TvPlanSelector({super.key, required this.plan, required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        context.pop();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        child: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inverseSurface,
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(50),
                child: Image.asset(
                  provider.image,
                  width: 48,
                  height: 48,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              "${provider.name} ${plan.name} - (${plan.duration})",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
                fontSize: 14,
              ),
            ),
            Spacer(),
            Text(
              CurrencyFormatter.format(plan.price),
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
