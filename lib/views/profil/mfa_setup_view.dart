import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../models/mfa_method.dart';
import '../../services/mfa_otp_simulator.dart';
import '../../widgets/continue_cta_button.dart';

/// Page complète : choix MFA + simulation OTP.
class MfaSetupView extends StatefulWidget {
  const MfaSetupView({super.key});

  @override
  State<MfaSetupView> createState() => _MfaSetupViewState();
}

class _MfaSetupViewState extends State<MfaSetupView> {
  MfaMethod? _selected;
  bool _busy = false;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _selected = SessionScope.of(context).mfaMethod;
      _loaded = true;
    }
  }

  Future<void> _confirm() async {
    final selected = _selected;
    if (_busy || selected == null) return;
    final controller = SessionScope.of(context);

    if (selected == MfaMethod.none) {
      setState(() => _busy = true);
      await controller.setMfaMethod(MfaMethod.none);
      if (!mounted) return;
      context.pop();
      return;
    }

    setState(() => _busy = true);
    try {
      await MfaOtpSimulator.instance.sendCode(selected);
      if (!mounted) return;
      final ok = await context.push<bool>('/mfa/verify?method=${selected.id}');
      if (!mounted) return;
      if (ok == true) {
        context.pop();
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected ?? MfaMethod.none;
    return Scaffold(
      backgroundColor: SoftUiColors.cream,
      appBar: AppBar(
        backgroundColor: SoftUiColors.cream,
        elevation: 0,
        foregroundColor: SoftUiColors.ink,
        title: Text(
          'Sécurité MFA',
          style: AppTypography.title.copyWith(color: SoftUiColors.ink),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choisis comment sécuriser ton compte. Tu pourras changer à tout moment.',
                style: AppTypography.body.copyWith(color: SoftUiColors.muted),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1E0),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: SoftUiColors.border),
                ),
                child: Text(
                  'Mode simulation : un code à 6 chiffres sera généré localement (pas d’envoi réel).',
                  style: AppTypography.caption.copyWith(
                    color: SoftUiColors.ink,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    for (final method in MfaMethod.values)
                      _MfaOptionTile(
                        method: method,
                        selected: selected == method,
                        onTap: () => setState(() => _selected = method),
                      ),
                  ],
                ),
              ),
              ContinueCtaButton(
                enabled: !_busy,
                onPressed: _confirm,
                label: selected == MfaMethod.none ? 'Enregistrer' : 'Continuer',
                showArrow: selected != MfaMethod.none,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MfaOptionTile extends StatelessWidget {
  const _MfaOptionTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final MfaMethod method;
  final bool selected;
  final VoidCallback onTap;

  IconData get _icon => switch (method) {
    MfaMethod.none => Icons.shield_outlined,
    MfaMethod.whatsapp => Icons.chat_outlined,
    MfaMethod.sms => Icons.sms_outlined,
    MfaMethod.authenticator => Icons.phonelink_lock_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected ? const Color(0xFFFFF1E0) : SoftUiColors.card,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? SoftUiColors.orange : SoftUiColors.border,
                width: selected ? 2 : 1.4,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _icon,
                  color: selected
                      ? SoftUiColors.orangeDeep
                      : SoftUiColors.muted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method.label,
                        style: AppTypography.optionTitle.copyWith(
                          color: SoftUiColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        method.description,
                        style: AppTypography.optionSubtitle,
                      ),
                    ],
                  ),
                ),
                if (selected)
                  const Icon(Icons.check_circle, color: SoftUiColors.orange),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Saisie du code OTP (simulation).
class MfaVerifyView extends StatefulWidget {
  const MfaVerifyView({super.key, required this.method});

  final MfaMethod method;

  @override
  State<MfaVerifyView> createState() => _MfaVerifyViewState();
}

class _MfaVerifyViewState extends State<MfaVerifyView> {
  final _controller = TextEditingController();
  String? _simCode;
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _simCode = MfaOtpSimulator.instance.lastSentCode;
    _controller.addListener(() => setState(() => _error = null));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _resend() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final code = await MfaOtpSimulator.instance.sendCode(widget.method);
      if (!mounted) return;
      setState(() => _simCode = code);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nouveau code généré (simulation)')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _submit() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await MfaOtpSimulator.instance.verify(_controller.text);
      if (!mounted) return;
      if (!result.isOk) {
        setState(() {
          _error = switch (result.status) {
            MfaVerifyStatus.invalid => 'Code incorrect. Réessaie.',
            MfaVerifyStatus.expired => 'Code expiré. Renvoie un nouveau code.',
            MfaVerifyStatus.noPending =>
              'Aucun code en attente. Renvoie-en un.',
            MfaVerifyStatus.success => null,
          };
        });
        return;
      }
      await SessionScope.of(context).setMfaMethod(result.method!);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${widget.method.label} activé')));
      context.pop(true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String get _channelHint => switch (widget.method) {
    MfaMethod.whatsapp => 'WhatsApp',
    MfaMethod.sms => 'SMS',
    MfaMethod.authenticator => 'Authenticator',
    MfaMethod.none => '',
  };

  @override
  Widget build(BuildContext context) {
    final canSubmit = _controller.text.trim().length == 6 && !_busy;

    return Scaffold(
      backgroundColor: SoftUiColors.cream,
      appBar: AppBar(
        backgroundColor: SoftUiColors.cream,
        elevation: 0,
        foregroundColor: SoftUiColors.ink,
        title: Text(
          'Vérification',
          style: AppTypography.title.copyWith(color: SoftUiColors.ink),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Entre le code à 6 chiffres ($_channelHint).',
                style: AppTypography.body.copyWith(color: SoftUiColors.ink),
              ),
              const SizedBox(height: 14),
              if (_simCode != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: SoftUiColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: SoftUiColors.orange, width: 1.6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SIMULATION — code envoyé',
                        style: AppTypography.caption.copyWith(
                          color: SoftUiColors.orangeDeep,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _simCode!,
                        style: AppTypography.display.copyWith(
                          color: SoftUiColors.ink,
                          fontSize: 36,
                          letterSpacing: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 22),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: AppTypography.display.copyWith(
                  color: SoftUiColors.ink,
                  fontSize: 28,
                  letterSpacing: 10,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                decoration: InputDecoration(
                  hintText: '••••••',
                  filled: true,
                  fillColor: SoftUiColors.card,
                  errorText: _error,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: SoftUiColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: SoftUiColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: SoftUiColors.orange,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _busy ? null : _resend,
                child: Text(
                  'Renvoyer le code',
                  style: AppTypography.label.copyWith(
                    color: SoftUiColors.orangeDeep,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              ContinueCtaButton(
                enabled: canSubmit,
                onPressed: _submit,
                label: 'Valider',
                showArrow: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
