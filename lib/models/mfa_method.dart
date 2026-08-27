enum MfaMethod { none, whatsapp, sms, authenticator }

extension MfaMethodX on MfaMethod {
  String get id => switch (this) {
    MfaMethod.none => 'none',
    MfaMethod.whatsapp => 'whatsapp',
    MfaMethod.sms => 'sms',
    MfaMethod.authenticator => 'authenticator',
  };

  String get label => switch (this) {
    MfaMethod.none => 'Aucun',
    MfaMethod.whatsapp => 'WhatsApp OTP',
    MfaMethod.sms => 'SMS OTP',
    MfaMethod.authenticator => 'Authenticator',
  };

  String get description => switch (this) {
    MfaMethod.none => 'Pas de double vérification pour l’instant.',
    MfaMethod.whatsapp => 'Code envoyé sur WhatsApp (à brancher story 1.3).',
    MfaMethod.sms => 'Code envoyé par SMS (à brancher story 1.3).',
    MfaMethod.authenticator => 'App d’authentification (à brancher story 1.3).',
  };

  static MfaMethod fromId(String? id) => switch (id) {
    'whatsapp' => MfaMethod.whatsapp,
    'sms' => MfaMethod.sms,
    'authenticator' => MfaMethod.authenticator,
    _ => MfaMethod.none,
  };
}
