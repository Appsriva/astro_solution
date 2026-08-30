import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'login_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _scaleAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
_controller.forward();

    // 4.5 second baad Login Screen par transfer
    Future.delayed(const Duration(milliseconds: 4500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF7A00),
              Color(0xFFE65100),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 320,
                        height: 320,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 300,
                              height: 300,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFFFB300).withValues(alpha: 0.18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 40,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                            Transform.rotate(
                              angle: _controller.value * 2 * math.pi,
                              child: CustomPaint(
                                size: const Size(290, 290),
                                painter: MantraCirclePainter(),
                              ),
                            ),
                            Container(
                              width: 210,
                              height: 210,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.amber.shade200.withValues(alpha: 0.4),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.35),
                                    blurRadius: 25,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'ASTRO SOLUATION',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 3.5,
                          shadows: [
                            Shadow(
                              color: Colors.black38,
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '✨ Connect with Destiny ✨',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class MantraCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    _drawRing(canvas, center, radius: 118, count: 16, fontSize: 13, opacity: 0.85);
    _drawRing(canvas, center, radius: 138, count: 22, fontSize: 11, opacity: 0.60);
  }

  void _drawRing(
    Canvas canvas,
    Offset center, {
    required double radius,
    required int count,
    required double fontSize,
    required double opacity,
  }) {
    final textStyle = TextStyle(
      color: Colors.amber.shade100.withValues(alpha: opacity),
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      shadows: const [
        Shadow(
          color: Colors.black26,
          blurRadius: 4,
        ),
      ],
    );

    for (int i = 0; i < count; i++) {
      final angle = (2 * math.pi / count) * i;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      final textSpan = TextSpan(text: 'राम', style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle + math.pi / 2);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}