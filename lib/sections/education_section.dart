import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';
import '../widgets/glowing_timeline.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  static const List<TimelineItem> _education = [
    TimelineItem(
      title: 'Bachelor\'s Degree in Computer Engineering',
      subtitle: 'Jönköping University, Tekniska högskolan',
      description:
          'Degree of Bachelor of Science in Computer Engineering with specialization in Software Engineering and Mobile Platforms. '
          'The education is largely based on projects and exercises that provide practical experience. '
          'Focus on understanding how computers work, computer networks structure, and fundamentals of computer science and mathematics. '
          'Deep dive into mobile device development, web development, and computer networks. '
          'Technologies: C, C++, SQL, algorithms and data structures, OOP principles, networking concepts, Windows OS, HTML, CSS, and JavaScript.',
      period: '2022 - 2025',
      link: 'https://ju.se/studera/valj-utbildning/program/program-pa-grundniva/datateknik--mjukvaruutveckling-och-mobila-plattformar-ht2025-52558.html',
      linkText: 'Jönköping University',
    ),
    TimelineItem(
      title: 'Industrial IoT Software Development',
      subtitle: 'EC Utbildning Yrkeshögskola',
      description:
          'Vocational Higher Education Degree in Industrial IoT Software Development. '
          'Comprehensive training in software development with a focus on IoT applications. '
          'In-depth understanding of the integration of software solutions in industrial environments, '
          'including automation systems, connected devices, and data-driven decision-making processes.',
      period: '2020 - 2022',
    ),
    TimelineItem(
      title: 'Natural Science Programme',
      subtitle: 'Internationella Engelska Gymnasiet Södermalm (IEGS)',
      description:
          'High school degree in natural science programme with specialization in social science. '
          'Emphasis on research, analysis, and communication skills within natural sciences, mathematics, and interdisciplinary connections. '
          'Core concepts in scientific method awareness, language proficiency for scientific communication, '
          'and cohesive knowledge integration in biology, chemistry, physics, and social sciences.',
      period: '2017 - 2020',
    ),
  ];

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
            title: 'Education',
            subtitle: 'Academic background',
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: AppTheme.getMaxContentWidth(context),
            ),
            child: const GlowingTimeline(items: _education, isEducation: true),
          ),
        ],
      ),
    );
  }
}

