import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../widgets/intro_brand_copy.dart';
import '../../widgets/intro_mascot.dart';

/// Animation de lancement — 5 secondes, plein écran, charte FinEdge.
class IntroView extends StatefulWidget {
  const IntroView({super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView>
    with SingleTickerProviderStateMixin {
  static const _duration = Duration(seconds: 5);

  late final AnimationController _controller;
  late final Animation<double> _mascotScale;
  late final Animation<double> _mascotOpacity;
  late final Animation<double> _titleOpacity;
  late final Animation<double> _subtitleOpacity;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    _controller = AnimationController(vsync: this, duration: _duration);

    // Apparition ~1.6s puis maintien jusqu’à 5s.
    _mascotOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.22, curve: Curves.easeOut),
    );
    _mascotScale = Tween<double>(begin: 0.72, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.32, curve: Curves.easeOutBack),
      ),
    );
    _glow = Tween<double>(begin: 0.2, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.08, 0.4, curve: Curves.easeOut),
      ),
    );
    _titleOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.28, 0.48, curve: Curves.easeOut),
    );
    _subtitleOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.42, 0.62, curve: Curves.easeOut),
    );

    _controller.forward().whenComplete(_finish);
  }

  Future<void> _finish() async {
    if (!mounted) return;
    await SessionScope.of(context).completeIntro();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final mascotSize = (size.shortestSide * 0.34).clamp(128.0, 180.0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: SoftUiColors.cream,
      ),
      child: Scaffold(
        body: SizedBox.expand(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFE4C4),
                  SoftUiColors.cream,
                  Color(0xFFFFF3E6),
                ],
                stops: [0, 0.55, 1],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    IntroMascot(
                      scale: _mascotScale,
                      opacity: _mascotOpacity,
                      glow: _glow,
                      size: mascotSize,
                    ),
                    SizedBox(height: size.height * 0.035),
                    IntroBrandCopy(
                      titleOpacity: _titleOpacity,
                      subtitleOpacity: _subtitleOpacity,
                    ),
                    const Spacer(flex: 3),
                    FadeTransition(
                      opacity: _subtitleOpacity,
                      child: const Column(
                        children: [
                          Text(
                            'Éducation financière',
                            style: TextStyle(
                              color: SoftUiColors.muted,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 14),
                          _IntroProgressBar(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IntroProgressBar extends StatelessWidget {
  const _IntroProgressBar();

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_IntroViewState>();
    if (state == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: state._controller,
      builder: (context, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: state._controller.value,
            minHeight: 4,
            backgroundColor: SoftUiColors.progressTrack,
            valueColor: const AlwaysStoppedAnimation(SoftUiColors.orange),
          ),
        );
      },
    );
  }
}
