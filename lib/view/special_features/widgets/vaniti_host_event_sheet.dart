import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../../widgets/widgets.dart';

class VanitiHostEventSheet extends StatefulWidget {
  const VanitiHostEventSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const VanitiHostEventSheet(),
    );
  }

  @override
  State<VanitiHostEventSheet> createState() => _VanitiHostEventSheetState();
}

class _VanitiHostEventSheetState extends State<VanitiHostEventSheet> {
  final _nameController = TextEditingController();
  String _selectedType = "Birthday Party";
  double _targetGoal = 1000000;
  bool _created = false;
  String _eventCode = "";

  final List<String> _eventTypes = [
    "Birthday Party",
    "Wedding Reception",
    "Club & Nightlife",
    "Graduation Bash",
    "Milestone Celebration",
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _createEvent() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      AppOverlays.showToast(
        context: context,
        title: "Event Name Required",
        message: "Please enter a name for your celebration.",
        toastType: ToastificationType.warning,
      );
      return;
    }

    setState(() {
      _created = true;
      _eventCode = "VANITI-${name.substring(0, 3).toUpperCase()}-777";
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF757575);
    final borderColor = isDark ? const Color(0xFF2C241B) : const Color(0xFFEFE8DE);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1A17) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 14,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2E2A24) : const Color(0xFFE2D6C5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),

          if (!_created) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Host Your Celebration",
                  style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, size: 20, color: textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Generate a dedicated Vaniti Event QR. Guests can scan to digitally spray you in real time.",
              style: GoogleFonts.inter(fontSize: 12, color: textSecondary, height: 1.35),
            ),
            const SizedBox(height: 16),

            // Event Name
            Text("Event Name", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary)),
            const SizedBox(height: 6),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "e.g. Queenie's Golden 30th",
                hintStyle: GoogleFonts.inter(fontSize: 13, color: textSecondary),
                filled: true,
                fillColor: isDark ? const Color(0xFF252018) : const Color(0xFFFAF7F2),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primaryColor)),
              ),
              style: GoogleFonts.inter(fontSize: 13.5, color: textPrimary),
            ),
            const SizedBox(height: 14),

            // Event Type
            Text("Celebration Category", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _eventTypes.map((type) {
                final isSelected = _selectedType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedType = type),
                  labelStyle: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : textPrimary,
                  ),
                  selectedColor: primaryColor,
                  backgroundColor: isDark ? const Color(0xFF252018) : const Color(0xFFFAF7F2),
                  side: BorderSide(color: isSelected ? primaryColor : borderColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Target Goal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Spray Target Goal", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary)),
                Text(
                  _targetGoal >= 1000000 ? "₦${(_targetGoal / 1000000).toStringAsFixed(1)}M" : "₦${(_targetGoal / 1000).toInt()}K",
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: primaryColor),
                ),
              ],
            ),
            Slider(
              value: _targetGoal,
              min: 200000,
              max: 5000000,
              divisions: 24,
              activeColor: primaryColor,
              onChanged: (val) => setState(() => _targetGoal = val),
            ),
            const SizedBox(height: 16),

            AppButton(
              actionText: "Launch Event & Get QR",
              borderRadius: 100,
              onPressed: _createEvent,
            ),
          ] else ...[
            // Event Created Success & QR
            const Icon(Icons.celebration_rounded, color: Color(0xFFFFB300), size: 48),
            const SizedBox(height: 10),
            Text(
              "Event Live!",
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              _nameController.text,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor),
            ),
            const SizedBox(height: 16),

            // QR & Code Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF252018) : const Color(0xFFFAF7F2),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Icon(Icons.qr_code_2_rounded, size: 120, color: textPrimary),
                  const SizedBox(height: 12),
                  Text(
                    _eventCode,
                    style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: primaryColor),
                  ),
                  const SizedBox(height: 6),
                  Text("Guests can scan this QR in Vaniti to spray you directly", style: GoogleFonts.inter(fontSize: 11, color: textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _eventCode));
                      AppOverlays.showToast(context: context, title: "Copied!", message: "Event invite code copied.", toastType: ToastificationType.success);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textPrimary,
                      side: BorderSide(color: borderColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Copy Code"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    actionText: "Done",
                    borderRadius: 100,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
