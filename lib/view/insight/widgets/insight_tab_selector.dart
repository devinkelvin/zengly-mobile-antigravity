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
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Color(0xFF171717)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight:
                                isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                            color:
                                isSelected
                                    ? Colors.white
                                    : Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
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
