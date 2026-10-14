import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/insight_models.dart';

class InsightTabSelector extends StatelessWidget {
  final InsightTab selected;
  final ValueChanged<InsightTab> onChanged;

  const InsightTabSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _tabs = [
    (InsightTab.all, "All", false),
 //   (InsightTab.analytics, "Analytics", true),
    (InsightTab.assistant, "Zengly AI Assistant", true),
    (InsightTab.spending, "Spending", false),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            _tabs.map((tab) {
              final (value, label, hasDot) = tab;
              final isSelected = value == selected;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => onChanged(value),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFC58314)
                          : const Color(0xFF22201D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : Colors.white60,
                          ),
                        ),
                        if (hasDot) ...[
                          const SizedBox(width: 4),
                          Container(
                            height: 6,
                            width: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
