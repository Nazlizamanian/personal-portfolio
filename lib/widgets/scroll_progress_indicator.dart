import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// An animated progress bar that shows scroll position.
class ScrollProgressIndicator extends StatelessWidget {
  final double progress;
  final double height;

  const ScrollProgressIndicator({
    super.key,
    required this.progress,
    this.height = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: AppTheme.primaryDark,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.accentBlue,
                AppTheme.accentGold,
                AppTheme.accentPink,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentGold.withValues(alpha: 0.5),
                blurRadius: 8,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A floating indicator showing which section you're in.
class SectionIndicatorDots extends StatelessWidget {
  final int totalSections;
  final int currentSection;
  final Function(int)? onDotTap;

  const SectionIndicatorDots({
    super.key,
    required this.totalSections,
    required this.currentSection,
    this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.dividerColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(totalSections, (index) {
          final isActive = index == currentSection;
          return Padding(
            padding: EdgeInsets.only(bottom: index < totalSections - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: onDotTap != null ? () => onDotTap!(index) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                width: isActive ? 12 : 8,
                height: isActive ? 12 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? AppTheme.accentGold : AppTheme.textMuted.withValues(alpha: 0.3),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppTheme.accentGold.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

