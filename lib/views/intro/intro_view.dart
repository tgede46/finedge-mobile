import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../widgets/intro_brand_copy.dart';
import '../../widgets/intro_mascot.dart';

/// Écran d’accueil rapide — logo tel quel, puis welcome.
class IntroView extends StatefulWidget {
  const IntroView({super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView>
    with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 1200);

  late final AnimationController _controller;
  late final Animation<double> _mascotScale;
  late final Animation<double> _mascotOpacity;
  late final Animation<double> _titleOpacity;
  late final Animation<double> _subtitleOpacity;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    _controller = AnimationController(vsync: this, duration: _duration);

    _mascotOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );
    _mascotScale = Tween<double>(begin: 0.88, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );
    _titleOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.55, curve: Curves.easeOut),
    );
    _subtitleOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
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
        backgroundColor: SoftUiColors.cream,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
            child: Column(
              children: [
                const Spacer(flex: 2),
                IntroMascot(
                  scale: _mascotScale,
                  opacity: _mascotOpacity,
                  size: mascotSize,
                ),
                SizedBox(height: size.height * 0.035),
                IntroBrandCopy(
                  titleOpacity: _titleOpacity,
                  subtitleOpacity: _subtitleOpacity,
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
