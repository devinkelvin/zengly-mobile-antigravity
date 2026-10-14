import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';
import '../../../view.dart';

class AirtimeBody extends ConsumerStatefulWidget {
  const AirtimeBody({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AirtimeBodyState();
}

class _AirtimeBodyState extends ConsumerState<AirtimeBody> {
  final List<int> amounts = [100, 200, 500, 1000, 2000, 5000];
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();

  void _updateAmount(int newAmount) {
    _amountController.text = NumberFormat.decimalPattern().format(newAmount);
    setState(() {});
  }

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
    _amountController.addListener(() => setState(() {}));
    _phoneController.addListener(() {
      _detectCarrier(_phoneController.text);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  double get _cashbackAmount {
    final text = _amountController.text.replaceAll(',', '').trim();
    final amt = double.tryParse(text) ?? 0;
    return amt * 0.02; // 2% instant cashback
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vm = ref.watch(airtimeVm);
    final networks = vm.networks;
    final selectedNetwork = vm.selectedNetwork ?? networks.first;

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

          const SizedBox(height: 16),

          // Amount Field
          AirtimeTextField(controller: _amountController),

          const SizedBox(height: 14),

          // Quick Amount Pills Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 2.3,
            ),
            itemCount: amounts.length,
            itemBuilder: (context, i) {
              final amount = amounts[i];
              final formatted = NumberFormat.decimalPattern().format(amount);
              final isSelected =
                  _amountController.text.replaceAll(',', '') == amount.toString();

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _updateAmount(amount),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected
                        ? const Color(0xFFB57510)
                        : (isDark ? const Color(0xFF241F18) : const Color(0xFFF2ECE1)),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFB57510)
                          : (isDark ? Colors.white10 : const Color(0xFFE2D6C5)),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFFB57510).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "₦$formatted",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.white : const Color(0xFF1E1A14)),
                        ),
                      ),
                      Text(
                        "+2% back",
                        style: GoogleFonts.inter(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white70
                              : const Color(0xFFB57510),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          if (_cashbackAmount > 0) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFB57510).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFB57510).withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.stars_rounded,
                    size: 20,
                    color: Color(0xFFB57510),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Cashback Reward: ",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  Text(
                    "+₦${NumberFormat("#,##0.00").format(_cashbackAmount)}",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFB57510),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB57510),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "Instant",
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Recent Contacts
          _RecentContacts(
            onSelect: (number) => ref
                .read(airtimeVm)
                .updatePhoneNumber(number: number, context: context),
          ),

          const SizedBox(height: 24),

          // Continue Button
          AppButton.primary(
            onPressed: () {
              final amount = _amountController.text.trim();
              ref.read(airtimeVm).startPurchase(
                    context: context,
                    type: "Airtime",
                    amount: amount.isEmpty ? "" : "₦$amount",
                    phoneNumber: _phoneController.text.replaceAll('-', ''),
                  );
            },
            actionText: "Recharge Airtime",
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _RecentContact {
  final String name;
  final String number;
  final Color? avatarColor;

  const _RecentContact({
    required this.name,
    required this.number,
    this.avatarColor,
  });
}

class _RecentContacts extends StatelessWidget {
  final void Function(String number) onSelect;
  const _RecentContacts({required this.onSelect});

  static const List<_RecentContact> _dummyContacts = [
    _RecentContact(
      name: "Mum",
      number: "08031234567",
      avatarColor: Color(0xFFB57510),
    ),
    _RecentContact(
      name: "Burna",
      number: "08029876543",
      avatarColor: Color(0xFF2B8A3E),
    ),
    _RecentContact(
      name: "Teni",
      number: "08155551212",
      avatarColor: Color(0xFF845EF7),
    ),
    _RecentContact(
      name: "Wizkid",
      number: "09090001122",
      avatarColor: Color(0xFFD9480F),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Top-ups",
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : const Color(0xFF6B5E4A),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 74,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _dummyContacts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, idx) {
              final c = _dummyContacts[idx];
              return GestureDetector(
                onTap: () => onSelect(c.number),
                child: Column(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: c.avatarColor?.withValues(alpha: 0.2) ??
                            const Color(0xFFB57510).withValues(alpha: 0.2),
                        border: Border.all(
                          color: c.avatarColor ?? const Color(0xFFB57510),
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        c.name.substring(0, 1).toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: c.avatarColor ?? const Color(0xFFB57510),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      c.name,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
