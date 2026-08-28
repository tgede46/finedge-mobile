`/// Monnaie choisie par l’utilisateur — l’app s’adapte (montants, textes).
class AppCurrency {
  const AppCurrency({
    required this.id,
    required this.label,
    required this.code,
  });

  final String id;
  final String label;
  final String code;

  static const xof = AppCurrency(
    id: 'xof',
    label: 'Franc CFA (UEMOA)',
    code: 'XOF',
  );

  static const all = [
    AppCurrency(id: 'ngn', label: 'Naira (Nigeria)', code: 'NGN'),
    AppCurrency(id: 'ghs', label: 'Cedi (Ghana)', code: 'GHS'),
    AppCurrency(id: 'mad', label: 'Dirham (Maroc)', code: 'MAD'),
    AppCurrency(id: 'tnd', label: 'Dinar (Tunisie)', code: 'TND'),
    AppCurrency(id: 'eur', label: 'Euro', code: 'EUR'),
    AppCurrency(id: 'usd', label: 'Dollar US', code: 'USD'),
    xof,
    AppCurrency(
      id: 'xaf',
      label: 'Franc CFA (Afrique centrale)',
      code: 'XAF',
    ),
    AppCurrency(id: 'kes', label: 'Shilling (Kenya)', code: 'KES'),
    AppCurrency(id: 'zar', label: 'Rand (Afrique du Sud)', code: 'ZAR'),
  ];

  static AppCurrency byId(String? id) {
    if (id == null || id.isEmpty) return xof;
    for (final c in all) {
      if (c.id == id) return c;
    }
    return xof;
  }

  static String format(int amount, {String? currencyId}) {
    final code = byId(currencyId).code;
    final s = amount.abs().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    final sign = amount < 0 ? '−' : '';
    return '$sign$buf $code';
  }

  /// Remplace les mentions FCFA figées par le code choisi.
  static String adapt(String text, {String? currencyId}) {
    final code = byId(currencyId).code;
    return text.replaceAll('FCFA', code);
  }
}
