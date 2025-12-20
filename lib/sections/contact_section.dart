import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
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

    return VisibilityDetector(
      key: const Key('contact-section'),
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
              title: 'Get In Touch',
              subtitle: 'Let\'s work together',
            ),
            AnimatedBuilder(
              animation: _entranceController,
              builder: (context, child) {
                return Transform.translate(
                  offset: _slideIn.value,
                  child: Opacity(
                    opacity: _fadeIn.value,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: AppTheme.getMaxContentWidth(context),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'I\'m always open to discussing new projects, creative ideas, '
                            'or opportunities to be part of your vision. Feel free to reach out!',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: isMobile ? 16 : 18,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 48),
                          // Social links with staggered animation
                          _buildSocialLinks(context),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLinks(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        _SocialButton(
          icon: FontAwesomeIcons.envelope,
          label: 'Email',
          iconSize: 28,
          onTap: () => _launchUrl('mailto:nazlizamanian@gmail.com'),
        ),
        _SocialButton(
          icon: FontAwesomeIcons.github,
          label: 'GitHub',
          iconSize: 28,
          onTap: () => _launchUrl('https://github.com/Nazlizamanian'),
        ),
        _SocialButton(
          icon: FontAwesomeIcons.linkedin,
          label: 'LinkedIn',
          iconSize: 28,
          onTap: () => _launchUrl('https://linkedin.com/in/nazlizamanian'),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _SocialButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double iconSize;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconSize = 18,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            color: AppTheme.accentGold,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentGold.withValues(alpha: _isHovered ? 0.5 : 0.25),
                blurRadius: _isHovered ? 20 : 10,
                spreadRadius: _isHovered ? 2 : 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                widget.icon,
                color: AppTheme.primaryDark,
                size: widget.iconSize,
              ),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: const TextStyle(
                  color: AppTheme.primaryDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

