import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../split_bill_vm.dart';

class AddSplitParticipantSheet extends StatefulWidget {
  final List<SplitParticipant> currentParticipants;
  final Function(SplitParticipant) onParticipantAdded;

  const AddSplitParticipantSheet({
    super.key,
    required this.currentParticipants,
    required this.onParticipantAdded,
  });

  static Future<void> show({
    required BuildContext context,
    required List<SplitParticipant> currentParticipants,
    required Function(SplitParticipant) onParticipantAdded,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16140F),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) => AddSplitParticipantSheet(
        currentParticipants: currentParticipants,
        onParticipantAdded: onParticipantAdded,
      ),
    );
  }

  @override
  State<AddSplitParticipantSheet> createState() => _AddSplitParticipantSheetState();
}

class _AddSplitParticipantSheetState extends State<AddSplitParticipantSheet> {
  int _selectedTab = 0; // 0: Saved Contacts with Accounts, 1: Account Number, 2: @Usertag / Username

  // Search in contacts
  final _searchController = TextEditingController();
  String _contactSearchQuery = "";

  // Bank Account Input Mode
  final _accountNumberController = TextEditingController();
  String _selectedBankName = "Guaranty Trust Bank (GTBank)";
  Color _selectedBankColor = const Color(0xFFE55300);
  bool _isResolvingAccount = false;
  String _resolvedAccountName = "";
  bool _isAccountVerified = false;

  // Usertag Input Mode
  final _usertagController = TextEditingController();
  final _fullNameController = TextEditingController();
  bool _isTagResolved = false;

  // Existing Contacts with Saved Bank Accounts
  final List<Map<String, String>> _contactsWithAccounts = [
    {
      "name": "Fola Adeola",
      "username": "@fola_a",
      "phone": "+234 803 998 7766",
      "bank": "Access Bank",
      "account": "0691234567",
      "initial": "F",
      "color": "0xFF0984E3",
    },
    {
      "name": "Zainab Bello",
      "username": "@zainab_b",
      "phone": "+234 814 223 3445",
      "bank": "Zenith Bank",
      "account": "1012345678",
      "initial": "Z",
      "color": "0xFFFD79A8",
    },
    {
      "name": "Emeka Obi",
      "username": "@emeka_o",
      "phone": "+234 817 889 9001",
      "bank": "Kuda Microfinance Bank",
      "account": "2001234567",
      "initial": "E",
      "color": "0xFF00CEC9",
    },
    {
      "name": "Chioma Eze",
      "username": "@chioma_e",
      "phone": "+234 802 556 6778",
      "bank": "United Bank for Africa (UBA)",
      "account": "2087654321",
      "initial": "C",
      "color": "0xFFE84393",
    },
    {
      "name": "Dayo Adeleke",
      "username": "@dayo_ad",
      "phone": "+234 805 112 2334",
      "bank": "Guaranty Trust Bank (GTBank)",
      "account": "0428658653",
      "initial": "D",
      "color": "0xFFE17055",
    },
    {
      "name": "Somi Balogun",
      "username": "@somi_b",
      "phone": "+234 808 333 4455",
      "bank": "First Bank of Nigeria",
      "account": "3051234567",
      "initial": "S",
      "color": "0xFF6C5CE7",
    },
    {
      "name": "Korede Bello",
      "username": "@korede",
      "phone": "+234 807 445 6677",
      "bank": "OPay Digital Services",
      "account": "8031234567",
      "initial": "K",
      "color": "0xFFE5A93C",
    },
    {
      "name": "Amara Williams",
      "username": "@amara",
      "phone": "+234 813 456 7890",
      "bank": "Moniepoint MFB",
      "account": "5051234567",
      "initial": "A",
      "color": "0xFF6C5CE7",
    },
    {
      "name": "Tunde Bakare",
      "username": "@tundeb",
      "phone": "+234 809 112 3344",
      "bank": "PalmPay",
      "account": "9021234567",
      "initial": "T",
      "color": "0xFF00B894",
    },
  ];

