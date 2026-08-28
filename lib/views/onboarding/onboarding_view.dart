import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/onboarding_spacing.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../models/app_currency.dart';
import '../../models/avatar_catalog.dart';
import '../../models/diagnostic.dart';
import '../../widgets/avatar_option_card.dart';
import '../../widgets/continue_cta_button.dart';
import '../../widgets/duo_choice_tile.dart';
import '../../widgets/duo_outline_field.dart';
import '../../widgets/duo_question_scaffold.dart';
import '../../widgets/finedge_mascot.dart';
import '../../widgets/mascot_speech_header.dart';
import '../../widgets/onboarding_progress_header.dart';

/// Parcours : mieux te comprendre → métier → niveau → rythme → …
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key, this.retake = false});

  /// Repasser le diagnostic (Profil) — étapes courtes.
  final bool retake;

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  /// 0 intro · 1 métier · 2 monnaie · 3 niveau · 4 rythme · 5 résumé
  /// · 6 objectifs · 7 nom · 8 âge · 9 avatar
  static const _totalSteps = 10;

  int _step = 0;
  String? _occupation;
  String? _currency;
  String? _level;
  String? _energy;
  String? _avatar;
  String? _ageRange;
  final Set<String> _goals = {};

  final _nameController = TextEditingController();

  static const _ageRanges = [
    ('under_18', 'Moins de 18 ans'),
    ('18_25', '18 – 25 ans'),
    ('26_35', '26 – 35 ans'),
    ('36_45', '36 – 45 ans'),
    ('46_60', '46 – 60 ans'),
    ('60_plus', 'Plus de 60 ans'),
  ];

  static const _occupations = [
    ('entrepreneur', 'Entrepreneur', Icons.rocket_launch_outlined),
    ('merchant', 'Commerçant', Icons.storefront_outlined),
    ('student', 'Étudiant', Icons.school_outlined),
    ('professional', 'Professionnel', Icons.work_outline),
    ('civil_servant', 'Fonctionnaire', Icons.account_balance_outlined),
    ('other', 'Autre', Icons.more_horiz),
  ];

  static const _levels = [
    ('beginner', 'Je débute complètement'),
    ('basics', 'Je connais quelques bases'),
    ('daily', 'Je gère mon quotidien'),
    ('solid', 'Je suis plutôt à l’aise'),
    ('economist', 'Presque économiste'),
  ];

  static const _energyOptions = [
    ('calm', '3 min / jour'),
    ('recommended', '5 min / jour'),
    ('serious', '10 min / jour'),
    ('intense', '15 min / jour'),
  ];

  static const _goalOptions = [
    ('save_project', 'Épargner pour un projet', Icons.savings_outlined),
    ('budget', 'Mieux gérer mon budget', Icons.account_balance_wallet_outlined),
    ('commerce', 'Séparer caisse et perso', Icons.point_of_sale_outlined),
    ('invest', 'Comprendre l’investissement', Icons.trending_up),
    ('family', 'Soutenir ma famille', Icons.family_restroom),
    ('fun', 'Progresser à mon rythme', Icons.auto_awesome_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFormChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _onFormChanged() => setState(() {});

  bool get _canContinue => switch (_step) {
    0 => true,
    1 => _occupation != null,
    2 => _currency != null,
    3 => _level != null,
    4 => _energy != null,
    5 => true,
    6 => _goals.isNotEmpty,
    7 => _nameController.text.trim().length >= 2,
    8 => _ageRange != null,
    9 => _avatar != null,
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
      if (o.$1 == _energy) return o.$2;
    }
    return '—';
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

  String get _currencyLabel => AppCurrency.byId(_currency).label;

  Diagnostic _buildDiagnostic() {
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
      age: _ageRange,
      startMode: 'placed',
      currency: _currency,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_prefilled || !widget.retake) return;
    _prefilled = true;
    final d = SessionScope.of(context).session.diagnostic;
    if (d == null) return;
    _occupation = d.occupation;
    _currency = d.currency;
    _level = d.level;
    _energy = d.energy == 'intense' ? 'serious' : d.energy;
    _goals.addAll(d.goals);
    _avatar = d.avatar;
    _ageRange = d.age;
    _nameController.text = d.displayName ?? '';
    _step = 1;
  }

  bool _prefilled = false;

  Future<void> _finish() async {
    if (widget.retake) {
      final existing = SessionScope.of(context).session.diagnostic;
      final built = _buildDiagnostic();
      final merged = Diagnostic(
        goals: built.goals,
        level: built.level,
        energy: built.energy,
        avatar: existing?.avatar ?? built.avatar,
        occupation: built.occupation,
        displayName: existing?.displayName ?? built.displayName,
        age: existing?.age ?? built.age,
        startMode: existing?.startMode ?? built.startMode,
        currency: built.currency ?? existing?.currency,
      );
      await SessionScope.of(context).retakeDiagnostic(merged);
      if (!mounted) return;
      context.go('/profil');
      return;
    }
    await SessionScope.of(context).completeOnboarding(_buildDiagnostic());
  }

  Future<void> _continue() async {
    if (!_canContinue) return;
    final lastStep = widget.retake ? 6 : _totalSteps - 1;
    if (_step >= lastStep) {
      await _finish();
      return;
    }
    setState(() => _step += 1);
  }

  void _back() {
    if (widget.retake) {
      if (_step <= 1) return;
    } else if (_step <= 0) {
      return;
    }
    setState(() => _step -= 1);
  }

  int get _progressStep => widget.retake ? _step : _step + 1;

  int get _progressTotal => widget.retake ? 6 : _totalSteps;

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
          child: Column(
            children: [
              if (widget.retake)
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => context.go('/profil'),
                    icon: const Icon(Icons.close_rounded),
                    color: SoftUiColors.muted,
                  ),
                ),
              Expanded(child: _body()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _choiceShell({
    required String speech,
    List<Widget>? children,
    Widget? body,
    String ctaLabel = 'Suivant',
  }) {
    assert(children != null || body != null);
    return Column(
      children: [
        OnboardingProgressHeader(
          step: _progressStep,
          total: _progressTotal,
          onBack: (widget.retake ? _step > 1 : _step > 0) ? _back : null,
        ),
        const SizedBox(height: OnboardingSpacing.afterProgress),
        // Bulle fixée : ne scrolle pas sous la barre de progression.
        MascotSpeechHeader(message: speech),
        const SizedBox(height: OnboardingSpacing.afterSpeech),
        Expanded(
          child:
              body ??
              ListView(
                padding: const EdgeInsets.only(bottom: 8),
                children: children!,
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
      0 => Column(
        children: [
          OnboardingProgressHeader(step: 1, total: _totalSteps),
          const Spacer(),
          Image.asset(
            FinedgeMascot.assetPath,
            width: 96,
            height: 96,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          Text(
            'Quelques questions pour mieux te comprendre',
            textAlign: TextAlign.center,
            style: AppTypography.display.copyWith(
              color: SoftUiColors.ink,
              fontSize: 26,
            ),
          ),
          const Spacer(),
          ContinueCtaButton(
            enabled: true,
            onPressed: _continue,
            label: 'C’est parti',
          ),
        ],
      ),
      1 => _choiceShell(
        speech: 'Tu fais quoi dans la vie ?',
        children: [
          for (final o in _occupations)
            DuoChoiceTile(
              title: o.$2,
              leading: Icon(
                o.$3,
                color: _occupation == o.$1
                    ? SoftUiColors.orangeDeep
                    : SoftUiColors.muted,
              ),
              selected: _occupation == o.$1,
              onTap: () => setState(() => _occupation = o.$1),
            ),
        ],
      ),
      2 => _choiceShell(
        speech: 'Quelle monnaie tu utilises au quotidien ?',
        children: [
          for (final c in AppCurrency.all)
            DuoChoiceTile(
              title: c.label,
              selected: _currency == c.id,
              dense: true,
              onTap: () => setState(() => _currency = c.id),
            ),
        ],
      ),
      3 => _choiceShell(
        speech: 'Tu t’y connais comment en argent ?',
        children: [
          for (final o in _levels)
            DuoChoiceTile(
              title: o.$2,
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
      4 => _choiceShell(
        speech: 'Combien de temps par jour ?',
        children: [
          for (final o in _energyOptions)
            DuoChoiceTile(
              title: o.$2,
              selected: _energy == o.$1,
              onTap: () => setState(() => _energy = o.$1),
            ),
        ],
      ),
      5 => _choiceShell(
        speech: 'Voici ce qu’on a retenu.',
        ctaLabel: 'Continuer',
        children: [
          _PersonSummaryCard(
            occupation: _occupationLabel,
            currency: _currencyLabel,
            level: _levelLabel,
            energy: _energyLabel,
          ),
        ],
      ),
      6 => _choiceShell(
        speech: 'Quel est ton objectif ?',
        children: [
          for (final o in _goalOptions)
            DuoChoiceTile(
              title: o.$2,
              leading: Icon(
                o.$3,
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
      7 => DuoQuestionScaffold(
        step: 8,
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
      8 => _choiceShell(
        speech: 'Quelle est ta tranche d’âge ?',
        children: [
          for (final o in _ageRanges)
            DuoChoiceTile(
              title: o.$2,
              selected: _ageRange == o.$1,
              onTap: () => setState(() => _ageRange = o.$1),
            ),
        ],
      ),
      9 => Column(
        children: [
          OnboardingProgressHeader(
            step: _step + 1,
            total: _totalSteps,
            onBack: _back,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              children: [
                Text(
                  'Choisissez votre Avatar',
                  textAlign: TextAlign.center,
                  style: AppTypography.display.copyWith(
                    color: SoftUiColors.ink,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 24),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: AvatarCatalog.all.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.95,
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
          ),
          ContinueCtaButton(
            enabled: _canContinue,
            onPressed: _continue,
            label: 'Commencer l’Aventure',
          ),
        ],
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _PersonSummaryCard extends StatelessWidget {
  const _PersonSummaryCard({
    required this.occupation,
    required this.currency,
    required this.level,
    required this.energy,
  });

  final String occupation;
  final String currency;
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
            'Ton profil',
            style: AppTypography.title.copyWith(color: SoftUiColors.ink),
          ),
          const SizedBox(height: 16),
          _row(Icons.work_outline, 'Métier', occupation),
          _row(Icons.payments_outlined, 'Monnaie', currency),
          _row(Icons.signal_cellular_alt, 'Niveau', level),
          _row(Icons.schedule_outlined, 'Rythme', energy, last: true),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value, {bool last = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: SoftUiColors.orangeDeep),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$label · $value',
              style: AppTypography.optionTitle.copyWith(
                color: SoftUiColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
