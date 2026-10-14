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
  final Map<String, bool> _expanded = {
    "Spray": true,
    "Bundles": true,
    "Gifts": true,
    "Premium": true,
    "Legendary": true,
  };

  final List<String> _categories = [
    "Spray",
    "Bundles",
    "Gifts",
    "Premium",
    "Legendary",
  ];

  String _searchQuery = "";
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allItems = SprayItem.defaultItems;

    final filteredItems = _searchQuery.isEmpty
        ? allItems
        : allItems
            .where((i) =>
                i.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                i.displayAmount
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
            .toList();

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
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: GoogleFonts.inter(
                  color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                ),
                decoration: InputDecoration(
                  hintText: "Search spray options...",
                  hintStyle: GoogleFonts.inter(
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              )
            : Text(
                "Spray Options",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
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
              _isSearching ? Icons.close : Icons.search,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: _categories.map((category) {
            final categoryItems = filteredItems
                .where((i) => i.category == category)
                .toList();

            if (categoryItems.isEmpty) return const SizedBox.shrink();

            final isExpanded = _expanded[category] ?? true;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _expanded[category] = !isExpanded;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFB57510),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              category,
                              style: GoogleFonts.raleway(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isExpanded)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: categoryItems.length,
                    itemBuilder: (context, idx) {
                      final item = categoryItems[idx];
                      final isSelected = widget.selectedItem?.id == item.id;
                      return _SprayOptionCard(
                        item: item,
                        isSelected: isSelected,
                        isDark: isDark,
                        onTap: () => context.pop(item),
                      );
                    },
                  ),
              ],
            );
          }).toList(),
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark
        ? const Color(0xFF241F18)
        : Colors.white;
    final borderColor = isSelected
        ? const Color(0xFFB57510)
        : (isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE8E0D2));

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
                  : Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
              blurRadius: isSelected ? 10 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? const Color(0xFF332A1C).withValues(alpha: 0.6)
                              : const Color(0xFFF7F2E7),
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          item.image,
                          height: 60,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.wallet, size: 40, color: Color(0xFFB57510)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
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
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFB57510).withValues(alpha: 0.15)
                        : (isDark ? const Color(0xFF2E261A) : const Color(0xFFF3EEE3)),
                    borderRadius: BorderRadius.circular(10),
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
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFB57510),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
