import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../data/data.dart';
import '../../widgets/widgets.dart';

class ProfileCompletionScreen extends ConsumerStatefulWidget {
  const ProfileCompletionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState
    extends ConsumerState<ProfileCompletionScreen> {
  final TextEditingController _tagController =
      TextEditingController(text: "usertag");
  bool _isMale = true;
  int _selectedAvatarIndex = 0;

  final List<String> _tagSuggestions = ["Ability01", "ElijahA", "Elijaah"];

  // Dynamic avatars with colored backgrounds matching Screenshot 8 & 9
  final List<Map<String, dynamic>> _maleAvatars = [
    {
      "color": const Color(0xFFB57510),
      "image": AppImages.kunle,
      "name": "Kunle",
    },
    {
      "color": const Color(0xFF228B22),
      "image": AppImages.dummyPerson,
      "name": "Elijah",
    },
    {
      "color": const Color(0xFFC82333),
      "image": AppImages.profilePerson,
      "name": "Tunde",
    },
    {
      "color": const Color(0xFFB8860B),
      "image": AppImages.kunle,
      "name": "Emeka",
    },
    {
      "color": const Color(0xFF8B0000),
      "image": AppImages.profilePicture,
      "name": "Femi",
    },
  ];

  final List<Map<String, dynamic>> _femaleAvatars = [
    {
      "color": const Color(0xFFB8860B),
      "image": AppImages.bella,
      "name": "Bella",
    },
    {
      "color": const Color(0xFF20B2AA),
      "image": AppImages.queenie,
      "name": "Queenie",
    },
    {
      "color": const Color(0xFFC71585),
      "image": AppImages.bella,
      "name": "Amaka",
    },
    {
      "color": const Color(0xFF9370DB),
      "image": AppImages.queenie,
      "name": "Zainab",
    },
    {
      "color": const Color(0xFF2E8B57),
      "image": AppImages.bella,
      "name": "Chioma",
    },
  ];

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  void _onComplete() {
    final tag = _tagController.text.trim();
    if (tag.isEmpty) {
      AppOverlays.showToast(
        context: context,
        title: "Usertag Required",
        message: "Please enter your desired usertag",
        toastType: ToastificationType.warning,
      );
      return;
    }

    AppOverlays.showToast(
      context: context,
      title: "Profile Upgraded",
      message: "Your usertag @$tag and avatar have been saved successfully!",
      toastType: ToastificationType.success,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF14120E);
    const inputBg = Color(0xFF22201D);
    const primaryAmber = Color(0xFFC58314);

    final avatars = _isMale ? _maleAvatars : _femaleAvatars;
    final currentAvatar = avatars[_selectedAvatarIndex % avatars.length];

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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Headline
              Text(
                "Let's upgrade your avatar's profile",
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 20),

              // Usertag Input
              Container(
                decoration: BoxDecoration(
                  color: inputBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Your Usertag",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _tagController,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Usertag Suggestions
              Row(
                children: [
                  Text(
                    "Suggestions: ",
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: Colors.white54,
                    ),
                  ),
                  Wrap(
                    spacing: 6,
                    children: _tagSuggestions.map((s) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _tagController.text = s;
                          });
                        },
                        child: Text(
                          "$s, ",
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Male / Female Selectors matching Screenshot 8 & 9
              Row(
                children: [
                  // Male Selector
                  Expanded(
                    child: _buildGenderButton(
                      label: "Male",
                      isSelected: _isMale,
                      onTap: () {
                        setState(() {
                          _isMale = true;
                          _selectedAvatarIndex = 0;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Female Selector
                  Expanded(
                    child: _buildGenderButton(
                      label: "Female",
                      isSelected: !_isMale,
                      onTap: () {
                        setState(() {
                          _isMale = false;
                          _selectedAvatarIndex = 0;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // "Choose Your Avatar" Heading
              Text(
                "Choose Your Avatar",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // Large Center Circular Avatar Preview with Top-Right Checkmark Badge
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: currentAvatar["color"] as Color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white24,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          currentAvatar["image"] as String,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 70,
                          ),
                        ),
                      ),
                    ),
                    // Checkmark Badge on circumference
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Color(0xFF14120E),
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Horizontal Carousel of Avatars matching Screenshot 8 & 9
              SizedBox(
                height: 75,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: avatars.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = avatars[index];
                    final isSelected = index == _selectedAvatarIndex;

                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedAvatarIndex = index);
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 66,
                            height: 66,
                            decoration: BoxDecoration(
                              color: item["color"] as Color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                item["image"] as String,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Color(0xFF14120E),
                                  size: 13,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 36),

              // Bottom Button "Complete Profile"
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _onComplete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryAmber,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Complete Profile",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const primaryAmber = Color(0xFFC58314);
    const unselectedBg = Color(0xFF22201D);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: unselectedBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryAmber : Colors.transparent,
            width: 1.8,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.white60,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: primaryAmber,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
