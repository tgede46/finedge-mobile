import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../models/diagnostic.dart';
import '../../widgets/auth_provider_marks.dart';
import '../../widgets/auth_text_field.dart';
import '../../widgets/continue_cta_button.dart';

/// Création de compte (UI stub) : Google · Apple · nom / e-mail / mot de passe.
class CreateProfileView extends StatefulWidget {
  const CreateProfileView({super.key});

  @override
  State<CreateProfileView> createState() => _CreateProfileViewState();
}

class _CreateProfileViewState extends State<CreateProfileView> {
  late final TextEditingController _name;
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _name.addListener(_refresh);
    _email.addListener(_refresh);
    _password.addListener(_refresh);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final session = SessionScope.of(context).session;
      if (session.diagnostic == null) {
        context.go('/onboarding');
        return;
      }
      if (_name.text.isEmpty && session.diagnostic!.displayName != null) {
        _name.text = session.diagnostic!.displayName!;
      }
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  bool get _formReady =>
      _name.text.trim().length >= 2 &&
      _email.text.trim().contains('@') &&
      _password.text.length >= 6;

  Diagnostic? get _base => SessionScope.of(context).session.diagnostic;

  Future<void> _complete({
    required String provider,
    String? email,
    String? displayName,
  }) async {
    final base = _base;
    if (base == null || _busy) return;
    setState(() => _busy = true);
    final diagnostic = Diagnostic(
      goals: base.goals,
      level: base.level,
      energy: base.energy,
      avatar: base.avatar,
      occupation: base.occupation,
      displayName: displayName?.trim().isNotEmpty == true
          ? displayName!.trim()
          : base.displayName,
      age: base.age,
      startMode: base.startMode,
    );
    await SessionScope.of(context)
        .completeOnboarding(diagnostic, email: email, authProvider: provider);
  }

  Future<void> _submitForm() async {
    if (!_formReady) return;
    await _complete(
      provider: 'email',
      email: _email.text.trim(),
      displayName: _name.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SoftUiColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  color: SoftUiColors.ink,
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Créer un profil',
                      textAlign: TextAlign.center,
                      style: AppTypography.display.copyWith(
                        color: SoftUiColors.ink,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sauvegarde ta progression FinEdge.',
                      textAlign: TextAlign.center,
                      style: AppTypography.body.copyWith(
                        color: SoftUiColors.muted,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _SocialButton(
                      label: 'Continuer avec Google',
                      leading: const GoogleMark(),
                      onPressed: _busy
                          ? null
                          : () => _complete(provider: 'google'),
                    ),
                    const SizedBox(height: 12),
                    _SocialButton(
                      label: 'Continuer avec Apple',
                      leading: const AppleMark(),
                      onPressed: _busy
                          ? null
                          : () => _complete(provider: 'apple'),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: SoftUiColors.border),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'ou',
                            style: AppTypography.caption.copyWith(
                              color: SoftUiColors.muted,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: SoftUiColors.border),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    AuthTextField(hint: 'Nom', controller: _name),
                    const SizedBox(height: 12),
                    AuthTextField(
                      hint: 'E-mail',
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    AuthTextField(
                      hint: 'Mot de passe',
                      controller: _password,
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    ContinueCtaButton(
                      enabled: _formReady && !_busy,
                      onPressed: _submitForm,
                      label: 'Créer mon profil',
                      showArrow: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.leading,
    required this.onPressed,
  });

  final String label;
  final Widget leading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: SoftUiColors.card,
          foregroundColor: SoftUiColors.ink,
          side: const BorderSide(color: SoftUiColors.border, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading,
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTypography.button.copyWith(
                color: SoftUiColors.ink,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
