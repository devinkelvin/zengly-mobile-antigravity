import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/data.dart';

class SpraySelectionSheet extends StatefulWidget {
  final SprayItem? selectedItem;
  final ValueChanged<SprayItem> onItemSelected;

  const SpraySelectionSheet({
    super.key,
    this.selectedItem,
    required this.onItemSelected,
  });

  static Future<SprayItem?> show(
    BuildContext context, {
    SprayItem? currentItem,
  }) {
    return showModalBottomSheet<SprayItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SpraySelectionSheet(
        selectedItem: currentItem,
        onItemSelected: (item) => Navigator.of(ctx).pop(item),
      ),
    );
  }

  @override
  State<SpraySelectionSheet> createState() => _SpraySelectionSheetState();
}

class _SpraySelectionSheetState extends State<SpraySelectionSheet> {
  final Map<String, bool> _expandedCategories = {
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF191612) : Colors.white;
    final allItems = SprayItem.defaultItems;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
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
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isExpanded = _expandedCategories[category] ?? true;
                    final categoryItems =
                        allItems.where((i) => i.category == category).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _expandedCategories[category] = !isExpanded;
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  category,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
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
                              childAspectRatio: 1.15,
                            ),
                            itemCount: categoryItems.length,
                            itemBuilder: (context, itemIdx) {
                              final item = categoryItems[itemIdx];
                              final isSelected =
                                  widget.selectedItem?.id == item.id;
                              return _SprayItemCard(
                                item: item,
                                isSelected: isSelected,
                                isDark: isDark,
                                onTap: () => widget.onItemSelected(item),
                              );
                            },
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SprayItemCard extends StatelessWidget {
  final SprayItem item;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _SprayItemCard({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark
        ? const Color(0xFF231E18)
        : const Color(0xFFF3F4F6);
    final borderColor = isSelected
        ? const Color(0xFFC87D0E)
        : Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  item.image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.wallet, size: 40, color: Color(0xFFC87D0E)),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.displayAmount,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
