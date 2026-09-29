import 'dart:math';

import '../models/mfa_method.dart';

enum MfaVerifyStatus { success, invalid, expired, noPending }

class MfaVerifyResult {
  const MfaVerifyResult({required this.status, this.method});

  final MfaVerifyStatus status;
  final MfaMethod? method;

  bool get isOk => status == MfaVerifyStatus.success;
}

/// Simulation locale d’OTP (pas d’envoi réseau).
class MfaOtpSimulator {
  MfaOtpSimulator._();
  static final instance = MfaOtpSimulator._();

  final _random = Random();
  String? _pendingCode;
  MfaMethod? _pendingMethod;
  DateTime? _expiresAt;

  static const ttl = Duration(minutes: 5);

  String? get lastSentCode => _pendingCode;

  /// Génère un code à 6 chiffres et le « envoie » (local).
  Future<String> sendCode(MfaMethod method) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final code = List.generate(6, (_) => _random.nextInt(10)).join();
    _pendingCode = code;
    _pendingMethod = method;
    _expiresAt = DateTime.now().add(ttl);
    return code;
  }

  Future<MfaVerifyResult> verify(String input) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final code = _pendingCode;
    final method = _pendingMethod;
    final expires = _expiresAt;

    if (code == null || method == null || expires == null) {
      return const MfaVerifyResult(status: MfaVerifyStatus.noPending);
    }
    if (DateTime.now().isAfter(expires)) {
      _clear();
      return const MfaVerifyResult(status: MfaVerifyStatus.expired);
    }
    final normalized = input.trim();
    if (normalized != code) {
      return const MfaVerifyResult(status: MfaVerifyStatus.invalid);
    }
    _clear();
    return MfaVerifyResult(status: MfaVerifyStatus.success, method: method);
  }

  void _clear() {
    _pendingCode = null;
    _pendingMethod = null;
    _expiresAt = null;
  }
}
