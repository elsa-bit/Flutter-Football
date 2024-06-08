import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';

class Loader extends StatelessWidget {

  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: AppColors.black.withOpacity(0.80),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

}