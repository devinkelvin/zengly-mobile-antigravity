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
  String? _selectedRecipient = "@tiwa_savage";
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

  void _showNfcRadarSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1813) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: isDark ? Colors.white10 : const Color(0xFFE5DECE),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black26,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFB57510).withValues(alpha: 0.15),
                border: Border.all(
                  color: const Color(0xFFB57510),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.nfc_rounded,
                size: 38,
                color: Color(0xFFB57510),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "NFC Radar Scanning",
              style: GoogleFonts.raleway(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1E1A14),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Hold your phone near the recipient's phone or Vaniti band",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF262017) : const Color(0xFFF9F5EC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFB57510).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(AppImages.queenie),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tiwa Savage (VIP Host)",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: isDark ? Colors.white : const Color(0xFF1E1A14),
                          ),
                        ),
                        Text(
                          "@tiwa_savage • Signal: Strong (0.5m)",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFFB57510),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _selectedRecipient = "@tiwa_savage";
                        _selectedSendMethod = "nfc";
                      });
                      AppOverlays.showToast(
                        context: context,
                        title: "NFC Target Paired",
                        message: "Connected to @tiwa_savage",
                        toastType: ToastificationType.success,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB57510),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Connect", style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactsPickerSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allContacts = [
      {"name": "Kunle Afolayan", "handle": "@kunle_a", "avatar": AppImages.kunle},
      {"name": "Teni Apata", "handle": "@tenientertainer", "avatar": AppImages.queenie},
      {"name": "Burna Boy", "handle": "@burna_live", "avatar": AppImages.bella},
      {"name": "Simi Kosoko", "handle": "@symplysimi", "avatar": AppImages.dummyPerson},
      {"name": "Wizkid Balogun", "handle": "@wizkidayo", "avatar": AppImages.kunle},
      {"name": "Davido Adeleke", "handle": "@davido", "avatar": AppImages.queenie},
      {"name": "Tiwa Savage", "handle": "@tiwasavage", "avatar": AppImages.bella},
      {"name": "Odumodu Blvck", "handle": "@odumodublvck", "avatar": AppImages.dummyPerson},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        String query = "";
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final filtered = allContacts.where((c) {
              final q = query.toLowerCase().trim();
              if (q.isEmpty) return true;
              return c["name"]!.toLowerCase().contains(q) ||
                  c["handle"]!.toLowerCase().contains(q);
            }).toList();

            return Container(
              height: MediaQuery.of(ctx).size.height * 0.72,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 14,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1C1813) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(
                  color: isDark ? Colors.white10 : const Color(0xFFE5DECE),
                ),
              ),
              child: Column(
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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Contact",
                        style: GoogleFonts.raleway(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF1E1A14),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB57510).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          "${filtered.length} Contacts",
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFB57510),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF262017) : const Color(0xFFF4ECE1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? Colors.white12 : const Color(0xFFDFD4C4),
                      ),
                    ),
                    child: TextField(
                      autofocus: false,
                      onChanged: (val) {
                        setSheetState(() => query = val);
                      },
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search name or @handle...",
                        hintStyle: GoogleFonts.inter(
                          fontSize: 13,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: isDark ? Colors.white60 : Colors.black45,
                        ),
                        suffixIcon: query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close_rounded, size: 18),
                                onPressed: () {
                                  setSheetState(() => query = "");
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Contacts List
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 48,
                                  color: isDark ? Colors.white24 : Colors.black26,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "No contacts found for \"$query\"",
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: isDark ? Colors.white54 : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => Divider(
                              height: 1,
                              thickness: 0.6,
                              indent: 56,
                              color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                            ),
                            itemBuilder: (context, idx) {
                              final c = filtered[idx];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 4,
                                ),
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(c["avatar"]!),
                                ),
                                title: Text(
                                  c["name"]!,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: isDark ? Colors.white : const Color(0xFF1E1A14),
                                  ),
                                ),
                                subtitle: Text(
                                  c["handle"]!,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: isDark ? Colors.white60 : Colors.black54,
                                  ),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF2C2419) : const Color(0xFFEDE4D5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 12,
                                    color: Color(0xFFB57510),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(ctx);
                                  setState(() {
                                    _selectedRecipient = c["handle"];
                                    _selectedSendMethod = "contacts";
                                  });
                                  AppOverlays.showToast(
                                    context: context,
                                    title: "Recipient Set",
                                    message: "Ready to spray ${c['name']} (${c['handle']})",
                                    toastType: ToastificationType.success,
                                  );
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

  void _showUsernameLookupSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = TextEditingController(text: _selectedRecipient ?? "");
    final suggestions = ["@davido", "@wizkidayo", "@burnaboy", "@asakemusic", "@tiwasavage"];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1813) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: isDark ? Colors.white10 : const Color(0xFFE5DECE),
            ),
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
                    color: isDark ? Colors.white24 : Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Enter Zengly @Username",
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1E1A14),
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF262017) : const Color(0xFFF9F5EC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFB57510).withValues(alpha: 0.3),
                  ),
                ),
                child: TextField(
                  controller: controller,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "e.g. @asakemusic",
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Suggested Stars & Ballers:",
                style: GoogleFonts.inter(fontSize: 12, color: isDark ? Colors.white54 : Colors.black54),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: suggestions.map((s) => InkWell(
                  onTap: () {
                    controller.text = s;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF28231A) : const Color(0xFFF0EBE0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      s,
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFFB57510)),
                    ),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final target = controller.text.trim();
                    if (target.isNotEmpty) {
                      Navigator.pop(ctx);
                      setState(() {
                        _selectedRecipient = target.startsWith("@") ? target : "@$target";
                        _selectedSendMethod = "username";
                      });
                      AppOverlays.showToast(
                        context: context,
                        title: "Target Confirmed",
                        message: "Selected $_selectedRecipient",
                        toastType: ToastificationType.success,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB57510),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Confirm Recipient", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onStartSpray() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SprayConfirmationScreen(
          initialItem: _selectedSprayItem,
          initialRecipient: _selectedRecipient ?? "@tiwa_savage",
          initialAutoSpray: _isAutoSprayMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF181511) : const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        title: Text(
          "Vaniti",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        actions: const [
          BalanceWidget(),
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
                color: isDark ? const Color(0xFF262017) : const Color(0xFFEBE4D8),
                borderRadius: BorderRadius.circular(100),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: isDark ? const Color(0xFF382E20) : Colors.white,
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
    final cardBg = isDark ? const Color(0xFF241F18) : Colors.white;
    final cardBorder = isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE5DEC8);

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
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : const Color(0xFF6B5E4A),
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
                    setState(() => _selectedRecipient = result);
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
                onTap: _showNfcRadarSheet,
              ),
              const SizedBox(width: 10),
              _buildSendOption(
                id: "contacts",
                label: "Contacts",
                icon: Icons.people_outline,
                isDark: isDark,
                onTap: _showContactsPickerSheet,
              ),
              const SizedBox(width: 10),
              _buildSendOption(
                id: "username",
                label: "Username",
                icon: Icons.alternate_email,
                isDark: isDark,
                onTap: _showUsernameLookupSheet,
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Selected Recipient Status Card
          if (_selectedRecipient != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF262017) : const Color(0xFFF9F5EC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFB57510).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFB57510),
                    ),
                    child: const Icon(Icons.person_rounded, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Target Recipient",
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white60 : Colors.black54,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.verified, size: 13, color: Color(0xFFB57510)),
                          ],
                        ),
                        Text(
                          _selectedRecipient!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF1E1A14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _showUsernameLookupSheet,
                    child: Text(
                      "Change",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB57510),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),

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
