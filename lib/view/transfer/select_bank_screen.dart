import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/data.dart';

class BankAccountOption {
  final String bankName;
  final String accountNumber;
  final String accountName;
  final String logo;
  final String bankCode;
  final Color? brandColor;

  BankAccountOption({
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    required this.logo,
    this.bankCode = "000",
    this.brandColor,
  });
}

class SelectBankSheet extends StatefulWidget {
  const SelectBankSheet({super.key});

  static List<BankAccountOption> get allBanks => _SelectBankSheetState._allBanks;

  @override
  State<SelectBankSheet> createState() => _SelectBankSheetState();
}

class _SelectBankSheetState extends State<SelectBankSheet> {
  final _searchController = TextEditingController();
  String _query = "";

  static final List<BankAccountOption> _allBanks = [
    BankAccountOption(
      bankName: "Guaranty Trust Bank (GTBank)",
      accountNumber: "0428658653",
      accountName: "Ability Elijah",
      logo: AppImages.gtbankLogo,
      bankCode: "058",
      brandColor: const Color(0xFFE55300),
    ),
    BankAccountOption(
      bankName: "Access Bank",
      accountNumber: "0691234567",
      accountName: "Saved Beneficiary",
      logo: AppImages.interBank,
      bankCode: "044",
      brandColor: const Color(0xFF003B70),
    ),
    BankAccountOption(
      bankName: "Zenith Bank",
      accountNumber: "1012345678",
      accountName: "Ability Elijah",
      logo: AppImages.zenithLogo,
      bankCode: "057",
      brandColor: const Color(0xFFD32F2F),
    ),
    BankAccountOption(
      bankName: "United Bank for Africa (UBA)",
      accountNumber: "2087654321",
      accountName: "Saved Beneficiary",
      logo: AppImages.interBank,
      bankCode: "033",
      brandColor: const Color(0xFFC62828),
    ),
    BankAccountOption(
      bankName: "First Bank of Nigeria",
      accountNumber: "3051234567",
      accountName: "Saved Beneficiary",
      logo: AppImages.interBank,
      bankCode: "011",
      brandColor: const Color(0xFF0D47A1),
    ),
    BankAccountOption(
      bankName: "Kuda Microfinance Bank",
      accountNumber: "2001234567",
      accountName: "Digital Account",
      logo: AppImages.interBank,
      bankCode: "50211",
      brandColor: const Color(0xFF49127E),
    ),
    BankAccountOption(
      bankName: "OPay Digital Services",
      accountNumber: "8031234567",
      accountName: "OPay Wallet",
      logo: AppImages.interBank,
      bankCode: "999992",
      brandColor: const Color(0xFF00B074),
    ),
    BankAccountOption(
      bankName: "PalmPay",
      accountNumber: "9021234567",
      accountName: "PalmPay Wallet",
      logo: AppImages.interBank,
      bankCode: "999991",
      brandColor: const Color(0xFF5F00B8),
    ),
    BankAccountOption(
      bankName: "Moniepoint MFB",
      accountNumber: "6211234567",
      accountName: "Business Account",
      logo: AppImages.interBank,
      bankCode: "50515",
      brandColor: const Color(0xFF0038FF),
    ),
    BankAccountOption(
      bankName: "First City Monument Bank (FCMB)",
      accountNumber: "5673658653",
      accountName: "Ability Elijah",
      logo: AppImages.fcmbLogo,
      bankCode: "214",
      brandColor: const Color(0xFF5C2D91),
    ),
    BankAccountOption(
      bankName: "Stanbic IBTC Bank",
      accountNumber: "0021234567",
      accountName: "Savings Account",
      logo: AppImages.interBank,
      bankCode: "221",
      brandColor: const Color(0xFF0033A0),
    ),
    BankAccountOption(
      bankName: "Sterling Bank",
      accountNumber: "0051234567",
      accountName: "Sterling Account",
      logo: AppImages.interBank,
      bankCode: "232",
      brandColor: const Color(0xFFC41230),
    ),
    BankAccountOption(
      bankName: "Fidelity Bank",
      accountNumber: "4011234567",
      accountName: "Fidelity Account",
      logo: AppImages.interBank,
      bankCode: "070",
      brandColor: const Color(0xFF1B365D),
    ),
    BankAccountOption(
      bankName: "Wema Bank / ALAT",
      accountNumber: "0121234567",
      accountName: "ALAT Digital",
      logo: AppImages.interBank,
      bankCode: "035",
      brandColor: const Color(0xFF7E004B),
    ),
    BankAccountOption(
      bankName: "Providus Bank",
      accountNumber: "5401234567",
      accountName: "Providus Account",
      logo: AppImages.interBank,
      bankCode: "101",
      brandColor: const Color(0xFFFFB81C),
    ),
    BankAccountOption(
      bankName: "Polaris Bank",
      accountNumber: "5673658653",
      accountName: "Ability Elijah",
      logo: AppImages.polarisLogo,
      bankCode: "076",
      brandColor: const Color(0xFF5F259F),
    ),
  ];

