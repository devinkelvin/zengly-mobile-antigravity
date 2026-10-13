import 'package:flutter/material.dart';
import 'package:zengly/data/app_images.dart';

class CoinWidget extends StatelessWidget {
  const CoinWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 16),

      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(112.5),
      ),
      child: Row(
        children: [Image.asset(AppImages.coinGif), Text("450 Z-coins")],
      ),
    );
  }
}
