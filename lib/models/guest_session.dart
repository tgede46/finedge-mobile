import 'diagnostic.dart';
import 'learning_path.dart';

class GuestSession {
  const GuestSession({required this.localId, this.diagnostic});

  final String localId;
  final Diagnostic? diagnostic;

  bool get isOnboarded => diagnostic != null;

  LearningPath get path => diagnostic == null
      ? const LearningPath(nodes: [])
      : LearningPath.fromDiagnostic(diagnostic!);

  Map<String, dynamic> toJson() => {
    'localId': localId,
    if (diagnostic != null) 'diagnostic': diagnostic!.toJson(),
  };

  static GuestSession fromJson(Map<String, dynamic> json) {
    final raw = json['diagnostic'];
    return GuestSession(
      localId: json['localId'] as String,
      diagnostic: raw is Map
          ? Diagnostic.fromJson(Map<String, dynamic>.from(raw))
          : null,
    );
  }

  GuestSession copyWith({Diagnostic? diagnostic}) {
    return GuestSession(
      localId: localId,
      diagnostic: diagnostic ?? this.diagnostic,
    );
  }
}
