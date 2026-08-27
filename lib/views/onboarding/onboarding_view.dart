import 'package:flutter/material.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../models/diagnostic.dart';
import '../../widgets/acquaintance_form_card.dart';
import '../../widgets/avatar_option_card.dart';
import '../../widgets/continue_cta_button.dart';
import '../../widgets/goal_option_card.dart';
import '../../widgets/onboarding_progress_header.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  static const _totalSteps = 3;

  int _step = 0;
  String? _goal;
  String? _avatar;

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  static const _goalOptions = [
    (
      'save_project',
      'Économiser pour un achat',
      'vélo, console, voyage… apprends à mettre de côté.',
      Icons.savings_outlined,
      Color(0xFFFFB74D),
    ),
    (
      'budget',
      'Gérer mon budget',
      "Comprendre mes dépenses et éviter d'être à découvert.",
      Icons.account_balance_wallet_outlined,
      Color(0xFFFFCA28),
    ),
    (
      'invest',
      "Comprendre l'investissement",
      'Découvrir comment faire fructifier mon argent.',
      Icons.trending_up,
      Color(0xFF90CAF9),
    ),
  ];

  static const _avatars = [
    ('entrepreneur', "L'Entrepreneur", 'Commerçant local', '🏪'),
    ('sage', 'Le Sage', "Figure d'expérience", '🧓'),
    ('batisseur', 'Le Bâtisseur', 'Projets ambitieux', '👷'),
    ('commercante', 'La Commerçante', 'Vente au marché', '🧺'),
    ('etudiant', "L'Étudiant", 'Apprentissage constant', '🎒'),
    ('visionnaire', 'Le Visionnaire', 'Grandes idées', '✨'),
  ];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFormChanged);
    _ageController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFormChanged);
    _ageController.removeListener(_onFormChanged);
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _onFormChanged() => setState(() {});

  bool get _canContinue => switch (_step) {
    0 => _goal != null,
    1 => _avatar != null,
    _ =>
      _nameController.text.trim().length >= 2 &&
          (int.tryParse(_ageController.text.trim()) ?? 0) >= 10,
  };

  Future<void> _continue() async {
    if (!_canContinue) return;
    if (_step < _totalSteps - 1) {
      setState(() => _step += 1);
      return;
    }

    final age = int.parse(_ageController.text.trim());
    await SessionScope.of(context).completeOnboarding(
      Diagnostic(
        goals: [_goal!],
        level: age < 18 ? 'beginner' : (age < 30 ? 'curious' : 'solid'),
        energy: 'recommended',
        avatar: _avatar!,
        displayName: _nameController.text.trim(),
        age: age,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _step == _totalSteps - 1;
    return Scaffold(
      backgroundColor: SoftUiColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            children: [
              OnboardingProgressHeader(
                step: _step + 1,
                total: _totalSteps,
                rightLabel: isLast ? 'Finalisation' : null,
                onBack: _step > 0 ? () => setState(() => _step -= 1) : null,
              ),
              const SizedBox(height: 18),
              Expanded(child: _body()),
              if (isLast) ...[
                ContinueCtaButton(
                  enabled: _canContinue,
                  onPressed: _continue,
                  label: "C'est parti ! 🚀",
                  showArrow: false,
                ),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 14,
                      color: SoftUiColors.muted,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Données sécurisées et privées',
                      style: TextStyle(
                        color: SoftUiColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ] else
                ContinueCtaButton(enabled: _canContinue, onPressed: _continue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return switch (_step) {
      0 => _GoalsStep(
        selected: _goal,
        onSelect: (id) => setState(() => _goal = id),
      ),
      1 => _AvatarStep(
        selected: _avatar,
        onSelect: (id) => setState(() => _avatar = id),
      ),
      _ => ListView(
        children: [
          AcquaintanceFormCard(
            nameController: _nameController,
            ageController: _ageController,
          ),
        ],
      ),
    };
  }
}

class _GoalsStep extends StatelessWidget {
  const _GoalsStep({required this.selected, required this.onSelect});

  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text(
          'Quel est ton objectif ?',
          style: TextStyle(
            color: SoftUiColors.orangeDeep,
            fontWeight: FontWeight.w900,
            fontSize: 26,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choisis ce que tu veux accomplir en premier avec FinEdge.',
          style: TextStyle(
            color: SoftUiColors.muted,
            fontSize: 14,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        for (final g in _OnboardingViewState._goalOptions)
          GoalOptionCard(
            title: g.$2,
            description: g.$3,
            icon: g.$4,
            iconBackground: g.$5,
            selected: selected == g.$1,
            onTap: () => onSelect(g.$1),
          ),
      ],
    );
  }
}

class _AvatarStep extends StatelessWidget {
  const _AvatarStep({required this.selected, required this.onSelect});

  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text(
          'Choisis ton Avatar',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: SoftUiColors.orangeDeep,
            fontWeight: FontWeight.w900,
            fontSize: 26,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sélectionne le compagnon qui te représentera dans ta quête financière.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: SoftUiColors.muted,
            fontSize: 14,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 18),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _OnboardingViewState._avatars.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.92,
          ),
          itemBuilder: (context, index) {
            final a = _OnboardingViewState._avatars[index];
            return AvatarOptionCard(
              title: a.$2,
              subtitle: a.$3,
              emoji: a.$4,
              selected: selected == a.$1,
              onTap: () => onSelect(a.$1),
            );
          },
        ),
      ],
    );
  }
}
