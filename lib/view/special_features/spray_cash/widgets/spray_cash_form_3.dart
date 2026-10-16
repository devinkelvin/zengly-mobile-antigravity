import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../../../../view/view.dart';
import '../../../../widgets/widgets.dart';

class SprayCashForm3 extends ConsumerStatefulWidget {
  const SprayCashForm3({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SprayCashForm3State();
}

class _SprayCashForm3State extends ConsumerState<SprayCashForm3> {
  final _accountNumberController = TextEditingController();
  BankAccountOption? _selectedBank;
  bool _isResolvingAccount = false;
  bool _isAccountVerified = false;
  String _resolvedAccountName = "";

  @override
  void initState() {
    super.initState();
    // Default to GTBank for quick start
    _selectedBank = SelectBankSheet.allBanks.firstWhere(
      (b) => b.bankName.contains("GTBank"),
      orElse: () => SelectBankSheet.allBanks.first,
    );
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickBank() async {
    final result = await AppOverlays.selectBankSheet(context: context);
    if (result != null) {
      setState(() {
        _selectedBank = result;
      });
      final clean = _accountNumberController.text.replaceAll(RegExp(r'\D'), '');
      if (clean.length == 10) {
        _resolveAccountName(clean);
      }
    }
  }

  void _onAccountNumberChanged(String val) {
    final clean = val.replaceAll(RegExp(r'\D'), '');
    if (clean.length == 10) {
      _resolveAccountName(clean);
    } else {
      setState(() {
        _isResolvingAccount = false;
        _isAccountVerified = false;
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

  Future<void> _resolveAccountName(String nuban) async {
    if (_selectedBank == null) {
      setState(() {
        _isResolvingAccount = false;
        _isAccountVerified = false;
        _resolvedAccountName = "";
      });
      return;
    }

    setState(() {
      _isResolvingAccount = true;
      _isAccountVerified = false;
      _resolvedAccountName = "";
    });

    await Future.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;

    String resolvedName;
    if (nuban.startsWith("042") || nuban.startsWith("567")) {
      resolvedName = "ABILITY ELIJAH OLUWAPELUMI";
    } else if (nuban.startsWith("069") || nuban.startsWith("101")) {
      resolvedName = "TIWA SAVAGE ENTERTAINMENT";
    } else if (nuban.startsWith("208") || nuban.startsWith("305")) {
      resolvedName = "DAVID ADELEKE MUSIC";
    } else if (nuban.startsWith("200") || nuban.startsWith("803")) {
      resolvedName = "BURNA BOY GLOBAL LLC";
    } else {
      resolvedName = "KELVIN EKUHOHO ENTERPRISE";
    }

    setState(() {
      _isResolvingAccount = false;
      _isAccountVerified = true;
      _resolvedAccountName = resolvedName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final cardBg = isDark ? const Color(0xFF1E1C18) : const Color(0xFFF9F5EC);
    final cardBorder = isDark ? Colors.white12 : const Color(0xFFE5DECE);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          "Recipient Destination Bank & Account",
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : const Color(0xFF5A4D3B),
          ),
        ),
        const SizedBox(height: 8),

        // Destination Bank Selector Card
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
                    ? (_selectedBank!.brandColor ?? primaryColor).withValues(alpha: 0.35)
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
        const SizedBox(height: 12),

        // 10-Digit NUBAN Account Number Input Box with Paste Button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isAccountVerified
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
              if (_isResolvingAccount)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFFE5A93C),
                  ),
                )
              else if (_isAccountVerified)
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

        // Dynamic Verified Account Card
        if (_isAccountVerified && _resolvedAccountName.isNotEmpty) ...[
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
                            "VERIFIED RECIPIENT",
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
        ] else if (_isResolvingAccount) ...[
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

        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(child: Divider()),
            const SizedBox(width: 10),
            Text(
              "OR",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        AlternativeOption(
          image: AppImages.search,
          isBluetooth: true,
          title: "Search Nearby Users",
          onPressed: () {
            context.pushNamed(AppRouter.sprayRadar);
          },
        ),
        const SizedBox(height: 12),
        AlternativeOption(
          image: AppImages.qrCode,
          isBluetooth: false,
          title: "Scan QR Code",
          onPressed: () {},
        ),
      ],
    );
  }
}
