import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../widgets/auth_text_field.dart';
import '../../widgets/continue_cta_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _email.addListener(() => setState(() {}));
    _password.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_email.text.trim().isEmpty || _password.text.isEmpty) return;
    await SessionScope.of(context).signIn(
      provider: 'email',
      email: _email.text.trim(),
    );
  }

  void _back() {
    final session = SessionScope.of(context);
    if (session.isOnboarded) {
      context.go('/accueil');
    } else {
      context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = _email.text.trim().isNotEmpty && _password.text.isNotEmpty;
    final onboarded = SessionScope.of(context).isOnboarded;

    return Scaffold(
      backgroundColor: SoftUiColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: _back,
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  color: SoftUiColors.ink,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'FinEdge',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: SoftUiColors.orangeDeep,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                onboarded ? 'Créer mon profil' : 'Se connecter',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: SoftUiColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                onboarded
                    ? 'Sauvegarde ta série, tes XP et ta progression.'
                    : 'Retrouve ton sentier, tes XP et ta caisse.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: SoftUiColors.muted, fontSize: 14),
              ),
              const SizedBox(height: 28),
              AuthTextField(
                hint: 'E-mail ou téléphone',
                controller: _email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              AuthTextField(
                hint: 'Mot de passe',
                controller: _password,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ContinueCtaButton(
                enabled: enabled,
                onPressed: _submit,
                label: onboarded ? 'Enregistrer mon compte' : 'Se connecter',
              ),
              const Spacer(),
              if (!onboarded)
                GestureDetector(
                  onTap: () => context.go('/welcome'),
                  child: const Text.rich(
                    TextSpan(
                      style: TextStyle(color: SoftUiColors.muted, fontSize: 14),
                      children: [
                        TextSpan(text: "Pas encore de compte ? "),
                        TextSpan(
                          text: 'Commencer',
                          style: TextStyle(
                            color: SoftUiColors.orangeDeep,
                            fontWeight: FontWeight.w800,
                          ),
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
  }
}
