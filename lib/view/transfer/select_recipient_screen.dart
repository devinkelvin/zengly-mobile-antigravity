import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/data.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'widgets/widgets.dart';

class _MockRecipient {
  final String name;
  final String accountNumber;
  final String bankName;
  final String logo;

  _MockRecipient({
    required this.name,
    required this.accountNumber,
    required this.bankName,
    required this.logo,
  });
}

class SelectRecipientScreen extends ConsumerStatefulWidget {
  final bool isZenglyTransfer;
  const SelectRecipientScreen({super.key, required this.isZenglyTransfer});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectRecipientScreenState();
}

class _SelectRecipientScreenState extends ConsumerState<SelectRecipientScreen> {
  final _accountNumberController = TextEditingController();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  String _query = "";
  String _amountInput = "";
  String _noteInput = "";
  _MockRecipient? _selectedRecipient;

  static const double _fee = 100;

  static final _mockRecipients = [
    _MockRecipient(
      name: "Ability Elijah",
      accountNumber: "5673658653",
      bankName: "GTBank",
      logo: AppImages.gtbankLogo,
    ),
    _MockRecipient(
      name: "Chidi Okafor",
      accountNumber: "0428658653",
      bankName: "FCMB",
      logo: AppImages.fcmbLogo,
    ),
    _MockRecipient(
      name: "Ngozi Eze",
      accountNumber: "7038271812",
      bankName: "Zenith Bank",
      logo: AppImages.zenithLogo,
    ),
  ];

  List<_MockRecipient> get _filteredRecipients {
    if (_query.isEmpty) return [];
    final query = _query.toLowerCase();
    return _mockRecipients
        .where(
          (r) =>
              r.name.toLowerCase().contains(query) ||
              r.accountNumber.contains(query),
        )
        .toList();
  }

  void _selectRecipient(_MockRecipient recipient) {
    setState(() => _selectedRecipient = recipient);
  }

  Future<void> _pickBankAccount() async {
    final result = await AppOverlays.selectBankSheet(context: context);
    if (result == null) return;
    _selectRecipient(
      _MockRecipient(
        name: result.accountName,
        accountNumber: result.accountNumber,
        bankName: result.bankName,
        logo: result.logo,
      ),
    );
  }

  void _continue() {
    final recipient = _selectedRecipient;
    if (recipient == null) return;
    final amount = double.tryParse(_amountInput.replaceAll(",", "")) ?? 0;
    context.pushNamed(
      AppRouter.confirmTransfer,
      extra: TransferResult(
        recipientName: recipient.name,
        recipientAccountNumber: recipient.accountNumber,
        recipientBank: recipient.bankName,
        sourceBank: "Zengly Wallet",
        sourceAccountNumber: "",
        amount: amount,
        note: _noteInput,
        fee: _fee,
        date: DateTime.now(),
        transactionReference: "",
        providerReference: "",
      ),
    );
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isZenglyTransfer) return _buildZenglyTransfer(context);
    return _buildBankTransfer(context);
  }

  Widget _buildBankTransfer(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "Enter Details",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            AccountBalanceTile(),
            SizedBox(height: 32),
            AppTextField(
              controller: _accountNumberController,
              labelText: "Account Number",
            ),
            SizedBox(height: 24),
            AccountDetailsCard(),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: () {
                  context.pushNamed(AppRouter.amountScreen);
                },
                actionText: "Continue",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZenglyTransfer(BuildContext context) {
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
          "Transfer",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Balance ",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.scrim,
                      ),
                    ),
                    TextSpan(
                      text: "₦345,778.90",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            DottedBorder(
              options: RoundedRectDottedBorderOptions(
                radius: const Radius.circular(12),
                color: Theme.of(context).colorScheme.primary,
                dashPattern: const [6, 4],
                strokeWidth: 1.2,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  height: 86,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      // Cash artwork bleeds past the card's vertical bounds and
                      // is trimmed by the ClipRRect, matching the design.
                      Positioned(
                        right: 4,
                        top: -12,
                        child: Image.asset(
                          AppImages.cash,
                          height: 109,
                          width: 109,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 110, 12),
                        child: Center(
                          child: Text(
                            "You have made 0 of 4 interbank transfers today. Transfer now to get ₦10 cashback.",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (value) => setState(() => _query = value),
              style: GoogleFonts.inter(fontSize: 15, letterSpacing: 0),
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.outlineVariant,
                hintText: "Search name, @username, or phone",
                hintStyle: GoogleFonts.inter(
                  fontSize: 15,
                  letterSpacing: 0,
                  color: Theme.of(context).colorScheme.scrim,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            if (_selectedRecipient != null) ...[
              _RecipientResultTile(
                recipient: _selectedRecipient!,
                onTap: () => setState(() => _selectedRecipient = null),
              ),
              SizedBox(height: 16),
              AmountTextField(
                fee: _fee,
                onAmountChanged: (value) => _amountInput = value,
                onNoteChanged: (value) => _noteInput = value,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  onPressed: _continue,
                  actionText: "Continue",
                ),
              ),
            ] else if (_filteredRecipients.isNotEmpty)
              ..._filteredRecipients.map(
                (recipient) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _RecipientResultTile(
                    recipient: recipient,
                    onTap: () => _selectRecipient(recipient),
                  ),
                ),
              )
            else ...[
              _ZenglyOptionTile(
                icon: Icons.alternate_email,
                title: "Send via Username",
                subtitle: "Find by @username",
                onTap: _pickBankAccount,
              ),
              SizedBox(height: 12),
              _ZenglyOptionTile(
                icon: Icons.phone_outlined,
                title: "Send via Phone",
                subtitle: "Enter phone number",
                onTap: _pickBankAccount,
              ),
              SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () => context.pushNamed(AppRouter.preTransferScreen),
                  child: Text(
                    "More ways to send",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RecipientResultTile extends StatelessWidget {
  final _MockRecipient recipient;
  final VoidCallback onTap;

  const _RecipientResultTile({required this.recipient, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipOval(
              child: Image.asset(
                recipient.logo,
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
                    "${recipient.accountNumber}, ${recipient.name}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    recipient.bankName,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Container(
              height: 22,
              width: 22,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                size: 14,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZenglyOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ZenglyOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              child: Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      letterSpacing: 0,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.scrim,
            ),
          ],
        ),
      ),
    );
  }
}
