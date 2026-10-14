import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/data.dart';

class SprayOptionsScreen extends StatefulWidget {
  final SprayItem? selectedItem;

  const SprayOptionsScreen({super.key, this.selectedItem});

  @override
  State<SprayOptionsScreen> createState() => _SprayOptionsScreenState();
}

class _SprayOptionsScreenState extends State<SprayOptionsScreen> {
  String _selectedCategory = "All";
  String _searchQuery = "";
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  SprayItem? _currentSelected;

  final List<String> _categories = [
    "All",
    "Spray",
    "Bundles",
    "Gifts",
    "Premium",
    "Legendary",
  ];

  @override
  void initState() {
    super.initState();
    _currentSelected = widget.selectedItem ?? SprayItem.defaultItems.first;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allItems = SprayItem.defaultItems;

    final filteredItems = allItems.where((i) {
      final matchesCat =
          _selectedCategory == "All" || i.category == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          i.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          i.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          i.displayAmount.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCat && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(_currentSelected),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 19,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: GoogleFonts.inter(
                  color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: "Search notes, bundles, gifts...",
                  hintStyle: GoogleFonts.inter(
                    color: isDark ? Colors.white54 : Colors.black45,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              )
            : Text(
                "Select Spray Option",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w700,
                  fontSize: 19,
                  color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                ),
              ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchQuery = "";
                  _searchController.clear();
                } else {
                  _isSearching = true;
                }
              });
            },
            icon: Icon(
              _isSearching ? Icons.close : Icons.search_rounded,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Category Selector Pills
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final cat = _categories[idx];
                final isSelected = _selectedCategory == cat;
                final count = cat == "All"
                    ? allItems.length
                    : allItems.where((i) => i.category == cat).length;

                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFB57510)
                          : (isDark
                              ? const Color(0xFF241F18)
                              : const Color(0xFFEDE5D5)),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFB57510)
                            : (isDark ? Colors.white10 : Colors.black12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          cat,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.white70 : Colors.black87),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.25)
                                : (isDark
                                    ? Colors.black26
                                    : Colors.white.withValues(alpha: 0.8)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "$count",
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                      ? Colors.white60
                                      : const Color(0xFF7A6B55)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Items Grid
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 52,
                          color: isDark ? Colors.white24 : Colors.black26,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "No spray options found",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white54 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.80,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, idx) {
                      final item = filteredItems[idx];
                      final isSelected = _currentSelected?.id == item.id;
                      return _SprayOptionCard(
                        item: item,
                        isSelected: isSelected,
                        isDark: isDark,
                        onTap: () {
                          setState(() => _currentSelected = item);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),

      // Bottom Floating Confirmation Bar
      bottomSheet: _currentSelected != null
          ? Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1A14) : Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.white10 : const Color(0xFFE5DEC8),
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentSelected!.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1E1A14),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                _currentSelected!.displayAmount,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFB57510),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "• ₦1,000 fee",
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color:
                                      isDark ? Colors.white54 : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    ElevatedButton(
                      onPressed: () {
                        context.pop(_currentSelected);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB57510),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Confirm Option",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

class _SprayOptionCard extends StatelessWidget {
  final SprayItem item;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _SprayOptionCard({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  Color _categoryBadgeColor(String cat) {
    switch (cat) {
      case "Bundles":
        return const Color(0xFFB57510);
      case "Gifts":
        return const Color(0xFFD9480F);
      case "Premium":
        return const Color(0xFF845EF7);
      case "Legendary":
        return const Color(0xFFF59F00);
      default:
        return const Color(0xFF2B8A3E);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = isSelected
        ? const Color(0xFFB57510).withValues(alpha: isDark ? 0.16 : 0.08)
        : (isDark
            ? Colors.white.withValues(alpha: 0.035)
            : Colors.white);
    final borderColor = isSelected
        ? const Color(0xFFB57510)
        : (isDark
            ? Colors.white.withValues(alpha: 0.08)
            : const Color(0xFFE8E0D2));
    final catColor = _categoryBadgeColor(item.category);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFFB57510).withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: isSelected ? 14 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Category tag and Selected indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: catColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.category.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: catColor,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? const Color(0xFFB57510)
                        : (isDark ? Colors.white10 : Colors.black12),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 13)
                      : null,
                ),
              ],
            ),

            // Floating 3D Cash Asset with generous size and transparent background
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Image.asset(
                    item.image,
                    height: 94,
                    width: 94,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.payments_rounded,
                      size: 50,
                      color: Color(0xFFB57510),
                    ),
                  ),
                ),
              ),
            ),

            // Item Name
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1E1A14),
              ),
            ),

            const SizedBox(height: 3),

            // Denomination Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFB57510).withValues(alpha: 0.15)
                    : (isDark
                        ? const Color(0xFF2C251B)
                        : const Color(0xFFF2ECE0)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.displayAmount,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? const Color(0xFFB57510)
                      : (isDark ? Colors.white70 : const Color(0xFF6B5E4A)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
