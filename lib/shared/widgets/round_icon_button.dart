import 'package:flutter/material.dart';

/// The small circular action buttons seen throughout the spec's Home
/// Screen wireframe (mic, copy, share, favorite, speak...).
class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? background;
  final Color? foreground;
  final double size;
  final String? tooltip;
  final bool filled;

  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.background,
    this.foreground,
    this.size = 38,
    this.tooltip,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = background ?? (filled ? scheme.secondaryContainer : Colors.transparent);
    final fg = foreground ?? scheme.onSecondaryContainer;

    final btn = Semantics(
      label: tooltip,
      button: true,
      enabled: onPressed != null,
      child: Material(
        color: bg,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            height: size,
            width: size,
            child: Icon(icon, size: size * 0.5, color: fg),
          ),
        ),
      ),
    );

    return tooltip != null ? Tooltip(message: tooltip!, child: btn) : btn;
  }
}
