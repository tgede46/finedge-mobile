import 'package:flutter/material.dart';

/// Catalogue d’avatars FinEdge (animaux de la quête).
///
/// Sans PNG : emoji temporaire. Déposer `assets/avatars/{id}.png` pour remplacer.
class AvatarSpec {
  const AvatarSpec({
    required this.id,
    required this.title,
    required this.emoji,
    required this.tint,
    this.subtitle = '',
    this.icon = Icons.pets_rounded,
    this.assetPath,
  });

  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final IconData icon;
  final Color tint;
  final String? assetPath;
}

abstract final class AvatarCatalog {
  static const List<AvatarSpec> all = [
    AvatarSpec(
      id: 'explorateur',
      title: 'Explorateur',
      emoji: '🦊',
      tint: Color(0xFFFFE0B2),
      assetPath: 'assets/avatars/explorateur.png',
    ),
    AvatarSpec(
      id: 'stratege',
      title: 'Stratège',
      emoji: '🦉',
      tint: Color(0xFFE8EAF6),
      assetPath: 'assets/avatars/stratege.png',
    ),
    AvatarSpec(
      id: 'batisseur',
      title: 'Bâtisseur',
      emoji: '🐻',
      tint: Color(0xFFFFECB3),
      assetPath: 'assets/avatars/batisseur.png',
    ),
    AvatarSpec(
      id: 'chanceux',
      title: 'Chanceux',
      emoji: '🐱',
      tint: Color(0xFFFFEBEE),
      assetPath: 'assets/avatars/chanceux.png',
    ),
    AvatarSpec(
      id: 'econome',
      title: 'Économe',
      emoji: '🐿️',
      tint: Color(0xFFFFF3E0),
      assetPath: 'assets/avatars/econome.png',
    ),
    AvatarSpec(
      id: 'patient',
      title: 'Patient',
      emoji: '🐢',
      tint: Color(0xFFE8F5E9),
      assetPath: 'assets/avatars/patient.png',
    ),
  ];

  /// Anciens IDs → nouveaux (sessions déjà sauvées).
  static const _legacy = {
    'entrepreneur': 'explorateur',
    'sage': 'stratege',
    'commercante': 'chanceux',
    'etudiant': 'econome',
    'visionnaire': 'patient',
  };

  static AvatarSpec byId(String? id) {
    final resolved = _legacy[id] ?? id;
    return all.firstWhere((a) => a.id == resolved, orElse: () => all.first);
  }
}

/// Pastille avatar (Profil, Accueil, classement).
class FinedgeAvatar extends StatelessWidget {
  const FinedgeAvatar({
    super.key,
    required this.avatarId,
    this.radius = 28,
    this.onTap,
  });

  final String? avatarId;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final spec = AvatarCatalog.byId(avatarId);
    final child = CircleAvatar(
      radius: radius,
      backgroundColor: spec.tint,
      child: _AvatarFace(spec: spec, size: radius * 1.35),
    );

    if (onTap == null) return child;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: child,
    );
  }
}

class _AvatarFace extends StatelessWidget {
  const _AvatarFace({required this.spec, required this.size});

  final AvatarSpec spec;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (spec.assetPath != null) {
      return Image.asset(
        spec.assetPath!,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, error, stackTrace) =>
            Text(spec.emoji, style: TextStyle(fontSize: size * 0.72)),
      );
    }
    return Text(spec.emoji, style: TextStyle(fontSize: size * 0.72));
  }
}
