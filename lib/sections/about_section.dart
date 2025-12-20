import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _entranceController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOut),
    );

    _slideIn = Tween<Offset>(
      begin: const Offset(0, 40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_hasAnimated && info.visibleFraction > 0.2) {
      _hasAnimated = true;
      _entranceController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);
    final isTablet = AppTheme.isTablet(context);
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Use mobile/stacked layout for screens under 900px
    final useStackedLayout = isMobile || isTablet || screenWidth < 900;

    return VisibilityDetector(
      key: const Key('about-section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.getHorizontalPadding(context),
          vertical: isMobile ? 60 : 100,
        ),
        child: Column(
          children: [
            const SectionHeader(
              title: 'About Me',
              subtitle: 'Crafting digital experiences with passion',
            ),
            AnimatedBuilder(
              animation: _entranceController,
              builder: (context, child) {
                return Transform.translate(
                  offset: _slideIn.value,
                  child: Opacity(
                    opacity: _fadeIn.value,
                    child: useStackedLayout
                        ? _buildMobileLayout(context)
                        : _buildDesktopLayout(context, screenWidth),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);
    final profileSize = isMobile ? 180.0 : 220.0; // Larger on tablet
    
    return Column(
      children: [
        _AnimatedProfileImage(
          size: profileSize,
          animation: _waveController,
        ),
        const SizedBox(height: 40),
        _buildAboutContent(context),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, double screenWidth) {
    return Container(
      constraints: BoxConstraints(maxWidth: AppTheme.getMaxContentWidth(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AnimatedProfileImage(
            size: 280,
            animation: _waveController,
          ),
          const SizedBox(width: 60),
          Expanded(child: _buildAboutContent(context)),
        ],
      ),
    );
  }

  Widget _buildAboutContent(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);
    final isTablet = AppTheme.isTablet(context);
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Use stacked/centered layout for smaller screens
    final useCenteredLayout = isMobile || isTablet || screenWidth < 900;
    
    // Responsive font size for the name
    double nameFontSize;
    if (isMobile) {
      nameFontSize = 32;
    } else if (screenWidth < 900) {
      nameFontSize = 40;
    } else {
      nameFontSize = 48;
    }

    return Column(
      crossAxisAlignment:
          useCenteredLayout ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, I\'m',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.accentGold,
                letterSpacing: 2,
              ),
          textAlign: useCenteredLayout ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 8),
        // Animated wave color name with responsive sizing
        _WaveColorText(
          text: 'Nazli Zamanian',
          animation: _waveController,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: nameFontSize,
                fontWeight: FontWeight.w600,
              ),
          textAlign: useCenteredLayout ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 8),
        Text(
          'Software Engineer',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w400,
              ),
          textAlign: useCenteredLayout ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 24),
        Container(
          constraints: BoxConstraints(
            maxWidth: useCenteredLayout ? 600 : double.infinity,
          ),
          child: Text(
            'I am a passionate software engineer with expertise in building '
            'cross-platform applications. With a keen eye for design and a love '
            'for clean code, I create digital experiences that are both beautiful '
            'and functional. My journey in tech has been driven by curiosity and '
            'a constant desire to learn and innovate.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: useCenteredLayout ? TextAlign.center : TextAlign.start,
          ),
        ),
      ],
    );
  }
}

// Animated profile image with wave color border
class _AnimatedProfileImage extends StatelessWidget {
  final double size;
  final Animation<double> animation;

  static const List<Color> _colors = [
    Color(0xFF9D4EDD),  // Purple
    Color(0xFFB76EF0),  // Light purple
    Color(0xFFE879A9),  // Pink
    Colors.white,       // White
  ];

  const _AnimatedProfileImage({
    required this.size,
    required this.animation,
  });

  Color _getColorForAnimation(double animValue) {
    final colorIndex = (animValue * (_colors.length - 1)).floor();
    final nextColorIndex = (colorIndex + 1).clamp(0, _colors.length - 1);
    final t = (animValue * (_colors.length - 1)) - colorIndex;
    return Color.lerp(_colors[colorIndex], _colors[nextColorIndex], t) ?? _colors[0];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final color = _getColorForAnimation(animation.value);
        return Container(
          width: size + 10,
          height: size + 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/profile-photo.jpg',
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppTheme.cardDark,
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: size * 0.5,
                      color: color.withValues(alpha: 0.5),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// Wave color text widget for animated letter colors
class _WaveColorText extends StatelessWidget {
  final String text;
  final Animation<double> animation;
  final TextStyle? style;
  final TextAlign? textAlign;

  static const List<Color> _colors = [
    Color(0xFF9D4EDD),  // Purple
    Color(0xFFB76EF0),  // Light purple
    Color(0xFFE879A9),  // Pink
    Colors.white,       // White
    Color(0xFFE879A9),  // Pink
    Color(0xFFB76EF0),  // Light purple
  ];

  const _WaveColorText({
    required this.text,
    required this.animation,
    this.style,
    this.textAlign,
  });

  Color _getColorForIndex(int index, double animValue) {
    // Create smoother wave effect with sine curve
    final offset = index / text.length * 0.5;
    final wave = (animValue + offset) % 1.0;
    final smoothWave = (math.sin(wave * math.pi * 2) + 1) / 2;
    
    // Map wave position to color
    final colorIndex = (smoothWave * (_colors.length - 1)).floor();
    final nextColorIndex = (colorIndex + 1).clamp(0, _colors.length - 1);
    final t = (smoothWave * (_colors.length - 1)) - colorIndex;
    
    return Color.lerp(_colors[colorIndex], _colors[nextColorIndex], t) ?? _colors[0];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Use FittedBox to prevent overflow and scale down if needed
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: textAlign == TextAlign.center 
              ? Alignment.center 
              : Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: textAlign == TextAlign.center 
                ? MainAxisAlignment.center 
                : MainAxisAlignment.start,
            children: List.generate(text.length, (index) {
              final char = text[index];
              if (char == ' ') {
                return SizedBox(width: (style?.fontSize ?? 16) * 0.3);
              }
              return Text(
                char,
                style: style?.copyWith(
                  color: _getColorForIndex(index, animation.value),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

