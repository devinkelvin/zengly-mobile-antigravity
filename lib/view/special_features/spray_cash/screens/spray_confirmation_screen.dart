import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../data/data.dart';
import '../../../../widgets/widgets.dart';
import '../../../view.dart';
import '../../widgets/leaderboard_podium.dart';
import '../../widgets/top_sprayers_section.dart';

class SprayConfirmationScreen extends ConsumerStatefulWidget {
  final SprayItem? initialItem;
  final String? initialRecipient;
  final bool? initialAutoSpray;

  const SprayConfirmationScreen({
    super.key,
    this.initialItem,
    this.initialRecipient,
    this.initialAutoSpray,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SprayConfirmationScreenState();
}

class _SprayConfirmationScreenState
    extends ConsumerState<SprayConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _noteController = TextEditingController(text: "Keep shining! 🔥");

  late SprayItem _selectedItem;
  late bool _isAutoSprayMode;
  late String _recipientName;
  final String _recipientAccount = "5673658653";
  final String _recipientBank = "GTBANK";

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialItem ??
        SprayItem.defaultItems.firstWhere(
          (i) => i.id == "bundle_50k",
          orElse: () => SprayItem.defaultItems.first,
        );
    _isAutoSprayMode = widget.initialAutoSpray ?? false;
    _recipientName = widget.initialRecipient ?? "@tiwasavage";
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onChangeItem() async {
    final chosen = await Navigator.of(context).push<SprayItem>(
      MaterialPageRoute(
        builder: (context) => SprayOptionsScreen(selectedItem: _selectedItem),
      ),
    );
    if (chosen != null && mounted) {
      setState(() {
        _selectedItem = chosen;
      });
      ref.read(sprayCashVm).updateAmount(
            chosen.amount > 0
                ? NumberFormat("#,##0").format(chosen.amount)
                : "50,000",
          );
    }
  }

  void _onStartSpray() async {
    final pin = await EnterTransactionPinScreen.show(context);
    if (pin == null || !mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AboutToSprayScreen(
          item: _selectedItem,
          recipient: _recipientName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 19,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        title: Text(
          "Confirmation",
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
    );
  }

  Widget _buildBallerMode(BuildContext context, bool isDark) {
    final cardBg = isDark ? const Color(0xFF211D16) : Colors.white;
    final cardBorder =
        isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE5DEC8);
    final totalAmount = _selectedItem.amount + 1000.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected Spray Item Card with enlarged clean asset
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Large transparent asset image
                Image.asset(
                  _selectedItem.image,
                  width: 74,
                  height: 74,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.wallet, size: 50, color: Color(0xFFC87D0E)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedItem.name,
                        style: GoogleFonts.inter(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedItem.amount > 0
                            ? "₦${NumberFormat("#,##0.00").format(_selectedItem.amount)}"
                            : _selectedItem.displayAmount,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFB57510),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _onChangeItem,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB57510).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "Change >",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB57510),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Recipient Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cardBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFB57510),
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _recipientName,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified,
                              size: 14, color: Color(0xFFB57510)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "$_recipientBank • $_recipientAccount",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B8A3E).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    "Verified",
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2B8A3E),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Personal Note Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                border: InputBorder.none,
                labelText: "Spray Note",
                labelStyle: GoogleFonts.inter(
                  fontSize: 12,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
                hintText: "Add a message...",
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Fee and Summary Breakdown Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cardBorder),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Spray Amount",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                    Text(
                      _selectedItem.amount > 0
                          ? "₦${NumberFormat("#,##0.00").format(_selectedItem.amount)}"
                          : _selectedItem.displayAmount,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
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
                      "Platform Service Fee",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                    Text(
                      "₦1,000.00",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(
                  color: isDark ? Colors.white10 : const Color(0xFFEDE4D4),
                ),
                const SizedBox(height: 6),
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
                      "₦${NumberFormat("#,##0.00").format(totalAmount)}",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFB57510),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Auto Spray Mode Toggle
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
          const SizedBox(height: 24),

          // Start Spray Action Button
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
                "Authorize & Start Spraying",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
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
                "Live Ranking",
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
