import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/feedback/app_feedback.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/soft_ui_colors.dart';
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
    _stepIndex = session
        .lessonStepIndex(widget.lessonId)
        .clamp(0, _steps.length - 1);
    _resetQuestionState();
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
    if (mounted) context.pop();
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
    final progress = ((_stepIndex + 1) / _steps.length).clamp(0.08, 1.0);
    final resumeHint = _stepIndex > 0;

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
                if (resumeHint) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1E0),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: SoftUiColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.play_circle_outline,
                          size: 18,
                          color: SoftUiColors.orangeDeep,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tu reprends où tu t’étais arrêté.',
                            style: AppTypography.caption.copyWith(
                              color: SoftUiColors.ink,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
    return switch (_step.kind) {
      LessonStepKind.read => _ReadStep(step: _step),
      LessonStepKind.mcq => _McqStep(
        step: _step,
        selected: _selectedMcq,
        validated: _mcqValidated,
        onSelect: (i) {
          if (_mcqValidated) return;
          setState(() => _selectedMcq = i);
        },
      ),
      LessonStepKind.fillBlank => SingleChildScrollView(
        child: FillBlankQuestion(
          key: ValueKey(_step.id),
          stepId: _step.id,
          prompt: _step.prompt!,
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
  const _ReadStep({required this.step});

  final LessonStep step;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (step.mascotLine != null) ...[
          MascotSpeechHeader(message: step.mascotLine!),
          const SizedBox(height: 20),
        ],
        if (step.title != null)
          Text(
            step.title!,
            style: AppTypography.display.copyWith(
              color: SoftUiColors.orangeDeep,
              fontSize: 26,
            ),
          ),
        if (step.body != null) ...[
          const SizedBox(height: 14),
          Text(
            step.body!.replaceAll('**', ''),
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
  });

  final LessonStep step;
  final int? selected;
  final bool validated;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          step.prompt!,
          style: AppTypography.display.copyWith(
            color: SoftUiColors.ink,
            fontSize: 24,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 20),
        for (var i = 0; i < step.options.length; i++)
          DuoChoiceTile(
            title: step.options[i],
            selected: selected == i,
            onTap: () => onSelect(i),
          ),
        if (validated && selected != step.correctIndex) ...[
          const SizedBox(height: 12),
          Text(
            'Tu as raté — lis l’indice et continue pour revoir au quiz.',
            style: AppTypography.caption.copyWith(color: SoftUiColors.orangeDeep),
          ),
        ],
      ],
    );
  }
}
