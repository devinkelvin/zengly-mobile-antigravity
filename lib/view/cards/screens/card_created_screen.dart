import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/utils.dart';
import '../../view.dart';

class CardCreatedScreen extends ConsumerWidget {
  const CardCreatedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.close),
        ),
      ),
      body: Padding(
        padding: AppDimensions.viewPadding,
        child: CardSuccessWidget(
          title: "Dollar Card Created",
          subTitle:
              "You are about to pay for a Prime Dollar Card, this will be debited from your Zed Wallet.",
        ),
      ),
    );
  }
}
