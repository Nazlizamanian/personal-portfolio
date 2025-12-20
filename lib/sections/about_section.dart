import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
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
          if (isMobile)
            _buildMobileLayout(context)
          else
            _buildDesktopLayout(context, screenWidth),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _AnimatedProfileImage(
          size: 180,
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

    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, I\'m',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.accentGold,
                letterSpacing: 2,
              ),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 8),
        // Animated wave color name
        _WaveColorText(
          text: 'Nazli Zamanian',
          animation: _waveController,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: isMobile ? 36 : 48,
                fontWeight: FontWeight.w600,
              ),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 8),
        Text(
          'Software Engineer',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w400,
              ),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 24),
        Text(
          'I am a passionate software engineer with expertise in building '
          'cross-platform applications. With a keen eye for design and a love '
          'for clean code, I create digital experiences that are both beautiful '
          'and functional. My journey in tech has been driven by curiosity and '
          'a constant desire to learn and innovate.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
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
        return Row(
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
        );
      },
    );
  }
}