  // List of banks for account number mode
  final List<Map<String, dynamic>> _banksList = [
    {"name": "Guaranty Trust Bank (GTBank)", "code": "058", "color": Color(0xFFE55300)},
    {"name": "Access Bank", "code": "044", "color": Color(0xFF003B70)},
    {"name": "Zenith Bank", "code": "057", "color": Color(0xFFD32F2F)},
    {"name": "United Bank for Africa (UBA)", "code": "033", "color": Color(0xFFC62828)},
    {"name": "First Bank of Nigeria", "code": "011", "color": Color(0xFF0D47A1)},
    {"name": "Kuda Microfinance Bank", "code": "50211", "color": Color(0xFF49127E)},
    {"name": "OPay Digital Services", "code": "999992", "color": Color(0xFF00B074)},
    {"name": "PalmPay", "code": "999991", "color": Color(0xFF5F00B8)},
    {"name": "Moniepoint Microfinance Bank", "code": "50515", "color": Color(0xFF003366)},
    {"name": "Stanbic IBTC Bank", "code": "039", "color": Color(0xFF0056B3)},
    {"name": "Fidelity Bank", "code": "070", "color": Color(0xFF003A70)},
    {"name": "FCMB", "code": "214", "color": Color(0xFF5C068C)},
    {"name": "Wema Bank (ALAT)", "code": "035", "color": Color(0xFF990033)},
  ];

