import 'package:flutter/material.dart';

import '../../controllers/session_scope.dart';
import '../../core/feedback/app_feedback.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/coach_simulation.dart';
import '../../widgets/chat_bubble.dart';
import '../../widgets/mascot_header.dart';
import '../../widgets/question_pills.dart';

class CoachView extends StatefulWidget {
  const CoachView({super.key});

  @override
  State<CoachView> createState() => _CoachViewState();
}

class _CoachViewState extends State<CoachView> {
  final _scroll = ScrollController();
  final _input = TextEditingController();
  final _messages = <CoachChatMessage>[];

  String? _scenarioId;
  String? _stepId;
  bool _waitingChoices = false;
  bool _typing = false;
  List<CoachSimChoice> _choices = [];

  static const _pills = [
    'Comment calculer ma marge ?',
    'Aide pour mon budget Wave',
    'Gérer un crédit client',
  ];

  bool get _inSimulation => _scenarioId != null;

  @override
  void dispose() {
    _scroll.dispose();
    _input.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _appendCoachMessages(List<String> texts) async {
    for (final text in texts) {
      if (!mounted) return;
      setState(() => _typing = true);
      _scrollToBottom();
      await Future<void>.delayed(const Duration(milliseconds: 520));
      if (!mounted) return;
      setState(() {
        _typing = false;
        _messages.add(CoachChatMessage(text: text));
      });
      _scrollToBottom();
      await Future<void>.delayed(const Duration(milliseconds: 180));
    }
  }

  Future<void> _appendUser(String text) async {
    setState(() {
      _messages.add(CoachChatMessage(text: text, fromCoach: false));
      _choices = [];
      _waitingChoices = false;
    });
    AppFeedback.selection();
    _scrollToBottom();
  }

  Future<void> _startScenario(CoachScenario scenario) async {
    AppFeedback.light();
    try {
      setState(() {
        _scenarioId = scenario.id;
        _stepId = scenario.startStepId;
        _choices = [];
        _waitingChoices = false;
      });
      await _appendUser('Simulation : ${scenario.title}');
      await _showStep(scenario.startStep);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _scenarioId = null;
        _stepId = null;
        _choices = [];
        _waitingChoices = false;
      });
      await _appendCoachMessages(const [
        'La simulation n’a pas pu démarrer. Réessaie avec une autre carte.',
      ]);
    }
  }

  Future<void> _showStep(CoachSimStep step) async {
    await _appendCoachMessages([step.coachText]);
    if (!mounted) return;

    if (step.outcome != null) {
      setState(() {
        _messages.add(CoachChatMessage(text: '', outcome: step.outcome));
        _scenarioId = null;
        _stepId = null;
        _choices = [];
        _waitingChoices = false;
      });
      AppFeedback.success();
      _scrollToBottom();
      return;
    }

    setState(() {
      _choices = step.choices;
      _waitingChoices = true;
    });
    _scrollToBottom();
  }

  Future<void> _pickChoice(CoachSimChoice choice) async {
    if (!_waitingChoices || _scenarioId == null || _stepId == null) return;
    AppFeedback.selection();
    await _appendUser(choice.label);
    await _appendCoachMessages(choice.replies);

    if (!mounted) return;

    if (choice.outcome != null) {
      setState(() {
        _messages.add(CoachChatMessage(text: '', outcome: choice.outcome));
        _scenarioId = null;
        _stepId = null;
        _choices = [];
        _waitingChoices = false;
      });
      AppFeedback.success();
      _scrollToBottom();
      return;
    }

    final nextId = choice.nextStepId;
    if (nextId == null) {
      setState(() {
        _scenarioId = null;
        _stepId = null;
        _choices = [];
        _waitingChoices = false;
      });
      return;
    }

    final next = CoachSimulationBank.step(_scenarioId!, nextId);
    if (next == null) return;
    setState(() => _stepId = nextId);
    await _showStep(next);
  }

  Future<void> _onUserTyped() async {
    final text = _input.text.trim();
    if (text.isEmpty || _typing) return;
    _input.clear();
    await _appendUser(text);
    await _appendCoachMessages(const [
      'Merci pour ton message ! Le chat est en cours de développement.',
    ]);
  }

  Future<void> _onQuickQuestion(String question) async {
    if (_typing) return;
    try {
      await _appendUser(question);
      await _appendCoachMessages(
        CoachSimulationBank.quickReplyFor(
          question,
          SessionScope.of(context).currency.code,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      await _appendCoachMessages(const [
        'Je n’ai pas pu répondre. Relance une simulation avec une carte en haut.',
      ]);
    }
  }

  void _exitSimulation() {
    AppFeedback.light();
    setState(() {
      _scenarioId = null;
      _stepId = null;
      _choices = [];
      _waitingChoices = false;
    });
    _appendCoachMessages([
      'Simulation arrêtée. Tu peux en relancer une autre quand tu veux.',
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final name = SessionScope.of(context).session.diagnostic?.displayName?.trim();
    final greeting = (name != null && name.isNotEmpty) ? 'Salut $name' : 'Salut';

    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: MascotHeader(
                      title: greeting,
                      subtitle: 'Coach FinEdge',
                    ),
                  ),
                  if (_inSimulation)
                    TextButton(
                      onPressed: _exitSimulation,
                      child: Text(
                        'Quitter',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (!_inSimulation)
              _ScenarioPicker(
                onStart: _startScenario,
                currencyCode: SessionScope.of(context).currency.code,
              ),
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                itemCount: _messages.length + (_typing ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_typing && index == _messages.length) {
                    return const _TypingBubble();
                  }
                  final msg = _messages[index];
                  if (msg.outcome != null) {
                    return _OutcomeCard(outcome: msg.outcome!);
                  }
                  return ChatBubble(
                    message: msg.text,
                    isUser: !msg.fromCoach,
                  );
                },
              ),
            ),
            if (_choices.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final c in _choices)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: OutlinedButton(
                          onPressed: _typing ? null : () => _pickChoice(c),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.brown,
                            backgroundColor: AppColors.surface,
                            side: BorderSide(
                              color: AppColors.primary.withValues(alpha: 0.4),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            c.label,
                            textAlign: TextAlign.center,
                            style: AppTypography.body.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            if (!_inSimulation && _choices.isEmpty)
              QuestionPills(labels: _pills, onSelected: _onQuickQuestion),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: TextField(
                controller: _input,
                enabled: !_typing,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _onUserTyped(),
                decoration: InputDecoration(
                  hintText: 'Écris au coach…',
                  hintStyle: AppTypography.caption,
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    onPressed: _typing ? null : _onUserTyped,
                    icon: Icon(
                      Icons.send_rounded,
                      color: AppColors.primary.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScenarioPicker extends StatelessWidget {
  const _ScenarioPicker({required this.onStart, required this.currencyCode});

  final ValueChanged<CoachScenario> onStart;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final scenarios = CoachSimulationBank.scenariosFor(currencyCode);
    return SizedBox(
      height: 124,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        itemCount: scenarios.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final s = scenarios[index];
          return _ScenarioCard(scenario: s, onTap: () => onStart(s));
        },
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({required this.scenario, required this.onTap});

  final CoachScenario scenario;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 168,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(scenario.icon, color: AppColors.primary, size: 22),
              Text(
                scenario.title,
                style: AppTypography.label.copyWith(
                  color: AppColors.brown,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                scenario.subtitle,
                style: AppTypography.caption.copyWith(
                  color: AppColors.muted,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutcomeCard extends StatelessWidget {
  const _OutcomeCard({required this.outcome});

  final CoachSimOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final accent = outcome.positive ? AppColors.success : AppColors.warning;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                outcome.positive
                    ? Icons.insights_outlined
                    : Icons.warning_amber_rounded,
                color: accent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                outcome.title,
                style: AppTypography.label.copyWith(
                  color: AppColors.brown,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final row in outcome.rows)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      row.$1,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  Text(
                    row.$2,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.brown,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Text(
            '💡 ${outcome.tip}',
            style: AppTypography.caption.copyWith(
              color: AppColors.brown,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.brown.withValues(alpha: 0.08)),
        ),
        child: Text(
          '…',
          style: AppTypography.body.copyWith(color: AppColors.muted),
        ),
      ),
    );
  }
}
