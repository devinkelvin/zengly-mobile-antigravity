import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';

import '../../../../data/data.dart';
import '../../../../widgets/widgets.dart';
import '../account_vm.dart';

class ProfileCoverSheet extends ConsumerStatefulWidget {
  const ProfileCoverSheet({super.key});

  @override
  ConsumerState<ProfileCoverSheet> createState() => _ProfileCoverSheetState();
}

class _ProfileCoverSheetState extends ConsumerState<ProfileCoverSheet> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickCustomCover() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked != null) {
        ref.read(accountProvider.notifier).setCustomCoverImage(picked.path);
        if (mounted) {
          AppOverlays.showToast(
            context: context,
            title: "Cover Updated",
            message: "Custom background photo applied successfully",
            toastType: ToastificationType.success,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppOverlays.showToast(
          context: context,
          title: "Image Selection",
          message: "Could not pick image: $e",
          toastType: ToastificationType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final accountState = ref.watch(accountProvider);
    final activeEffect = accountState.coverEffect;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1813) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
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
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Profile Background Effect",
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1E1A14),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Live Preview Banner
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: 100,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background
                  if (activeEffect.customImagePath != null)
                    Image.file(
                      File(activeEffect.customImagePath!),
                      fit: BoxFit.cover,
                    )
                  else
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: activeEffect.colors,
                        ),
                      ),
                    ),

                  // Avatar Blur Melt (if enabled)
                  if (activeEffect.enableAvatarBlur &&
                      activeEffect.customImagePath == null)
                    Positioned(
                      right: -20,
                      top: -20,
                      bottom: -20,
                      width: 140,
                      child: Opacity(
                        opacity: 0.7,
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                          child: Image.asset(
                            AppImages.profilePicture,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                  // Mini preview badge
                  Positioned(
                    bottom: 8,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.visibility_rounded,
                              size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            activeEffect.name,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Presets Label
          Text(
            "Curated Themes & Gradients",
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),

          // Presets Horizontal Carousel
          SizedBox(
            height: 82,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: ProfileCoverEffect.presets.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final preset = ProfileCoverEffect.presets[index];
                final isSelected =
                    activeEffect.id == preset.id &&
                    activeEffect.customImagePath == null;

                return GestureDetector(
                  onTap: () {
                    ref.read(accountProvider.notifier).setCoverEffect(preset);
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: preset.colors,
                          ),
                          border: Border.all(
                            color: isSelected ? primaryColor : Colors.white24,
                            width: isSelected ? 3 : 1.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: primaryColor.withValues(alpha: 0.4),
                                    blurRadius: 10,
                                  ),
                                ]
                              : [],
                        ),
                        child: isSelected
                            ? const Center(
                                child: Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 68,
                        child: Text(
                          preset.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? primaryColor
                                : (isDark ? Colors.white70 : Colors.black87),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 14),

          // Options & Upload Custom Photo
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.add_photo_alternate_rounded, size: 18),
                  label: const Text("Custom Photo"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(
                      color: isDark ? Colors.white24 : const Color(0xFFD4C8B5),
                    ),
                  ),
                  onPressed: _pickCustomCover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text("Apply Cover"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    AppOverlays.showToast(
                      context: context,
                      title: "Cover Effect Saved",
                      message: "Your profile background has been updated.",
                      toastType: ToastificationType.success,
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Avatar Blur Melt Toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.blur_on_rounded, size: 20, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      "Avatar Frosted Blur Effect",
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: activeEffect.enableAvatarBlur,
                  onChanged: (val) {
                    ref.read(accountProvider.notifier).toggleAvatarBlur(val);
                  },
                  activeThumbColor: Theme.of(context).colorScheme.onPrimary,
                  activeTrackColor: primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