  // Quick Usertag ballers
  final List<Map<String, String>> _quickUsertags = [
    {"name": "Fola Adeola", "tag": "@fola_a"},
    {"name": "Zainab Bello", "tag": "@zainab_b"},
    {"name": "Emeka Obi", "tag": "@emeka_o"},
    {"name": "Chioma Eze", "tag": "@chioma_e"},
    {"name": "David Adeleke", "tag": "@davido"},
    {"name": "Damini Ogulu", "tag": "@burna"},
    {"name": "Tiwa Savage", "tag": "@tiwasavage"},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _accountNumberController.dispose();
    _usertagController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void _onAccountNumberChanged(String val) {
    final clean = val.trim();
    if (clean.length == 10) {
      _resolveAccount(clean, _selectedBankName);
    } else {
      setState(() {
        _isAccountVerified = false;
        _resolvedAccountName = "";
      });
    }
  }

  Future<void> _resolveAccount(String account, String bank) async {
    setState(() {
      _isResolvingAccount = true;
      _isAccountVerified = false;
      _resolvedAccountName = "";
    });

    await Future.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;

    String resolved = "";
    if (account.startsWith("042") || account.startsWith("567")) {
      resolved = "Adeola Fola";
    } else if (account.startsWith("069") || account.startsWith("101")) {
      resolved = "Bello Zainab";
    } else if (account.startsWith("200")) {
      resolved = "Obi Emeka";
    } else if (account.startsWith("803") || account.startsWith("902")) {
      resolved = "Eze Chioma";
    } else {
      resolved = "Balogun Somi";
    }

    setState(() {
      _isResolvingAccount = false;
      _isAccountVerified = true;
      _resolvedAccountName = resolved;
    });
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

  void _onUsertagChanged(String val) {
    final clean = val.trim();
    final tag = clean.startsWith("@") ? clean : "@$clean";
    final match = _quickUsertags.firstWhere(
      (u) => u["tag"]!.toLowerCase() == tag.toLowerCase(),
      orElse: () => {},
    );

    if (match.isNotEmpty) {
      setState(() {
        _fullNameController.text = match["name"]!;
        _isTagResolved = true;
      });
    } else if (clean.length >= 3) {
      setState(() {
        _isTagResolved = true;
      });
    } else {
      setState(() {
        _isTagResolved = false;
      });
    }
  }

  void _openBankPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16140F),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        String q = "";
        return StatefulBuilder(
          builder: (context, setPickerState) {
            final filtered = _banksList.where((b) {
              return (b["name"] as String).toLowerCase().contains(q.toLowerCase());
            }).toList();

            return Container(
              padding: EdgeInsets.only(
                top: 16,
                left: 18,
                right: 18,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(height: 14),
                  Text("Select Participant Bank", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 12),
                  // Search
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFF221F18), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white10)),
                    child: Row(
                      children: [
                        const Icon(Icons.search, size: 18, color: Colors.white54),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (val) => setPickerState(() => q = val),
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                            decoration: const InputDecoration(hintText: "Search bank...", hintStyle: TextStyle(color: Colors.white38), border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 1),
                      itemBuilder: (context, i) {
                        final b = filtered[i];
                        final isSel = b["name"] == _selectedBankName;
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          leading: Icon(Icons.account_balance_rounded, color: b["color"] as Color, size: 20),
                          title: Text(b["name"] as String, style: GoogleFonts.inter(fontSize: 13.5, color: isSel ? const Color(0xFFE5A93C) : Colors.white, fontWeight: isSel ? FontWeight.w700 : FontWeight.w500)),
                          trailing: isSel ? const Icon(Icons.check_circle_rounded, color: Color(0xFFE5A93C), size: 18) : null,
                          onTap: () {
                            Navigator.pop(ctx);
                            setState(() {
                              _selectedBankName = b["name"] as String;
                              _selectedBankColor = b["color"] as Color;
                            });
                            if (_accountNumberController.text.length == 10) {
                              _resolveAccount(_accountNumberController.text, _selectedBankName);
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

  void _submitViaContact(Map<String, String> c) {
    final participant = SplitParticipant(
      id: "p_${DateTime.now().millisecondsSinceEpoch}_${c["account"]}",
      name: c["name"]!,
      username: c["username"]!,
      phone: c["phone"]!,
      bankName: c["bank"]!,
      accountNumber: c["account"]!,
      avatarInitial: c["initial"]!,
      avatarColor: Color(int.parse(c["color"]!)),
      amount: 0.0,
      status: ParticipantSplitStatus.pending,
    );

    widget.onParticipantAdded(participant);
    Navigator.pop(context);
  }

  void _submitViaAccountNumber() {
    if (_accountNumberController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 10-digit account number")),
      );
      return;
    }

    final name = _resolvedAccountName.isNotEmpty ? _resolvedAccountName : "Participant (${_accountNumberController.text.substring(6)})";
    final participant = SplitParticipant(
      id: "p_${DateTime.now().millisecondsSinceEpoch}",
      name: name,
      username: "@${name.toLowerCase().replaceAll(' ', '_')}",
      bankName: _selectedBankName,
      accountNumber: _accountNumberController.text.trim(),
      avatarInitial: name[0].toUpperCase(),
      avatarColor: _selectedBankColor,
      amount: 0.0,
      status: ParticipantSplitStatus.pending,
    );

    widget.onParticipantAdded(participant);
    Navigator.pop(context);
  }

  void _submitViaUsertag() {
    final rawTag = _usertagController.text.trim();
    if (rawTag.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please input a valid username or usertag")),
      );
      return;
    }

    final tag = rawTag.startsWith("@") ? rawTag : "@$rawTag";
    final name = _fullNameController.text.trim().isNotEmpty
        ? _fullNameController.text.trim()
        : tag.substring(1);

    final participant = SplitParticipant(
      id: "p_${DateTime.now().millisecondsSinceEpoch}",
      name: name,
      username: tag,
      avatarInitial: name[0].toUpperCase(),
      avatarColor: const Color(0xFF6C5CE7),
      amount: 0.0,
      status: ParticipantSplitStatus.pending,
    );

    widget.onParticipantAdded(participant);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 18,
        right: 18,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
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

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Add Participant to Split",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  child: const Icon(Icons.close_rounded, size: 16, color: Colors.white70),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Search existing contacts with saved accounts, or input account number/usertag directly.",
            style: GoogleFonts.inter(fontSize: 12, color: Colors.white54),
          ),
          const SizedBox(height: 16),

          // 3 Method Selector Tabs
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1D19),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                _buildMethodTab(0, "Saved Contacts", Icons.contacts_rounded),
                _buildMethodTab(1, "Account Number", Icons.account_balance_rounded),
                _buildMethodTab(2, "@Usertag", Icons.alternate_email_rounded),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // TAB 0: Contacts with Saved Accounts
          if (_selectedTab == 0) ...[
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF221F18),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white54, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _contactSearchQuery = val),
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 13.5),
                      decoration: const InputDecoration(
                        hintText: "Search by name, @usertag, phone or account...",
                        hintStyle: TextStyle(color: Colors.white38, fontSize: 12.5),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Contacts List
            Expanded(
              child: _buildContactsList(),
            ),
          ]

          // TAB 1: Account Number & Bank Input
          else if (_selectedTab == 1) ...[
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Destination Bank",
                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),

                    // Bank Selector
                    InkWell(
                      onTap: _openBankPicker,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF221F18),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.account_balance_rounded, size: 18, color: _selectedBankColor),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _selectedBankName,
                                style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w600, color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white54),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      "10-Digit NUBAN Account Number",
                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),

                    // Account Number Input
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF221F18),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _isAccountVerified ? const Color(0xFF2ED573) : Colors.white12,
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
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                hintText: "0123456789",
                                hintStyle: TextStyle(color: Colors.white24, letterSpacing: 1.2),
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
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(6)),
                                child: Text("PASTE", style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w700, color: const Color(0xFFE5A93C))),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Resolved Account Name Card
                    if (_isAccountVerified && _resolvedAccountName.isNotEmpty) ...[
                      const SizedBox(height: 10),
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
                                    style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700, color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "Verified Account • $_selectedBankName",
                                    style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF2ED573)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isAccountVerified ? const Color(0xFFE5A93C) : Colors.white12,
                          foregroundColor: _isAccountVerified ? Colors.black : Colors.white38,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        onPressed: _isAccountVerified ? _submitViaAccountNumber : null,
                        child: Text(
                          "Add Participant via Bank Account",
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]

          // TAB 2: @Usertags or Username Input
          else ...[
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Zengly @Usertag or Username",
                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),

                    // Usertag Field
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF221F18),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _isTagResolved ? const Color(0xFF2ED573) : Colors.white12,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5A93C).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "@",
                              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFFE5A93C)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _usertagController,
                              style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w600, color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: "e.g. fola_a, burnaboy, amara",
                                hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
                                border: InputBorder.none,
                              ),
                              onChanged: _onUsertagChanged,
                            ),
                          ),
                          if (_isTagResolved)
                            const Icon(Icons.check_circle_rounded, color: Color(0xFF2ED573), size: 18),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Optional Full Name override
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF221F18),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: TextField(
                        controller: _fullNameController,
                        style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: "Display Name (Optional)",
                          labelStyle: TextStyle(color: Colors.white54, fontSize: 12),
                          hintText: "e.g. Fola Adeola",
                          hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Quick Usertags chips
                    Text(
                      "Popular Zengly Ballers:",
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _quickUsertags.map((u) {
                        return InkWell(
                          onTap: () {
                            _usertagController.text = u["tag"]!.replaceFirst("@", "");
                            _fullNameController.text = u["name"]!;
                            setState(() => _isTagResolved = true);
                          },
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF252119),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Text(
                              u["tag"]!,
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFFE5A93C)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isTagResolved ? const Color(0xFFE5A93C) : Colors.white12,
                          foregroundColor: _isTagResolved ? Colors.black : Colors.white38,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        onPressed: _isTagResolved ? _submitViaUsertag : null,
                        child: Text(
                          "Add Participant via Usertag",
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMethodTab(int index, String label, IconData icon) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE5A93C) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 13, color: isSelected ? Colors.black : Colors.white70),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? Colors.black : Colors.white70,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactsList() {
    final filtered = _contactsWithAccounts.where((c) {
      final q = _contactSearchQuery.toLowerCase();
      final name = c["name"]!.toLowerCase();
      final tag = c["username"]!.toLowerCase();
      final bank = c["bank"]!.toLowerCase();
      final account = c["account"]!;
      return name.contains(q) || tag.contains(q) || bank.contains(q) || account.contains(q);
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, color: Colors.white24, size: 36),
            const SizedBox(height: 8),
            Text(
              "No contacts found matching '$_contactSearchQuery'",
              style: GoogleFonts.inter(fontSize: 13, color: Colors.white54),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final c = filtered[index];
        final alreadyAdded = widget.currentParticipants.any(
          (p) => p.username == c["username"] || (p.accountNumber != null && p.accountNumber == c["account"]),
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1D19),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: alreadyAdded ? const Color(0xFF2ED573).withValues(alpha: 0.3) : Colors.white10,
            ),
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(int.parse(c["color"]!)),
                ),
                alignment: Alignment.center,
                child: Text(
                  c["initial"]!,
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),

              // Name, Tag & Bank Account
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            c["name"]!,
                            style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700, color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            c["username"]!,
                            style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFFE5A93C), fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.account_balance_rounded, size: 12, color: Colors.white38),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "${c["bank"]} • ${c["account"]}",
                            style: GoogleFonts.inter(fontSize: 11.5, color: Colors.white60),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Add / Added status
              if (alreadyAdded)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2ED573).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check, size: 12, color: Color(0xFF2ED573)),
                      const SizedBox(width: 4),
                      Text("Added", style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF2ED573))),
                    ],
                  ),
                )
              else
                InkWell(
                  onTap: () => _submitViaContact(c),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5A93C),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "+ Add",
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
