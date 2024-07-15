
import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';

class MatchStatusWidget extends StatelessWidget {
  final String title;
  final Color? color;

  const MatchStatusWidget({super.key, required this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: AppColors.white,
        ),
      ),
    );
  }
}
