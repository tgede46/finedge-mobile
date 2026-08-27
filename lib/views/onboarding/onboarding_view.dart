import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/onboarding_spacing.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../models/avatar_catalog.dart';
import '../../models/diagnostic.dart';
import '../../widgets/avatar_option_card.dart';
import '../../widgets/continue_cta_button.dart';
import '../../widgets/create_profile_prompt.dart';
import '../../widgets/duo_choice_tile.dart';
import '../../widgets/duo_outline_field.dart';
import '../../widgets/duo_question_scaffold.dart';
import '../../widgets/mascot_speech_header.dart';
import '../../widgets/onboarding_progress_header.dart';

/// Parcours jeu : métier → niveau → rythme → résumé → objectifs → avatar
/// → nom / âge → (optionnel) créer profil. Pas d’e-mail / mot de passe ici.
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  /// 0 métier · 1 niveau · 2 rythme · 3 résumé · 4 objectifs
  /// · 5 avatar · 6 nom · 7 âge · 8 créer profil (sans mail)
  static const _totalSteps = 9;

  int _step = 0;
  String? _occupation;
  String? _level;
  String? _energy;
  String? _avatar;
  final Set<String> _goals = {};

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  static const _occupations = [
    (
      'entrepreneur',
      'Entrepreneur',
      'Je lance ou je développe mon activité.',
      Icons.rocket_launch_outlined,
    ),
    (
      'merchant',
      'Commerçant / vendeur',
      'Boutique, marché, vente au quotidien.',
      Icons.storefront_outlined,
    ),
    (
      'student',
      'Étudiant',
      'Études, stage, premier budget perso.',
      Icons.school_outlined,
    ),
    (
      'professional',
      'Professionnel / salarié',
      'Salaire, épargne, projets de vie.',
      Icons.work_outline,
    ),
    (
      'civil_servant',
      'Fonctionnaire',
      'Revenu stable, organisation du budget.',
      Icons.account_balance_outlined,
    ),
    ('other', 'Autre', 'Une situation un peu différente.', Icons.more_horiz),
  ];

  static const _levels = [
    ('beginner', 'Je débute complètement', 'Je découvre la gestion d’argent.'),
    ('basics', 'Je connais quelques bases', 'Je gère un peu, sans méthode.'),
    ('daily', 'Je gère mon quotidien', 'Budget simple, dépenses du mois.'),
    ('solid', 'Je suis plutôt à l’aise', 'Je veux peaufiner et progresser.'),
    ('economist', 'Presque économiste', 'Stratégie, marge, investissement.'),
  ];

  static const _energyOptions = [
    ('calm', '3 min / jour', 'Tranquille — sans pression'),
    ('recommended', '5 min / jour', 'Régulier — le rythme idéal'),
    ('serious', '10 min / jour', 'Motivée — je veux avancer'),
    ('intense', '15 min / jour', 'En feu — progression rapide'),
  ];

  static const _goalOptions = [
    (
      'save_project',
      'Épargner pour un projet précis',
      'Moto, mariage, matériel, voyage…',
      Icons.savings_outlined,
    ),
    (
      'budget',
      'Mieux gérer mon budget',
      'Comprendre mes dépenses et éviter le découvert.',
      Icons.account_balance_wallet_outlined,
    ),
    (
      'commerce',
      'Séparer caisse perso et business',
      'Optimiser les bénéfices au quotidien.',
      Icons.point_of_sale_outlined,
    ),
    (
      'invest',
      'Comprendre l’investissement',
      'Faire fructifier mon argent, simplement.',
      Icons.trending_up,
    ),
    (
      'family',
      'Mieux soutenir ma famille',
      'Anticiper et partager sans se mettre en danger.',
      Icons.family_restroom,
    ),
    (
      'fun',
      'Juste progresser à mon rythme',
      'Apprendre pour le plaisir et la clarté.',
      Icons.auto_awesome_outlined,
    ),
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
    0 => _occupation != null,
    1 => _level != null,
    2 => _energy != null,
    3 => true,
    4 => _goals.isNotEmpty,
    5 => _avatar != null,
    6 => _nameController.text.trim().length >= 2,
    7 => (int.tryParse(_ageController.text.trim()) ?? 0) >= 10,
    _ => true,
  };

  String get _occupationLabel {
    for (final o in _occupations) {
      if (o.$1 == _occupation) return o.$2;
    }
    return '—';
  }

  String get _levelLabel {
    for (final o in _levels) {
      if (o.$1 == _level) return o.$2;
    }
    return '—';
  }

  String get _energyLabel {
    for (final o in _energyOptions) {
      if (o.$1 == _energy) return '${o.$2} · ${o.$3}';
    }
    return '—';
  }

  String get _goalsSpeech {
    return switch (_occupation) {
      'entrepreneur' ||
      'merchant' => 'Maintenant, où veux-tu aller avec ton activité ?',
      'student' => 'Maintenant, où veux-tu aller en tant qu’étudiant ?',
      'civil_servant' =>
        'Maintenant, quels objectifs vises-tu en tant que fonctionnaire ?',
      'professional' =>
        'Maintenant, où veux-tu aller en tant que professionnel ?',
      _ => 'Maintenant, quels objectifs veux-tu atteindre ?',
    };
  }

  void _toggleGoal(String id) {
    setState(() {
      if (_goals.contains(id)) {
        _goals.remove(id);
      } else {
        _goals.add(id);
      }
    });
  }

  Diagnostic _buildDiagnostic() {
    final age = int.parse(_ageController.text.trim());
    final energy = switch (_energy) {
      'serious' => 'intense',
      _ => _energy!,
    };
    return Diagnostic(
      goals: _goals.toList(),
      level: _level!,
      energy: energy,
      avatar: _avatar!,
      occupation: _occupation,
      displayName: _nameController.text.trim(),
      age: age,
      startMode: 'placed',
    );
  }

  Future<void> _finish() async {
    await SessionScope.of(context)
        .completeOnboarding(_buildDiagnostic(), authProvider: 'guest');
  }

  Future<void> _continue() async {
    if (!_canContinue) return;
    if (_step >= _totalSteps - 1) {
      await _finish();
      return;
    }
    setState(() => _step += 1);
  }

  void _back() {
    if (_step <= 0) return;
    setState(() => _step -= 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SoftUiColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            OnboardingSpacing.screenH,
            OnboardingSpacing.screenTop,
            OnboardingSpacing.screenH,
            OnboardingSpacing.screenBottom,
          ),
          child: _body(),
        ),
      ),
    );
  }

  Widget _choiceShell({
    required String speech,
    required List<Widget> children,
    String ctaLabel = 'Suivant',
  }) {
    return Column(
      children: [
        OnboardingProgressHeader(
          step: _step + 1,
          total: _totalSteps,
          onBack: _step > 0 ? _back : null,
        ),
        const SizedBox(height: OnboardingSpacing.afterProgress),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              MascotSpeechHeader(message: speech),
              const SizedBox(height: OnboardingSpacing.afterSpeech),
              ...children,
            ],
          ),
        ),
        const SizedBox(height: OnboardingSpacing.beforeCta),
        ContinueCtaButton(
          enabled: _canContinue,
          onPressed: _continue,
          label: ctaLabel,
        ),
      ],
    );
  }

  Widget _body() {
    return switch (_step) {
      0 => _choiceShell(
        speech: 'Et toi, tu fais quoi dans la vie ?',
        children: [
          for (final o in _occupations)
            DuoChoiceTile(
              title: o.$2,
              subtitle: o.$3,
              leading: Icon(
                o.$4,
                color: _occupation == o.$1
                    ? SoftUiColors.orangeDeep
                    : SoftUiColors.muted,
              ),
              selected: _occupation == o.$1,
              onTap: () => setState(() => _occupation = o.$1),
            ),
        ],
      ),
      1 => _choiceShell(
        speech: 'Tu t’y connais comment en argent ?',
        children: [
          for (final o in _levels)
            DuoChoiceTile(
              title: o.$2,
              subtitle: o.$3,
              leading: Icon(
                Icons.signal_cellular_alt,
                color: _level == o.$1
                    ? SoftUiColors.orangeDeep
                    : SoftUiColors.muted,
              ),
              selected: _level == o.$1,
              onTap: () => setState(() => _level = o.$1),
            ),
        ],
      ),
      2 => _choiceShell(
        speech: 'Combien de temps veux-tu t’entraîner chaque jour ?',
        children: [
          for (final o in _energyOptions)
            DuoChoiceTile(
              title: o.$2,
              subtitle: o.$3,
              selected: _energy == o.$1,
              onTap: () => setState(() => _energy = o.$1),
            ),
        ],
      ),
      3 => _choiceShell(
        speech: 'Voici ce qu’on a retenu de toi. On continue ?',
        ctaLabel: 'Continuer vers mes objectifs',
        children: [
          _PersonSummaryCard(
            occupation: _occupationLabel,
            level: _levelLabel,
            energy: _energyLabel,
          ),
        ],
      ),
      4 => _choiceShell(
        speech: _goalsSpeech,
        children: [
          for (final o in _goalOptions)
            DuoChoiceTile(
              title: o.$2,
              subtitle: o.$3,
              leading: Icon(
                o.$4,
                color: _goals.contains(o.$1)
                    ? SoftUiColors.orangeDeep
                    : SoftUiColors.muted,
              ),
              selected: _goals.contains(o.$1),
              showCheck: true,
              onTap: () => _toggleGoal(o.$1),
            ),
        ],
      ),
      5 => _choiceShell(
        speech: 'Choisis l’avatar qui te représentera dans ta quête.',
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: AvatarCatalog.all.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.92,
            ),
            itemBuilder: (context, index) {
              final spec = AvatarCatalog.all[index];
              return AvatarOptionCard(
                spec: spec,
                selected: _avatar == spec.id,
                onTap: () => setState(() => _avatar = spec.id),
              );
            },
          ),
        ],
      ),
      6 => DuoQuestionScaffold(
        step: 7,
        total: _totalSteps,
        title: 'Comment t’appelles-tu ?',
        onBack: _back,
        ctaLabel: 'SUIVANT',
        ctaEnabled: _canContinue,
        onCta: _continue,
        child: DuoOutlineField(
          controller: _nameController,
          hint: 'Prénom ou pseudo',
          textCapitalization: TextCapitalization.words,
          showValid: _nameController.text.trim().length >= 2,
        ),
      ),
      7 => DuoQuestionScaffold(
        step: 8,
        total: _totalSteps,
        title: 'Quel âge as-tu ?',
        onBack: _back,
        ctaLabel: 'SUIVANT',
        ctaEnabled: _canContinue,
        onCta: _continue,
        child: DuoOutlineField(
          controller: _ageController,
          hint: 'Âge',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
          showValid: (int.tryParse(_ageController.text.trim()) ?? 0) >= 10,
        ),
      ),
      _ => Column(
        children: [
          OnboardingProgressHeader(
            step: _step + 1,
            total: _totalSteps,
            onBack: _back,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: CreateProfilePrompt(onCreate: _finish, onLater: _finish),
          ),
        ],
      ),
    };
  }
}

class _PersonSummaryCard extends StatelessWidget {
  const _PersonSummaryCard({
    required this.occupation,
    required this.level,
    required this.energy,
  });

  final String occupation;
  final String level;
  final String energy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      decoration: BoxDecoration(
        color: SoftUiColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SoftUiColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ce qu’on sait déjà',
            style: AppTypography.title.copyWith(color: SoftUiColors.ink),
          ),
          const SizedBox(height: 16),
          _row(Icons.work_outline, 'Métier', occupation),
          _row(Icons.signal_cellular_alt, 'Niveau', level),
          _row(Icons.schedule_outlined, 'Rythme', energy, last: true),
          const SizedBox(height: 14),
          Text(
            'Ensuite : tes objectifs, ton avatar, puis ton prénom.',
            style: AppTypography.body.copyWith(color: SoftUiColors.muted),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value, {bool last = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: SoftUiColors.orangeDeep),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: SoftUiColors.muted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTypography.optionTitle.copyWith(
                    color: SoftUiColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
