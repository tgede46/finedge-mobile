import 'package:flutter/material.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/onboarding_spacing.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../models/diagnostic.dart';
import '../../widgets/acquaintance_form_card.dart';
import '../../widgets/continue_cta_button.dart';
import '../../widgets/duo_choice_tile.dart';
import '../../widgets/mascot_speech_header.dart';
import '../../widgets/onboarding_progress_header.dart';

/// Onboarding Duolingo-like : métier + objectifs + rythme + profil.
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  /// 0 niveau · 1 métier · 2 objectifs · 3 rythme · 4 feedback · 5 départ · 6 profil
  static const _totalSteps = 7;

  int _step = 0;
  String? _level;
  String? _occupation;
  final Set<String> _goals = {};
  String? _energy;
  String? _startMode;

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  static const _levels = [
    ('beginner', 'Je débute complètement', 'Je découvre la gestion d’argent.'),
    ('basics', 'Je connais quelques bases', 'Je gère un peu, sans méthode.'),
    ('daily', 'Je gère mon quotidien', 'Budget simple, dépenses du mois.'),
    ('solid', 'Je suis plutôt à l’aise', 'Je veux peaufiner et progresser.'),
    ('economist', 'Presque économiste', 'Stratégie, marge, investissement.'),
  ];

  static const _occupations = [
    (
      'entrepreneur',
      'Entrepreneur',
      'Je lance ou je développe mon activité.',
      '🚀',
    ),
    (
      'merchant',
      'Commerçant / vendeur',
      'Boutique, marché, vente au quotidien.',
      '🏪',
    ),
    ('student', 'Étudiant', 'Études, stage, premier budget perso.', '🎒'),
    (
      'professional',
      'Professionnel / salarié',
      'Salaire, épargne, projets de vie.',
      '💼',
    ),
    (
      'civil_servant',
      'Fonctionnaire',
      'Revenu stable, organisation du budget.',
      '🏛️',
    ),
    ('other', 'Autre', 'Une situation un peu différente.', '✨'),
  ];

  static const _goalOptions = [
    (
      'save_project',
      'Épargner pour un projet précis',
      'Moto, mariage, matériel, voyage…',
      '🎯',
    ),
    (
      'budget',
      'Mieux gérer mon budget',
      'Comprendre mes dépenses et éviter le découvert.',
      '👛',
    ),
    (
      'commerce',
      'Séparer caisse perso et business',
      'Optimiser les bénéfices au quotidien.',
      '🏪',
    ),
    (
      'invest',
      'Comprendre l’investissement',
      'Faire fructifier mon argent, simplement.',
      '📈',
    ),
    (
      'family',
      'Mieux soutenir ma famille',
      'Anticiper et partager sans se mettre en danger.',
      '👨‍👩‍👧',
    ),
    (
      'fun',
      'Juste progresser à mon rythme',
      'Apprendre pour le plaisir et la clarté.',
      '✨',
    ),
  ];

  static const _energyOptions = [
    ('calm', '3 min / jour', 'Tranquille — sans pression'),
    ('recommended', '5 min / jour', 'Régulier — le rythme idéal'),
    ('serious', '10 min / jour', 'Motivée — je veux avancer'),
    ('intense', '15 min / jour', 'En feu — progression rapide'),
  ];

  static const _startOptions = [
    (
      'scratch',
      'Commencer depuis zéro',
      'Les bases d’abord, pas à pas.',
      false,
    ),
    (
      'placed',
      'Trouver mon niveau',
      'On adapte le sentier à ton profil.',
      true,
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
    0 => _level != null,
    1 => _occupation != null,
    2 => _goals.isNotEmpty,
    3 => _energy != null,
    4 => true,
    5 => _startMode != null,
    _ =>
      _nameController.text.trim().length >= 2 &&
          (int.tryParse(_ageController.text.trim()) ?? 0) >= 10,
  };

  String get _ctaLabel => switch (_step) {
    3 => 'Je m’engage',
    6 => "C'est parti ! 🚀",
    _ => 'Continuer',
  };

  String get _goalsSpeech {
    return switch (_occupation) {
      'entrepreneur' || 'merchant' =>
        'En tant qu’indépendant, quel est ton objectif prioritaire ?',
      'student' => 'En tant qu’étudiant, qu’est-ce que tu veux accomplir ?',
      'civil_servant' => 'En tant que fonctionnaire, quel est ton objectif ?',
      'professional' =>
        'En tant que professionnel, qu’est-ce qui compte le plus pour toi ?',
      _ => 'Quel est ton objectif avec FinEdge ?',
    };
  }

  String get _feedbackMessage {
    final words = switch (_energy) {
      'calm' => 'une base solide',
      'serious' => 'des habitudes fortes',
      'intense' => 'un vrai coup d’avance',
      _ => 'de vrais progrès dès la 1ère semaine',
    };
    return 'Avec ce rythme, tu construis déjà $words !';
  }

  String get _avatarFromContext {
    return switch (_occupation) {
      'merchant' => 'commercante',
      'entrepreneur' => 'entrepreneur',
      'student' => 'etudiant',
      'civil_servant' || 'professional' => 'sage',
      _ when _goals.contains('invest') => 'visionnaire',
      _ => 'entrepreneur',
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

  Future<void> _continue() async {
    if (!_canContinue) return;
    if (_step < _totalSteps - 1) {
      setState(() => _step += 1);
      return;
    }

    final age = int.parse(_ageController.text.trim());
    final energy = switch (_energy) {
      'serious' => 'intense',
      _ => _energy!,
    };

    await SessionScope.of(context).completeOnboarding(
      Diagnostic(
        goals: _goals.toList(),
        level: _level!,
        energy: energy,
        avatar: _avatarFromContext,
        occupation: _occupation,
        displayName: _nameController.text.trim(),
        age: age,
        startMode: _startMode,
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
          padding: const EdgeInsets.fromLTRB(
            OnboardingSpacing.screenH,
            OnboardingSpacing.screenTop,
            OnboardingSpacing.screenH,
            OnboardingSpacing.screenBottom,
          ),
          child: Column(
            children: [
              OnboardingProgressHeader(
                step: _step + 1,
                total: _totalSteps,
                onBack: _step > 0 ? () => setState(() => _step -= 1) : null,
              ),
              const SizedBox(height: OnboardingSpacing.afterProgress),
              Expanded(child: _body()),
              const SizedBox(height: OnboardingSpacing.beforeCta),
              ContinueCtaButton(
                enabled: _canContinue,
                onPressed: _continue,
                label: _ctaLabel,
                showArrow: !isLast,
              ),
              if (isLast) ...[
                const SizedBox(height: 12),
                Text(
                  'Données sécurisées et privées',
                  style: AppTypography.caption.copyWith(
                    color: SoftUiColors.muted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepList({required String speech, required List<Widget> children}) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        MascotSpeechHeader(message: speech),
        const SizedBox(height: OnboardingSpacing.afterSpeech),
        ...children,
      ],
    );
  }

  Widget _body() {
    return switch (_step) {
      0 => _stepList(
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
      1 => _stepList(
        speech: 'Et toi, tu fais quoi dans la vie ?',
        children: [
          for (final o in _occupations)
            DuoChoiceTile(
              title: o.$2,
              subtitle: o.$3,
              leading: Text(o.$4, style: const TextStyle(fontSize: 22)),
              selected: _occupation == o.$1,
              onTap: () => setState(() => _occupation = o.$1),
            ),
        ],
      ),
      2 => _stepList(
        speech: _goalsSpeech,
        children: [
          for (final o in _goalOptions)
            DuoChoiceTile(
              title: o.$2,
              subtitle: o.$3,
              leading: Text(o.$4, style: const TextStyle(fontSize: 22)),
              selected: _goals.contains(o.$1),
              showCheck: true,
              onTap: () => _toggleGoal(o.$1),
            ),
        ],
      ),
      3 => _stepList(
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
      4 => _stepList(
        speech: _feedbackMessage,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            decoration: BoxDecoration(
              color: SoftUiColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: SoftUiColors.border),
            ),
            child: Column(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 44)),
                const SizedBox(height: 14),
                Text(
                  'La régularité bat l’intensité.',
                  textAlign: TextAlign.center,
                  style: AppTypography.title.copyWith(color: SoftUiColors.ink),
                ),
                const SizedBox(height: 10),
                Text(
                  'Même 5 minutes par jour changent ta relation à l’argent.',
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(color: SoftUiColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
      5 => _stepList(
        speech: 'Par où veux-tu commencer ton sentier ?',
        children: [
          for (final o in _startOptions)
            DuoChoiceTile(
              title: o.$2,
              subtitle: o.$3,
              badge: o.$4 ? 'RECOMMANDÉ' : null,
              leading: Icon(
                o.$1 == 'scratch'
                    ? Icons.menu_book_outlined
                    : Icons.explore_outlined,
                color: _startMode == o.$1
                    ? SoftUiColors.orangeDeep
                    : SoftUiColors.muted,
              ),
              selected: _startMode == o.$1,
              onTap: () => setState(() => _startMode = o.$1),
            ),
        ],
      ),
      _ => _stepList(
        speech: 'Dis-moi comment on t’appelle, et ton âge !',
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
