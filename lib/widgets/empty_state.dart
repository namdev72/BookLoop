import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';

class EmptyState extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 64)),
              const SizedBox(height: 20),
              Text(title,
                  style: AppTextStyles.headlineMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text(subtitle,
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
