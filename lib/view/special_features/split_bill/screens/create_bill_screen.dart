import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';

class _MockBillRecipient {
  final String name;
  final String accountNumber;
  final String bankName;
  final String logo;

  const _MockBillRecipient({
    required this.name,
    required this.accountNumber,
    required this.bankName,
    required this.logo,
  });
}

class CreateBillScreen extends ConsumerStatefulWidget {
  const CreateBillScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateBillScreenState();
}

class _CreateBillScreenState extends ConsumerState<CreateBillScreen> {
  final _searchController = TextEditingController();
  String _query = "";
  late _MockBillRecipient? _selectedRecipient = _mockRecipients.first;
  int _friendsAdded = 0;

  static final _mockRecipients = [
    _MockBillRecipient(
      name: "RSVP Restaurant Lagos",
      accountNumber: "5673658653",
      bankName: "GTBank",
      logo: AppImages.gtbankLogo,
    ),
  ];

  List<_MockBillRecipient> get _filteredRecipients {
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openAddFriends() async {
    final addedCount = await AppOverlays.selectSplitFriendsSheet(
      context: context,
    );
    if (addedCount == null) return;
    setState(() => _friendsAdded = addedCount);
  }

  /// Tapping the search field opens the recipient picker rather than filtering
  /// inline, so the flow matches the transfer screen.
  Future<void> _pickRecipient() async {
    final result = await AppOverlays.selectBankSheet(context: context);
    if (result == null) return;
    setState(() {
      _selectedRecipient = _MockBillRecipient(
        name: result.accountName,
        accountNumber: result.accountNumber,
        bankName: result.bankName,
        logo: result.logo,
      );
      _searchController.clear();
      _query = "";
    });
  }

  @override
  Widget build(BuildContext context) {
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
          "Split Bill",
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
            SizedBox(height: 8),
            TextField(
              controller: _searchController,
              readOnly: true,
              onTap: _pickRecipient,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.outlineVariant,
                hintText: "Search recipient account",
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.scrim,
                ),
                suffixIcon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Theme.of(context).colorScheme.scrim,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            if (_selectedRecipient != null)
              _BillRecipientTile(
                recipient: _selectedRecipient!,
                onTap: () => setState(() => _selectedRecipient = null),
              )
            else
              ..._filteredRecipients.map(
                (recipient) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _BillRecipientTile(
                    recipient: recipient,
                    onTap: () => setState(() => _selectedRecipient = recipient),
                  ),
                ),
              ),
            if (_selectedRecipient != null) ...[
              SizedBox(height: 16),
              AmountTextField(hasFee: false),
              SizedBox(height: 24),
              GestureDetector(
                onTap: _openAddFriends,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 56,
                      height: 36,
                      child: Stack(
                        children: List.generate(3, (i) {
                          return Positioned(
                            left: i * 16.0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  AppImages.splitImage,
                                  height: 32,
                                  width: 32,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _friendsAdded == 0
                                ? "Add friends"
                                : "$_friendsAdded friends added",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "users must be using zengly app as well",
                            style: GoogleFonts.inter(
                              fontSize: 11,
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
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  onPressed: () {
                    context.pushNamed(AppRouter.inputSplitScreen);
                  },
                  actionText: "Continue",
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BillRecipientTile extends StatelessWidget {
  final _MockBillRecipient recipient;
  final VoidCallback onTap;

  const _BillRecipientTile({required this.recipient, required this.onTap});

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
