import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/feedback/app_feedback.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../models/app_currency.dart';
import '../../models/lesson_quiz_bank.dart';
import '../../models/lesson_quiz_question.dart';
import '../../widgets/continue_cta_button.dart';
import '../../widgets/duo_choice_tile.dart';
import '../../widgets/finedge_mascot.dart';

/// Quiz de fin — 10 questions · explication sur demande après validation.
class LessonQuizView extends StatefulWidget {
  const LessonQuizView({super.key, required this.lessonId});

  final String lessonId;

  @override
  State<LessonQuizView> createState() => _LessonQuizViewState();
}

class _LessonQuizViewState extends State<LessonQuizView> {
  late List<LessonQuizQuestion> _allQuestions;
  late List<int> _queue;

  int _queueIndex = 0;
  int? _selected;
  bool _validated = false;
  bool? _lastCorrect;
  bool _showExplanation = false;
  final Map<int, bool> _results = {};
  bool _showSummary = false;

  @override
  void initState() {
    super.initState();
    _allQuestions = LessonQuizBank.questionsFor(widget.lessonId);
    _queue = List.generate(_allQuestions.length, (i) => i);
  }

  LessonQuizQuestion get _question => _allQuestions[_queue[_queueIndex]];

  int get _globalIndex => _queue[_queueIndex];

  void _validate() {
    if (_selected == null || _validated) return;
    final correct = _selected == _question.correctIndex;
    setState(() {
      _validated = true;
      _lastCorrect = correct;
      _showExplanation = false;
      _results[_globalIndex] = correct;
    });
    if (correct) {
      AppFeedback.success();
    } else {
      AppFeedback.light();
    }
  }

  void _continueAfterQuestion() {
    if (_queueIndex >= _queue.length - 1) {
      setState(() => _showSummary = true);
      return;
    }
    setState(() {
      _queueIndex += 1;
      _selected = null;
      _validated = false;
      _lastCorrect = null;
      _showExplanation = false;
    });
  }

  void _revealExplanation() {
    AppFeedback.selection();
    setState(() => _showExplanation = true);
  }

  List<int> get _failedIndices =>
      _results.entries.where((e) => !e.value).map((e) => e.key).toList();

  void _retryFailed() {
    final failed = _failedIndices;
    if (failed.isEmpty) return;
    setState(() {
      _queue = failed;
      _queueIndex = 0;
      _selected = null;
      _validated = false;
      _lastCorrect = null;
      _showExplanation = false;
      _showSummary = false;
    });
  }

  Future<void> _finishLesson() async {
    final session = SessionScope.of(context);
    await session.completeLesson(widget.lessonId, xpEarned: 80);

    final isFirst =
        widget.lessonId == 'besoins_envies' &&
        !session.session.hasCompletedFirstLesson;

    if (!mounted) return;
    if (isFirst) {
      context.go('/lecon-complete?xp=125&next=/premiere-lecon');
    } else {
      context.go('/lecon-complete?xp=80&next=/lecons');
    }
  }

