import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_extensions.dart';

/// "English ▼  [swap]  Swahili ▼" bar from the spec's Home Screen.
class LanguageBar extends StatelessWidget {
  final String sourceLang;
  final String targetLang;
  final ValueChanged<String> onSourceChanged;
  final ValueChanged<String> onTargetChanged;
  final VoidCallback onSwap;

  const LanguageBar({
    super.key,
    required this.sourceLang,
    required this.targetLang,
    required this.onSourceChanged,
    required this.onTargetChanged,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colors.outline),
      ),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              label: 'Source language: ${sourceLang == AppConstants.langEnglish ? context.l10n.english : context.l10n.swahili}',
              child: _LanguageDropdown(value: sourceLang, onChanged: onSourceChanged),
            ),
          ),
          Container(
            height: 32,
            width: 32,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Semantics(
              label: context.l10n.swapLanguages,
              button: true,
              child: IconButton.filledTonal(
                onPressed: onSwap,
                icon: const Icon(Icons.swap_horiz, size: 18),
                tooltip: context.l10n.swapLanguages,
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  backgroundColor: context.colors.primary.withValues(alpha: 0.1),
                  foregroundColor: context.colors.primary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Semantics(
              label: 'Target language: ${targetLang == AppConstants.langEnglish ? context.l10n.english : context.l10n.swahili}',
              child: _LanguageDropdown(value: targetLang, onChanged: onTargetChanged),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _LanguageDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        alignment: Alignment.center,
        icon: Icon(Icons.keyboard_arrow_down, size: 18, color: context.colors.primary),
        onChanged: (v) => v == null ? null : onChanged(v),
        items: AppConstants.languageNames.entries
            .map((e) {
              final itemLabel = e.key == AppConstants.langEnglish ? context.l10n.english : context.l10n.swahili;
              return DropdownMenuItem(
                value: e.key,
                child: Center(
                  child: Text(
                    itemLabel.toUpperCase(),
                    style: context.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.primary,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              );
            })
            .toList(),
      ),
    );
  }
}
