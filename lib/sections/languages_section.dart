import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';

class LanguageData {
  final String language;
  final String level;
  final String cefrLevel;
  final double proficiency;
  final String flag;

  const LanguageData({
    required this.language,
    required this.level,
    required this.cefrLevel,
    required this.proficiency,
    required this.flag,
  });
}

class LanguagesSection extends StatefulWidget {
  const LanguagesSection({super.key});

  @override
  State<LanguagesSection> createState() => _LanguagesSectionState();
}

class _LanguagesSectionState extends State<LanguagesSection> {
  bool _isVisible = false;

  static const List<LanguageData> _languages = [
    LanguageData(
      language: 'Swedish',
      level: 'Native',
      cefrLevel: 'C2',
      proficiency: 1.0,
      flag: '🇸🇪',
    ),
    LanguageData(
      language: 'English',
      level: 'Native',
      cefrLevel: 'C2',
      proficiency: 1.0,
      flag: '🇬🇧',
    ),
    LanguageData(
      language: 'Persian',
      level: 'Professional',
      cefrLevel: 'B2',
      proficiency: 0.75,
      flag: '🇮🇷',
    ),
    LanguageData(
      language: 'Greek',
      level: 'Basic',
      cefrLevel: 'A2',
      proficiency: 0.3,
      flag: '🇬🇷',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);
    final isDesktop = AppTheme.isDesktop(context);

    return VisibilityDetector(
      key: const Key('languages-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.getHorizontalPadding(context),
          vertical: isMobile ? 60 : 100,
        ),
        decoration: BoxDecoration(
          color: AppTheme.secondaryDark.withValues(alpha: 0.5),
        ),
        child: Column(
          children: [
            const SectionHeader(
              title: 'Languages',
              subtitle: 'Communication across cultures',
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: AppTheme.getMaxContentWidth(context),
              ),
              child: isDesktop
                  ? _buildDesktopLayout(context)
                  : _buildMobileLayout(context, isMobile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _languages
          .asMap()
          .entries
          .map((entry) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _LanguageCard(
                    language: entry.value,
                    isMobile: false,
                    startAnimation: _isVisible,
                    animationDelay: entry.key * 150,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildMobileLayout(BuildContext context, bool isMobile) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: _languages
          .asMap()
          .entries
          .map((entry) => SizedBox(
                width: isMobile
                    ? MediaQuery.of(context).size.width * 0.42
                    : 200,
                child: _LanguageCard(
                  language: entry.value,
                  isMobile: isMobile,
                  startAnimation: _isVisible,
                  animationDelay: entry.key * 150,
                ),
              ))
          .toList(),
    );
  }
}

class _LanguageCard extends StatefulWidget {
  final LanguageData language;
  final bool isMobile;
  final bool startAnimation;
  final int animationDelay;

  const _LanguageCard({
    required this.language,
    required this.isMobile,
    required this.startAnimation,
    this.animationDelay = 0,
  });

  @override
  State<_LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<_LanguageCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _hasAnimated = false;
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.language.proficiency,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void didUpdateWidget(covariant _LanguageCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startAnimation && !_hasAnimated) {
      _hasAnimated = true;
      Future.delayed(Duration(milliseconds: widget.animationDelay), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final circleSize = widget.isMobile ? 100.0 : 120.0;
    final levelColor = _getLevelColor(widget.language.level);
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()..scale(_isHovered ? 1.03 : 1.0),
        transformAlignment: Alignment.center,
        padding: EdgeInsets.all(widget.isMobile ? 20 : 28),
        decoration: BoxDecoration(
          color: _isHovered ? AppTheme.cardDark : AppTheme.cardDark.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isHovered
                ? levelColor.withValues(alpha: 0.5)
                : AppTheme.dividerColor,
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: levelColor.withValues(alpha: 0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular progress with flag in center
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                final strokeWidth = widget.isMobile ? 6.0 : 8.0;
                return SizedBox(
                  width: circleSize,
                  height: circleSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background circle using CustomPaint for consistent alignment
                      SizedBox(
                        width: circleSize,
                        height: circleSize,
                        child: CustomPaint(
                          painter: _CircularBackgroundPainter(
                            color: AppTheme.dividerColor.withValues(alpha: 0.5),
                            strokeWidth: strokeWidth,
                          ),
                        ),
                      ),
                      // Progress circle
                      SizedBox(
                        width: circleSize,
                        height: circleSize,
                        child: CustomPaint(
                          painter: _CircularProgressPainter(
                            progress: _progressAnimation.value,
                            color: levelColor,
                            strokeWidth: strokeWidth,
                            glowColor: _isHovered ? levelColor.withValues(alpha: 0.4) : null,
                          ),
                        ),
                      ),
                      // Flag and percentage in center
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.language.flag,
                            style: TextStyle(fontSize: widget.isMobile ? 28 : 36),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${(_progressAnimation.value * 100).toInt()}%',
                            style: TextStyle(
                              color: levelColor,
                              fontSize: widget.isMobile ? 14 : 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // Language name
            Text(
              widget.language.language,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: widget.isMobile ? 16 : 18,
                    fontWeight: FontWeight.w700,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Level with CEFR badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: levelColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: levelColor.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                '${widget.language.level} (${widget.language.cefrLevel})',
                style: TextStyle(
                  color: levelColor,
                  fontSize: widget.isMobile ? 11 : 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'Native':
        return AppTheme.accentGold;
      case 'Professional':
        return AppTheme.accentPink;
      case 'Basic':
        return AppTheme.accentBlue;
      default:
        return AppTheme.textSecondary;
    }
  }
}

// Custom painter for circular progress with gradient and glow
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;
  final Color? glowColor;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Don't draw anything if progress is too small
    if (progress < 0.01) return;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final sweepAngle = 2 * math.pi * progress;
    const startAngle = -math.pi / 2;

    // Draw glow effect if hovered
    if (glowColor != null && progress > 0.05) {
      final glowPaint = Paint()
        ..color = glowColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 8
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        glowPaint,
      );
    }

    // Draw progress arc with solid color (avoiding shader issues)
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );

    // Draw end cap glow
    if (progress > 0.05) {
      final endAngle = startAngle + sweepAngle;
      final endPoint = Offset(
        center.dx + radius * math.cos(endAngle),
        center.dy + radius * math.sin(endAngle),
      );
      
      final capGlowPaint = Paint()
        ..color = color.withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      
      canvas.drawCircle(endPoint, strokeWidth / 2, capGlowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || 
           oldDelegate.color != color ||
           oldDelegate.glowColor != glowColor;
  }
}

// Custom painter for background circle (ensures alignment with progress)
class _CircularBackgroundPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _CircularBackgroundPainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _CircularBackgroundPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}

