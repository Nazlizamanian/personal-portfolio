import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class SubRole {
  final String title;
  final String period;
  final String description;

  const SubRole({
    required this.title,
    required this.period,
    required this.description,
  });
}

class TimelineItem {
  final String title;
  final String subtitle;
  final String description;
  final String period;
  final String? location;
  final String? link;
  final String? linkText;
  final List<SubRole>? subRoles;

  const TimelineItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.period,
    this.location,
    this.link,
    this.linkText,
    this.subRoles,
  });
}

class GlowingTimeline extends StatelessWidget {
  final List<TimelineItem> items;
  final bool isEducation;

  const GlowingTimeline({
    super.key,
    required this.items,
    this.isEducation = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);
    final circleSize = 28.0;
    final timelineWidth = isMobile ? 56.0 : 72.0;

    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        final isLast = index == items.length - 1;

        return Stack(
          children: [
            // Vertical line (behind everything)
            if (!isLast)
              Positioned(
                left: (timelineWidth / 2) - 1,
                top: circleSize / 2,
                bottom: 0,
                child: Container(
                  width: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.accentGold,
                        AppTheme.accentGold.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
              ),
            // Main content row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Circle container
                SizedBox(
                  width: timelineWidth,
                  child: Center(
                    child: _GlowingCircle(isEducation: isEducation),
                  ),
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: isMobile ? 8 : 16,
                      bottom: isLast ? 0 : 40,
                    ),
                    child: _TimelineContent(item: item, isMobile: isMobile),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class _GlowingCircle extends StatefulWidget {
  final bool isEducation;
  final double size;

  const _GlowingCircle({this.isEducation = false, this.size = 28});

  @override
  State<_GlowingCircle> createState() => _GlowingCircleState();
}

class _GlowingCircleState extends State<_GlowingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.accentGold,
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentGold.withValues(alpha: 0.6 * _animation.value),
                blurRadius: 16 * _animation.value,
                spreadRadius: 3 * _animation.value,
              ),
              BoxShadow(
                color: AppTheme.accentGold.withValues(alpha: 0.4 * _animation.value),
                blurRadius: 32 * _animation.value,
                spreadRadius: 6 * _animation.value,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SmallGlowingCircle extends StatelessWidget {
  const _SmallGlowingCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.accentGold,
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentGold.withValues(alpha: 0.5),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

class _TimelineContent extends StatelessWidget {
  final TimelineItem item;
  final bool isMobile;

  const _TimelineContent({
    required this.item,
    required this.isMobile,
  });

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasSubRoles = item.subRoles != null && item.subRoles!.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: AppTheme.cardDark.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company/Institution header
          if (isMobile) ...[
            // Mobile layout: stack vertically
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        item.subtitle,
                        style: TextStyle(
                          color: AppTheme.accentGoldLight,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Period badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.accentGold.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        item.period,
                        style: const TextStyle(
                          color: AppTheme.accentGold,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                if (item.location != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          item.location!,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ] else ...[
            // Desktop layout: side by side
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.subtitle,
                        style: const TextStyle(
                          color: AppTheme.accentGoldLight,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (item.location != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: AppTheme.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.location!,
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Period badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.accentGold.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    item.period,
                    style: const TextStyle(
                      color: AppTheme.accentGold,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          
          // If has sub-roles, show them with mini timeline
          if (hasSubRoles)
            ...item.subRoles!.asMap().entries.map((entry) {
              final index = entry.key;
              final subRole = entry.value;
              final isLastSubRole = index == item.subRoles!.length - 1;
              
              return _SubRoleItem(
                subRole: subRole,
                isLast: isLastSubRole,
                isMobile: isMobile,
              );
            })
          else ...[
            // Title
            Text(
              item.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            // Description
            Text(
              item.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: isMobile ? 14 : 16,
                  ),
            ),
          ],
          
          // Link button if available
          if (item.link != null) ...[
            const SizedBox(height: 16),
            _LinkButton(
              text: item.linkText ?? 'Learn more',
              onTap: () => _launchUrl(item.link!),
              isMobile: isMobile,
            ),
          ],
        ],
      ),
    );
  }
}

class _SubRoleItem extends StatelessWidget {
  final SubRole subRole;
  final bool isLast;
  final bool isMobile;

  const _SubRoleItem({
    required this.subRole,
    required this.isLast,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    const circleSize = 16.0;
    const timelineWidth = 32.0;

    return Stack(
      children: [
        // Vertical line (behind everything)
        if (!isLast)
          Positioned(
            left: (timelineWidth / 2) - 1,
            top: circleSize / 2,
            bottom: 0,
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.accentGold.withValues(alpha: 0.6),
                    AppTheme.accentGold.withValues(alpha: 0.2),
                  ],
                ),
              ),
            ),
          ),
        // Main content row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circle container
            const SizedBox(
              width: timelineWidth,
              child: Center(
                child: _SmallGlowingCircle(),
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Role title
                    Text(
                      subRole.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    // Period
                    Text(
                      subRole.period,
                      style: TextStyle(
                        color: AppTheme.accentGold,
                        fontSize: isMobile ? 12 : 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      subRole.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: isMobile ? 13 : 15,
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LinkButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool isMobile;

  const _LinkButton({
    required this.text,
    required this.onTap,
    required this.isMobile,
  });

  @override
  State<_LinkButton> createState() => _LinkButtonState();
}

class _LinkButtonState extends State<_LinkButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
          transformAlignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMobile ? 16 : 20,
            vertical: widget.isMobile ? 10 : 12,
          ),
          decoration: BoxDecoration(
            color: AppTheme.accentGold,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentGold.withValues(alpha: _isHovered ? 0.5 : 0.2),
                blurRadius: _isHovered ? 16 : 8,
                spreadRadius: _isHovered ? 1 : 0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.open_in_new,
                size: widget.isMobile ? 14 : 16,
                color: AppTheme.primaryDark,
              ),
              const SizedBox(width: 8),
              Text(
                widget.text,
                style: TextStyle(
                  color: AppTheme.primaryDark,
                  fontSize: widget.isMobile ? 12 : 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
