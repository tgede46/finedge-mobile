/// Types d’étapes d’une leçon (style Sapio / Duolingo).
enum LessonStepKind { read, mcq, fillBlank }

class LessonStep {
  const LessonStep.read({
    required this.id,
    required this.title,
    required this.body,
    this.mascotLine,
  }) : kind = LessonStepKind.read,
       prompt = null,
       options = const [],
       correctIndex = null,
       segments = const [],
       wordBank = const [],
       correctWords = null;

  const LessonStep.mcq({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correctIndex,
  }) : kind = LessonStepKind.mcq,
       title = null,
       body = null,
       mascotLine = null,
       segments = const [],
       wordBank = const [],
       correctWords = null;

  const LessonStep.fillBlank({
    required this.id,
    required this.prompt,
    required this.segments,
    required this.wordBank,
    required this.correctWords,
  }) : kind = LessonStepKind.fillBlank,
       title = null,
       body = null,
       mascotLine = null,
       options = const [],
       correctIndex = null;

  final String id;
  final LessonStepKind kind;

  // read
  final String? title;
  final String? body;
  final String? mascotLine;

  // mcq
  final String? prompt;
  final List<String> options;
  final int? correctIndex;

  // fillBlank — segments alternent texte fixe et '' pour un trou
  final List<String> segments;
  final List<String> wordBank;
  final List<String>? correctWords;

  List<String> get resolvedCorrectWords =>
      correctWords ?? (correctIndex != null ? [options[correctIndex!]] : []);
}
