import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../data/data.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'select_bank_screen.dart';

class SelectRecipientScreen extends ConsumerStatefulWidget {
  final bool isZenglyTransfer;
  const SelectRecipientScreen({super.key, required this.isZenglyTransfer});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectRecipientScreenState();
}

class _SelectRecipientScreenState extends ConsumerState<SelectRecipientScreen> {
  // Common
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  double _enteredAmount = 0.0;
  static const double _walletBalance = 2000000.0;

  // Zengly Transfer
  final _usernameController = TextEditingController();
  String _selectedUsername = "";
  String _resolvedFullName = "";
  bool _isZenglyUserResolved = false;

  final List<Map<String, String>> _suggestedZenglyUsers = [
    {"username": "@tiwasavage", "name": "Tiwa Savage", "role": "VIP Host"},
    {"username": "@asakemusic", "name": "Ahmed Ololade (Asake)", "role": "Baller"},
    {"username": "@burnaboy", "name": "Damini Ogulu (Burna)", "role": "Global Star"},
    {"username": "@davido", "name": "David Adeleke (OBO)", "role": "VIP Baller"},
    {"username": "@kelvin", "name": "Kelvin Ekuhoho", "role": "Lead Architect"},
    {"username": "@yemialade", "name": "Yemi Eberechi Alade", "role": "Mama Africa"},
  ];

  // Bank Transfer
  final _accountNumberController = TextEditingController();
  BankAccountOption? _selectedBank;
  String _resolvedAccountName = "";
  bool _isValidatingAccount = false;
  bool _isAccountResolved = false;

  static final List<Map<String, String>> _savedBeneficiaries = [
    {
      "name": "Adekunle Gold",
      "account": "0123456789",
      "bank": "Guaranty Trust Bank (GTBank)",
    },
    {
      "name": "Chidi Okafor",
      "account": "0428658653",
      "bank": "Access Bank",
    },
    {
      "name": "Ngozi Eze",
      "account": "1012345678",
      "bank": "Zenith Bank",
    },
    {
      "name": "Zubby Michael",
      "account": "2001234567",
      "bank": "Kuda Microfinance Bank",
    },
  ];

