import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);

    return Container(
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
          Container(
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
                // Social links
                _buildSocialLinks(context),
              ],
            ),
          ),
        ],
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
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            color: _isHovered ? AppTheme.accentGold : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppTheme.accentGold,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                widget.icon,
                color: _isHovered ? AppTheme.primaryDark : AppTheme.accentGold,
                size: widget.iconSize,
              ),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: TextStyle(
                  color:
                      _isHovered ? AppTheme.primaryDark : AppTheme.accentGold,
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

