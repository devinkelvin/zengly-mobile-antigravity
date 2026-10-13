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

  BankAccountOption({
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    required this.logo,
  });
}

class SelectBankSheet extends StatefulWidget {
  const SelectBankSheet({super.key});

  @override
  State<SelectBankSheet> createState() => _SelectBankSheetState();
}

class _SelectBankSheetState extends State<SelectBankSheet> {
  final _searchController = TextEditingController();
  String _query = "";

  static final _accounts = [
    BankAccountOption(
      bankName: "Guarantee Trust Bank",
      accountNumber: "0428658653",
      accountName: "Ability Elijah",
      logo: AppImages.gtbankLogo,
    ),
    BankAccountOption(
      bankName: "FCMB",
      accountNumber: "5673658653",
      accountName: "Ability Elijah",
      logo: AppImages.fcmbLogo,
    ),
    BankAccountOption(
      bankName: "Zenith Bank",
      accountNumber: "5673658653",
      accountName: "Ability Elijah",
      logo: AppImages.zenithLogo,
    ),
    BankAccountOption(
      bankName: "Polaris Bank",
      accountNumber: "5673658653",
      accountName: "Ability Elijah",
      logo: AppImages.polarisLogo,
    ),
  ];

  List<BankAccountOption> get _filteredAccounts {
    if (_query.isEmpty) return _accounts;
    final query = _query.toLowerCase();
    return _accounts
        .where((a) => a.bankName.toLowerCase().contains(query))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Select Bank",
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: 0,
              ),
            ),
            IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _query = value),
          style: GoogleFonts.inter(fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.04),
            hintText: "Search Bank Name",
            hintStyle: GoogleFonts.inter(
              fontSize: 14,
              color: Theme.of(context).colorScheme.scrim,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SvgPicture.asset(
                AppImages.search,
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.scrim,
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
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: 16),
        ..._filteredAccounts.map(
          (account) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => context.pop(account),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        account.logo,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account.bankName,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "${account.accountNumber}, ${account.accountName}",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.scrim,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.more_vert,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
