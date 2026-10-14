import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../widgets/widgets.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF14120E);
    const cardColor = Color(0xFF1F1D19);
    const dividerColor = Color(0xFF2C2822);
    const badgeGreen = Color(0xFF00B050);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
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
        ),
        title: Text(
          "Support",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Chat with a Live Person
                _buildSupportTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: "Chat with a Live Person",
                  subtitle: "We're always here for you.",
                  onTap: () {
                    AppOverlays.showToast(
                      context: context,
                      title: "Live Chat",
                      message: "Connecting to a support agent...",
                    );
                  },
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: dividerColor,
                  indent: 16,
                  endIndent: 16,
                ),
                // Email Us
                _buildSupportTile(
                  icon: Icons.mail_outline_rounded,
                  title: "Email Us",
                  hasNewBadge: true,
                  badgeColor: badgeGreen,
                  subtitle: "Support@zenglypay.com",
                  onTap: () {
                    Clipboard.setData(
                      const ClipboardData(text: "Support@zenglypay.com"),
                    );
                    AppOverlays.showToast(
                      context: context,
                      title: "Email Copied",
                      message: "Support@zenglypay.com copied to clipboard",
                      toastType: ToastificationType.success,
                    );
                  },
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: dividerColor,
                  indent: 16,
                  endIndent: 16,
                ),
                // Call Center
                _buildSupportTile(
                  icon: Icons.headset_mic_outlined,
                  title: "Call Center",
                  hasNewBadge: true,
                  badgeColor: badgeGreen,
                  subtitle: "Ring our support agents",
                  onTap: () {
                    AppOverlays.showToast(
                      context: context,
                      title: "Call Center",
                      message: "Calling +234 800 ZENGLY (+234 800 936 459)...",
                      toastType: ToastificationType.info,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSupportTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool hasNewBadge = false,
    Color badgeColor = const Color(0xFF00B050),
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white70,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      if (hasNewBadge) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            "New",
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.chevron_right,
              color: Colors.white38,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
