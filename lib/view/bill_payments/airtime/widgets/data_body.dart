import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';
import '../../../view.dart';

class DataBody extends ConsumerStatefulWidget {
  const DataBody({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DataBodyState();
}

class _DataBodyState extends ConsumerState<DataBody> {
  final _phoneController = TextEditingController();

  DataPlanCategory _selectedCategory = DataPlanCategory.hotDeals;
  DataPlanModel? _selectedPlan;

  static const _categories = [
    DataPlanCategory.hotDeals,
    DataPlanCategory.daily,
    DataPlanCategory.monthly,
    DataPlanCategory.weekly,
  ];

  updatePhoneNumber(String phone) {
    _phoneController.text = PhoneNumberFormatter.format(
      phone.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    setState(() {});
  }

  @override
  void initState() {
    ref.read(airtimeVm).initalizeFunction(updatePhone: updatePhoneNumber);
    super.initState();
  }

  void _openSelectDataPlan() {
    final network = ref.read(airtimeVm).selectedNetwork!;
    context.pushNamed(
      AppRouter.selectDataPlan,
      extra: {
        "network": network,
        "onSelected": (DataPlanModel plan) {
          setState(() => _selectedPlan = plan);
        },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final network = ref.watch(airtimeVm).selectedNetwork;
    final plans =
        network == null
            ? <DataPlanModel>[]
            : DataPlanModel.plansForNetwork(
              network.name,
            ).where((plan) => plan.category == _selectedCategory).toList();

    return SingleChildScrollView(
      padding: AppDimensions.viewPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Text(
            "Select network provider",
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
            ),
          ),
          SizedBox(height: 10),
          AirtimeNumberTextfield(controller: _phoneController),
          SizedBox(height: 22),
          SizedBox(
            height: 46,
            child: ListView.separated(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length + 1,
              separatorBuilder: (context, i) => SizedBox(width: 8),
              itemBuilder: (context, i) {
                if (i == _categories.length) {
                  return DataCategoryChip(
                    label: "More",
                    isSelected: false,
                    onTap: _openSelectDataPlan,
                  );
                }
                final category = _categories[i];
                return DataCategoryChip(
                  label: category.label,
                  isSelected: _selectedCategory == category,
                  onTap: () => setState(() => _selectedCategory = category),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 0.85,
            ),
            itemCount: plans.length,
            itemBuilder: (context, i) {
              final plan = plans[i];
              final isSelected =
                  _selectedPlan == null ? i == 0 : _selectedPlan == plan;
              return DataPlanCard(
                plan: plan,
                isSelected: isSelected,
                onTap: () => setState(() => _selectedPlan = plan),
              );
            },
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              onPressed: () {
                final selectedPlan =
                    _selectedPlan ?? (plans.isNotEmpty ? plans.first : null);
                if (selectedPlan == null) {
                  AppOverlays.showToast(
                    context: context,
                    message: "Select a data plan",
                    toastType: ToastificationType.error,
                  );
                  return;
                }
                ref
                    .read(airtimeVm)
                    .startPurchase(
                      context: context,
                      type: "Data",
                      amount: selectedPlan.price,
                      phoneNumber: _phoneController.text.replaceAll('-', ''),
                      planLabel: selectedPlan.duration,
                      cashback:
                          selectedPlan.cashback.isEmpty
                              ? null
                              : selectedPlan.cashback,
                    );
              },
              actionText: "Continue",
            ),
          ),
        ],
      ),
    );
  }
}
