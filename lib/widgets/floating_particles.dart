import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Animated floating particles/orbs for dynamic backgrounds.
class FloatingParticles extends StatefulWidget {
  final int particleCount;
  final double minSize;
  final double maxSize;
  final List<Color>? colors;

  const FloatingParticles({
    super.key,
    this.particleCount = 15,
    this.minSize = 4.0,
    this.maxSize = 12.0,
    this.colors,
  });

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with TickerProviderStateMixin {
  late List<_Particle> _particles;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _initializeParticles();
  }

  void _initializeParticles() {
    final random = math.Random();
    final colors = widget.colors ??
        [
          AppTheme.accentGold.withValues(alpha: 0.3),
          AppTheme.accentBlue.withValues(alpha: 0.25),
          AppTheme.accentPink.withValues(alpha: 0.2),
          AppTheme.accentPurple.withValues(alpha: 0.25),
        ];

    _particles = List.generate(widget.particleCount, (index) {
      return _Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: widget.minSize +
            random.nextDouble() * (widget.maxSize - widget.minSize),
        color: colors[random.nextInt(colors.length)],
        speedX: (random.nextDouble() - 0.5) * 0.02,
        speedY: (random.nextDouble() - 0.5) * 0.015,
        phaseOffset: random.nextDouble() * math.pi * 2,
        pulseSpeed: 0.5 + random.nextDouble() * 1.5,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlesPainter(
            particles: _particles,
            animationValue: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Particle {
  double x;
  double y;
  final double size;
  final Color color;
  final double speedX;
  final double speedY;
  final double phaseOffset;
  final double pulseSpeed;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speedX,
    required this.speedY,
    required this.phaseOffset,
    required this.pulseSpeed,
  });
}

class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double animationValue;

  _ParticlesPainter({
    required this.particles,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final time = animationValue * math.pi * 2;

      // Calculate movement with smooth looping
      final dx = math.sin(time + particle.phaseOffset) * 0.03;
      final dy = math.cos(time * 0.7 + particle.phaseOffset) * 0.02;

      final x = ((particle.x + dx + animationValue * particle.speedX * 3) % 1.0) *
          size.width;
      final y = ((particle.y + dy + animationValue * particle.speedY * 3) % 1.0) *
          size.height;

      // Pulse effect
      final pulse = 0.7 + 0.3 * math.sin(time * particle.pulseSpeed + particle.phaseOffset);
      final currentSize = particle.size * pulse;

      // Draw glow
      final glowPaint = Paint()
        ..color = particle.color.withValues(alpha: 0.3 * pulse)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, currentSize * 2);
      canvas.drawCircle(Offset(x, y), currentSize * 2, glowPaint);

      // Draw core
      final corePaint = Paint()
        ..color = particle.color.withValues(alpha: 0.6 * pulse);
      canvas.drawCircle(Offset(x, y), currentSize, corePaint);
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter oldDelegate) => true;
}

/// Animated gradient mesh background.
class AnimatedGradientMesh extends StatefulWidget {
  final List<Color>? colors;
  final Duration duration;

  const AnimatedGradientMesh({
    super.key,
    this.colors,
    this.duration = const Duration(seconds: 8),
  });

  @override
  State<AnimatedGradientMesh> createState() => _AnimatedGradientMeshState();
}

class _AnimatedGradientMeshState extends State<AnimatedGradientMesh>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final offset1 = Alignment(
          math.sin(t * math.pi * 2) * 0.3,
          math.cos(t * math.pi * 2) * 0.3,
        );
        final offset2 = Alignment(
          math.cos(t * math.pi * 2 + 1) * 0.3,
          math.sin(t * math.pi * 2 + 1) * 0.3,
        );

        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.5 + offset1.x, -0.3 + offset1.y),
              radius: 1.2,
              colors: [
                AppTheme.accentBlue.withValues(alpha: 0.08),
                Colors.transparent,
              ],
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.5 + offset2.x, 0.7 + offset2.y),
                radius: 1.0,
                colors: [
                  AppTheme.accentGold.withValues(alpha: 0.06),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A single floating orb with breathing animation.
class FloatingOrb extends StatefulWidget {
  final double size;
  final Color color;
  final Offset position;
  final Duration duration;

  const FloatingOrb({
    super.key,
    required this.size,
    required this.color,
    required this.position,
    this.duration = const Duration(seconds: 4),
  });

  @override
  State<FloatingOrb> createState() => _FloatingOrbState();
}

class _FloatingOrbState extends State<FloatingOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
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
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      widget.color.withValues(alpha: 0.4),
                      widget.color.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

