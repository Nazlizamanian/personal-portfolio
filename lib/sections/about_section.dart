import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

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
        _buildProfileImage(context, 180),
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
          _buildProfileImage(context, 280),
          const SizedBox(width: 60),
          Expanded(child: _buildAboutContent(context)),
        ],
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.accentGold,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentGold.withValues(alpha: 0.3),
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
                  size: size * 0.8,
                  color: AppTheme.accentGold.withValues(alpha: 0.5),
                ),
              ),
            );
          },
        ),
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
        Text(
          'Nazli Zamanian',
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

