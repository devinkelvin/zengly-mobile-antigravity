import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:toastification/toastification.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool _hasScanned = false;
  double? _presetAmount;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  void _handleDetectedCode(String code) {
    if (_hasScanned) return;
    _hasScanned = true;
    HapticFeedback.mediumImpact();

    AppOverlays.showToast(
      context: context,
      title: "QR Code Scanned",
      message: "Scanned: $code",
      toastType: ToastificationType.success,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        if (Navigator.of(context).canPop()) {
          context.pop(code);
        } else {
          context.pushNamed(AppRouter.preTransferScreen);
        }
      }
    });
  }

  void _showManualInputDialog() {
    final controller = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E1A14) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "Enter Zengly Tag or Code",
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Type a recipient username, payment code, or bill ID",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: "@username or payment code",
                  prefixIcon: const Icon(Icons.qr_code_2_rounded),
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF2B251B)
                      : const Color(0xFFF4ECE1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  actionText: "Proceed",
                  onPressed: () {
                    final text = controller.text.trim();
                    if (text.isNotEmpty) {
                      Navigator.pop(ctx);
                      _handleDetectedCode(text);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSetAmountSheet() {
    final controller = TextEditingController(
      text: _presetAmount != null ? _presetAmount!.toInt().toString() : "",
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E1A14) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "Set Payment Amount",
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "When anyone scans this QR, this amount will be automatically prefilled.",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  prefixText: "₦ ",
                  prefixStyle: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFB57510),
                  ),
                  hintText: "0.00",
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF2B251B)
                      : const Color(0xFFF4ECE1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  if (_presetAmount != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _presetAmount = null);
                          Navigator.pop(ctx);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text("Clear"),
                      ),
                    ),
                  if (_presetAmount != null) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      actionText: "Save Preset",
                      onPressed: () {
                        final val = double.tryParse(controller.text.trim());
                        setState(() => _presetAmount = val);
                        Navigator.pop(ctx);
                        AppOverlays.showToast(
                          context: context,
                          title: "Amount Updated",
                          message: val != null
                              ? "QR now requests ₦${controller.text}"
                              : "QR amount cleared",
                          toastType: ToastificationType.success,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF14120E) : const Color(0xFFF9F6F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "QR Code",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF241F18)
                  : const Color(0xFFEDE4D4),
              borderRadius: BorderRadius.circular(100),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(100),
              ),
              labelColor: Colors.white,
              unselectedLabelColor:
                  isDark ? Colors.white60 : const Color(0xFF7A6F62),
              labelStyle: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code_scanner_rounded, size: 16),
                      SizedBox(width: 8),
                      Text("Scan Code"),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code_2_rounded, size: 16),
                      SizedBox(width: 8),
                      Text("My QR Code"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildScannerTab(isDark, primaryColor),
          _buildMyQrTab(isDark, primaryColor),
        ],
      ),
    );
  }

  Widget _buildScannerTab(bool isDark, Color primaryColor) {
    return Stack(
      children: [
        // Camera View
        Positioned.fill(
          child: MobileScanner(
            controller: _scannerController,
            onDetect: (capture) {
              final barcode = capture.barcodes.firstOrNull;
              if (barcode?.rawValue != null) {
                _handleDetectedCode(barcode!.rawValue!);
              }
            },
          ),
        ),

        // Dark cutout overlay
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.65),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Animated Gold Corner brackets
        Center(
          child: SizedBox(
            width: 260,
            height: 260,
            child: CustomPaint(painter: _CornerPainter(primaryColor)),
          ),
        ),

        // Controls bar (Torch & Camera Switch)
        Positioned(
          top: 24,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                valueListenable: _scannerController,
                builder: (context, state, child) {
                  final isTorchOn = state.torchState == TorchState.on;
                  return _scannerCircleBtn(
                    icon: isTorchOn ? Icons.flash_on : Icons.flash_off,
                    label: isTorchOn ? "Flash On" : "Flash Off",
                    isActive: isTorchOn,
                    onTap: _scannerController.toggleTorch,
                  );
                },
              ),
              const SizedBox(width: 24),
              _scannerCircleBtn(
                icon: Icons.flip_camera_ios_rounded,
                label: "Flip",
                isActive: false,
                onTap: _scannerController.switchCamera,
              ),
            ],
          ),
        ),

        // Bottom action card with fallback testing chips
        Positioned(
          bottom: 24,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E1A14).withValues(alpha: 0.95)
                  : Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white12 : const Color(0xFFE2D6C5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Align QR code inside the frame to scan",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.keyboard_outlined, size: 16),
                        label: const Text("Enter Code"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: isDark ? Colors.white24 : Colors.black26,
                          ),
                        ),
                        onPressed: _showManualInputDialog,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.flash_auto_rounded, size: 16),
                        label: const Text("Demo Scan"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _handleDetectedCode("@kelvin_zengly"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  children: [
                    _quickCodeChip("@tunde_ade"),
                    _quickCodeChip("@chioma_gtb"),
                    _quickCodeChip("RSVP-LAGOS"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _scannerCircleBtn({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFFB57510)
              : Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickCodeChip(String code) {
    return ActionChip(
      label: Text(
        code,
        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
      ),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      onPressed: () => _handleDetectedCode(code),
    );
  }

  Widget _buildMyQrTab(bool isDark, Color primaryColor) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          // Luxury QR Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF262017), const Color(0xFF1B1610)]
                    : [Colors.white, const Color(0xFFFAF5ED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.35),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top Tag
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_user_rounded,
                          size: 14, color: primaryColor),
                      const SizedBox(width: 6),
                      Text(
                        "ZENGLY SECURE QR",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Stylized QR Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.qr_code_2_rounded,
                        size: 210,
                        color: const Color(0xFF1A1A1A),
                      ),
                      // Center Zengly emblem
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                        ),
                        child: const Icon(
                          Icons.currency_exchange_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // User details
                Text(
                  "Kelvin Ekuhoho",
                  style: GoogleFonts.raleway(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),

                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        const ClipboardData(text: "@kelvin_zengly"));
                    AppOverlays.showToast(
                      context: context,
                      title: "Copied!",
                      message: "Zengly tag copied to clipboard",
                      toastType: ToastificationType.success,
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF332A1D)
                          : const Color(0xFFF3ECE0),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "@kelvin_zengly",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.copy_rounded, size: 13, color: primaryColor),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Bank details capsule
                Text(
                  "Sterling Bank • 0287646370",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),

                if (_presetAmount != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF34C759).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "Requested Amount: ₦${CurrencyFormatter.format(_presetAmount!.toInt()).replaceFirst('₦', '')}",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF28A745),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Preset amount & Share options
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit_note_rounded, size: 18),
                  label: Text(_presetAmount == null ? "Set Amount" : "Change"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(
                      color: isDark ? Colors.white24 : const Color(0xFFD4C8B5),
                    ),
                  ),
                  onPressed: _showSetAmountSheet,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.share_rounded, size: 18),
                  label: const Text("Share QR"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Clipboard.setData(const ClipboardData(
                        text: "https://zengly.app/pay/@kelvin_zengly"));
                    AppOverlays.showToast(
                      context: context,
                      title: "Share Link Copied",
                      message: "https://zengly.app/pay/@kelvin_zengly",
                      toastType: ToastificationType.success,
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color cornerColor;
  _CornerPainter(this.cornerColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = cornerColor
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 24.0;
    const r = 20.0;

    // Top-left
    canvas.drawPath(
      Path()
        ..moveTo(0, r)
        ..quadraticBezierTo(0, 0, r, 0)
        ..lineTo(r + len, 0),
      paint,
    );
    canvas.drawLine(const Offset(0, r), const Offset(0, r + len), paint);

    // Top-right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - r - len, 0)
        ..lineTo(size.width - r, 0)
        ..quadraticBezierTo(size.width, 0, size.width, r)
        ..lineTo(size.width, r + len),
      paint,
    );

    // Bottom-left
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - r - len)
        ..lineTo(0, size.height - r)
        ..quadraticBezierTo(0, size.height, r, size.height)
        ..lineTo(r + len, size.height),
      paint,
    );

    // Bottom-right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - r - len, size.height)
        ..lineTo(size.width - r, size.height)
        ..quadraticBezierTo(
            size.width, size.height, size.width, size.height - r)
        ..lineTo(size.width, size.height - r - len),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
