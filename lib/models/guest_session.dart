import 'diagnostic.dart';
import 'learning_path.dart';

class GuestSession {
  const GuestSession({
    required this.localId,
    this.diagnostic,
    this.hasSeenIntro = false,
    this.authProvider,
  });

  final String localId;
  final Diagnostic? diagnostic;
  final bool hasSeenIntro;
  final String? authProvider;

  bool get isOnboarded => diagnostic != null;
  bool get isSignedIn => authProvider != null;

  LearningPath get path => diagnostic == null
      ? const LearningPath(nodes: [])
      : LearningPath.fromDiagnostic(diagnostic!);

  Map<String, dynamic> toJson() => {
    'localId': localId,
    'hasSeenIntro': hasSeenIntro,
    if (authProvider != null) 'authProvider': authProvider,
    if (diagnostic != null) 'diagnostic': diagnostic!.toJson(),
  };

  static GuestSession fromJson(Map<String, dynamic> json) {
    final raw = json['diagnostic'];
    return GuestSession(
      localId: json['localId'] as String,
      hasSeenIntro: json['hasSeenIntro'] == true,
      authProvider: json['authProvider'] as String?,
      diagnostic: raw is Map
          ? Diagnostic.fromJson(Map<String, dynamic>.from(raw))
          : null,
    );
  }

  GuestSession copyWith({
    Diagnostic? diagnostic,
    bool? hasSeenIntro,
    String? authProvider,
  }) {
    return GuestSession(
      localId: localId,
      diagnostic: diagnostic ?? this.diagnostic,
      hasSeenIntro: hasSeenIntro ?? this.hasSeenIntro,
      authProvider: authProvider ?? this.authProvider,
    );
  }
}
