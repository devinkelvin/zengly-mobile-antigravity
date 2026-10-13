import 'package:flutter/material.dart';

enum InsightTab { all, analytics, assistant, spending }

class InsightChip {
  final String label;
  final String value;

  const InsightChip({required this.label, required this.value});
}

class InsightCardModel {
  final String icon;
  final Color iconBackground;
  final bool hasAlert;
  final String title;
  final String description;
  final List<InsightChip>? chips;
  final String? linkText;

  const InsightCardModel({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.description,
    this.hasAlert = false,
    this.chips,
    this.linkText,
  });
}

class AnalyticsPoint {
  final String label;
  final double income;
  final double expense;

  const AnalyticsPoint({
    required this.label,
    required this.income,
    required this.expense,
  });
}

class ChatMessage {
  final String text;
  final bool isUser;
  final String timestamp;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class SpendingCategory {
  final String label;
  final double amount;
  final Color color;
  final double widthFactor;
  final IconData? icon;
  final int? transactionCount;

  const SpendingCategory({
    required this.label,
    required this.amount,
    required this.color,
    required this.widthFactor,
    this.icon,
    this.transactionCount,
  });
}
