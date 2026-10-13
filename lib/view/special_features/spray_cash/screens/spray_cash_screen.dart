import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';
import '../../../dashboard/widgets/dashboard_bottom_bar.dart';
import '../../../view.dart';
import '../../widgets/leaderboard_podium.dart';
import '../../widgets/top_sprayers_section.dart';



class SprayCashScreen extends ConsumerStatefulWidget {
  const SprayCashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SprayCashScreenState();
}

class _SprayCashScreenState extends ConsumerState<SprayCashScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  SprayItem? _selectedSprayItem;
  String _selectedSendMethod = "qr";
  bool _isAutoSprayMode = false;

  @override
  void initState() {
    super.initState();
    ref.read(sprayCashVm).init();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onChooseCurrency() async {
    await SelectCurrencyBottomSheet.show(context);
  }

  void _onSelectSprayOption() async {
    final chosen = await Navigator.of(context).push<SprayItem>(
      MaterialPageRoute(
        builder: (context) => SprayOptionsScreen(selectedItem: _selectedSprayItem),
      ),
    );
    if (chosen != null && mounted) {
      setState(() {
        _selectedSprayItem = chosen;
      });
    }
  }

  void _onStartSpray() async {
    final pin = await EnterTransactionPinScreen.show(context);
    if (pin == null || !mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AboutToSprayScreen(
          item: _selectedSprayItem,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF161410) : const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        title: Text(
          "Vaniti",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF26211B) : const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Balance ",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
                Text(
                  "₦345,778.90",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Container(
              height: 44,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF26211B) : const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(100),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: isDark ? const Color(0xFF3D3327) : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: isDark ? Colors.white : Colors.black,
                unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
                labelStyle: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: "Baller mode"),
                  Tab(text: "Leaderboard"),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBallerMode(context, isDark),
                _buildLeaderboard(isDark),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const DashboardBottomBar(),
    );
  }

  Widget _buildBallerMode(BuildContext context, bool isDark) {
    final vm = ref.watch(sprayCashVm);
    final cardBg = isDark ? const Color(0xFF26211B) : Colors.white;
    final cardBorder = isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black12;

    final currencyLabel = vm.selectedCurrencyType != null
        ? "${vm.selectedCurrencyType!.name} (${vm.selectedCurrencyType!.symbol})"
        : "Choose Currency";

    final sprayOptionLabel = _selectedSprayItem != null
        ? "${_selectedSprayItem!.name} (${_selectedSprayItem!.displayAmount})"
        : "Select Spray Option";

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Choose Currency Dropdown Card
          GestureDetector(
            onTap: _onChooseCurrency,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cardBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      currencyLabel,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Select Spray Option Dropdown Card
          GestureDetector(
            onTap: _onSelectSprayOption,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cardBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      sprayOptionLabel,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Send to label
          Text(
            "Send to",
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          const SizedBox(height: 12),

          // 4 Action Buttons in a Row (Scan QR, NFC Tap, Contacts, Username)
          Row(
            children: [
              _buildSendOption(
                id: "qr",
                label: "Scan QR",
                icon: Icons.qr_code_scanner,
                isDark: isDark,
                onTap: () async {
                  setState(() => _selectedSendMethod = "qr");
                  final result = await context.push<String>(AppRouter.qrScanner);
                  if (result != null && mounted) {
                    _onStartSpray();
                  }
                },
              ),
              const SizedBox(width: 10),
              _buildSendOption(
                id: "nfc",
                label: "NFC Tap",
                icon: Icons.nfc,
                isDark: isDark,
                onTap: () => setState(() => _selectedSendMethod = "nfc"),
              ),
              const SizedBox(width: 10),
              _buildSendOption(
                id: "contacts",
                label: "Contacts",
                icon: Icons.people_outline,
                isDark: isDark,
                onTap: () => setState(() => _selectedSendMethod = "contacts"),
              ),
              const SizedBox(width: 10),
              _buildSendOption(
                id: "username",
                label: "Username",
                icon: Icons.alternate_email,
                isDark: isDark,
                onTap: () => setState(() => _selectedSendMethod = "username"),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Auto Spray Mode Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Auto Spray Mode  ",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: "Continuous animation until amount is spent",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Switch(
                value: _isAutoSprayMode,
                onChanged: (val) => setState(() => _isAutoSprayMode = val),
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFFB57510),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: isDark ? Colors.white24 : Colors.black12,
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Start Spray Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _onStartSpray,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB57510),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                "Start Spray",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSendOption({
    required String id,
    required String label,
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final isSelected = _selectedSendMethod == id;
    final cardBg = isDark ? const Color(0xFF26211B) : const Color(0xFFF1F3F5);
    final borderColor = isSelected ? const Color(0xFFC87D0E) : Colors.transparent;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Column(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF332717),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: const Color(0xFFC87D0E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboard(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LeaderboardPodium(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Top Sprayers",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Text(
                "28, Nov. 2025",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const TopSprayersSection(showHeader: false),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              onPressed: () {
                AppOverlays.showToast(
                  context: context,
                  title: "Notice",
                  message: "VIP Club is coming soon",
                  toastType: ToastificationType.custom(
                    "Notice",
                    Theme.of(context).colorScheme.primary,
                    Icons.warning_amber_outlined,
                  ),
                );
              },
              actionText: "Join the VIP Club",
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
