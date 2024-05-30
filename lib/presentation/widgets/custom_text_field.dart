import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_themes.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final String labelText;
  final bool obscureText;

  const CustomTextField({
    Key? key,
    this.hint,
    this.obscureText = false,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hint,
        hintStyle: AppTextStyle.small,
      ),
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
    );
  }
}
