import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toastification/toastification.dart';

import '../../widgets/widgets.dart';
import 'models/legal_doc_model.dart';

class LegalDocumentViewerScreen extends StatefulWidget {
  final LegalDoc document;

  const LegalDocumentViewerScreen({
    super.key,
    required this.document,
  });

  @override
  State<LegalDocumentViewerScreen> createState() =>
      _LegalDocumentViewerScreenState();
}

class _LegalDocumentViewerScreenState extends State<LegalDocumentViewerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _shareDocument() {
    final fullText = StringBuffer();
    fullText.writeln(widget.document.title);
    fullText.writeln("Operator: ${widget.document.operatorEntity}");
    fullText.writeln("Version: ${widget.document.version} • Effective: ${widget.document.effectiveDate}");
    fullText.writeln("------------------------------------------\n");

    for (final section in widget.document.sections) {
      fullText.writeln(section.title);
      fullText.writeln(section.content);
      fullText.writeln();
    }
    fullText.writeln("Available online at: ${LegalRepository.officialWebsite}");

    Share.share(
      fullText.toString(),
      subject: "${widget.document.title} - Zengly",
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF6B655D);
    final cardBg = isDark ? const Color(0xFF1E1A14) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2C241B) : const Color(0xFFEBE3D7);

    final filteredSections = widget.document.sections.where((s) {
      if (_searchQuery.isEmpty) return true;
      return s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.content.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.document.title,
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Share Document",
            icon: Icon(Icons.share_outlined, size: 20, color: primaryColor),
            onPressed: _shareDocument,
          ),
        ],
      ),
      body: Column(
        children: [
          // Document Header Summary Banner
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        widget.document.version,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Text(
                      "Effective: ${widget.document.effectiveDate}",
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.document.subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.business_rounded, size: 14, color: primaryColor),
                    const SizedBox(width: 6),
                    Text(
                      "Operator: ${widget.document.operatorEntity}",
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: GoogleFonts.inter(fontSize: 13, color: textPrimary),
              decoration: InputDecoration(
                hintText: "Search clauses, fees, or keywords...",
                hintStyle: GoogleFonts.inter(fontSize: 13, color: textSecondary),
                prefixIcon: Icon(Icons.search_rounded, size: 20, color: textSecondary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = "");
                        },
                      )
                    : null,
                filled: true,
                fillColor: cardBg,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
            ),
          ),

          // Scrollable Sections
          Expanded(
            child: filteredSections.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off_rounded, size: 48, color: textSecondary),
                          const SizedBox(height: 12),
                          Text(
                            "No matching clauses found",
                            style: GoogleFonts.raleway(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Try searching with broader terms or clear your search query.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(fontSize: 12.5, color: textSecondary),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    itemCount: filteredSections.length,
                    itemBuilder: (context, index) {
                      final section = filteredSections[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: section.isDraftNotice
                              ? (isDark ? const Color(0xFF2C1E0A) : const Color(0xFFFFF7EB))
                              : cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: section.isDraftNotice
                                ? primaryColor.withValues(alpha: 0.5)
                                : borderColor,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (section.isDraftNotice) ...[
                              Row(
                                children: [
                                  Icon(Icons.gavel_rounded, size: 16, color: primaryColor),
                                  const SizedBox(width: 6),
                                  Text(
                                    "COMPLIANCE NOTICE",
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: primaryColor,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                            Text(
                              section.title,
                              style: GoogleFonts.raleway(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              section.content,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: textSecondary,
                                height: 1.55,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
