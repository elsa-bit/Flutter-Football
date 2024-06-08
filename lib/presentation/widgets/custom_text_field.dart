import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/config/app_themes.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final String? error;
  final Function(String)? onChanged;
  final String labelText;
  final bool obscureText;
  final Widget? icon;

  const CustomTextField({
    Key? key,
    this.hint,
    this.controller,
    this.error,
    this.onChanged,
    this.obscureText = false,
    this.icon,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        errorText: error,
        hintText: hint,
        prefixIcon: icon,
        hintStyle: AppTextStyle.small,
        filled: true,
        fillColor: currentAppColors.primaryVariantColor2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.yellow, width: 2),
        ),
      ),
      controller: controller,
      obscureText: obscureText,
      enableSuggestions: false,
      autocorrect: false,
      onChanged: onChanged,
    );
  }
}