  void _exitQuiz() {
    AppFeedback.light();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/lecons');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showSummary) return _buildSummary();

    final progress = (_queueIndex + 1) / _queue.length;
    final wrongPendingChoice =
        _validated && _lastCorrect == false && !_showExplanation;
    final money = (String t) => AppCurrency.adapt(
      t,
      currencyId: SessionScope.of(context).session.diagnostic?.currency,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _exitQuiz();
      },
      child: Scaffold(
        backgroundColor: SoftUiColors.cream,
        body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _exitQuiz,
                    icon: const Icon(Icons.close_rounded),
                    color: SoftUiColors.muted,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.08, 1.0),
                        minHeight: 10,
                        backgroundColor: SoftUiColors.progressTrack,
                        color: SoftUiColors.orange,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Quiz · question ${_queueIndex + 1}/${_queue.length}',
                style: AppTypography.caption.copyWith(
                  color: SoftUiColors.muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      money(_question.prompt),
                      style: AppTypography.display.copyWith(
                        color: SoftUiColors.ink,
                        fontSize: 24,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (var i = 0; i < _question.options.length; i++)
                      DuoChoiceTile(
                        title: money(_question.options[i]),
                        selected: _selected == i,
                        onTap: _validated
                            ? () {}
                            : () => setState(() => _selected = i),
                      ),
                  ],
                ),
              ),
              if (wrongPendingChoice) ...[
                Text(
                  'Pas tout à fait. Tu veux voir l’explication ?',
                  textAlign: TextAlign.center,
                  style: AppTypography.label.copyWith(
                    color: SoftUiColors.ink,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                ContinueCtaButton(
                  enabled: true,
                  onPressed: _revealExplanation,
                  label: 'Voir l’explication',
                  showArrow: false,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _continueAfterQuestion,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: SoftUiColors.ink,
                      side: const BorderSide(color: SoftUiColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      _queueIndex >= _queue.length - 1
                          ? 'Continuer vers les résultats'
                          : 'Continuer sans explication',
                      style: AppTypography.button.copyWith(
                        color: SoftUiColors.ink,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ] else if (_validated && _lastCorrect == false && _showExplanation) ...[
                _ExplanationCard(text: money(_question.explanation)),
                const SizedBox(height: 12),
                ContinueCtaButton(
                  enabled: true,
                  onPressed: _continueAfterQuestion,
                  label: _queueIndex >= _queue.length - 1
                      ? 'Voir les résultats'
                      : 'Continuer',
                  showArrow: false,
                ),
              ] else if (_validated && _lastCorrect == true) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8F0),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF00C076)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF00C076),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Bonne réponse !',
                          style: AppTypography.label.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ContinueCtaButton(
                  enabled: true,
                  onPressed: _continueAfterQuestion,
                  label: _queueIndex >= _queue.length - 1
                      ? 'Voir les résultats'
                      : 'Continuer',
                  showArrow: false,
                ),
              ] else
                ContinueCtaButton(
                  enabled: _selected != null,
                  onPressed: _validate,
                  label: 'Valider',
                  showArrow: false,
                ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildSummary() {
    final total = _allQuestions.length;
    final correct = _results.values.where((v) => v).length;
    final failed = _failedIndices.length;
    final passed = failed == 0;

    return Scaffold(
      backgroundColor: SoftUiColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            children: [
              const FinedgeMascot(size: 88, emojiSize: 44),
              const SizedBox(height: 20),
              Text(
                passed ? 'Quiz réussi !' : 'Presque !',
                style: AppTypography.display.copyWith(
                  color: SoftUiColors.orangeDeep,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$correct / $total bonnes réponses',
                style: AppTypography.title.copyWith(color: SoftUiColors.ink),
              ),
              const SizedBox(height: 24),
              if (!passed) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: SoftUiColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: SoftUiColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$failed question${failed > 1 ? 's' : ''} à retenter',
                        style: AppTypography.label.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Retente uniquement celles que tu as ratées.',
                        style: AppTypography.body.copyWith(
                          color: SoftUiColors.muted,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                ContinueCtaButton(
                  enabled: true,
                  onPressed: _retryFailed,
                  label: 'Retenter les ratées',
                  showArrow: false,
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _exitQuiz,
                  child: Text(
                    'Revoir la leçon',
                    style: AppTypography.label.copyWith(
                      color: SoftUiColors.muted,
                    ),
                  ),
                ),
              ] else ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8F0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF00C076),
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Leçon validée — elle est cochée sur ton sentier.',
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ContinueCtaButton(
                  enabled: true,
                  onPressed: _finishLesson,
                  label: 'Terminer la leçon',
                  showArrow: false,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ExplanationCard extends StatelessWidget {
  const _ExplanationCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1E0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SoftUiColors.orange),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explication',
            style: AppTypography.label.copyWith(
              color: SoftUiColors.orangeDeep,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: AppTypography.body.copyWith(
              color: SoftUiColors.ink,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
