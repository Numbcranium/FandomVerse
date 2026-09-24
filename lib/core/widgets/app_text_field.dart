import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// A configurable text field wrapping [TextFormField] with the app's
/// standard decoration.
///
/// Use the default constructor for plain fields, [AppTextField.password]
/// for a field with a show/hide toggle, and [AppTextField.search] for a
/// pill-shaped search input.
class AppTextField extends StatefulWidget {
  const AppTextField({
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.onChanged,
    this.autofocus = false,
    super.key,
  })  : _isPassword = false,
        _isSearch = false;

  const AppTextField.password({
    this.label = 'Password',
    this.hint,
    this.controller,
    this.validator,
    this.textInputAction,
    this.enabled = true,
    this.onChanged,
    this.autofocus = false,
    super.key,
  })  : keyboardType = TextInputType.visiblePassword,
        prefixIcon = Icons.lock_outline,
        suffixIcon = null,
        maxLines = 1,
        _isPassword = true,
        _isSearch = false;

  const AppTextField.search({
    this.hint = 'Search',
    this.controller,
    this.onChanged,
    this.enabled = true,
    this.autofocus = false,
    super.key,
  })  : label = null,
        validator = null,
        keyboardType = TextInputType.text,
        textInputAction = TextInputAction.search,
        prefixIcon = Icons.search,
        suffixIcon = null,
        maxLines = 1,
        _isPassword = false,
        _isSearch = true;

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool enabled;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  final bool _isPassword;
  final bool _isSearch;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      labelText: widget._isSearch ? null : widget.label,
      hintText: widget.hint,
      prefixIcon: widget.prefixIcon != null
          ? Icon(widget.prefixIcon, color: AppColors.textSecondary)
          : null,
      suffixIcon: widget._isPassword
          ? IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.textSecondary,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            )
          : (widget.suffixIcon != null ? Icon(widget.suffixIcon) : null),
      border: widget._isSearch
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(999),
              borderSide: const BorderSide(color: AppColors.border),
            )
          : null,
    );

    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget._isPassword && _obscure,
      enabled: widget.enabled,
      maxLines: widget._isPassword ? 1 : widget.maxLines,
      onChanged: widget.onChanged,
      autofocus: widget.autofocus,
      decoration: decoration,
    );
  }
}
