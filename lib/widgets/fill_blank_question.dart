import 'package:flutter/material.dart';

import '../core/feedback/app_feedback.dart';
import '../core/theme/app_typography.dart';
import '../core/theme/soft_ui_colors.dart';

/// Phrase à compléter avec mots-cliquables (style Sapio « groupe de mots »).
class FillBlankQuestion extends StatefulWidget {
  const FillBlankQuestion({
    super.key,
    required this.stepId,
    required this.prompt,
    required this.segments,
    required this.wordBank,
    required this.correctWords,
    required this.onValidated,
  });

  final String stepId;
  final String prompt;
  final List<String> segments;
  final List<String> wordBank;
  final List<String> correctWords;
  final ValueChanged<bool> onValidated;

  @override
  State<FillBlankQuestion> createState() => _FillBlankQuestionState();
}

class _FillBlankQuestionState extends State<FillBlankQuestion> {
  late List<String?> _filled;
  late List<String> _remaining;
  bool? _lastValid;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  @override
  void didUpdateWidget(covariant FillBlankQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stepId != widget.stepId) _reset();
  }

  void _reset() {
    final blankCount = widget.segments.where((s) => s.isEmpty).length;
    _filled = List.filled(blankCount, null);
    _remaining = List<String>.from(widget.wordBank);
    _lastValid = null;
  }

  int get _nextBlankIndex {
    for (var i = 0; i < _filled.length; i++) {
      if (_filled[i] == null) return i;
    }
    return -1;
  }

  void _pickWord(String word) {
    final idx = _nextBlankIndex;
    if (idx < 0) return;
    setState(() {
      _filled[idx] = word;
      _remaining.remove(word);
    });
    _checkIfComplete();
  }

  void _removeAt(int blankIdx) {
    final word = _filled[blankIdx];
    if (word == null) return;
    setState(() {
      _filled[blankIdx] = null;
      _remaining.add(word);
      _lastValid = null;
    });
    widget.onValidated(false);
  }

  void _checkIfComplete() {
    if (_filled.any((w) => w == null)) {
      widget.onValidated(false);
      return;
    }
    final ok = _filled.length == widget.correctWords.length &&
        List.generate(
          _filled.length,
          (i) => _filled[i] == widget.correctWords[i],
        ).every((v) => v);
    setState(() => _lastValid = ok);
    if (ok) {
      AppFeedback.success();
    } else {
      AppFeedback.light();
    }
    widget.onValidated(ok);
  }

  @override
  Widget build(BuildContext context) {
    var blankIdx = 0;
    final inline = <Widget>[];
    for (final segment in widget.segments) {
      if (segment.isNotEmpty) {
        inline.add(
          Text(
            segment,
            style: AppTypography.body.copyWith(
              color: SoftUiColors.ink,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        );
      } else {
        final current = blankIdx;
        inline.add(
          _BlankSlot(
            word: _filled[current],
            valid: _lastValid,
            onTap: () => _removeAt(current),
          ),
        );
        blankIdx++;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.prompt,
          style: AppTypography.label.copyWith(
            color: SoftUiColors.muted,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: SoftUiColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: SoftUiColors.border),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            runSpacing: 8,
            children: inline,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final word in _remaining)
              ActionChip(
                label: Text(
                  word,
                  style: AppTypography.label.copyWith(
                    color: SoftUiColors.ink,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                backgroundColor: SoftUiColors.tanSoft,
                side: const BorderSide(color: SoftUiColors.border),
                onPressed: () {
                  AppFeedback.selection();
                  _pickWord(word);
                },
              ),
          ],
        ),
        if (_lastValid == false) ...[
          const SizedBox(height: 12),
          Text(
            'Pas tout à fait. Touche un mot dans la phrase pour le retirer et réessayer.',
            style: AppTypography.caption.copyWith(
              color: SoftUiColors.orangeDeep,
            ),
          ),
        ],
      ],
    );
  }
}

class _BlankSlot extends StatelessWidget {
  const _BlankSlot({
    required this.word,
    required this.valid,
    required this.onTap,
  });

  final String? word;
  final bool? valid;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final filled = word != null;
    Color border = SoftUiColors.orange;
    Color bg = const Color(0xFFFFF1E0);
    if (filled && valid == false) {
      border = SoftUiColors.orangeDeep;
      bg = const Color(0xFFFFEBEE);
    } else if (filled && valid == true) {
      border = const Color(0xFF00C076);
      bg = const Color(0xFFE8F8F0);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: filled ? onTap : null,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          constraints: const BoxConstraints(minWidth: 72, minHeight: 36),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: filled ? bg : SoftUiColors.tanSoft,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: filled ? border : SoftUiColors.border,
              width: filled ? 2 : 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            word ?? '…',
            style: AppTypography.label.copyWith(
              color: SoftUiColors.ink,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
