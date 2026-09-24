import 'package:flutter/material.dart';

/// Generic labeled dropdown, styled to match [AppTextField].
///
/// Example:
/// ```dart
/// AppDropdown<String>(
///   label: 'Role',
///   value: selectedRole,
///   items: const ['user', 'provider', 'admin'],
///   itemLabelBuilder: (r) => r,
///   onChanged: (value) => setState(() => selectedRole = value),
/// )
/// ```
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
    this.label,
    this.hint,
    this.value,
    this.validator,
    this.enabled = true,
    super.key,
  });

  final String? label;
  final String? hint;
  final T? value;
  final List<T> items;
  final String Function(T item) itemLabelBuilder;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabelBuilder(item)),
            ),
          )
          .toList(),
      onChanged: enabled ? onChanged : null,
      validator: validator,
    );
  }
}
