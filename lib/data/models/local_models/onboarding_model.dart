import 'package:flutter/material.dart';

import '../../data.dart';

class OnboardingModel {
  final String headline;
  final String highlightedWord;
  final String description;
  final String image;
  final String badge;

  const OnboardingModel({
    required this.headline,
    required this.highlightedWord,
    required this.description,
    required this.image,
    required this.badge,
  });
}

final List<OnboardingModel> _onboardingList = [
  OnboardingModel(
    headline: "Lifestyle Banking,",
    highlightedWord: "Reimagined.",
    description:
        "Seamless zero-fee transfers, instant virtual dollar cards, and total financial clarity at your fingertips.",
    image: AppImages.part1,
    badge: "GLOBAL TRANSFERS & CARDS",
  ),
  OnboardingModel(
    headline: "Social Finance &",
    highlightedWord: "Celebrations.",
    description:
        "Split dining bills in seconds, launch community Ajo circles, and shower friends with digital Vaniti cash spraying.",
    image: AppImages.part2,
    badge: "VANITI & AJO CIRCLES",
  ),
  OnboardingModel(
    headline: "Intelligence Built For",
    highlightedWord: "Your Freedom.",
    description:
        "AI-driven spending insights, automated budget tracking, and bank-grade biometric security for your peace of mind.",
    image: AppImages.part3,
    badge: "AI COMPANION & SECURITY",
  ),
];

List<OnboardingModel> get onboardingList => _onboardingList;
