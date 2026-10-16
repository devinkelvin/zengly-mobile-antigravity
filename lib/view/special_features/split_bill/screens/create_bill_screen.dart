import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../split_bill_vm.dart';
import '../widgets/add_participant_sheet.dart';

class CreateBillScreen extends ConsumerStatefulWidget {
  const CreateBillScreen({super.key});

  @override
  ConsumerState<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends ConsumerState<CreateBillScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _accountNumberController = TextEditingController();

  String _selectedCategory = "Dining";
  final List<Map<String, dynamic>> _categories = [
    {"label": "Dining", "icon": Icons.restaurant_rounded, "emoji": "🍽️"},
    {"label": "Travel", "icon": Icons.flight_takeoff_rounded, "emoji": "✈️"},
    {"label": "Groceries", "icon": Icons.shopping_basket_rounded, "emoji": "🛒"},
    {"label": "Nightlife", "icon": Icons.celebration_rounded, "emoji": "🎉"},
    {"label": "Rent", "icon": Icons.home_rounded, "emoji": "🏠"},
    {"label": "General", "icon": Icons.receipt_long_rounded, "emoji": "⚡"},
  ];

  // Bank selection & Dynamic account resolution
  String _selectedBankName = "Guaranty Trust Bank (GTBank)";
  String _selectedBankLogo = AppImages.gtbankLogo;
  Color _selectedBankColor = const Color(0xFFE55300);

  bool _isResolvingAccount = false;
  String _resolvedAccountName = "";
  bool _isAccountVerified = false;

  final List<Map<String, dynamic>> _availableBanks = [
    {
      "name": "Guaranty Trust Bank (GTBank)",
      "code": "058",
      "logo": AppImages.gtbankLogo,
      "color": const Color(0xFFE55300),
    },
    {
      "name": "Access Bank",
      "code": "044",
      "logo": AppImages.interBank,
      "color": const Color(0xFF003B70),
    },
    {
      "name": "Zenith Bank",
      "code": "057",
      "logo": AppImages.zenithLogo,
      "color": const Color(0xFFD32F2F),
    },
    {
      "name": "United Bank for Africa (UBA)",
      "code": "033",
      "logo": AppImages.interBank,
      "color": const Color(0xFFC62828),
    },
    {
      "name": "First Bank of Nigeria",
      "code": "011",
      "logo": AppImages.interBank,
      "color": const Color(0xFF0D47A1),
    },
    {
      "name": "Kuda Microfinance Bank",
      "code": "50211",
      "logo": AppImages.interBank,
      "color": const Color(0xFF49127E),
    },
    {
      "name": "OPay Digital Services",
      "code": "999992",
      "logo": AppImages.interBank,
      "color": const Color(0xFF00B074),
    },
    {
      "name": "PalmPay",
      "code": "999991",
      "logo": AppImages.interBank,
      "color": const Color(0xFF5F00B8),
    },
    {
      "name": "Moniepoint Microfinance Bank",
      "code": "50515",
      "logo": AppImages.interBank,
      "color": const Color(0xFF003366),
    },
    {
      "name": "Stanbic IBTC Bank",
      "code": "039",
      "logo": AppImages.interBank,
      "color": const Color(0xFF0056B3),
    },
    {
      "name": "Fidelity Bank",
      "code": "070",
      "logo": AppImages.interBank,
      "color": const Color(0xFF003A70),
    },
    {
      "name": "FCMB",
      "code": "214",
      "logo": AppImages.interBank,
      "color": const Color(0xFF5C068C),
    },
    {
      "name": "Wema Bank (ALAT)",
      "code": "035",
      "logo": AppImages.interBank,
      "color": const Color(0xFF990033),
    },
    {
      "name": "Sterling Bank",
      "code": "232",
      "logo": AppImages.interBank,
      "color": const Color(0xFFD32F2F),
    },
  ];

  // Participants list
  List<SplitParticipant> _participants = [
    const SplitParticipant(
      id: "p_you",
      name: "You",
      username: "@kelvin",
      phone: "+234 802 000 1122",
      avatarInitial: "K",
      amount: 0.0,
      status: ParticipantSplitStatus.paid,
      isYou: true,
    ),
    const SplitParticipant(
      id: "p_amara",
      name: "Amara Williams",
      username: "@amara",
      phone: "+234 813 456 7890",
      avatarInitial: "A",
      avatarColor: Color(0xFF6C5CE7),
      amount: 0.0,
      status: ParticipantSplitStatus.pending,
    ),
    const SplitParticipant(
      id: "p_tunde",
      name: "Tunde Bakare",
      username: "@tundeb",
      phone: "+234 809 112 3344",
      avatarInitial: "T",
      avatarColor: Color(0xFF00B894),
      amount: 0.0,
      status: ParticipantSplitStatus.pending,
    ),
  ];

