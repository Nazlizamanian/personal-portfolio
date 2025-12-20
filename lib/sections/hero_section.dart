import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../theme/app_theme.dart';
import '../widgets/floating_particles.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback? onExplorePressed;

  const HeroSection({super.key, this.onExplorePressed});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _floatController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;
  late Animation<double> _nameScale;

  @override
  void initState() {
    super.initState();
    
    // Entrance animations
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.1, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _nameScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Subtle floating animation for the content
    _floatController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    // Start entrance animation
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _floatController.dispose();
    super.dispose();
  }

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
            const Color(0xFF070714),  
            const Color(0xFF0A0A1C),  
            const Color(0xFF0D0818),  
            AppTheme.secondaryDark,
          ],
          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Animated floating particles
          const Positioned.fill(
            child: FloatingParticles(
              particleCount: 20,
              minSize: 3.0,
              maxSize: 10.0,
            ),
          ),
          // Animated gradient mesh overlay
          const Positioned.fill(
            child: AnimatedGradientMesh(),
          ),
          // Background decorative elements with parallax
          _buildBackgroundDecorations(context),
          // Main content with entrance animation
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.getHorizontalPadding(context),
              ),
              child: AnimatedBuilder(
                animation: Listenable.merge([_entranceController, _floatController]),
                builder: (context, child) {
                  final floatOffset = math.sin(_floatController.value * math.pi) * 6;
                  return Transform.translate(
                    offset: Offset(0, floatOffset) + _slideUp.value,
                    child: Opacity(
                      opacity: _fadeIn.value,
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
                          // Name with scale animation
                          Transform.scale(
                            scale: _nameScale.value,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    AppTheme.textPrimary,
                                    AppTheme.textPrimary.withValues(alpha: 0.9),
                                    AppTheme.accentGoldLight.withValues(alpha: 0.7),
                                  ],
                                  stops: [
                                    0.0,
                                    0.7 + 0.3 * math.sin(_floatController.value * math.pi),
                                    1.0,
                                  ],
                                ).createShader(bounds),
                                child: Text(
                                  'Nazli Zamanian',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                        fontSize: isMobile ? 42 : 72,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: isMobile ? 2 : 6,
                                        color: Colors.white,
                                      ),
                                ),
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
                          _ExploreButton(onPressed: widget.onExplorePressed),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecorations(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final breathe = math.sin(_floatController.value * math.pi);
        return Stack(
          children: [
            // Top left blue glow - animated
            Positioned(
              top: -120 + breathe * 20,
              left: -120 + breathe * 15,
              child: Transform.scale(
                scale: 1.0 + breathe * 0.1,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.accentBlue.withValues(alpha: 0.12 + breathe * 0.03),
                        AppTheme.accentBlue.withValues(alpha: 0.04),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Bottom right purple glow - animated
            Positioned(
              bottom: -150 - breathe * 25,
              right: -150 - breathe * 20,
              child: Transform.scale(
                scale: 1.0 + breathe * 0.15,
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.accentGold.withValues(alpha: 0.12 + breathe * 0.04),
                        AppTheme.accentGoldLight.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Center-right accent - animated
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25 + breathe * 30,
              right: -80 + breathe * 10,
              child: Transform.scale(
                scale: 1.0 + breathe * 0.08,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.accentPink.withValues(alpha: 0.08 + breathe * 0.02),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Subtle animated grid lines
            Opacity(
              opacity: 0.015 + breathe * 0.005,
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
      },
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
          transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isHovered
                  ? [AppTheme.accentGoldLight, AppTheme.accentGold]
                  : [AppTheme.accentGold, AppTheme.accentGold],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentGold.withValues(alpha: _isHovered ? 0.6 : 0.3),
                blurRadius: _isHovered ? 24 : 12,
                spreadRadius: _isHovered ? 2 : 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            'EXPLORE MY WORK',
            style: TextStyle(
              color: AppTheme.primaryDark,
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


