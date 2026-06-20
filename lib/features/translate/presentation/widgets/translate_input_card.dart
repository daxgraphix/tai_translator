import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/round_icon_button.dart';

class TranslateInputCard extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onMic;
  final VoidCallback onCamera;
  final VoidCallback onPaste;

  const TranslateInputCard({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.onMic,
    required this.onCamera,
    required this.onPaste,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: context.colors.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    controller: controller,
                    hint: context.l10n.enterText,
                    onChanged: onChanged,
                    maxLines: 5,
                  ),
                ),
                if (controller.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: RoundIconButton(
                      icon: Icons.close,
                      onPressed: onClear,
                      filled: false,
                      size: 32,
                      foreground: context.colors.outline,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                _ActionButton(
                  icon: Icons.mic_none_rounded,
                  label: context.l10n.voice,
                  onPressed: onMic,
                ),
                const SizedBox(width: 12),
                _ActionButton(
                  icon: Icons.camera_alt_outlined,
                  label: context.l10n.camera,
                  onPressed: onCamera,
                ),
                const SizedBox(width: 12),
                _ActionButton(
                  icon: Icons.content_paste,
                  label: context.l10n.paste,
                  onPressed: onPaste,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filledTonal(
          onPressed: onPressed,
          icon: Icon(icon, size: 22, color: context.colors.primary),
          style: IconButton.styleFrom(
            backgroundColor: context.colors.primary.withValues(alpha: 0.1),
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colors.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
