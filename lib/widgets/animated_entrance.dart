import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

enum SlideDirection { fromBottom, fromLeft, fromRight, fromTop }

/// A widget that animates its child with a fade and slide effect when it becomes visible.
/// Uses VisibilityDetector to trigger the animation when scrolled into view.
class AnimatedEntrance extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final double slideOffset;
  final SlideDirection direction;
  final double visibilityThreshold;

  const AnimatedEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOutCubic,
    this.slideOffset = 40.0,
    this.direction = SlideDirection.fromBottom,
    this.visibilityThreshold = 0.1,
  });

  @override
  State<AnimatedEntrance> createState() => _AnimatedEntranceState();
}

class _AnimatedEntranceState extends State<AnimatedEntrance>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    final Offset beginOffset = switch (widget.direction) {
      SlideDirection.fromBottom => Offset(0, widget.slideOffset),
      SlideDirection.fromTop => Offset(0, -widget.slideOffset),
      SlideDirection.fromLeft => Offset(-widget.slideOffset, 0),
      SlideDirection.fromRight => Offset(widget.slideOffset, 0),
    };

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_hasAnimated && info.visibleFraction >= widget.visibilityThreshold) {
      _hasAnimated = true;
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('animated-entrance-${widget.hashCode}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: _slideAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

/// A widget that animates a list of children with staggered delays.
class StaggeredAnimatedList extends StatelessWidget {
  final List<Widget> children;
  final Duration itemDelay;
  final Duration itemDuration;
  final SlideDirection direction;
  final double slideOffset;

  const StaggeredAnimatedList({
    super.key,
    required this.children,
    this.itemDelay = const Duration(milliseconds: 100),
    this.itemDuration = const Duration(milliseconds: 600),
    this.direction = SlideDirection.fromBottom,
    this.slideOffset = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(children.length, (index) {
        return AnimatedEntrance(
          delay: Duration(milliseconds: itemDelay.inMilliseconds * index),
          duration: itemDuration,
          direction: direction,
          slideOffset: slideOffset,
          child: children[index],
        );
      }),
    );
  }
}

/// Horizontal version of staggered animation for wrapping elements.
class StaggeredAnimatedWrap extends StatelessWidget {
  final List<Widget> children;
  final Duration itemDelay;
  final Duration itemDuration;
  final SlideDirection direction;
  final double slideOffset;
  final double spacing;
  final double runSpacing;

  const StaggeredAnimatedWrap({
    super.key,
    required this.children,
    this.itemDelay = const Duration(milliseconds: 50),
    this.itemDuration = const Duration(milliseconds: 500),
    this.direction = SlideDirection.fromBottom,
    this.slideOffset = 20.0,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: List.generate(children.length, (index) {
        return AnimatedEntrance(
          delay: Duration(milliseconds: itemDelay.inMilliseconds * index),
          duration: itemDuration,
          direction: direction,
          slideOffset: slideOffset,
          child: children[index],
        );
      }),
    );
  }
}

