import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';
import '../widgets/glowing_timeline.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection>
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

  static const List<TimelineItem> _experiences = [
    TimelineItem(
      title: '',
      subtitle: 'Spotify',
      description: '',
      period: 'Jun 2025 - Present',
      location: 'Headquarters, Stockholm, Sweden',
      link: 'https://www.spotify.com/',
      linkText: 'Spotify',
      subRoles: [
        SubRole(
          title: 'iOS Engineer (ETP)',
          period: 'Sep 2025 - Present',
          description:
              'Focusing on Apple Watch development and wearable experiences. '
              'Building and maintaining watchOS applications using SwiftUI, UIKit, and Combine frameworks. '
              'Developing reactive and performant user interfaces while ensuring seamless integration with the Spotify ecosystem. '
              'Contributing to architecture decisions and implementing best practices for watchOS development.',
        ),
        SubRole(
          title: 'Software Engineering Intern (Embedded Car Platforms)',
          period: 'Jun 2025 - Aug 2025',
          description:
              'Part of a team focused on embedded car platforms and in-car user experience. '
              'Built and enhanced software solutions using Kotlin and Android technologies. '
              'Implemented comprehensive E2E testing with Espresso and AI-powered testing methodologies. '
              'Refactored the settings page to improve usability and collaborated on Android layouts '
              'to deliver responsive, intuitive user interfaces which made it into the release.',
        ),
      ],
    ),
    TimelineItem(
      title: 'Software Engineering Intern',
      subtitle: 'Albia Sweden AB',
      description:
          'Worked on a customizable cloud solution designed to enhance communication '
          'between companies and their customers. Worked with NoSQL databases and '
          'ensured the application was responsive.',
      period: 'Apr 2024 - May 2024',
      location: 'Jönköping, Sweden',
      link: 'https://www.albia.se/',
      linkText: 'Albia',
    ),
    TimelineItem(
      title: 'Event & Operations Coordinator',
      subtitle: 'O\'Learys Mall Of Scandinavia',
      description:
          'Responsible for planning and coordinating all events, conferences, pentathlons '
          'and other activities. Maintained operational oversight of key departments including '
          'bar and event organization. Handled administrative tasks and served as primary liaison '
          'between customers and staff. Supervised daily operations and ensured compliance with '
          'health and safety regulations to maintain a high-quality guest experience.',
      period: 'Apr 2016 - Jan 2020',
      location: 'Stockholm, Sweden',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);

    return VisibilityDetector(
      key: const Key('experience-section'),
      onVisibilityChanged: _onVisibilityChanged,
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
              title: 'Experience',
              subtitle: 'My professional journey',
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
                      child: const GlowingTimeline(items: _experiences),
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
}
