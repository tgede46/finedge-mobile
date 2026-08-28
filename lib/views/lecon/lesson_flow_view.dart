import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/feedback/app_feedback.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../models/app_currency.dart';
import '../../models/course_curriculum.dart';
import '../../models/lesson_bank.dart';
import '../../models/lesson_step.dart';
import '../../widgets/continue_cta_button.dart';
import '../../widgets/duo_choice_tile.dart';
import '../../widgets/fill_blank_question.dart';
import '../../widgets/mascot_speech_header.dart';

/// Parcours leçon multi-étapes — reprise auto si tu quittes (style Sapio).
class LessonFlowView extends StatefulWidget {
  const LessonFlowView({super.key, required this.lessonId});

  final String lessonId;

  @override
  State<LessonFlowView> createState() => _LessonFlowViewState();
}

class _LessonFlowViewState extends State<LessonFlowView> {
  late List<LessonStep> _steps;
  late int _stepIndex;
  int? _pendingResumeStep;
  bool _resumeConfirmed = true;
  int? _selectedMcq;
  bool _questionValid = false;
  bool _mcqValidated = false;

  @override
  void initState() {
    super.initState();
    _steps = LessonBank.stepsFor(widget.lessonId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final session = SessionScope.of(context);
    final rawSaved = session.lessonStepIndex(widget.lessonId);
    if (rawSaved >= _steps.length) {
      session.clearLessonProgress(widget.lessonId);
    }
    final saved = rawSaved.clamp(0, _steps.length - 1);
    if (saved > 0) {
      _pendingResumeStep = saved;
      _stepIndex = 0;
      _resumeConfirmed = false;
    } else {
      _pendingResumeStep = null;
      _stepIndex = 0;
      _resumeConfirmed = true;
    }
    _resetQuestionState();
  }

  bool get _showResumeGate =>
      !_resumeConfirmed &&
      _pendingResumeStep != null &&
      _pendingResumeStep! > 0;

  void _confirmResume() {
    AppFeedback.light();
    setState(() {
      _stepIndex = _pendingResumeStep!;
      _resumeConfirmed = true;
      _resetQuestionState();
    });
  }

  Future<void> _restartLesson() async {
    AppFeedback.selection();
    await SessionScope.of(context).clearLessonProgress(widget.lessonId);
    if (!mounted) return;
    setState(() {
      _pendingResumeStep = null;
      _stepIndex = 0;
      _resumeConfirmed = true;
      _resetQuestionState();
    });
  }

  String get _lessonTitle {
    final copy = CourseCurriculum.lessonCopy[widget.lessonId];
    if (copy != null) return copy.$1;
    return _steps.first.title ?? 'Leçon';
  }

  bool _initialized = false;

  LessonStep get _step => _steps[_stepIndex];

  void _resetQuestionState() {
    _selectedMcq = null;
    _mcqValidated = false;
    _questionValid = _step.kind == LessonStepKind.read;
  }

  Future<void> _persistStep() async {
    await SessionScope.of(context).saveLessonStep(widget.lessonId, _stepIndex);
  }

  Future<void> _exit() async {
    await _persistStep();
    if (!mounted) return;
    AppFeedback.light();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/lecons');
    }
  }

  Future<void> _advance() async {
    if (_step.kind == LessonStepKind.mcq && !_mcqValidated) {
      if (_selectedMcq == null) return;
      setState(() {
        _mcqValidated = true;
        _questionValid = _selectedMcq == _step.correctIndex;
      });
      if (_questionValid) {
        AppFeedback.success();
      } else {
        AppFeedback.light();
      }
      return;
    }

    if (!_canContinue) return;

    if (_stepIndex >= _steps.length - 1) {
      await _finishLesson();
      return;
    }
    setState(() {
      _stepIndex += 1;
      _resetQuestionState();
    });
    await SessionScope.of(context).saveLessonStep(widget.lessonId, _stepIndex);
  }

  Future<void> _finishLesson() async {
    await SessionScope.of(context).clearLessonProgress(widget.lessonId);
    if (!mounted) return;
    context.push('/lecon/${widget.lessonId}/quiz');
  }

  bool get _canContinue {
    if (_step.kind == LessonStepKind.read) return true;
    if (_step.kind == LessonStepKind.mcq) {
      if (!_mcqValidated) return _selectedMcq != null;
      return true;
    }
    return _questionValid;
  }

  String get _ctaLabel {
    if (_stepIndex >= _steps.length - 1) {
      return _step.kind == LessonStepKind.mcq && !_mcqValidated
          ? 'Valider'
          : 'Passer au quiz';
    }
    if (_step.kind == LessonStepKind.mcq && !_mcqValidated) return 'Valider';
    if (_step.kind == LessonStepKind.mcq && _mcqValidated && !_questionValid) {
      return 'Continuer';
    }
    return 'Continuer';
  }

