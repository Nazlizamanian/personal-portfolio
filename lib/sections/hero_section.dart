import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../theme/app_theme.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback? onExplorePressed;

  const HeroSection({super.key, this.onExplorePressed});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = AppTheme.isMobile(context);

    return Container(
      width: double.infinity,
      height: screenHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryDark,
            AppTheme.secondaryDark,
            AppTheme.primaryDark.withValues(alpha: 0.95),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background decorative elements
          _buildBackgroundDecorations(context),
          // Main content
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.getHorizontalPadding(context),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Animated greeting in multiple languages
                  SizedBox(
                    height: isMobile ? 36 : 44,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            "Hello I'm Nazli,",
                            textStyle: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: AppTheme.accentGold,
                                  letterSpacing: 2,
                                  fontSize: isMobile ? 20 : 28,
                                ),
                            speed: const Duration(milliseconds: 80),
                          ),
                          TypewriterAnimatedText(
                            'Γεια σας είμαι η Nazli,',
                            textStyle: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: AppTheme.accentGold,
                                  letterSpacing: 2,
                                  fontSize: isMobile ? 20 : 28,
                                ),
                            speed: const Duration(milliseconds: 80),
                          ),
                          TypewriterAnimatedText(
                            'Hej jag heter Nazli,',
                            textStyle: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: AppTheme.accentGold,
                                  letterSpacing: 2,
                                  fontSize: isMobile ? 20 : 28,
                                ),
                            speed: const Duration(milliseconds: 80),
                          ),
                          TypewriterAnimatedText(
                            'سلام من نازلی هستم',
                            textStyle: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: AppTheme.accentGold,
                                  letterSpacing: 2,
                                  fontSize: isMobile ? 20 : 28,
                                ),
                            speed: const Duration(milliseconds: 80),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Nazli Zamanian',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: isMobile ? 42 : 72,
                            fontWeight: FontWeight.w300,
                            letterSpacing: isMobile ? 2 : 6,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Role - static text
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Software Engineer',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            color: AppTheme.textSecondary,
                            letterSpacing: 2,
                          ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  // CTA Button
                  _ExploreButton(onPressed: onExplorePressed),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecorations(BuildContext context) {
    return Stack(
      children: [
        // Top left glow
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.accentGold.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Bottom right glow
        Positioned(
          bottom: -150,
          right: -150,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.accentGold.withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Grid pattern overlay
        Opacity(
          opacity: 0.03,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://www.transparenttextures.com/patterns/dark-geometric.png',
                ),
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExploreButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const _ExploreButton({this.onPressed});

  @override
  State<_ExploreButton> createState() => _ExploreButtonState();
}

class _ExploreButtonState extends State<_ExploreButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          decoration: BoxDecoration(
            color: _isHovered ? AppTheme.accentGold : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppTheme.accentGold,
              width: 2,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppTheme.accentGold.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Text(
            'EXPLORE MY WORK',
            style: TextStyle(
              color: _isHovered ? AppTheme.primaryDark : AppTheme.accentGold,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _ScrollIndicator extends StatefulWidget {
  @override
  State<_ScrollIndicator> createState() => _ScrollIndicatorState();
}

class _ScrollIndicatorState extends State<_ScrollIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Column(
            children: [
              Text(
                'SCROLL',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 10,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 24,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.textMuted,
                    width: 1.5,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      width: 4,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.accentGold,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

