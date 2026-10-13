import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../data/data.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(height: 140, width: double.infinity),
              SizedBox(
                height: 70,
                width: 70,
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).colorScheme.onSurface,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Center(child: SvgPicture.asset(AppImages.zenglyIcon)),
              Positioned(
                bottom: 0,
                child: DefaultTextStyle(
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),

                  child: Text(
                    "One moment, Good things take time…",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