  @override
  Widget build(BuildContext context) {
    if (_showResumeGate) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;
          if (mounted) context.pop();
        },
        child: Scaffold(
          backgroundColor: SoftUiColors.cream,
          body: SafeArea(
            child: _ResumeGate(
              lessonTitle: _lessonTitle,
              stepIndex: _pendingResumeStep!,
              totalSteps: _steps.length,
              onResume: _confirmResume,
              onRestart: _restartLesson,
              onClose: () => context.pop(),
            ),
          ),
        ),
      );
    }

    final progress = ((_stepIndex + 1) / _steps.length).clamp(0.08, 1.0);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _exit();
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
                      onPressed: _exit,
                      icon: const Icon(Icons.close_rounded),
                      color: SoftUiColors.muted,
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          backgroundColor: SoftUiColors.progressTrack,
                          color: SoftUiColors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_stepIndex + 1}/${_steps.length}',
                      style: AppTypography.caption.copyWith(
                        color: SoftUiColors.muted,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(child: _buildStep()),
                const SizedBox(height: 12),
                ContinueCtaButton(
                  enabled: _canContinue,
                  onPressed: _advance,
                  label: _ctaLabel,
                  showArrow: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    final money = (String t) => AppCurrency.adapt(
      t,
      currencyId: SessionScope.of(context).session.diagnostic?.currency,
    );
    return switch (_step.kind) {
      LessonStepKind.read => _ReadStep(step: _step, adapt: money),
      LessonStepKind.mcq => _McqStep(
        step: _step,
        selected: _selectedMcq,
        validated: _mcqValidated,
        adapt: money,
        onSelect: (i) {
          if (_mcqValidated) return;
          setState(() => _selectedMcq = i);
        },
      ),
      LessonStepKind.fillBlank => SingleChildScrollView(
        child: FillBlankQuestion(
          key: ValueKey(_step.id),
          stepId: _step.id,
          prompt: money(_step.prompt!),
          segments: _step.segments,
          wordBank: _step.wordBank,
          correctWords: _step.resolvedCorrectWords,
          onValidated: (ok) => setState(() => _questionValid = ok),
        ),
      ),
    };
  }
}

class _ReadStep extends StatelessWidget {
  const _ReadStep({required this.step, required this.adapt});

  final LessonStep step;
  final String Function(String) adapt;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (step.mascotLine != null) ...[
          MascotSpeechHeader(message: adapt(step.mascotLine!)),
          const SizedBox(height: 20),
        ],
        if (step.title != null)
          Text(
            adapt(step.title!),
            style: AppTypography.display.copyWith(
              color: SoftUiColors.orangeDeep,
              fontSize: 26,
            ),
          ),
        if (step.body != null) ...[
          const SizedBox(height: 14),
          Text(
            adapt(step.body!.replaceAll('**', '')),
            style: AppTypography.body.copyWith(
              color: SoftUiColors.ink,
              height: 1.5,
              fontSize: 16,
            ),
          ),
        ],
      ],
    );
  }
}

class _McqStep extends StatelessWidget {
  const _McqStep({
    required this.step,
    required this.selected,
    required this.validated,
    required this.onSelect,
    required this.adapt,
  });

  final LessonStep step;
  final int? selected;
  final bool validated;
  final ValueChanged<int> onSelect;
  final String Function(String) adapt;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          adapt(step.prompt!),
          style: AppTypography.display.copyWith(
            color: SoftUiColors.ink,
            fontSize: 24,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 20),
        for (var i = 0; i < step.options.length; i++)
          DuoChoiceTile(
            title: adapt(step.options[i]),
            selected: selected == i,
            onTap: () => onSelect(i),
          ),
        if (validated && selected != step.correctIndex) ...[
          const SizedBox(height: 12),
          Text(
            'Ce n’est pas ça — lis l’indice, puis continue. Tu reverras ça au quiz.',
            style: AppTypography.caption.copyWith(color: SoftUiColors.orangeDeep),
          ),
        ],
      ],
    );
  }
}

class _ResumeGate extends StatelessWidget {
  const _ResumeGate({
    required this.lessonTitle,
    required this.stepIndex,
    required this.totalSteps,
    required this.onResume,
    required this.onRestart,
    required this.onClose,
  });

  final String lessonTitle;
  final int stepIndex;
  final int totalSteps;
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close_rounded),
              color: SoftUiColors.muted,
            ),
          ),
          const Spacer(),
          Text(
            lessonTitle,
            style: AppTypography.display.copyWith(
              color: SoftUiColors.orangeDeep,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tu t’étais arrêté à l’étape ${stepIndex + 1} sur $totalSteps.\n'
            'Que veux-tu faire ?',
            style: AppTypography.body.copyWith(
              color: SoftUiColors.ink,
              height: 1.45,
            ),
          ),
          const Spacer(),
          ContinueCtaButton(
            enabled: true,
            onPressed: onResume,
            label: 'Reprendre où je me suis arrêté',
            showArrow: false,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 54,
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onRestart,
              style: OutlinedButton.styleFrom(
                foregroundColor: SoftUiColors.ink,
                side: const BorderSide(color: SoftUiColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Recommencer depuis le début',
                style: AppTypography.button.copyWith(color: SoftUiColors.ink),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choisis comment continuer.',
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(color: SoftUiColors.muted),
          ),
        ],
      ),
    );
  }
}
