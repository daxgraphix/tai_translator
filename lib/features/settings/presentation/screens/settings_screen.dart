import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final onlineEnabled = ref.watch(onlineTranslationEnabledProvider);
    final apiKeyAsync = ref.watch(groqApiKeyProvider);
    final apiKey = apiKeyAsync.valueOrNull ?? '';
    final speed = ref.watch(voiceSpeedProvider);
    final pitch = ref.watch(voicePitchProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settings)),
      body: ListView(
        children: [
          _SectionHeader(context.l10n.appearance),
          RadioGroup<ThemeMode>(
            groupValue: themeMode,
            onChanged: (m) => m == null ? null : ref.read(themeModeProvider.notifier).set(m),
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: Text(context.l10n.systemDefault),
                  value: ThemeMode.system,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(context.l10n.light),
                  value: ThemeMode.light,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(context.l10n.dark),
                  value: ThemeMode.dark,
                ),
              ],
            ),
          ),
          const Divider(),
          _SectionHeader(context.l10n.translation),
          SwitchListTile(
            title: Text(context.l10n.onlineTranslation),
            subtitle: Text(context.l10n.onlineTranslationDesc),
            value: onlineEnabled,
            onChanged: (v) => ref.read(onlineTranslationEnabledProvider.notifier).set(v),
          ),
          ListTile(
            title: Text(context.l10n.groqApiKey),
            subtitle: Text(apiKey.isEmpty ? context.l10n.notSet : '•' * 10 + (apiKey.length > 4 ? apiKey.substring(apiKey.length - 4) : '')),
            trailing: const Icon(Icons.edit_outlined),
            onTap: () => _editApiKey(context, ref, apiKey),
          ),
          const Divider(),
          _SectionHeader(context.l10n.voice),
          ListTile(
            title: Text(context.l10n.speechRate),
            subtitle: Slider(
              value: speed,
              min: 0.1,
              max: 1.0,
              onChanged: (v) => ref.read(voiceSpeedProvider.notifier).set(v),
            ),
          ),
          ListTile(
            title: Text(context.l10n.pitch),
            subtitle: Slider(
              value: pitch,
              min: 0.5,
              max: 2.0,
              onChanged: (v) => ref.read(voicePitchProvider.notifier).set(v),
            ),
          ),
          const Divider(),
          _SectionHeader(context.l10n.privacyAbout),
          ListTile(
            leading: const Icon(Icons.shield_outlined),
            title: Text(context.l10n.noTracking),
            subtitle: Text(context.l10n.privacyDesc),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text(AppConstants.appName),
            subtitle: Text('${AppConstants.appTagline} · Community Edition · v1.0.0'),
          ),
        ],
      ),
    );
  }

  void _editApiKey(BuildContext context, WidgetRef ref, String current) {
    final controller = TextEditingController(text: current);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.groqApiKey),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(hintText: 'gsk_...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.cancel)),
          FilledButton(
            onPressed: () {
              ref.read(groqApiKeyProvider.notifier).set(controller.text.trim());
              Navigator.pop(ctx);
              context.showSnack(context.l10n.apiKeySaved);
            },
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
  }
}

class RadioGroup<T> extends StatelessWidget {
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final Widget child;

  const RadioGroup({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return _RadioGroupScope(
      groupValue: groupValue,
      onChanged: onChanged,
      child: child,
    );
  }
}

class _RadioGroupScope<T> extends InheritedWidget {
  final T groupValue;
  final ValueChanged<T?> onChanged;

  const _RadioGroupScope({
    required this.groupValue,
    required this.onChanged,
    required super.child,
  });

  static _RadioGroupScope<T>? of<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_RadioGroupScope<T>>();
  }

  @override
  bool updateShouldNotify(_RadioGroupScope<T> oldWidget) {
    return oldWidget.groupValue != groupValue;
  }
}

class RadioListTile<T> extends StatelessWidget {
  final Widget title;
  final T value;

  const RadioListTile({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final scope = _RadioGroupScope.of<T>(context);
    final isSelected = scope?.groupValue == value;

    return ListTile(
      title: title,
      leading: Radio<T>(
        value: value,
      ),
      onTap: () => scope?.onChanged(value),
      selected: isSelected,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700),
      ),
    );
  }
}
