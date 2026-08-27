import 'package:flutter/material.dart';

import '../core/theme/soft_ui_colors.dart';

/// Catalogue d’avatars FinEdge.
///
/// Pour l’instant : icônes Material + teinte.
/// Plus tard : remplacer `icon` par un asset SVG/PNG (`assetPath`) sans changer les IDs.
class AvatarSpec {
  const AvatarSpec({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tint,
    this.assetPath,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color tint;
  final String? assetPath;
}

abstract final class AvatarCatalog {
  static const List<AvatarSpec> all = [
    AvatarSpec(
      id: 'entrepreneur',
      title: "L'Entrepreneur",
      subtitle: 'Commerçant local',
      icon: Icons.storefront_rounded,
      tint: Color(0xFFFFB74D),
    ),
    AvatarSpec(
      id: 'sage',
      title: 'Le Sage',
      subtitle: "Figure d'expérience",
      icon: Icons.menu_book_rounded,
      tint: Color(0xFFBCAAA4),
    ),
    AvatarSpec(
      id: 'batisseur',
      title: 'Le Bâtisseur',
      subtitle: 'Projets ambitieux',
      icon: Icons.construction_rounded,
      tint: Color(0xFFFFCC80),
    ),
    AvatarSpec(
      id: 'commercante',
      title: 'La Commerçante',
      subtitle: 'Vente au marché',
      icon: Icons.shopping_bag_rounded,
      tint: Color(0xFFF8BBD0),
    ),
    AvatarSpec(
      id: 'etudiant',
      title: "L'Étudiant",
      subtitle: 'Apprentissage constant',
      icon: Icons.school_rounded,
      tint: Color(0xFF90CAF9),
    ),
    AvatarSpec(
      id: 'visionnaire',
      title: 'Le Visionnaire',
      subtitle: 'Grandes idées',
      icon: Icons.insights_rounded,
      tint: Color(0xFFCE93D8),
    ),
  ];

  static AvatarSpec byId(String? id) {
    return all.firstWhere((a) => a.id == id, orElse: () => all.first);
  }
}

/// Pastille avatar réutilisable (Profil, Accueil, onboarding).
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
      child: Icon(spec.icon, size: radius * 0.95, color: SoftUiColors.ink),
    );

    if (onTap == null) return child;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: child,
    );
  }
}
