import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_state.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late List<Animation<double>> _letterDropAnimations;
  late List<Animation<double>> _letterFadeAnimations;
  late Animation<double> _arrowDrawAnimation;
  late Animation<double> _starScaleAnimation;
  late Animation<double> _starRotateAnimation;
  late Animation<double> _buttonsFadeAnimation;
  late Animation<double> _subtitleFadeAnimation;

  final String _brandName = "Dawem";
  final String _brandSubtitle = "Build. Learn. Stay Consistent.";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    final letterCount = _brandName.length;
    _letterDropAnimations = [];
    _letterFadeAnimations = [];

    for (int i = 0; i < letterCount; i++) {
      final start = 0.05 + (i * 0.06);
      final end = (start + 0.20).clamp(0.0, 0.55);

      _letterDropAnimations.add(
        Tween<double>(begin: -60.0, end: 0.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(start, end, curve: Curves.bounceOut),
          ),
        ),
      );

      _letterFadeAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              start,
              (start + 0.12).clamp(0.0, 0.55),
              curve: Curves.easeIn,
            ),
          ),
        ),
      );
    }

    _arrowDrawAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.42,
          0.72,
          curve: Curves.easeInOutCubic,
        ),
      ),
    );

    _starScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.70,
          0.86,
          curve: Curves.elasticOut,
        ),
      ),
    );

    _starRotateAnimation = Tween<double>(
      begin: -0.5,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.70,
          0.86,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _subtitleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.55,
          0.78,
          curve: Curves.easeIn,
        ),
      ),
    );

    _buttonsFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.84,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  void _navigateToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = appState.isDarkMode;
    final size = MediaQuery.of(context).size;

    final backgroundColor =
        isDark ? AppColors.darkBackground : Colors.white;

        final textColor =
        isDark ? AppColors.neonGreen : AppColors.dawemGreenDark;

    final subtitleColor =
        isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          const Spacer(flex: 2),

                          Center(
                            child: Container(
                              width: math.min(size.width * 0.8, 300),
                              height: 250,
                              decoration: isDark
                                  ? null
                                  : BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(32),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.08),
                                          blurRadius: 30,
                                          offset: const Offset(0, 14),
                                        ),
                                      ],
                                    ),
                              padding: const EdgeInsets.all(20),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomPaint(
                                    size: const Size(240, 200),
                                    painter: DawemCurveArrowPainter(
                                      progress:
                                          _arrowDrawAnimation.value,
                                      starScale:
                                          _starScaleAnimation.value,
                                      starRotation:
                                          _starRotateAnimation.value,
                                      isDark: isDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _brandName.length,
                              (index) {
                                final drop =
                                    _letterDropAnimations[index].value;

                                final opacity =
                                    _letterFadeAnimations[index].value;

                                final char = _brandName[index];

                                return Opacity(
                                  opacity: opacity,
                                  child: Transform.translate(
                                    offset: Offset(0, drop),
                                    child: Text(
                                      char,
                                      style: TextStyle(
                                        fontSize: 44,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 2,
                                        color: textColor,
                                        shadows: isDark
                                            ? [
                                                Shadow(
                                                  color: AppColors
                                                      .neonGreen
                                                      .withValues(
                                                    alpha: 0.8,
                                                  ),
                                                  blurRadius: 18,
                                                ),
                                                Shadow(
                                                  color: AppColors
                                                      .neonGreenGlow
                                                      .withValues(
                                                    alpha: 0.4,
                                                  ),
                                                  blurRadius: 30,
                                                ),
                                              ]
                                            : [
                                                Shadow(
                                                  color: AppColors
                                                      .dawemGreen
                                                      .withValues(
                                                    alpha: 0.3,
                                                  ),
                                                  offset:
                                                      const Offset(0, 3),
                                                  blurRadius: 6,
                                                ),
                                              ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 10),

                          Opacity(
                            opacity: _subtitleFadeAnimation.value,
                            child: Text(
                              _brandSubtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: subtitleColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),

                          const Spacer(flex: 3),

                          Opacity(
                            opacity: _buttonsFadeAnimation.value,
                            child: Transform.translate(
                              offset: Offset(
                                0,
                                30 *
                                    (1.0 -
                                        _buttonsFadeAnimation.value),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withValues(
                                            alpha: 0.04,
                                          )
                                        : Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(24),
                                    border: Border.all(
                                      color: isDark
                                          ? Colors.white.withValues(
                                              alpha: 0.16,
                                            )
                                          : AppColors.border,
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isDark
                                            ? Colors.black.withValues(
                                                alpha: 0.4,
                                              )
                                            : AppColors.primary
                                                .withValues(alpha: 0.06),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: _navigateToLogin,
                                        child: Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            gradient: isDark
                                                ? const LinearGradient(
                                                    colors: [
                                                      Color(0xFF0E7490),
                                                      Color(0xFF0F766E),
                                                    ],
                                                    begin:
                                                        Alignment.topCenter,
                                                    end: Alignment
                                                        .bottomCenter,
                                                  )
                                                : AppColors.primaryGradient,
                                            boxShadow: [
                                              BoxShadow(
                                                color: isDark
                                                    ? const Color(
                                                        0xFF0E7490,
                                                      ).withValues(
                                                        alpha: 0.35,
                                                      )
                                                    : AppColors.primary
                                                        .withValues(alpha: 0.35,
                                                      ),
                                                blurRadius: 12,
                                                offset:
                                                    const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            "Login",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 12),

                                      GestureDetector(
                                        onTap: _navigateToRegister,
                                        child: Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? Colors.white.withValues(
                                                    alpha: 0.04,
                                                  )
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            border: Border.all(
                                              color: isDark
                                                  ? Colors.white.withValues(
                                                      alpha: 0.25,
                                                    )
                                                  : AppColors.primary,
                                              width: 1.4,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Create Account",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: isDark
                                                  ? Colors.white
                                                  : AppColors.primary,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// Custom Painter for the animated Dawem curve arrow.
class DawemCurveArrowPainter extends CustomPainter {
  final double progress;
  final double starScale;
  final double starRotation;
  final bool isDark;
  DawemCurveArrowPainter({
    required this.progress,
    required this.starScale,
    required this.starRotation,
    this.isDark = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0) return;

    final fullPath = Path();

    final p0 = Offset(size.width * 0.12, size.height * 0.78);
    final p1 = Offset(size.width * 0.35, size.height * 0.32);
    final p2 = Offset(size.width * 0.52, size.height * 0.65);
    final p3 = Offset(size.width * 0.82, size.height * 0.22);

    fullPath.moveTo(p0.dx, p0.dy);

    fullPath.cubicTo(
      size.width * 0.18,
      size.height * 0.60,
      size.width * 0.26,
      size.height * 0.32,
      p1.dx,
      p1.dy,
    );

    fullPath.cubicTo(
      size.width * 0.42,
      size.height * 0.32,
      size.width * 0.44,
      size.height * 0.65,
      p2.dx,
      p2.dy,
    );

    fullPath.cubicTo(
      size.width * 0.60,
      size.height * 0.65,
      size.width * 0.70,
      size.height * 0.42,
      p3.dx,
      p3.dy,
    );

    final pathMetrics = fullPath.computeMetrics().toList();
    if (pathMetrics.isEmpty) return;

    final metric = pathMetrics.first;
    final animatedLength = metric.length * progress;

    final extractedPath = metric.extractPath(
      0.0,
      animatedLength,
    );

    final gradient = LinearGradient(
      colors: isDark
          ? const [
              Color(0xFF86EFAC),
              Color(0xFFBEF264),
              Color(0xFFFDBA74),
            ]
          : const [
              Color(0xFF22C55E),
              Color(0xFF84CC16),
              Color(0xFFF97316),
            ],
      stops: const [0.0, 0.45, 1.0],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    );

    if (isDark) {
      final glowGradient = LinearGradient(
        colors: const [
          Color(0xFF22C55E),
          Color(0xFFA3E635),
          Color(0xFFF97316),
        ],
        stops: const [0.0, 0.45, 1.0],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      );

      final outerGlowPaint = Paint()
        ..shader = glowGradient.createShader(Offset.zero & size)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 22
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter =
            const MaskFilter.blur(BlurStyle.normal, 16);

      final midGlowPaint = Paint()
        ..shader = glowGradient.createShader(Offset.zero & size)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter =
            const MaskFilter.blur(BlurStyle.normal, 6);

      final corePaint = Paint()
        ..shader = gradient.createShader(Offset.zero & size)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(extractedPath, outerGlowPaint);
      canvas.drawPath(extractedPath, midGlowPaint);
      canvas.drawPath(extractedPath, corePaint);
    } else {
      final strokePaint = Paint()
        ..shader = gradient.createShader(Offset.zero & size)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final shadowPaint = Paint()
        ..color = const Color(0xFFF97316).withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..maskFilter =
            const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawPath(extractedPath, shadowPaint);
      canvas.drawPath(extractedPath, strokePaint);
    }

    if (starScale > 0.01) {
      final starCenter = Offset(p3.dx + 4, p3.dy - 6);

      canvas.save();
      canvas.translate(starCenter.dx, starCenter.dy);
      canvas.rotate(starRotation);
      canvas.scale(starScale);
      final glowPaint = Paint()
        ..color = (isDark
                ? const Color(0xFFF97316)
                : const Color(0xFFF59E0B))
            .withValues(alpha: 0.35 * starScale)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

      canvas.drawCircle(Offset.zero, 24, glowPaint);

      final starPath = _createStarPath();

      final starOutlinePaint = Paint()
        ..color = const Color(0xFFF97316)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeJoin = StrokeJoin.round;

      if (!isDark) {
        final starFillPaint = Paint()
          ..color = const Color(0xFFFBBF24)
          ..style = PaintingStyle.fill;

        canvas.drawPath(starPath, starFillPaint);
      }

      canvas.drawPath(starPath, starOutlinePaint);

      if (!isDark) {
        final highlightPaint = Paint()
          ..color = Colors.white.withValues(alpha: 0.85);

        canvas.drawCircle(Offset.zero, 3.5, highlightPaint);
      }

      canvas.restore();
    }

    if (!isDark && progress >= 0.95) {
      final tangent = metric.getTangentForOffset(animatedLength);

      if (tangent != null) {
        final tip = tangent.position;
        final angle = tangent.angle;

        final arrowHeadPath = Path();
        const arrowLen = 16.0;

        final left = Offset(
          tip.dx - arrowLen * math.cos(angle - 0.5),
          tip.dy - arrowLen * math.sin(angle - 0.5),
        );

        final right = Offset(
          tip.dx - arrowLen * math.cos(angle + 0.5),
          tip.dy - arrowLen * math.sin(angle + 0.5),
        );

        arrowHeadPath.moveTo(tip.dx, tip.dy);
        arrowHeadPath.lineTo(left.dx, left.dy);
        arrowHeadPath.lineTo(right.dx, right.dy);
        arrowHeadPath.close();

        final arrowPaint = Paint()
          ..color = const Color(0xFFF97316)
          ..style = PaintingStyle.fill;

        canvas.drawPath(arrowHeadPath, arrowPaint);
      }
    }
  }

  Path _createStarPath() {
    final starPath = Path();

    const double outerR = 26.0;
    const double innerR = 7.5;
    const int points = 4;

    for (int i = 0; i < points * 2; i++) {
      final r = (i % 2 == 0) ? outerR : innerR;
      final theta = (i * math.pi / points) - (math.pi / 2);

      final x = r * math.cos(theta);
      final y = r * math.sin(theta);

      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }
    }

    starPath.close();
    return starPath;
  }

  @override
  bool shouldRepaint(covariant DawemCurveArrowPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.starScale != starScale ||
        oldDelegate.starRotation != starRotation ||
        oldDelegate.isDark != isDark;
  }
}