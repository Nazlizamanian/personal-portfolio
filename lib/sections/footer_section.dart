import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);
    final year = DateTime.now().year;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.getHorizontalPadding(context),
        vertical: isMobile ? 32 : 48,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.primaryDark,
        border: Border(
          top: BorderSide(
            color: AppTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Decorative element
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 1,
                color: AppTheme.dividerColor,
              ),
              const SizedBox(width: 16),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentGold,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 40,
                height: 1,
                color: AppTheme.dividerColor,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Copyright
          Text(
            '$year Nazli Zamanian. All rights reserved.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMuted,
                  letterSpacing: 1,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Built with text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Built with ',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMuted,
                    ),
              ),
              const Icon(
                Icons.favorite,
                size: 14,
                color: AppTheme.accentGold,
              ),
              Text(
                ' using Flutter',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMuted,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

