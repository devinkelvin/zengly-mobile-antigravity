import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../widgets/widgets.dart';
import 'ajo_group_details_screen.dart';
import 'ajo_models.dart';
import 'create_ajo_group_screen.dart';
import 'join_ajo_group_screen.dart';

class AjoLandingScreen extends StatefulWidget {
  const AjoLandingScreen({super.key});

  @override
  State<AjoLandingScreen> createState() => _AjoLandingScreenState();
}

class _AjoLandingScreenState extends State<AjoLandingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<AjoGroup> _myGroups = [
    AjoGroup(
      id: "ajo-1",
      name: "Family Wealth Circle",
      category: "Friends & Family",
      contributionAmount: 50000,
      frequency: "Monthly",
      totalMembers: 10,
      currentRound: 3,
      totalPool: 500000,
      nextPayoutDate: "Oct 25, 2026",
      myPosition: 4,
      isCreator: true,
      members: const [
        AjoMember(id: "1", name: "Uncle Remi", position: 1, status: MemberPaymentStatus.paidOut, payoutDate: "Aug 25, 2026"),
        AjoMember(id: "2", name: "Aunty Bisi", position: 2, status: MemberPaymentStatus.paidOut, payoutDate: "Sep 25, 2026"),
        AjoMember(id: "3", name: "Deji Adeleke", position: 3, status: MemberPaymentStatus.paid, payoutDate: "Oct 25, 2026"),
        AjoMember(id: "4", name: "You", position: 4, status: MemberPaymentStatus.pending, payoutDate: "Nov 25, 2026", isMe: true),
        AjoMember(id: "5", name: "Seyi Makinde", position: 5, status: MemberPaymentStatus.pending, payoutDate: "Dec 25, 2026"),
        AjoMember(id: "6", name: "Kemi Adeosun", position: 6, status: MemberPaymentStatus.pending, payoutDate: "Jan 25, 2027"),
        AjoMember(id: "7", name: "Fola Arthur", position: 7, status: MemberPaymentStatus.pending, payoutDate: "Feb 25, 2027"),
        AjoMember(id: "8", name: "Tunde Bakare", position: 8, status: MemberPaymentStatus.pending, payoutDate: "Mar 25, 2027"),
        AjoMember(id: "9", name: "Dapo Abiodun", position: 9, status: MemberPaymentStatus.pending, payoutDate: "Apr 25, 2027"),
        AjoMember(id: "10", name: "Wale Babalakin", position: 10, status: MemberPaymentStatus.pending, payoutDate: "May 25, 2027"),
      ],
    ),
    AjoGroup(
      id: "ajo-2",
      name: "Tech Hustlers Weekly",
      category: "Work Colleagues",
      contributionAmount: 25000,
      frequency: "Weekly",
      totalMembers: 5,
      currentRound: 2,
      totalPool: 125000,
      nextPayoutDate: "Oct 20, 2026",
      myPosition: 2,
      members: const [
        AjoMember(id: "1", name: "Emeka Chidi", position: 1, status: MemberPaymentStatus.paidOut, payoutDate: "Oct 13, 2026"),
        AjoMember(id: "2", name: "You", position: 2, status: MemberPaymentStatus.paid, payoutDate: "Oct 20, 2026", isMe: true),
        AjoMember(id: "3", name: "Zainab Bello", position: 3, status: MemberPaymentStatus.pending, payoutDate: "Oct 27, 2026"),
        AjoMember(id: "4", name: "Tobi Owo", position: 4, status: MemberPaymentStatus.pending, payoutDate: "Nov 03, 2026"),
        AjoMember(id: "5", name: "David Kalu", position: 5, status: MemberPaymentStatus.pending, payoutDate: "Nov 10, 2026"),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF757575);
    final currencyFormat = NumberFormat.currency(symbol: "₦", decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Ajo 2.0 Savings",
          style: GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 18, color: textPrimary),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline_rounded, color: textPrimary, size: 20),
            onPressed: () {
              AppOverlays.showToast(
                context: context,
                title: "How Ajo 2.0 Works",
                message: "Ajo 2.0 automates rotational savings. All contributions are held in secure escrow.",
                toastType: ToastificationType.info,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner: Rotating Collective Savings
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF382709), Color(0xFF221A0F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primaryColor.withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.groups_rounded, color: primaryColor, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Smart Rotational Thrift",
                        style: GoogleFonts.raleway(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Contribute fixed sums on a schedule and receive guaranteed lump-sum payouts when your turn arrives.",
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withValues(alpha: 0.8), height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const CreateAjoGroupScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text("Create Group", style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const JoinAjoGroupScreen()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text("Join with Code", style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tab Bar: My Circles vs Public Circles
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1A14) : const Color(0xFFF0EBE1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: textSecondary,
                labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                tabs: const [
                  Tab(text: "My Active Groups (2)"),
                  Tab(text: "Explore Circles"),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Active Groups List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _myGroups.length,
              separatorBuilder: (context, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final group = _myGroups[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => AjoGroupDetailsScreen(group: group)),
                    );
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1A14) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark ? const Color(0xFF2C241B) : const Color(0xFFEFE8DE),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              group.name,
                              style: GoogleFonts.raleway(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                "Round ${group.currentRound}/${group.totalMembers}",
                                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Cycle Pool", style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary)),
                            Text(
                              currencyFormat.format(group.totalPool),
                              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: textPrimary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Mini progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: group.currentRound / group.totalMembers,
                            minHeight: 5,
                            backgroundColor: isDark ? const Color(0xFF2C2419) : const Color(0xFFE2D6C5),
                            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Your Turn: #${group.myPosition} (${group.nextPayoutDate})",
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: primaryColor),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Details",
                                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary),
                                ),
                                Icon(Icons.chevron_right_rounded, size: 16, color: textSecondary),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
