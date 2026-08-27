import 'dart:math';

import '../models/mfa_method.dart';

/// Simulation locale OTP (WhatsApp / SMS / Authenticator).
/// Remplaçable plus tard par une vraie API (story 1.3).
class MfaOtpSimulator {
  MfaOtpSimulator._();
  static final instance = MfaOtpSimulator._();

  final _random = Random();
  String? _pendingCode;
  MfaMethod? _pendingMethod;
  DateTime? _expiresAt;

  String? get lastSentCode => _pendingCode;
  MfaMethod? get pendingMethod => _pendingMethod;

  bool get hasActiveCode =>
      _pendingCode != null &&
      _expiresAt != null &&
      DateTime.now().isBefore(_expiresAt!);

  /// « Envoie » un code à 6 chiffres (valide 5 min).
  Future<String> sendCode(MfaMethod method) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (method == MfaMethod.none) {
      throw StateError('Aucun OTP pour la méthode none');
    }
    _pendingCode = (_random.nextInt(900000) + 100000).toString();
    _pendingMethod = method;
    _expiresAt = DateTime.now().add(const Duration(minutes: 5));
    return _pendingCode!;
  }

  /// Vérifie le code saisi.
  Future<MfaVerifyResult> verify(String input) async {
    await Future<void>.delayed(const Duration(milliseconds: 280));
    final code = input.trim();
    if (_pendingCode == null || _pendingMethod == null) {
      return MfaVerifyResult.noPending;
    }
    if (_expiresAt != null && DateTime.now().isAfter(_expiresAt!)) {
      clear();
      return MfaVerifyResult.expired;
    }
    if (code != _pendingCode) {
      return MfaVerifyResult.invalid;
    }
    final method = _pendingMethod!;
    clear();
    return MfaVerifyResult.success(method);
  }

  void clear() {
    _pendingCode = null;
    _pendingMethod = null;
    _expiresAt = null;
  }
}

enum MfaVerifyStatus { success, invalid, expired, noPending }

class MfaVerifyResult {
  const MfaVerifyResult._(this.status, [this.method]);

  final MfaVerifyStatus status;
  final MfaMethod? method;

  static const invalid = MfaVerifyResult._(MfaVerifyStatus.invalid);
  static const expired = MfaVerifyResult._(MfaVerifyStatus.expired);
  static const noPending = MfaVerifyResult._(MfaVerifyStatus.noPending);

  factory MfaVerifyResult.success(MfaMethod method) =>
      MfaVerifyResult._(MfaVerifyStatus.success, method);

  bool get isOk => status == MfaVerifyStatus.success;
}