  @override
  void initState() {
    super.initState();
    final draft = ref.read(splitDraftProvider);
    if (draft.title.isNotEmpty) _titleController.text = draft.title;
    if (draft.amount > 0) {
      _amountController.text = CurrencyFormatter.format(draft.amount).replaceFirst("₦", "").trim();
    }
    if (draft.note.isNotEmpty) _noteController.text = draft.note;
    _selectedCategory = draft.category;

    if (draft.merchantAccount.isNotEmpty) {
      _accountNumberController.text = draft.merchantAccount;
      _selectedBankName = draft.merchantBank;
      _resolvedAccountName = draft.merchantResolvedName;
      _isAccountVerified = draft.isMerchantResolved;
    } else {
      // Default initial mock merchant demo
      _accountNumberController.text = "0428658653";
      _selectedBankName = "Guaranty Trust Bank (GTBank)";
      _resolvedAccountName = "RSVP Restaurant Lekki Ltd";
      _isAccountVerified = true;
    }

    if (draft.participants.isNotEmpty) {
      _participants = List.from(draft.participants);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  double get _parsedAmount {
    final clean = _amountController.text.replaceAll(",", "").trim();
    return double.tryParse(clean) ?? 0.0;
  }

  void _addPresetAmount(double additional) {
    final current = _parsedAmount;
    final total = current + additional;
    setState(() {
      _amountController.text = CurrencyFormatter.format(total).replaceFirst("₦", "").trim();
    });
  }

  void _onAccountNumberChanged(String value) {
    final clean = value.trim();
    if (clean.length == 10) {
      _resolveAccountName(clean, _selectedBankName);
    } else {
      setState(() {
        _isAccountVerified = false;
        _resolvedAccountName = "";
      });
    }
  }

  Future<void> _resolveAccountName(String account, String bank) async {
    setState(() {
      _isResolvingAccount = true;
      _isAccountVerified = false;
      _resolvedAccountName = "";
    });

    // Realistic NIP lookup delay
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    String name = "";
    if (account.startsWith("042") || account.startsWith("567")) {
      name = "RSVP Restaurant Lekki Ltd";
    } else if (account.startsWith("069") || account.startsWith("101")) {
      name = "Lekki Palms Facility Services";
    } else if (account.startsWith("200")) {
      name = "Ebeano Supermarket Lekki";
    } else if (account.startsWith("803") || account.startsWith("902")) {
      name = "Terra Kulture Arts & Dining";
    } else {
      name = "Kelvin Ekuhoho Enterprise";
    }

    setState(() {
      _isResolvingAccount = false;
      _isAccountVerified = true;
      _resolvedAccountName = name;
    });
  }

  void _openBankSelectorModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16140F),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        String query = "";
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = _availableBanks.where((b) {
              final name = (b["name"] as String).toLowerCase();
              return name.contains(query.toLowerCase());
            }).toList();

            return Container(
              padding: EdgeInsets.only(
                top: 16,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Select Destination Bank",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF221F18),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.white54, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (val) => setModalState(() => query = val),
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: "Search bank by name...",
                              hintStyle: TextStyle(color: Colors.white38),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 1),
                      itemBuilder: (context, index) {
                        final b = filtered[index];
                        final isSelected = b["name"] == _selectedBankName;
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          leading: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (b["color"] as Color).withValues(alpha: 0.15),
                            ),
                            child: Icon(
                              Icons.account_balance_rounded,
                              color: b["color"] as Color,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            b["name"] as String,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? const Color(0xFFE5A93C) : Colors.white,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle_rounded, color: Color(0xFFE5A93C), size: 20)
                              : null,
                          onTap: () {
                            Navigator.pop(ctx);
                            setState(() {
                              _selectedBankName = b["name"] as String;
                              _selectedBankLogo = b["logo"] as String;
                              _selectedBankColor = b["color"] as Color;
                            });
                            if (_accountNumberController.text.length == 10) {
                              _resolveAccountName(_accountNumberController.text, _selectedBankName);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _pasteAccountNumber() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      final clean = data.text!.replaceAll(RegExp(r'[^0-9]'), '');
      if (clean.isNotEmpty) {
        final formatted = clean.length > 10 ? clean.substring(0, 10) : clean;
        _accountNumberController.text = formatted;
        _onAccountNumberChanged(formatted);
      }
    }
  }

  void _openAddParticipantModal() {
    AddSplitParticipantSheet.show(
      context: context,
      currentParticipants: _participants,
      onParticipantAdded: _addParticipant,
    );
  }

  void _addParticipant(SplitParticipant participant) {
    setState(() {
      _participants.add(participant);
    });
    ref.read(splitDraftProvider.notifier).setParticipants(_participants);
  }

  void _removeParticipant(String id) {
    if (_participants.length <= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("A split bill requires at least 2 participants")),
      );
      return;
    }
    setState(() {
      _participants.removeWhere((p) => p.id == id);
    });
    ref.read(splitDraftProvider.notifier).setParticipants(_participants);
  }

