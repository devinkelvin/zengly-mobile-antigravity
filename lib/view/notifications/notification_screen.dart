import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/utils.dart';
import 'widgets/widgets.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Notifications",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          children: [
            NotificationWidget(
              message:
                  "Get ready for your upcoming energy bill! Click to view consumption details.",
            ),
            NotificationWidget(
              message:
                  "Get ready for your upcoming energy bill! Click to view consumption details.",
            ),
            NotificationWidget(
              message:
                  "Stay informed about your energy usage! Click here to check your consumption details.",
              isRead: true,
            ),
            NotificationWidget(
              message:
                  "Prepare for your next energy bill! Click here to see your usage breakdown.",
              isRead: true,
            ),
            NotificationWidget(
              message:
                  "Your installation is complete! Check out the details of your energy usage now.",
              isRead: true,
            ),
            NotificationWidget(
              message:
                  "Your installation is complete! Check out the details of your energy usage now.",
              isRead: true,
            ),
          ],
        ),
      ),
    );
  }
}
