import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../sections/hero_section.dart';
import '../sections/about_section.dart';
import '../sections/experience_section.dart';
import '../sections/education_section.dart';
import '../sections/projects_section.dart';
import '../sections/skills_section.dart';
import '../sections/languages_section.dart';
import '../sections/contact_section.dart';
import '../widgets/scroll_progress_indicator.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showNavBar = false;
  int _currentSection = 0;
  double _scrollProgress = 0.0;

  // Section keys for scrolling
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _languagesKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  final List<String> _sectionNames = [
    'Home',
    'About',
    'Experience',
    'Education',
    'Projects',
    'Skills',
    'Languages',
    'Contact',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final screenHeight = MediaQuery.of(context).size.height;
    final scrollOffset = _scrollController.offset;
    final maxScroll = _scrollController.position.maxScrollExtent;

    // Update scroll progress for indicator
    final newProgress = maxScroll > 0 ? scrollOffset / maxScroll : 0.0;
    if ((_scrollProgress - newProgress).abs() > 0.001) {
      setState(() => _scrollProgress = newProgress);
    }

    // Show/hide navbar based on scroll position
    if (scrollOffset > screenHeight * 0.5 && !_showNavBar) {
      setState(() => _showNavBar = true);
    } else if (scrollOffset <= screenHeight * 0.5 && _showNavBar) {
      setState(() => _showNavBar = false);
    }

    // Update current section
    _updateCurrentSection();
  }

  void _updateCurrentSection() {
    final screenHeight = MediaQuery.of(context).size.height;
    final scrollOffset = _scrollController.offset;

    // Determine current section based on scroll position
    final sectionOffsets = [
      0.0,
      _getKeyOffset(_aboutKey),
      _getKeyOffset(_experienceKey),
      _getKeyOffset(_educationKey),
      _getKeyOffset(_projectsKey),
      _getKeyOffset(_skillsKey),
      _getKeyOffset(_languagesKey),
      _getKeyOffset(_contactKey),
    ];

    for (int i = sectionOffsets.length - 1; i >= 0; i--) {
      if (scrollOffset >= sectionOffsets[i] - screenHeight * 0.3) {
        if (_currentSection != i) {
          setState(() => _currentSection = i);
        }
        break;
      }
    }
  }

  double _getKeyOffset(GlobalKey key) {
    final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      return box.localToGlobal(Offset.zero).dy + _scrollController.offset;
    }
    return 0;
  }

  void _scrollToSection(GlobalKey key) {
    final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final offset = box.localToGlobal(Offset.zero).dy + _scrollController.offset;
      _scrollController.animateTo(
        offset - 80, // Account for navbar height
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);

    return Scaffold(
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                HeroSection(
                  onExplorePressed: () => _scrollToSection(_aboutKey),
                ),
                Container(key: _aboutKey, child: const AboutSection()),
                Container(key: _experienceKey, child: const ExperienceSection()),
                Container(key: _educationKey, child: const EducationSection()),
                Container(key: _projectsKey, child: const ProjectsSection()),
                Container(key: _skillsKey, child: const SkillsSection()),
                Container(key: _languagesKey, child: const LanguagesSection()),
                Container(key: _contactKey, child: const ContactSection()),
              ],
            ),
          ),
          // Animated navigation bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            top: _showNavBar ? 0 : -80,
            left: 0,
            right: 0,
            child: _buildNavBar(context, isMobile),
          ),
          // Scroll progress indicator at top
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            top: _showNavBar ? 72 : 0,
            left: 0,
            right: 0,
            child: ScrollProgressIndicator(progress: _scrollProgress),
          ),
          // Section indicator dots (desktop only)
          if (!isMobile)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              right: _showNavBar ? 24 : -60,
              top: 0,
              bottom: 0,
              child: Center(
                child: SectionIndicatorDots(
                  totalSections: _sectionNames.length,
                  currentSection: _currentSection,
                  onDotTap: _handleNavTap,
                ),
              ),
            ),
          // Scroll to top button
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            bottom: _showNavBar ? 24 : -60,
            right: isMobile ? 24 : 80,
            child: _ScrollToTopButton(onPressed: _scrollToTop),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context, bool isMobile) {
    final isTablet = AppTheme.isTablet(context);
    final useCompactNav = isMobile || isTablet;
    
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppTheme.primaryDark.withValues(alpha: 0.95),
        border: const Border(
          bottom: BorderSide(
            color: AppTheme.dividerColor,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : AppTheme.getHorizontalPadding(context),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo / Name
          GestureDetector(
            onTap: _scrollToTop,
            child: Text(
              'NZ',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.accentGold,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
            ),
          ),
          // Navigation items - use mobile menu for tablet too
          if (useCompactNav)
            _MobileNavMenu(
              sectionNames: _sectionNames,
              currentSection: _currentSection,
              onSectionTap: _handleNavTap,
            )
          else
            Row(
              children: List.generate(_sectionNames.length, (index) {
                return _NavItem(
                  label: _sectionNames[index],
                  isActive: _currentSection == index,
                  onTap: () => _handleNavTap(index),
                );
              }),
            ),
        ],
      ),
    );
  }

  void _handleNavTap(int index) {
    switch (index) {
      case 0:
        _scrollToTop();
        break;
      case 1:
        _scrollToSection(_aboutKey);
        break;
      case 2:
        _scrollToSection(_experienceKey);
        break;
      case 3:
        _scrollToSection(_educationKey);
        break;
      case 4:
        _scrollToSection(_projectsKey);
        break;
      case 5:
        _scrollToSection(_skillsKey);
        break;
      case 6:
        _scrollToSection(_languagesKey);
        break;
      case 7:
        _scrollToSection(_contactKey);
        break;
    }
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.isActive || _isHovered
                      ? AppTheme.accentGold
                      : AppTheme.textSecondary,
                  fontWeight:
                      widget.isActive ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: widget.isActive || _isHovered ? 20 : 0,
                height: 2,
                decoration: BoxDecoration(
                  color: AppTheme.accentGold,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileNavMenu extends StatefulWidget {
  final List<String> sectionNames;
  final int currentSection;
  final Function(int) onSectionTap;

  const _MobileNavMenu({
    required this.sectionNames,
    required this.currentSection,
    required this.onSectionTap,
  });

  @override
  State<_MobileNavMenu> createState() => _MobileNavMenuState();
}

class _MobileNavMenuState extends State<_MobileNavMenu> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(
        _isOpen ? Icons.close : Icons.menu,
        color: AppTheme.accentGold,
      ),
      color: AppTheme.cardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppTheme.dividerColor),
      ),
      offset: const Offset(0, 56),
      onOpened: () => setState(() => _isOpen = true),
      onCanceled: () => setState(() => _isOpen = false),
      onSelected: (index) {
        setState(() => _isOpen = false);
        widget.onSectionTap(index);
      },
      itemBuilder: (context) => List.generate(
        widget.sectionNames.length,
        (index) => PopupMenuItem<int>(
          value: index,
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.currentSection == index
                      ? AppTheme.accentGold
                      : Colors.transparent,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                widget.sectionNames[index],
                style: TextStyle(
                  color: widget.currentSection == index
                      ? AppTheme.accentGold
                      : AppTheme.textSecondary,
                  fontWeight: widget.currentSection == index
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScrollToTopButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _ScrollToTopButton({required this.onPressed});

  @override
  State<_ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<_ScrollToTopButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _isHovered ? AppTheme.accentGold : AppTheme.cardDark,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.accentGold,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentGold.withValues(alpha: _isHovered ? 0.4 : 0.2),
                blurRadius: _isHovered ? 15 : 10,
                spreadRadius: _isHovered ? 2 : 0,
              ),
            ],
          ),
          child: Icon(
            Icons.keyboard_arrow_up_rounded,
            color: _isHovered ? AppTheme.primaryDark : AppTheme.accentGold,
            size: 28,
          ),
        ),
      ),
    );
  }
}

