import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class ProjectData {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> technologies;
  final String? githubUrl;
  final String? liveUrl;
  final Alignment imageAlignment;

  const ProjectData({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.technologies = const [],
    this.githubUrl,
    this.liveUrl,
    this.imageAlignment = Alignment.topCenter,
  });
}

class ProjectCard extends StatefulWidget {
  final ProjectData project;
  final bool isMobile;

  const ProjectCard({
    super.key,
    required this.project,
    required this.isMobile,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;
  Offset _hoverPosition = Offset.zero;

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _onHover(PointerEvent event, Size cardSize) {
    if (_isHovered) {
      setState(() {
        _hoverPosition = Offset(
          (event.localPosition.dx / cardSize.width - 0.5) * 2,
          (event.localPosition.dy / cardSize.height - 0.5) * 2,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = widget.isMobile
        ? MediaQuery.of(context).size.width - 64
        : 380.0;
    final cardHeight = widget.isMobile ? 460.0 : 520.0;
    
    // Subtle 3D tilt effect
    final tiltX = _isHovered && !widget.isMobile ? _hoverPosition.dy * 3.0 : 0.0;
    final tiltY = _isHovered && !widget.isMobile ? -_hoverPosition.dx * 3.0 : 0.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _hoverPosition = Offset.zero;
      }),
      onHover: (event) => _onHover(event, Size(cardWidth, cardHeight)),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 200),
        tween: Tween<double>(begin: 0, end: _isHovered ? 1 : 0),
        builder: (context, value, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(tiltX * 0.0174533 * value)
              ..rotateY(tiltY * 0.0174533 * value)
              ..translate(0.0, -8.0 * value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              width: cardWidth,
              height: cardHeight,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _isHovered
                      ? AppTheme.accentGold.withValues(alpha: 0.5)
                      : AppTheme.dividerColor,
                  width: _isHovered ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? AppTheme.accentGold.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.3),
                    blurRadius: _isHovered ? 30 : 20,
                    offset: Offset(
                      tiltY * 2 * value,
                      (_isHovered ? 15 : 10) + tiltX * 2 * value,
                    ),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project image
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryDark,
                          image: widget.project.imageUrl.isNotEmpty
                              ? DecorationImage(
                                  image: _getImageProvider(widget.project.imageUrl),
                                  fit: BoxFit.cover,
                                  alignment: widget.project.imageAlignment,
                                )
                              : null,
                        ),
                        child: widget.project.imageUrl.isEmpty
                            ? Center(
                                child: Icon(
                                  _getProjectIcon(widget.project.title),
                                  size: 64,
                                  color: AppTheme.accentGold.withValues(alpha: 0.4),
                                ),
                              )
                            : null,
                      ),
                    ),
                    // Project info
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.all(widget.isMobile ? 16 : 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              widget.project.title,
                              style:
                                  Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontSize: widget.isMobile ? 18 : 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            // Description
                            Expanded(
                              child: Text(
                                widget.project.description,
                                style:
                                    Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontSize: widget.isMobile ? 13 : 14,
                                          height: 1.5,
                                        ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Technologies
                            if (widget.project.technologies.isNotEmpty)
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: widget.project.technologies
                                    .take(4)
                                    .map((tech) => _TechBadge(label: tech))
                                    .toList(),
                              ),
                            const SizedBox(height: 16),
                            // GitHub button
                            if (widget.project.githubUrl != null)
                              _GitHubButton(
                                onTap: () => _launchUrl(widget.project.githubUrl!),
                                isMobile: widget.isMobile,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('assets/')) {
      return AssetImage(imageUrl);
    }
    return NetworkImage(imageUrl);
  }

  IconData _getProjectIcon(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('meal') || lowerTitle.contains('recipe')) {
      return Icons.restaurant_menu;
    } else if (lowerTitle.contains('weather')) {
      return Icons.cloud;
    } else if (lowerTitle.contains('tic') || lowerTitle.contains('game')) {
      return Icons.games;
    } else if (lowerTitle.contains('city') || lowerTitle.contains('web')) {
      return Icons.language;
    }
    return Icons.code;
  }
}

class _TechBadge extends StatelessWidget {
  final String label;

  const _TechBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.accentGold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.accentGold.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.accentGoldLight,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _GitHubButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isMobile;

  const _GitHubButton({
    required this.onTap,
    required this.isMobile,
  });

  @override
  State<_GitHubButton> createState() => _GitHubButtonState();
}

class _GitHubButtonState extends State<_GitHubButton> {
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
              FaIcon(
                FontAwesomeIcons.github,
                size: widget.isMobile ? 16 : 18,
                color: AppTheme.primaryDark,
              ),
              const SizedBox(width: 8),
              Text(
                'View on GitHub',
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