  @override
  void initState() {
    super.initState();
    if (!widget.isZenglyTransfer) {
      _selectedBank = BankAccountOption(
        bankName: "Guaranty Trust Bank (GTBank)",
        accountNumber: "0428658653",
        accountName: "Ability Elijah",
        logo: AppImages.gtbankLogo,
        bankCode: "058",
        brandColor: const Color(0xFFE55300),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _usernameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  void _onSelectSuggestedUser(Map<String, String> user) {
    setState(() {
      _selectedUsername = user["username"]!;
      _usernameController.text = _selectedUsername;
      _resolvedFullName = user["name"]!;
      _isZenglyUserResolved = true;
    });
  }

  void _onUsernameChanged(String value) {
    final clean = value.trim();
    if (clean.isEmpty) {
      setState(() {
        _isZenglyUserResolved = false;
        _resolvedFullName = "";
      });
      return;
    }
    final formatted = clean.startsWith("@") ? clean : "@$clean";
    final match = _suggestedZenglyUsers.firstWhere(
      (u) => u["username"]!.toLowerCase() == formatted.toLowerCase(),
      orElse: () => {
        "username": formatted,
        "name": "${formatted.substring(1).toUpperCase()} (Zengly User)",
        "role": "Verified Member",
      },
    );
    setState(() {
      _selectedUsername = formatted;
      _resolvedFullName = match["name"]!;
      _isZenglyUserResolved = true;
    });
  }

  Future<void> _pickBank() async {
    final result = await AppOverlays.selectBankSheet(context: context);
    if (result != null) {
      setState(() {
        _selectedBank = result;
      });
      final clean = _accountNumberController.text.replaceAll(RegExp(r'\D'), '');
      if (clean.length == 10) {
        _resolveBankAccount(clean);
      }
    }
  }

  void _onAccountNumberChanged(String val) {
    final clean = val.replaceAll(RegExp(r'\D'), '');
    if (clean.length == 10) {
      _resolveBankAccount(clean);
    } else {
      setState(() {
        _isValidatingAccount = false;
        _isAccountResolved = false;
        _resolvedAccountName = "";
      });
    }
  }

  void _pasteAccountNumber() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      final clean = data!.text!.replaceAll(RegExp(r'\D'), '');
      if (clean.isNotEmpty) {
        final formatted = clean.length > 10 ? clean.substring(0, 10) : clean;
        _accountNumberController.text = formatted;
        _onAccountNumberChanged(formatted);
      }
    }
  }

  Future<void> _resolveBankAccount(String nuban) async {
    if (_selectedBank == null) {
      setState(() {
        _isValidatingAccount = false;
        _isAccountResolved = false;
        _resolvedAccountName = "";
      });
      return;
    }

    setState(() {
      _isValidatingAccount = true;
      _isAccountResolved = false;
      _resolvedAccountName = "";
    });

    // Realistic NIP lookup delay
    await Future.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;

    String resolvedName;
    if (nuban.startsWith("042") || nuban.startsWith("567")) {
      resolvedName = "ABILITY ELIJAH OLUWAPELUMI";
    } else if (nuban.startsWith("069") || nuban.startsWith("101")) {
      resolvedName = "CHIDIEBERE EMMANUEL OKECHUKWU";
    } else if (nuban.startsWith("208") || nuban.startsWith("305")) {
      resolvedName = "FATIMA ABUBAKAR DANGOTE";
    } else if (nuban.startsWith("200") || nuban.startsWith("803")) {
      resolvedName = "BABATUNDE ADEWALE OLUWASEUN";
    } else if (nuban.startsWith("902") || nuban.startsWith("621")) {
      resolvedName = "FOLASHADE BLESSING ADEBAYO";
    } else {
      resolvedName = "KELVIN EKUHOHO ENTERPRISE";
    }

    setState(() {
      _isValidatingAccount = false;
      _isAccountResolved = true;
      _resolvedAccountName = resolvedName;
    });
  }

  void _selectBeneficiary(Map<String, String> b) {
    _accountNumberController.text = b["account"]!;
    final matchBank = SelectBankSheet.allBanks.firstWhere(
      (bank) => bank.bankName.toLowerCase().contains(b["bank"]!.toLowerCase()) || b["bank"]!.toLowerCase().contains(bank.bankName.toLowerCase()),
      orElse: () => BankAccountOption(
        bankName: b["bank"]!,
        accountNumber: b["account"]!,
        accountName: b["name"]!,
        logo: AppImages.interBank,
        brandColor: const Color(0xFFE5A93C),
      ),
    );
    setState(() {
      _selectedBank = matchBank;
      _isAccountResolved = true;
      _resolvedAccountName = b["name"]!.toUpperCase();
    });
  }

  void _setAmount(double amount) {
    setState(() {
      _enteredAmount = amount;
      _amountController.text = NumberFormat("#,##0").format(amount);
    });
  }

  void _setPercentage(double percent) {
    _setAmount(_walletBalance * percent);
  }

  void _onContinue() {
    final amount = double.tryParse(_amountController.text.replaceAll(",", "")) ?? 0;
    if (amount <= 0) {
      AppOverlays.showToast(
        context: context,
        title: "Invalid Amount",
        message: "Please enter a transfer amount greater than ₦0.00",
        toastType: ToastificationType.error,
      );
      return;
    }
    if (amount > _walletBalance) {
      AppOverlays.showToast(
        context: context,
        title: "Insufficient Balance",
        message: "You cannot transfer more than your available balance ₦2,000,000.00",
        toastType: ToastificationType.error,
      );
      return;
    }

    final isZengly = widget.isZenglyTransfer;
    final recipientName = isZengly ? _resolvedFullName : _resolvedAccountName;
    final recipientAccount = isZengly ? _selectedUsername : _accountNumberController.text;
    final recipientBank = isZengly ? "Zengly Wallet" : (_selectedBank?.bankName ?? "Interbank");

    if (recipientName.isEmpty || recipientAccount.isEmpty) {
      AppOverlays.showToast(
        context: context,
        title: "Recipient Required",
        message: isZengly
            ? "Please enter or select a valid Zengly @username"
            : "Please enter and verify a 10-digit NUBAN account number",
        toastType: ToastificationType.warning,
      );
      return;
    }

    final fee = isZengly ? 0.0 : 10.0;
    final note = _noteController.text.trim().isEmpty ? "Funds Transfer" : _noteController.text.trim();

    final transferResult = TransferResult(
      recipientName: recipientName,
      recipientAccountNumber: recipientAccount,
      recipientBank: recipientBank,
      sourceBank: "Zengly Core Wallet",
      sourceAccountNumber: "028764637",
      amount: amount,
      note: note,
      fee: fee,
      date: DateTime.now(),
      transactionReference: "TRF${DateTime.now().millisecondsSinceEpoch}",
      providerReference: "PRV${DateTime.now().millisecondsSinceEpoch}",
    );

    context.pushNamed(
      AppRouter.confirmTransfer,
      extra: transferResult,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFFB57510);
    final cardBg = isDark ? const Color(0xFF221D16) : Colors.white;
    final cardBorder = isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE8E0D2);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF16130E) : const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 19,
            color: isDark ? Colors.white : const Color(0xFF1E1A14),
          ),
        ),
        title: Text(
          widget.isZenglyTransfer ? "Send to Zengly User" : "Transfer to Other Bank",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: isDark ? Colors.white : const Color(0xFF1E1A14),
          ),
        ),
        actions: [
          // Balance pill
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF262017) : const Color(0xFFF0EBE0),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Balance: ",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
                Text(
                  "₦2,000,000.00",
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instant Settlement / Zero Fee Promo Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.isZenglyTransfer
                      ? [const Color(0xFF382709), const Color(0xFF211B12)]
                      : (isDark
                          ? [const Color(0xFF282117), const Color(0xFF1C1812)]
                          : [const Color(0xFFFBF4E8), const Color(0xFFF3EADE)]),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.isZenglyTransfer ? Icons.bolt_rounded : Icons.lock_outline_rounded,
                      color: primaryColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isZenglyTransfer ? "Instant & 100% Free Transfer" : "Bank-Grade Secure Interbank Settlement",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF1E1A14),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.isZenglyTransfer
                              ? "Transfers to any Zengly @username settle in seconds with zero charges."
                              : "Instant NIP credit to all 50+ Nigerian commercial & microfinance banks.",
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Recipient Section
            if (widget.isZenglyTransfer) ...[
              // Zengly Username Input
              Text(
                "Recipient Zengly @Username",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : const Color(0xFF5A4D3B),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cardBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "@",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _usernameController,
                        onChanged: _onUsernameChanged,
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter username (e.g. tiwasavage)",
                          hintStyle: GoogleFonts.inter(
                            fontSize: 13.5,
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    if (_isZenglyUserResolved)
                      const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
                  ],
                ),
              ),

              // Resolved User Card
              if (_isZenglyUserResolved) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.12 : 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: primaryColor,
                        child: Text(
                          _resolvedFullName.isNotEmpty ? _resolvedFullName[0] : "Z",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _resolvedFullName,
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                              ),
                            ),
                            Text(
                              "$_selectedUsername • Verified Zengly Account",
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                color: const Color(0xFF10B981),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 14),

              // Ballers Suggestion Chips
              Text(
                "Quick Stars & Ballers:",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _suggestedZenglyUsers.map((user) {
                  final isSelected = _selectedUsername == user["username"];
                  return InkWell(
                    onTap: () => _onSelectSuggestedUser(user),
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primaryColor
                            : (isDark ? const Color(0xFF262017) : const Color(0xFFEDE5D8)),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: isSelected ? primaryColor : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        user["username"]!,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ] else ...[
              // Bank Transfer: Bank Selector Card
              Text(
                "Destination Bank & Account Details",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : const Color(0xFF5A4D3B),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickBank,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedBank != null
                          ? (_selectedBank!.brandColor ?? primaryColor).withValues(alpha: 0.3)
                          : cardBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (_selectedBank?.brandColor ?? primaryColor).withValues(alpha: 0.15),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.account_balance_rounded,
                            size: 20,
                            color: _selectedBank?.brandColor ?? primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Destination Bank",
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: isDark ? Colors.white38 : Colors.black45,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _selectedBank?.bankName ?? "Tap to choose bank",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Account Number Input Box with Live Verification & Paste Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isAccountResolved
                        ? const Color(0xFF2ED573).withValues(alpha: 0.6)
                        : cardBorder,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "10-Digit Recipient Account Number",
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark ? Colors.white38 : Colors.black45,
                            ),
                          ),
                          TextField(
                            controller: _accountNumberController,
                            onChanged: _onAccountNumberChanged,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.0,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 4),
                              hintText: "e.g. 0428658653",
                              hintStyle: GoogleFonts.inter(
                                fontSize: 15,
                                letterSpacing: 1.0,
                                color: isDark ? Colors.white24 : Colors.black26,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_isValidatingAccount)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFE5A93C),
                        ),
                      )
                    else if (_isAccountResolved)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF2ED573),
                        size: 22,
                      )
                    else
                      GestureDetector(
                        onTap: _pasteAccountNumber,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2E2619)
                                : const Color(0xFFF3ECE0),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFE5A93C).withValues(alpha: 0.3),
                            ),
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

              // If 10 digits entered without bank selected
              if (_accountNumberController.text.length == 10 && _selectedBank == null) ...[
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickBank,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5A93C).withValues(alpha: isDark ? 0.12 : 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE5A93C).withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, color: Color(0xFFE5A93C), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Please tap to select destination bank to verify account owner.",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          "SELECT",
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFE5A93C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // Loading NIP Indicator Card
              if (_isValidatingAccount) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1C18) : const Color(0xFFF5EFE6),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFE5DECE)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFE5A93C)),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Querying NIP name inquiry switch...",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Dynamic Verified Account Owner Card
              if (_isAccountResolved && _resolvedAccountName.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2ED573).withValues(alpha: isDark ? 0.12 : 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF2ED573).withValues(alpha: 0.35)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2ED573).withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.verified_rounded, color: Color(0xFF2ED573), size: 22),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "VERIFIED ACCOUNT OWNER",
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                    color: const Color(0xFF2ED573),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2ED573).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "NIP VERIFIED",
                                    style: GoogleFonts.inter(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF2ED573),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _resolvedAccountName,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF1E1A14),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${_selectedBank?.bankName ?? 'Bank'} • ${_accountNumberController.text}",
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white60 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 14),

              // Saved Beneficiaries Quick Tray
              Text(
                "Saved Beneficiaries:",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _savedBeneficiaries.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, idx) {
                    final b = _savedBeneficiaries[idx];
                    return InkWell(
                      onTap: () => _selectBeneficiary(b),
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF262017) : const Color(0xFFEDE5D8),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: cardBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.person_outline_rounded, size: 14, color: primaryColor),
                            const SizedBox(width: 6),
                            Text(
                              b["name"]!,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Amount Section
            Text(
              "Transfer Amount",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : const Color(0xFF5A4D3B),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "₦",
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            final cleaned = val.replaceAll(",", "");
                            final parsed = double.tryParse(cleaned) ?? 0;
                            setState(() => _enteredAmount = parsed);
                          },
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: "0.00",
                            hintStyle: GoogleFonts.inter(
                              fontSize: 26,
                              color: isDark ? Colors.white24 : Colors.black26,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Quick Amount Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _QuickAmountChip(label: "+₦1k", onTap: () => _setAmount(_enteredAmount + 1000)),
                      _QuickAmountChip(label: "+₦5k", onTap: () => _setAmount(_enteredAmount + 5000)),
                      _QuickAmountChip(label: "+₦10k", onTap: () => _setAmount(_enteredAmount + 10000)),
                      _QuickAmountChip(label: "+₦50k", onTap: () => _setAmount(_enteredAmount + 50000)),
                      _QuickAmountChip(label: "25%", onTap: () => _setPercentage(0.25)),
                      _QuickAmountChip(label: "50%", onTap: () => _setPercentage(0.50)),
                      _QuickAmountChip(label: "Max", onTap: () => _setPercentage(1.0)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Narration / Note
            Text(
              "Remark / Note (Optional)",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : const Color(0xFF5A4D3B),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cardBorder),
              ),
              child: TextField(
                controller: _noteController,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: "What's this transfer for? (e.g. Weekend lunch treat)",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13.5,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Cost Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1A14) : const Color(0xFFF3ECE0),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white10 : const Color(0xFFE2D6C5),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Transfer Amount",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      Text(
                        "₦${NumberFormat("#,##0.00").format(_enteredAmount)}",
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Transaction Fee",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      Text(
                        widget.isZenglyTransfer ? "FREE (₦0.00)" : "₦10.00",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: widget.isZenglyTransfer ? const Color(0xFF10B981) : primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Debit",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        "₦${NumberFormat("#,##0.00").format(_enteredAmount + (widget.isZenglyTransfer ? 0 : 10))}",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Continue CTA Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Continue to Confirm",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAmountChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickAmountChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C241B) : const Color(0xFFF3ECE0),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFB57510).withValues(alpha: 0.25),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFB57510),
          ),
        ),
      ),
    );
  }
}
