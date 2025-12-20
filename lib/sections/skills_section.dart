import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';
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
              children: _categories.asMap().entries
                  .map((entry) => _SkillCategoryWidget(
                        category: entry.value,
                        isMobile: isMobile,
                        categoryIndex: entry.key,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillCategoryWidget extends StatefulWidget {
  final SkillCategory category;
  final bool isMobile;
  final int categoryIndex;

  const _SkillCategoryWidget({
    required this.category,
    required this.isMobile,
    this.categoryIndex = 0,
  });

  @override
  State<_SkillCategoryWidget> createState() => _SkillCategoryWidgetState();
}

class _SkillCategoryWidgetState extends State<_SkillCategoryWidget>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _skillsController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _skillsController = AnimationController(
      duration: Duration(milliseconds: 400 + widget.category.skills.length * 50),
      vsync: this,
    );

    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(-30, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _headerController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_hasAnimated && info.visibleFraction > 0.2) {
      _hasAnimated = true;
      Future.delayed(Duration(milliseconds: widget.categoryIndex * 150), () {
        if (mounted) {
          _headerController.forward();
          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted) _skillsController.forward();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('skill-category-${widget.category.title}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated category header
            AnimatedBuilder(
              animation: _headerController,
              builder: (context, child) {
                return Transform.translate(
                  offset: _headerSlide.value,
                  child: Opacity(
                    opacity: _headerFade.value,
                    child: Row(
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
                            widget.category.icon,
                            color: AppTheme.accentGold,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          widget.category.title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: widget.isMobile ? 18 : 22,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Staggered skill items
            AnimatedBuilder(
              animation: _skillsController,
              builder: (context, child) {
                return Wrap(
                  spacing: widget.isMobile ? 12 : 16,
                  runSpacing: widget.isMobile ? 12 : 16,
                  children: List.generate(widget.category.skills.length, (index) {
                    final staggerProgress = (_skillsController.value * widget.category.skills.length - index)
                        .clamp(0.0, 1.0);
                    final curvedProgress = Curves.easeOutCubic.transform(staggerProgress);
                    
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - curvedProgress)),
                      child: Opacity(
                        opacity: curvedProgress,
                        child: _SkillChip(
                          skill: widget.category.skills[index],
                          isMobile: widget.isMobile,
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
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
