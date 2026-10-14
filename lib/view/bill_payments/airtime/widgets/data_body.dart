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

  void _detectCarrier(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length >= 4) {
      final prefix = cleaned.substring(0, 4);
      final mtnPrefixes = [
        "0803", "0806", "0703", "0706", "0813", "0816", "0810", "0814",
        "0903", "0906", "0913", "0916"
      ];
      final airtelPrefixes = [
        "0802", "0808", "0708", "0812", "0701", "0902", "0901", "0904",
        "0907", "0912"
      ];
      final gloPrefixes = [
        "0805", "0807", "0705", "0815", "0811", "0905", "0915"
      ];
      final nineMobilePrefixes = [
        "0809", "0818", "0817", "0909", "0908"
      ];

      if (mtnPrefixes.contains(prefix)) {
        ref.read(airtimeVm).selectNetworkByName("MTN");
      } else if (airtelPrefixes.contains(prefix)) {
        ref.read(airtimeVm).selectNetworkByName("AIRTEL");
      } else if (gloPrefixes.contains(prefix)) {
        ref.read(airtimeVm).selectNetworkByName("GLO");
      } else if (nineMobilePrefixes.contains(prefix)) {
        ref.read(airtimeVm).selectNetworkByName("9MOBILE");
      }
    }
  }

  void _updatePhoneNumber(String phone) {
    final formatted = PhoneNumberFormatter.format(
      phone.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    _phoneController.text = formatted;
    _detectCarrier(formatted);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ref.read(airtimeVm).initalizeFunction(updatePhone: _updatePhoneNumber);
    _phoneController.addListener(() {
      _detectCarrier(_phoneController.text);
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vm = ref.watch(airtimeVm);
    final networks = vm.networks;
    final selectedNetwork = vm.selectedNetwork ?? networks.first;

    final plans = DataPlanModel.plansForNetwork(
      selectedNetwork.name,
    ).where((plan) => plan.category == _selectedCategory).toList();

    return SingleChildScrollView(
      padding: AppDimensions.viewPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),

          // Network Provider Selector Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select Network Provider",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : const Color(0xFF6B5E4A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFB57510).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  "Auto-detected",
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFB57510),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Network Brand Selector Chips
          Row(
            children: networks.map((net) {
              final isSelected = net.name.toUpperCase() == selectedNetwork.name.toUpperCase();
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    vm.selectNetworkByName(net.name);
                    setState(() => _selectedPlan = null);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFB57510).withValues(alpha: 0.15)
                          : (isDark ? const Color(0xFF241F18) : Colors.white),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFB57510)
                            : (isDark ? Colors.white10 : const Color(0xFFE2D6C5)),
                        width: isSelected ? 1.8 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFFB57510).withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipOval(
                          child: Image.asset(
                            net.image,
                            height: 28,
                            width: 28,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.cell_tower_rounded,
                              size: 24,
                              color: Color(0xFFB57510),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          net.name,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected
                                ? const Color(0xFFB57510)
                                : (isDark ? Colors.white70 : Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Phone Number Input
          AirtimeNumberTextfield(controller: _phoneController),

          const SizedBox(height: 18),

          // Category Chips Bar
          SizedBox(
            height: 42,
            child: ListView.separated(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length + 1,
              separatorBuilder: (context, i) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                if (i == _categories.length) {
                  return DataCategoryChip(
                    label: "More Plans",
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

          const SizedBox(height: 16),

          // Plans Grid
          if (plans.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  "No data plans available for this category",
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 0.94,
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

          const SizedBox(height: 20),

          // Selected Plan Details Card
          Builder(
            builder: (context) {
              final activePlan =
                  _selectedPlan ?? (plans.isNotEmpty ? plans.first : null);
              if (activePlan == null) return const SizedBox.shrink();

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF221D17) : const Color(0xFFF7F2E7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.white10 : const Color(0xFFE5DEC8),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB57510).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.wifi_tethering_rounded,
                        color: Color(0xFFB57510),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${activePlan.data} (${activePlan.duration})",
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF1E1A14),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Instant activation on ${selectedNetwork.name}",
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark ? Colors.white54 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      activePlan.price,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFB57510),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Action Button
          AppButton.primary(
            onPressed: () {
              final selectedPlan =
                  _selectedPlan ?? (plans.isNotEmpty ? plans.first : null);
              if (selectedPlan == null) {
                AppOverlays.showToast(
                  context: context,
                  message: "Select a data plan to proceed",
                  toastType: ToastificationType.error,
                );
                return;
              }
              ref.read(airtimeVm).startPurchase(
                    context: context,
                    type: "Data",
                    amount: selectedPlan.price,
                    phoneNumber: _phoneController.text.replaceAll('-', ''),
                    planLabel: selectedPlan.duration,
                    cashback: selectedPlan.cashback.isEmpty
                        ? null
                        : selectedPlan.cashback,
                  );
            },
            actionText: "Purchase Data Bundle",
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
