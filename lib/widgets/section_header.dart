import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../theme/app_theme.dart';

class SectionHeader extends StatefulWidget {
  final String title;
  final String? subtitle;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  State<SectionHeader> createState() => _SectionHeaderState();
}

class _SectionHeaderState extends State<SectionHeader>
    with TickerProviderStateMixin {
  late AnimationController _lineController;
  late AnimationController _textController;
  late AnimationController _pulseController;
  late Animation<double> _lineWidth;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    
    _lineController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _lineWidth = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _lineController, curve: Curves.easeOutCubic),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 20),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _lineController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_hasAnimated && info.visibleFraction > 0.3) {
      _hasAnimated = true;
      _lineController.forward();
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _textController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);
    final lineWidth = isMobile ? 40.0 : 60.0;

    return VisibilityDetector(
      key: Key('section-header-${widget.title}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Column(
        children: [
          // Animated decorative line
          AnimatedBuilder(
            animation: Listenable.merge([_lineController, _pulseController]),
            builder: (context, child) {
              final pulse = 0.5 + 0.5 * _pulseController.value;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: lineWidth * _lineWidth.value,
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
                  Transform.scale(
                    scale: 0.8 + 0.2 * _lineWidth.value,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.accentGold,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accentGold.withValues(alpha: 0.3 + 0.3 * pulse),
                            blurRadius: 8 + 8 * pulse,
                            spreadRadius: 1 + 2 * pulse,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: lineWidth * _lineWidth.value,
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
              );
            },
          ),
          const SizedBox(height: 24),
          // Animated title
          AnimatedBuilder(
            animation: _textController,
            builder: (context, child) {
              return Transform.translate(
                offset: _textSlide.value,
                child: Opacity(
                  opacity: _textFade.value,
                  child: Text(
                    widget.title.toUpperCase(),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: isMobile ? 28 : 36,
                          letterSpacing: 6,
                          fontWeight: FontWeight.w300,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: 12),
            AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _textSlide.value.dy * 1.2),
                  child: Opacity(
                    opacity: _textFade.value,
                    child: Text(
                      widget.subtitle!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textMuted,
                            fontStyle: FontStyle.italic,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ],
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}


