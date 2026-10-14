import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../widgets/widgets.dart';
import '../../widgets/leaderboard_podium.dart';

class OwnTheMomentScreen extends StatefulWidget {
  const OwnTheMomentScreen({super.key});

  @override
  State<OwnTheMomentScreen> createState() => _OwnTheMomentScreenState();
}

class _OwnTheMomentScreenState extends State<OwnTheMomentScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: "Kelvin's Birthday Bash");
  String _selectedType = "Birthday Party";
  double _targetGoal = 1000000;
  bool _isEventCreated = false;
  String _eventCode = "VANITI-KEL-777";

  final List<String> _eventTypes = [
    "Birthday Party",
    "Wedding Reception",
    "Club & Nightlife",
    "Concert / VIP",
    "Anniversary",
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
        message: "Please enter your event name",
        toastType: ToastificationType.warning,
      );
      return;
    }

    HapticFeedback.heavyImpact();
    setState(() {
      _eventCode =
          "VANITI-${name.substring(0, 3).toUpperCase()}-${DateTime.now().millisecond}";
      _isEventCreated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF14120E);
    const cardColor = Color(0xFF1F1D19);
    const inputBg = Color(0xFF262420);
    const primaryAmber = Color(0xFFC58314);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Subtle Gold Glow in top-right
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryAmber.withValues(alpha: 0.15),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: Color(0xFF25231F),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      Text(
                        _isEventCreated ? "Live Event Leaderboard" : "Own the Moment",
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 38),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: _isEventCreated
                        ? _buildLiveEventView(primaryAmber, cardColor)
                        : _buildEventCreator(primaryAmber, cardColor, inputBg),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCreator(Color primaryAmber, Color cardColor, Color inputBg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // VIP Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2B2113), Color(0xFF1E170E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: primaryAmber.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: primaryAmber.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.celebration_rounded,
                  color: primaryAmber,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Host VIP Digital Spray Event",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Guests scan your QR code to spray money live.",
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Event Name
        Text(
          "Event Name",
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: TextField(
            controller: _nameController,
            style: GoogleFonts.inter(fontSize: 15, color: Colors.white),
            decoration: const InputDecoration(
              hintText: "e.g. Wedding Reception 2026",
              hintStyle: TextStyle(color: Colors.white38),
              border: InputBorder.none,
            ),
          ),
        ),

        const SizedBox(height: 18),

        // Event Type
        Text(
          "Event Type",
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _eventTypes.map((type) {
            final isSelected = type == _selectedType;
            return GestureDetector(
              onTap: () => setState(() => _selectedType = type),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? primaryAmber : cardColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  type,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : Colors.white70,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        // Target Spray Goal
        Text(
          "Target Spray Goal (₦)",
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: [500000, 1000000, 5000000, 10000000].map((amt) {
            final isSelected = _targetGoal == amt.toDouble();
            return GestureDetector(
              onTap: () => setState(() => _targetGoal = amt.toDouble()),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? primaryAmber : cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "₦${amt ~/ 1000000 >= 1 ? '${amt ~/ 1000000}M' : '${amt ~/ 1000}k'}",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.white70,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 28),

        // Create Event Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _createEvent,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryAmber,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              "Launch VIP Event & Leaderboard",
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLiveEventView(Color primaryAmber, Color cardColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Live Event Header Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: primaryAmber.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "LIVE EVENT",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFEF4444),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryAmber.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      _eventCode,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: primaryAmber,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _nameController.text,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Total Sprayed: ₦4,850,000 / ₦${NumberFormat('#,###').format(_targetGoal.toInt())}",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.485,
                  minHeight: 6,
                  backgroundColor: const Color(0xFF2E2B25),
                  valueColor: AlwaysStoppedAnimation(primaryAmber),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Shared Leaderboard Podium
        Text(
          "Top Sprayers Podium",
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        const LeaderboardPodium(),

        const SizedBox(height: 24),

        // Event Share & QR Code CTA
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.share_outlined, size: 18),
                  label: const Text("Share Event"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _eventCode));
                    AppOverlays.showToast(
                      context: context,
                      title: "Code Copied",
                      message: "Event code $_eventCode copied to clipboard!",
                      toastType: ToastificationType.success,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.qr_code_2_rounded, size: 20),
                  label: const Text("Show QR"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryAmber,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    AppOverlays.showToast(
                      context: context,
                      title: "Projector Mode",
                      message: "Opening high-resolution event QR code...",
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
