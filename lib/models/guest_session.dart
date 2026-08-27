import 'diagnostic.dart';
import 'learning_path.dart';
import 'mfa_method.dart';

class GuestSession {
  const GuestSession({
    required this.localId,
    this.diagnostic,
    this.hasSeenIntro = false,
    this.authProvider,
    this.mfaMethod = MfaMethod.none,
    this.email,
  });

  final String localId;
  final Diagnostic? diagnostic;
  final bool hasSeenIntro;
  final String? authProvider;
  final MfaMethod mfaMethod;
  final String? email;

  bool get isOnboarded => diagnostic != null;
  bool get isSignedIn => authProvider != null;

  LearningPath get path => diagnostic == null
      ? const LearningPath(nodes: [])
      : LearningPath.fromDiagnostic(diagnostic!);

  Map<String, dynamic> toJson() => {
    'localId': localId,
    'hasSeenIntro': hasSeenIntro,
    'mfaMethod': mfaMethod.id,
    if (authProvider != null) 'authProvider': authProvider,
    if (email != null) 'email': email,
    if (diagnostic != null) 'diagnostic': diagnostic!.toJson(),
  };

  static GuestSession fromJson(Map<String, dynamic> json) {
    final raw = json['diagnostic'];
    return GuestSession(
      localId: json['localId'] as String,
      hasSeenIntro: json['hasSeenIntro'] == true,
      authProvider: json['authProvider'] as String?,
      email: json['email'] as String?,
      mfaMethod: MfaMethodX.fromId(json['mfaMethod'] as String?),
      diagnostic: raw is Map
          ? Diagnostic.fromJson(Map<String, dynamic>.from(raw))
          : null,
    );
  }

  GuestSession copyWith({
    Diagnostic? diagnostic,
    bool? hasSeenIntro,
    String? authProvider,
    MfaMethod? mfaMethod,
    String? email,
  }) {
    return GuestSession(
      localId: localId,
      diagnostic: diagnostic ?? this.diagnostic,
      hasSeenIntro: hasSeenIntro ?? this.hasSeenIntro,
      authProvider: authProvider ?? this.authProvider,
      mfaMethod: mfaMethod ?? this.mfaMethod,
      email: email ?? this.email,
    );
  }
}
