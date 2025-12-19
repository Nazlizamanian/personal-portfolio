import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);

    return Column(
      children: [
        // Decorative line
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isMobile ? 40 : 60,
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppTheme.accentGold.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accentGold,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentGold.withValues(alpha: 0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: isMobile ? 40 : 60,
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.accentGold.withValues(alpha: 0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Title
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: isMobile ? 28 : 36,
                letterSpacing: 6,
                fontWeight: FontWeight.w300,
              ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textMuted,
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 48),
      ],
    );
  }
}


