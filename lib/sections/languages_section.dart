import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';

class LanguageData {
  final String language;
  final String level;
  final String cefrLevel;
  final double proficiency;
  final String flag;

  const LanguageData({
    required this.language,
    required this.level,
    required this.cefrLevel,
    required this.proficiency,
    required this.flag,
  });
}

class LanguagesSection extends StatelessWidget {
  const LanguagesSection({super.key});

  static const List<LanguageData> _languages = [
    LanguageData(
      language: 'Swedish',
      level: 'Native',
      cefrLevel: 'C2',
      proficiency: 1.0,
      flag: '🇸🇪',
    ),
    LanguageData(
      language: 'English',
      level: 'Native',
      cefrLevel: 'C2',
      proficiency: 1.0,
      flag: '🇬🇧',
    ),
    LanguageData(
      language: 'Persian',
      level: 'Professional',
      cefrLevel: 'B2',
      proficiency: 0.75,
      flag: '🇮🇷',
    ),
    LanguageData(
      language: 'Greek',
      level: 'Basic',
      cefrLevel: 'A2',
      proficiency: 0.3,
      flag: '🇬🇷',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);
    final isDesktop = AppTheme.isDesktop(context);

    return Container(
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
            title: 'Languages',
            subtitle: 'Communication across cultures',
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: AppTheme.getMaxContentWidth(context),
            ),
            child: isDesktop
                ? _buildDesktopLayout(context)
                : _buildMobileLayout(context, isMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _languages
          .map((lang) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _LanguageCard(language: lang, isMobile: false),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildMobileLayout(BuildContext context, bool isMobile) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: _languages
          .map((lang) => SizedBox(
                width: isMobile
                    ? MediaQuery.of(context).size.width * 0.42
                    : 200,
                child: _LanguageCard(language: lang, isMobile: isMobile),
              ))
          .toList(),
    );
  }
}

class _LanguageCard extends StatefulWidget {
  final LanguageData language;
  final bool isMobile;

  const _LanguageCard({
    required this.language,
    required this.isMobile,
  });

  @override
  State<_LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<_LanguageCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.language.proficiency,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(widget.isMobile ? 16 : 24),
        decoration: BoxDecoration(
          color: _isHovered ? AppTheme.cardDark : AppTheme.cardDark.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? AppTheme.accentGold.withValues(alpha: 0.5)
                : AppTheme.dividerColor,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppTheme.accentGold.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Flag
            Text(
              widget.language.flag,
              style: TextStyle(fontSize: widget.isMobile ? 32 : 40),
            ),
            const SizedBox(height: 12),
            // Language name
            Text(
              widget.language.language,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: widget.isMobile ? 16 : 18,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            // Level with CEFR in one badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: _getLevelColor(widget.language.level).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getLevelColor(widget.language.level).withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                '${widget.language.level} (${widget.language.cefrLevel})',
                style: TextStyle(
                  color: _getLevelColor(widget.language.level),
                  fontSize: widget.isMobile ? 10 : 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Progress bar
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _progressAnimation.value,
                        backgroundColor: AppTheme.dividerColor,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getLevelColor(widget.language.level),
                        ),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(_progressAnimation.value * 100).toInt()}%',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'Native':
        return AppTheme.accentGold;
      case 'Professional':
        return const Color(0xFF4CAF50);
      case 'Basic':
        return const Color(0xFF64B5F6);
      default:
        return AppTheme.textSecondary;
    }
  }
}

