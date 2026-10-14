import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/insight_models.dart';
import 'insight_card.dart';

class InsightAllTab extends StatefulWidget {
  final List<InsightCardModel> cards;

  const InsightAllTab({super.key, required this.cards});

  @override
  State<InsightAllTab> createState() => _InsightAllTabState();
}

class _InsightAllTabState extends State<InsightAllTab> {
  String _selectedCategory = "All";
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final List<String> _categories = const [
    "All",
    "Savings",
    "Alerts",
    "Bills",
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<InsightCardModel> get _filteredCards {
    return widget.cards.where((card) {
      // Category filter
      if (_selectedCategory == "Alerts" && !card.hasAlert) return false;
      if (_selectedCategory == "Savings" &&
          !card.title.toLowerCase().contains("saving") &&
          !card.title.toLowerCase().contains("fund")) {
        return false;
      }
      if (_selectedCategory == "Bills" &&
          !card.title.toLowerCase().contains("dstv") &&
          !card.title.toLowerCase().contains("airtime") &&
          !card.title.toLowerCase().contains("bill")) {
        return false;
      }

      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final inTitle = card.title.toLowerCase().contains(_searchQuery);
        final inDesc = card.description.toLowerCase().contains(_searchQuery);
        if (!inTitle && !inDesc) return false;
      }

      return true;
    }).toList();
  }

  void _showInsightDetailSheet(BuildContext context, InsightCardModel model) {
    HapticFeedback.mediumImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1B1712) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black12,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black26,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: model.iconBackground.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(model.icon),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.title,
                        style: GoogleFonts.raleway(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF1E1A14),
                        ),
                      ),
                      if (model.hasAlert)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "HIGH PRIORITY ADVISORY",
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFEF4444),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF241F17) : const Color(0xFFF9F6F0),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFB57510).withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                model.description,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.5,
                  color: isDark ? Colors.white70 : const Color(0xFF5A4D3B),
                ),
              ),
            ),
            if (model.chips != null && model.chips!.isNotEmpty) ...[
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: model.chips!.map(
                  (chip) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2E261A) : const Color(0xFFF3EEE3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      chip.value.isNotEmpty ? "${chip.label}: ${chip.value}" : chip.label,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFB57510),
                      ),
                    ),
                  ),
                ).toList(),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                        color: isDark ? Colors.white24 : Colors.black26,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Dismiss",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF1E1A14),
                          content: Text(
                            "Action initiated for: ${model.linkText ?? 'Insight'}",
                            style: GoogleFonts.inter(color: Colors.white),
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFFB57510),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      model.linkText ?? "Take Action",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _filteredCards;

    return Column(
      children: [
        const SizedBox(height: 8),
        // Search bar
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1712) : const Color(0xFFF6F3EB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? Colors.white10 : const Color(0xFFE5DECE),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 20,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: "Search insights, bills, goals...",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                ),
              ),
              if (_searchQuery.isNotEmpty)
                GestureDetector(
                  onTap: () => _searchController.clear(),
                  child: Icon(
                    Icons.cancel,
                    size: 16,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Filter pills
        SizedBox(
          height: 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = cat == _selectedCategory;
              return InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedCategory = cat);
                },
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFB57510)
                        : (isDark ? const Color(0xFF1E1A14) : const Color(0xFFF3EEE3)),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFB57510)
                          : (isDark ? Colors.white10 : const Color(0xFFE2DAD0)),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    cat,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white70 : const Color(0xFF5A4D3B)),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Summary banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF261E10), const Color(0xFF1A1610)]
                  : [const Color(0xFFFFF8EC), const Color(0xFFF9F2E2)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFB57510).withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.trending_up_rounded,
                color: Color(0xFFB57510),
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Potential monthly savings: ₦17,200 found",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1E1A14),
                  ),
                ),
              ),
              Text(
                "${filtered.length} active",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFB57510),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // List or Empty state
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 48,
                        color: isDark ? Colors.white24 : Colors.black26,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "No insights found",
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Try clearing your search or category filter",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedCategory = "All";
                            _searchController.clear();
                          });
                        },
                        child: Text(
                          "Reset Filters",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFB57510),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final card = filtered[index];
                    return InsightCard(
                      model: card,
                      onTap: () => _showInsightDetailSheet(context, card),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
