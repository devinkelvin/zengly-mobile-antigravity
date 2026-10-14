import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/data.dart';
import '../../utils/utils.dart';
import '../../view/dashboard/dashboard_vm.dart';
import '../../widgets/widgets.dart';

class PreBillScreen extends ConsumerStatefulWidget {
  const PreBillScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PreBillScreenState();
}

class _PreBillScreenState extends ConsumerState<PreBillScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF757575);
    final borderColor = isDark ? const Color(0xFF2C241B) : const Color(0xFFEFE8DE);

    // Master catalog of all Zengly services
    final categories = [
      _MenuCategory(
        title: "Payments & Transfers",
        items: [
          _MenuItemData(
            title: "Send Money",
            subtitle: "Instant Zengly & interbank transfers",
            iconSvg: AppImages.sendNew,
            onTap: () => context.pushNamed(AppRouter.preTransferScreen),
          ),
          _MenuItemData(
            title: "Split Bill",
            subtitle: "Divide group expenses smoothly",
            iconSvg: AppImages.splitNew,
            badge: "NEW",
            onTap: () => context.pushNamed(AppRouter.splitBill),
          ),
          _MenuItemData(
            title: "QR Code Pay",
            subtitle: "Fast contactless payments",
            iconData: Icons.qr_code_scanner_rounded,
            onTap: () => context.pushNamed(AppRouter.preTransferScreen),
          ),
        ],
      ),
      _MenuCategory(
        title: "Social & Lifestyle Finance",
        items: [
          _MenuItemData(
            title: "Vaniti Spray Cash",
            subtitle: "Digital money spraying & celebrations",
            iconSvg: AppImages.vanitiNew,
            badge: "POPULAR",
            onTap: () => context.pushNamed(AppRouter.preSpecialFeatures),
          ),
          _MenuItemData(
            title: "Ajo 2.0 Savings",
            subtitle: "Automated rotational group thrift",
            iconData: Icons.groups_rounded,
            badge: "V2",
            onTap: () => context.pushNamed(AppRouter.ajoHub),
          ),
          _MenuItemData(
            title: "Split Bill History",
            subtitle: "Track settled and pending splits",
            iconData: Icons.history_rounded,
            onTap: () => context.pushNamed(AppRouter.splitBillHistory),
          ),
        ],
      ),
      _MenuCategory(
        title: "Bills & Utilities",
        items: [
          _MenuItemData(
            title: "Airtime Top-up",
            subtitle: "Instant mobile recharge for all networks",
            iconSvg: AppImages.airtimeNew,
            onTap: () => context.pushNamed(AppRouter.airtimeData, extra: 0),
          ),
          _MenuItemData(
            title: "Data Bundles",
            subtitle: "Daily, weekly and monthly data plans",
            iconSvg: AppImages.dataNew,
            onTap: () => context.pushNamed(AppRouter.airtimeData, extra: 1),
          ),
          _MenuItemData(
            title: "Electricity Tokens",
            subtitle: "Prepaid & postpaid disco meters",
            iconSvg: AppImages.electricityNew,
            onTap: () => context.pushNamed(AppRouter.electricity),
          ),
          _MenuItemData(
            title: "Airtime to Cash",
            subtitle: "Convert excess airtime to wallet balance",
            iconSvg: AppImages.airtime2CashNew,
            badge: "HOT",
            onTap: () => context.pushNamed(AppRouter.airtimeToCash),
          ),
          _MenuItemData(
            title: "TV & Cable",
            subtitle: "DStv, GOtv, and StarTimes bouquets",
            iconData: Icons.tv_rounded,
            onTap: () => context.pushNamed(AppRouter.tvSubscription),
          ),
          _MenuItemData(
            title: "Gift Cards",
            subtitle: "Global digital gift cards & vouchers",
            iconData: Icons.card_giftcard_rounded,
            onTap: () => context.pushNamed(AppRouter.giftCard),
          ),
        ],
      ),
      _MenuCategory(
        title: "Smart Finance & Intelligence",
        items: [
          _MenuItemData(
            title: "Finance AI Insights",
            subtitle: "Smart spending categorisation & analytics",
            iconSvg: AppImages.insightsIcon,
            badge: "AI",
            onTap: () {
              ref.read(dashboardVm).switchPage(3);
              context.pop();
            },
          ),
          _MenuItemData(
            title: "P2P Lending & Credit",
            subtitle: "Fast micro-credit & community investing",
            iconData: Icons.handshake_rounded,
            badge: "NEW",
            onTap: () => context.pushNamed(AppRouter.p2pLending),
          ),
          _MenuItemData(
            title: "Voice Banking",
            subtitle: "Hands-free speech-powered financial actions",
            iconData: Icons.mic_rounded,
            badge: "AI",
            onTap: () => context.pushNamed(AppRouter.voiceBanking),
          ),
        ],
      ),
      _MenuCategory(
        title: "Cards & Security",
        items: [
          _MenuItemData(
            title: "Zengly Virtual Cards",
            subtitle: "Manage debit cards & international limits",
            iconData: Icons.credit_card_rounded,
            onTap: () => context.pushNamed(AppRouter.cardScreen),
          ),
          _MenuItemData(
            title: "KYC & Identity Verification",
            subtitle: "Upgrade limits with BVN & NIN verification",
            iconData: Icons.badge_outlined,
            onTap: () => context.pushNamed(AppRouter.preVerification),
          ),
        ],
      ),
    ];

    // Filter items if searching
    final query = _searchQuery.toLowerCase().trim();
    final filteredCategories = query.isEmpty
        ? categories
        : categories
            .map((cat) {
              final matchedItems = cat.items
                  .where((item) =>
                      item.title.toLowerCase().contains(query) ||
                      item.subtitle.toLowerCase().contains(query))
                  .toList();
              return _MenuCategory(title: cat.title, items: matchedItems);
            })
            .where((cat) => cat.items.isNotEmpty)
            .toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: textPrimary),
        ),
        title: Text(
          "Menu & Services",
          style: GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 20, color: textPrimary),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF26211A) : const Color(0xFFF3ECE0),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Tier 2 • ", style: GoogleFonts.inter(fontSize: 11, color: textSecondary)),
                Text("Verified", style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: primaryColor)),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instant Search Field
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1A14) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                style: GoogleFonts.inter(fontSize: 13.5, color: textPrimary),
                decoration: InputDecoration(
                  hintText: "Search services, bills, or features...",
                  hintStyle: GoogleFonts.inter(fontSize: 13, color: textSecondary),
                  prefixIcon: Icon(Icons.search_rounded, color: primaryColor, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear_rounded, color: textSecondary, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = "");
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Render Categories
            if (filteredCategories.isEmpty) ...[
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded, size: 48, color: textSecondary),
                    const SizedBox(height: 12),
                    Text(
                      "No services found for '$_searchQuery'",
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
                    ),
                  ],
                ),
              ),
            ] else ...[
              for (final cat in filteredCategories) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8, top: 6),
                  child: Text(
                    cat.title,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1A14) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: borderColor),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cat.items.length,
                    separatorBuilder: (context, _) => Divider(
                      height: 1,
                      thickness: 1,
                      indent: 64,
                      color: isDark ? const Color(0xFF28231B) : const Color(0xFFF4EDE4),
                    ),
                    itemBuilder: (context, index) {
                      final item = cat.items[index];
                      return InkWell(
                        onTap: item.onTap,
                        borderRadius: BorderRadius.circular(18),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark ? const Color(0xFF2B241A) : const Color(0xFFFAF5ED),
                                  border: Border.all(
                                    color: isDark ? const Color(0xFF382F22) : const Color(0xFFEBE3D7),
                                  ),
                                ),
                                padding: const EdgeInsets.all(9),
                                child: item.iconSvg != null
                                    ? SvgPicture.asset(
                                        item.iconSvg!,
                                        colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
                                      )
                                    : Icon(item.iconData, color: primaryColor, size: 20),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            item.title,
                                            style: GoogleFonts.inter(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w600,
                                              color: textPrimary,
                                            ),
                                          ),
                                        ),
                                        if (item.badge != null) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                            decoration: BoxDecoration(
                                              color: item.badge == "AI"
                                                  ? const Color(0xFF8E24AA)
                                                  : (item.badge == "POPULAR" || item.badge == "HOT"
                                                      ? const Color(0xFFE53935)
                                                      : primaryColor),
                                              borderRadius: BorderRadius.circular(100),
                                            ),
                                            child: Text(
                                              item.badge!,
                                              style: GoogleFonts.inter(
                                                fontSize: 8.5,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.subtitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.chevron_right_rounded, size: 18, color: textSecondary),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _MenuCategory {
  final String title;
  final List<_MenuItemData> items;

  const _MenuCategory({required this.title, required this.items});
}

class _MenuItemData {
  final String title;
  final String subtitle;
  final String? iconSvg;
  final IconData? iconData;
  final String? badge;
  final VoidCallback onTap;

  const _MenuItemData({
    required this.title,
    required this.subtitle,
    this.iconSvg,
    this.iconData,
    this.badge,
    required this.onTap,
  });
}