  void _proceedToSplit() {
    final amount = _parsedAmount;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid bill amount")),
      );
      return;
    }

    if (_accountNumberController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a 10-digit recipient account number")),
      );
      return;
    }

    if (!_isAccountVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please verify the recipient account name before proceeding")),
      );
      return;
    }

    if (_participants.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please include at least 2 participants to split the bill")),
      );
      return;
    }

    final title = _titleController.text.trim().isEmpty
        ? "$_selectedCategory Bill"
        : _titleController.text.trim();

    final draftNotifier = ref.read(splitDraftProvider.notifier);
    draftNotifier.updateTitle(title);
    draftNotifier.updateCategory(_selectedCategory);
    draftNotifier.updateAmount(amount);
    draftNotifier.updateNote(_noteController.text.trim());
    draftNotifier.updateRecipient(
      bank: _selectedBankName,
      account: _accountNumberController.text.trim(),
      resolvedName: _resolvedAccountName,
      logo: _selectedBankLogo,
      isResolved: _isAccountVerified,
    );
    draftNotifier.setParticipants(_participants);

    context.pushNamed(AppRouter.inputSplitScreen);
  }

  @override
  Widget build(BuildContext context) {
    final amount = _parsedAmount;
    final canContinue = amount > 0 &&
        _accountNumberController.text.length == 10 &&
        _isAccountVerified &&
        _participants.length >= 2;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0D0C0A) : const Color(0xFFFAF7F2);
    final buttonBg = isDark ? const Color(0xFF1E1D1A) : const Color(0xFFEDE4D4);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1E1A14);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              decoration: BoxDecoration(
                color: buttonBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: textPrimary,
                size: 18,
              ),
            ),
          ),
        ),
        title: Text(
          "Create Split Bill",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 3-Step Journey Indicator
            Row(
              children: [
                _buildStepPill(1, "Bill Details", true),
                Container(
                  width: 20,
                  height: 1.5,
                  color: const Color(0xFFE5A93C),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                ),
                _buildStepPill(2, "Allocation", false),
                Container(
                  width: 20,
                  height: 1.5,
                  color: Colors.white12,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                ),
                _buildStepPill(3, "Confirmation", false),
              ],
            ),
            const SizedBox(height: 20),

            // Category Chips Carousel
            Text(
              "Select Category",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: _categories.map((c) {
                  final isSelected = c["label"] == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      avatar: Text(c["emoji"] as String, style: const TextStyle(fontSize: 15)),
                      label: Text(c["label"] as String),
                      selected: isSelected,
                      selectedColor: const Color(0xFFE5A93C),
                      backgroundColor: const Color(0xFF1E1D1A),
                      labelStyle: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.black : Colors.white70,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFFE5A93C) : Colors.white10,
                        ),
                      ),
                      onSelected: (_) => setState(() => _selectedCategory = c["label"] as String),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Bill Title Input
            Text(
              "Bill Title",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF171512),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                controller: _titleController,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: "e.g. VIP Table at RSVP, Weekend Roadtrip",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white38,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Total Amount Input Card with Presets
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF171512),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5A93C).withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "TOTAL BILL AMOUNT",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          color: const Color(0xFFE5A93C),
                        ),
                      ),
                      Text(
                        "Balance: ₦2,000,000.00",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "₦",
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFE5A93C),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                          decoration: InputDecoration(
                            hintText: "0.00",
                            hintStyle: GoogleFonts.inter(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.white24,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Preset Quick Add Chips
                  Row(
                    children: [
                      _buildPresetChip("+₦10,000", 10000),
                      const SizedBox(width: 8),
                      _buildPresetChip("+₦50,000", 50000),
                      const SizedBox(width: 8),
                      _buildPresetChip("+₦100,000", 100000),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ==========================================
            // RECIPIENT / MERCHANT SECTION (NEW INPUT BOX + BANK SELECTOR)
            // ==========================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recipient / Merchant Details",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5A93C).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "Interbank NIP",
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFE5A93C),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "Select destination bank and input the 10-digit NUBAN account number.",
              style: GoogleFonts.inter(fontSize: 12, color: Colors.white54),
            ),
            const SizedBox(height: 12),

            // Destination Bank Selector Card
            GestureDetector(
              onTap: _openBankSelectorModal,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF171512),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _selectedBankColor.withValues(alpha: 0.15),
                      ),
                      child: Icon(
                        Icons.account_balance_rounded,
                        color: _selectedBankColor,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Destination Bank",
                            style: GoogleFonts.inter(fontSize: 11, color: Colors.white38),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _selectedBankName,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white54),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Account Number Input Box with Paste Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF171512),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isAccountVerified
                      ? const Color(0xFF2ED573).withValues(alpha: 0.6)
                      : Colors.white12,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _accountNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: "10-Digit Recipient Account Number",
                        labelStyle: GoogleFonts.inter(color: Colors.white54, fontSize: 12),
                        hintText: "e.g. 0428658653",
                        hintStyle: GoogleFonts.inter(color: Colors.white24, fontSize: 14),
                        border: InputBorder.none,
                      ),
                      onChanged: _onAccountNumberChanged,
                    ),
                  ),
                  if (_isResolvingAccount)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFE5A93C)),
                    )
                  else if (_isAccountVerified)
                    const Icon(Icons.check_circle_rounded, color: Color(0xFF2ED573), size: 20)
                  else
                    GestureDetector(
                      onTap: _pasteAccountNumber,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "PASTE",
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFE5A93C),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Dynamic Account Resolution Preview Card
            if (_isAccountVerified && _resolvedAccountName.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2ED573).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2ED573).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_rounded, color: Color(0xFF2ED573), size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _resolvedAccountName,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Verified Merchant Account • $_selectedBankName",
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF2ED573),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // ==========================================
            // PARTICIPANTS SECTION (ADD & REMOVE OPTIONS)
            // ==========================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Participants (${_participants.length})",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: _openAddParticipantModal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5A93C).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, size: 14, color: Color(0xFFE5A93C)),
                        const SizedBox(width: 4),
                        Text(
                          "Add Friend",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFE5A93C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Participants List with Remove (x) Option
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _participants.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final p = _participants[index];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF171512),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: p.avatarColor,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          p.avatarInitial.isNotEmpty ? p.avatarInitial : p.name[0],
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    p.name,
                                    style: GoogleFonts.inter(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (p.isYou) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE5A93C).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      "Creator",
                                      style: GoogleFonts.inter(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFE5A93C),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              p.username.isNotEmpty ? p.username : (p.phone.isNotEmpty ? p.phone : "Split member"),
                              style: GoogleFonts.inter(fontSize: 11.5, color: Colors.white54),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Remove button (unless only 2 participants remain or user is creator)
                      if (!p.isYou)
                        GestureDetector(
                          onTap: () => _removeParticipant(p.id),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                            child: const Icon(Icons.close_rounded, size: 14, color: Colors.white70),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 14),

            // Note (Optional)
            Text(
              "Note or Memo (Optional)",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF171512),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                controller: _noteController,
                maxLines: 2,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: "Add any context or instructions for your friends...",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white38,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Proceed to Step 2 Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: canContinue ? const Color(0xFFE5A93C) : Colors.white12,
                  foregroundColor: canContinue ? Colors.black : Colors.white38,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: canContinue ? _proceedToSplit : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Proceed to Split Allocation",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStepPill(int step, String label, bool isActive) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE5A93C).withValues(alpha: 0.15) : const Color(0xFF1A1815),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? const Color(0xFFE5A93C) : Colors.white10,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 9,
              backgroundColor: isActive ? const Color(0xFFE5A93C) : Colors.white24,
              child: Text(
                "$step",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isActive ? Colors.black : Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? const Color(0xFFE5A93C) : Colors.white54,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip(String label, double val) {
    return Expanded(
      child: InkWell(
        onTap: () => _addPresetAmount(val),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
