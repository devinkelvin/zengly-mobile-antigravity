import 'package:flutter/material.dart';

import '../models/insight_models.dart';
import 'insight_card.dart';

class InsightAllTab extends StatelessWidget {
  final List<InsightCardModel> cards;

  const InsightAllTab({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: cards.length,
      separatorBuilder:
          (context, index) => Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
      itemBuilder: (context, index) => InsightCard(model: cards[index]),
    );
  }
}