  List<BankAccountOption> get _filteredBanks {
    if (_query.isEmpty) return _allBanks;
    final query = _query.toLowerCase();
    return _allBanks
        .where((a) =>
            a.bankName.toLowerCase().contains(query) ||
            a.bankCode.contains(query))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.78,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select Destination Bank",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: isDark ? Colors.white : const Color(0xFF1E1A14),
                ),
              ),
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.close,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark
                  ? const Color(0xFF262017)
                  : const Color(0xFFF4EDE2),
              hintText: "Search bank by name or code...",
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SvgPicture.asset(
                  AppImages.search,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    isDark ? Colors.white54 : Colors.black45,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Popular Banks Quick Chips
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildQuickBankChip("GTBank", const Color(0xFFE55300), isDark),
                const SizedBox(width: 8),
                _buildQuickBankChip("Access Bank", const Color(0xFF003B70), isDark),
                const SizedBox(width: 8),
                _buildQuickBankChip("Zenith Bank", const Color(0xFFD32F2F), isDark),
                const SizedBox(width: 8),
                _buildQuickBankChip("OPay", const Color(0xFF00B074), isDark),
                const SizedBox(width: 8),
                _buildQuickBankChip("PalmPay", const Color(0xFF5F00B8), isDark),
                const SizedBox(width: 8),
                _buildQuickBankChip("Kuda Bank", const Color(0xFF49127E), isDark),
                const SizedBox(width: 8),
                _buildQuickBankChip("Moniepoint", const Color(0xFF0038FF), isDark),
                const SizedBox(width: 8),
                _buildQuickBankChip("First Bank", const Color(0xFF0D47A1), isDark),
                const SizedBox(width: 8),
                _buildQuickBankChip("UBA", const Color(0xFFC62828), isDark),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredBanks.length,
              separatorBuilder: (context, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final bank = _filteredBanks[index];
                return InkWell(
                  onTap: () => context.pop(bank),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF221D16)
                          : const Color(0xFFFAF7F2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : const Color(0xFFEBE3D7),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Bank Icon badge
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (bank.brandColor ?? const Color(0xFFB57510))
                                .withValues(alpha: isDark ? 0.2 : 0.12),
                          ),
                          child: Center(
                            child: bank.logo.endsWith(".svg")
                                ? SvgPicture.asset(
                                    bank.logo,
                                    width: 22,
                                    height: 22,
                                  )
                                : ClipOval(
                                    child: Image.asset(
                                      bank.logo,
                                      width: 26,
                                      height: 26,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => Icon(
                                        Icons.account_balance_rounded,
                                        size: 20,
                                        color: bank.brandColor ??
                                            const Color(0xFFB57510),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bank.bankName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF1E1A14),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "CBN Code: ${bank.bankCode}",
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickBankChip(String label, Color color, bool isDark) {
    return InkWell(
      onTap: () {
        final query = label.toLowerCase().replaceAll(" bank", "");
        final match = _allBanks.firstWhere(
          (b) => b.bankName.toLowerCase().contains(query),
          orElse: () => _allBanks.first,
        );
        context.pop(match);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.16 : 0.10),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF1E1A14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
