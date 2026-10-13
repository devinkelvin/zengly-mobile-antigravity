import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/locale/locale_controller.dart';
import '../../data/data.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  List<Map<String, String>> _languages(AppLocalizations l10n) => [
    {"name": "English", "label": l10n.english, "flag": AppImages.ukFlag},
    {"name": "French", "label": l10n.french, "flag": AppImages.franceFlag},
  ];

  void _selectLanguage(String name, String currentLanguage) {
    if (name == currentLanguage) return;
    final languages = _languages(AppLocalizations.of(context));
    final currentFlag =
        languages.firstWhere((l) => l["name"] == currentLanguage)["flag"]!;
    final newFlag = languages.firstWhere((l) => l["name"] == name)["flag"]!;
    AppOverlays.languageSwitchSheet(
      context: context,
      currentFlag: currentFlag,
      newFlag: newFlag,
      newLanguageName: name,
      onConfirm: () {
        ref.read(localeProvider.notifier).setLanguage(name);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languages = _languages(l10n);
    final locale = ref.watch(localeProvider);
    final currentLanguage = locale.languageCode == 'fr' ? "French" : "English";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.language,
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppDimensions.viewPadding,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(languages.length, (i) {
              final lang = languages[i];
              final isDefault = lang["name"] == currentLanguage;
              return Column(
                children: [
                  ListTile(
                    onTap:
                        () => _selectLanguage(lang["name"]!, currentLanguage),
                    leading: ClipOval(
                      child: Image.asset(
                        lang["flag"]!,
                        width: 28,
                        height: 28,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      lang["label"]!,
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: isDefault ? _defaultBadge(context, l10n) : null,
                  ),
                  if (i != languages.length - 1)
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _defaultBadge(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(AppImages.starIcon, width: 12, height: 12),
          SizedBox(width: 4),
          Text(
            l10n.defaultLabel,
            style: GoogleFonts.raleway(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
