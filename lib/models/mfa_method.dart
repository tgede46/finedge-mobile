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
    MfaMethod.whatsapp => 'Code simulé comme sur WhatsApp.',
    MfaMethod.sms => 'Code simulé comme par SMS.',
    MfaMethod.authenticator => 'Code simulé comme une app Authenticator.',
  };

  static MfaMethod fromId(String? id) => switch (id) {
    'whatsapp' => MfaMethod.whatsapp,
    'sms' => MfaMethod.sms,
    'authenticator' => MfaMethod.authenticator,
    _ => MfaMethod.none,
  };
}
