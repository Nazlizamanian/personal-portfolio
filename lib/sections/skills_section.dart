import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';

class SkillItem {
  final String name;
  final String icon;
  final String color;

  const SkillItem({
    required this.name,
    required this.icon,
    required this.color,
  });

  String get iconUrl => 'https://cdn.simpleicons.org/$icon/$color';
}

class SkillCategory {
  final String title;
  final IconData icon;
  final List<SkillItem> skills;

  const SkillCategory({
    required this.title,
    required this.icon,
    required this.skills,
  });
}

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  static const List<SkillCategory> _categories = [
    SkillCategory(
      title: 'Programming Languages',
      icon: Icons.code,
      skills: [
        SkillItem(name: 'Swift', icon: 'swift', color: 'F05138'),
        SkillItem(name: 'Kotlin', icon: 'kotlin', color: '7F52FF'),
        SkillItem(name: 'Dart', icon: 'dart', color: '0175C2'),
        SkillItem(name: 'Python', icon: 'python', color: '3776AB'),
        SkillItem(name: 'Java', icon: 'openjdk', color: 'ED8B00'),
        SkillItem(name: 'C++', icon: 'cplusplus', color: '00599C'),
        SkillItem(name: 'JavaScript', icon: 'javascript', color: 'F7DF1E'),
        SkillItem(name: 'HTML5', icon: 'html5', color: 'E34F26'),
        SkillItem(name: 'CSS3', icon: 'css3', color: '1572B6'),
      ],
    ),
    SkillCategory(
      title: 'Mobile Development',
      icon: Icons.phone_iphone,
      skills: [
        SkillItem(name: 'iOS', icon: 'apple', color: '000000'),
        SkillItem(name: 'Android', icon: 'android', color: '3DDC84'),
        SkillItem(name: 'Flutter', icon: 'flutter', color: '02569B'),
        SkillItem(name: 'SwiftUI', icon: 'swift', color: 'F05138'),
        SkillItem(name: 'Xcode', icon: 'xcode', color: '147EFB'),
        SkillItem(name: 'Android Studio', icon: 'androidstudio', color: '3DDC84'),
        SkillItem(name: 'Jetpack Compose', icon: 'jetpackcompose', color: '4285F4'),
      ],
    ),
    SkillCategory(
      title: 'Tools & Frameworks',
      icon: Icons.build,
      skills: [
        SkillItem(name: 'Git', icon: 'git', color: 'F05032'),
        SkillItem(name: 'GitHub', icon: 'github', color: '181717'),
        SkillItem(name: 'Firebase', icon: 'firebase', color: 'FFCA28'),
        SkillItem(name: 'Docker', icon: 'docker', color: '2496ED'),
        SkillItem(name: 'PostgreSQL', icon: 'postgresql', color: '4169E1'),
        SkillItem(name: 'MongoDB', icon: 'mongodb', color: '47A248'),
        SkillItem(name: 'VS Code', icon: 'visualstudiocode', color: '007ACC'),
      ],
    ),
    SkillCategory(
      title: 'Testing & DevOps',
      icon: Icons.verified,
      skills: [
        SkillItem(name: 'Unit Testing', icon: 'testinglibrary', color: 'E33332'),
        SkillItem(name: 'Espresso', icon: 'android', color: '3DDC84'),
        SkillItem(name: 'XCTest', icon: 'apple', color: '000000'),
        SkillItem(name: 'CI/CD', icon: 'githubactions', color: '2088FF'),
        SkillItem(name: 'Jira', icon: 'jira', color: '0052CC'),
      ],
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
            title: 'Technical Skills',
            subtitle: 'Technologies I work with',
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: AppTheme.getMaxContentWidth(context),
            ),
            child: Column(
              children: _categories
                  .map((category) => _SkillCategoryWidget(
                        category: category,
                        isMobile: isMobile,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillCategoryWidget extends StatelessWidget {
  final SkillCategory category;
  final bool isMobile;

  const _SkillCategoryWidget({
    required this.category,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.accentGold.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(
                  category.icon,
                  color: AppTheme.accentGold,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                category.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: isMobile ? 18 : 22,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Skill items
          Wrap(
            spacing: isMobile ? 12 : 16,
            runSpacing: isMobile ? 12 : 16,
            children: category.skills
                .map((skill) => _SkillChip(skill: skill, isMobile: isMobile))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatefulWidget {
  final SkillItem skill;
  final bool isMobile;

  const _SkillChip({
    required this.skill,
    required this.isMobile,
  });

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final rawColor = Color(int.parse('0xFF${widget.skill.color}'));
    // Use a light grey border for dark colors (like iOS, XCTest with black icons)
    final isDarkColor = rawColor.computeLuminance() < 0.2;
    final borderColor = isDarkColor 
        ? const Color(0xFF9E9E9E) // Light grey for dark icons
        : rawColor;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..scale(_isHovered ? 1.05 : 1.0),
        transformAlignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: widget.isMobile ? 14 : 18,
          vertical: widget.isMobile ? 10 : 12,
        ),
        decoration: BoxDecoration(
          color: AppTheme.cardDark.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor.withValues(alpha: 0.6),
            width: 1.5,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: borderColor.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon from Simple Icons CDN
            SizedBox(
              width: widget.isMobile ? 28 : 36,
              height: widget.isMobile ? 28 : 36,
              child: SvgPicture.network(
                widget.skill.iconUrl,
                width: widget.isMobile ? 28 : 36,
                height: widget.isMobile ? 28 : 36,
                placeholderBuilder: (context) => Icon(
                  Icons.code,
                  size: widget.isMobile ? 26 : 32,
                  color: rawColor,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Skill name
            Text(
              widget.skill.name,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: widget.isMobile ? 13 : 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
