import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InsightPeriodSelector extends StatelessWidget {
  final List<String> periods;
  final String selected;
  final ValueChanged<String> onChanged;
  final VoidCallback? onCustomTap;

  const InsightPeriodSelector({
    super.key,
    required this.periods,
    required this.selected,
    required this.onChanged,
    this.onCustomTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children:
            periods.map((period) {
              final isSelected = period == selected;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    onChanged(period);
                    if (period == "CUSTOM") {
                      onCustomTap?.call();
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? const Color(0xFF262626)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border:
                          isSelected
                              ? Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              )
                              : null,
                    ),
                    child: Text(
                      period,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color:
                            isSelected
                                ? Colors.white
                                : Theme.of(context).colorScheme.scrim,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
