import 'package:flutter/material.dart';

import '../../data.dart';

class OnboardingModel {
  final String title, titleAnnex, image, subTitle;
  final Color titleColor, buttonColor1, buttonColor2, backgroundColor;

  OnboardingModel({
    required this.title,
    required this.subTitle,
    required this.image,
    required this.titleAnnex,
    required this.titleColor,
    required this.buttonColor1,
    required this.buttonColor2,
    required this.backgroundColor,
  });
}

final List<OnboardingModel> _onboardingList = [
  OnboardingModel(
    title: "Hey there! your money just got an",
    titleAnnex: " Upgrade!",
    subTitle:
        "Seamless payments, automatic savings, and total financial control—right at your fingertips.",
    image: AppImages.part1,
    titleColor: Color(0XFFD8D8D8),
    buttonColor1: Color(0XFFFFFFFF),
    buttonColor2: Color(0XFFB57510),
    backgroundColor: Color(0XFF202020),
  ),
  OnboardingModel(
    title: "Smarter banking,",
    titleAnnex: " Zero Hassle.",
    subTitle:
        "Split bills in seconds, track expenses, Zengly keeps you one step ahead.",
    image: AppImages.part2,
    titleColor: Color(0XFF090909),
    buttonColor1: Color(0XFFFFFFFF),
    buttonColor2: Color(0XFFB57510),
    backgroundColor: Color(0XFFFFECCD),
  ),
  OnboardingModel(
    title: "Power, Flexibility,",
    titleAnnex: " Freedom.",
    subTitle:
        "Built for now. Designed for the future. Welcome to a new era of finance.",
    image: AppImages.part3,
    titleColor: Color(0XFFFFFFFF),
    buttonColor1: Color(0XFFFFFFFF),
    buttonColor2: Color(0XFF282828),
    backgroundColor: Color(0XFFAAAAAA),
  ),
];

List<OnboardingModel> get onboardingList => _onboardingList;
