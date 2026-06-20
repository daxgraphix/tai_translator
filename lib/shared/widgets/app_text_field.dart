import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLines = 6,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      maxLines: maxLines,
      minLines: 1,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
