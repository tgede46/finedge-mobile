import 'package:flutter/material.dart';

import '../../controllers/session_scope.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/soft_ui_colors.dart';
import '../../models/avatar_catalog.dart';

enum ClassementTab { amis, mondiale }

class RankEntry {
  const RankEntry({
    required this.rank,
    required this.name,
    required this.xp,
    required this.avatarId,
    this.isYou = false,
    this.delta = 0,
  });

  final int rank;
  final String name;
  final int xp;
  final String avatarId;
  final bool isYou;

  /// >0 montée, <0 descente, 0 stable
  final int delta;
}

/// Classement Amis (invités) + Ligue mondiale.
class ClassementView extends StatefulWidget {
  const ClassementView({super.key});

  @override
  State<ClassementView> createState() => _ClassementViewState();
}

class _ClassementViewState extends State<ClassementView> {
  ClassementTab _tab = ClassementTab.amis;

  static const _boardSize = 30;
  static const _avatars = [
    'explorateur',
    'stratege',
    'batisseur',
    'chanceux',
    'econome',
    'patient',
  ];
  static const _names = [
    'Léo',
    'Emma',
    'Mia',
    'Hugo',
    'Alice',
    'Tom',
    'Awa',
    'Ibrahim',
    'Fatou',
    'Moussa',
    'Kofi',
    'Aïcha',
    'Yann',
    'Sana',
    'Omar',
    'Lina',
    'Noah',
    'Chloé',
    'Amadou',
    'Inès',
    'Paul',
    'Mariama',
    'Lucas',
    'Zineb',
    'Adama',
    'Camille',
    'Sekou',
    'Nadia',
    'Jules',
    'Rama',
    'Imane',
    'David',
  ];

  late final List<RankEntry> _amis = _buildBoard(
    startXp: 1450,
    step: 28,
    youRank: 5,
    topNames: const ['Léo', 'Emma', 'Mia'],
  );

  late final List<RankEntry> _mondiale = _buildBoard(
    startXp: 4820,
    step: 95,
    youRank: 18,
    topNames: const ['Kofi', 'Aïcha', 'Yann'],
  );

  static List<RankEntry> _buildBoard({
    required int startXp,
    required int step,
    required int youRank,
    required List<String> topNames,
  }) {
    final list = <RankEntry>[];
    var nameIndex = 0;
    for (var rank = 1; rank <= _boardSize; rank++) {
      final isYou = rank == youRank;
      final xp = startXp - (rank - 1) * step;
      final delta = rank % 5 == 0 ? 0 : (rank % 2 == 0 ? 1 : -1);
      String name;
      if (isYou) {
        name = 'Vous';
      } else if (rank <= 3) {
        name = topNames[rank - 1];
      } else {
        // saute les prénoms déjà utilisés en top 3
        while (topNames.contains(_names[nameIndex % _names.length])) {
          nameIndex++;
        }
        name = _names[nameIndex % _names.length];
        nameIndex++;
      }
      list.add(
        RankEntry(
          rank: rank,
          name: name,
          xp: xp.clamp(120, startXp),
          avatarId: _avatars[(rank - 1) % _avatars.length],
          isYou: isYou,
          delta: isYou ? 2 : delta,
        ),
      );
    }
    return list;
  }

  List<RankEntry> get _entries =>
      _tab == ClassementTab.amis ? _amis : _mondiale;

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context).session;
    final youXp = session.xp > 0 ? session.xp : 980;
    final entries = _entries.map((e) {
      if (!e.isYou) return e;
      return RankEntry(
        rank: e.rank,
        name: e.name,
        xp: youXp,
        avatarId: session.diagnostic?.avatar ?? e.avatarId,
        isYou: true,
        delta: e.delta,
      );
    }).toList();

    final top3 = entries.where((e) => e.rank <= 3).toList()
      ..sort((a, b) => a.rank.compareTo(b.rank));
    final rest = entries.where((e) => e.rank > 3).toList();

    return ColoredBox(
      color: SoftUiColors.cream,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Text(
              'Classement',
              textAlign: TextAlign.center,
              style: AppTypography.display.copyWith(
                color: SoftUiColors.ink,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 16),
            _TabSwitch(tab: _tab, onChanged: (t) => setState(() => _tab = t)),
            const SizedBox(height: 20),
            if (top3.length >= 3) _Podium(entries: top3),
            const SizedBox(height: 18),
            for (final e in rest) ...[
              _RankRow(entry: e),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _TabSwitch extends StatelessWidget {
  const _TabSwitch({required this.tab, required this.onChanged});

  final ClassementTab tab;
  final ValueChanged<ClassementTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: SoftUiColors.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: SoftUiColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabPill(
              label: 'Amis',
              selected: tab == ClassementTab.amis,
              onTap: () => onChanged(ClassementTab.amis),
            ),
          ),
          Expanded(
            child: _TabPill(
              label: 'Ligue mondiale',
              selected: tab == ClassementTab.mondiale,
              onTap: () => onChanged(ClassementTab.mondiale),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? SoftUiColors.orange : Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.label.copyWith(
              color: selected ? Colors.white : SoftUiColors.orangeDeep,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _Podium extends StatelessWidget {
  const _Podium({required this.entries});

  final List<RankEntry> entries;

  RankEntry _at(int rank) =>
      entries.firstWhere((e) => e.rank == rank, orElse: () => entries.first);

  @override
  Widget build(BuildContext context) {
    final first = _at(1);
    final second = _at(2);
    final third = _at(3);

    return SizedBox(
      height: 210,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: _PodiumColumn(entry: second, barHeight: 56)),
          const SizedBox(width: 8),
          Expanded(child: _PodiumColumn(entry: first, barHeight: 88)),
          const SizedBox(width: 8),
          Expanded(child: _PodiumColumn(entry: third, barHeight: 44)),
        ],
      ),
    );
  }
}

class _PodiumColumn extends StatelessWidget {
  const _PodiumColumn({required this.entry, required this.barHeight});

  final RankEntry entry;
  final double barHeight;

  @override
  Widget build(BuildContext context) {
    final medal = switch (entry.rank) {
      1 => const Color(0xFFFFD54F),
      2 => const Color(0xFFE0E0E0),
      _ => const Color(0xFFFFCC80),
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            FinedgeAvatar(
              avatarId: entry.avatarId,
              radius: entry.rank == 1 ? 30 : 26,
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: medal,
                  shape: BoxShape.circle,
                  border: Border.all(color: SoftUiColors.card, width: 2),
                ),
                child: Text(
                  '${entry.rank}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: SoftUiColors.ink,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          entry.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.optionTitle.copyWith(
            color: SoftUiColors.ink,
            fontSize: 13,
          ),
        ),
        Text(
          '${entry.xp} XP',
          style: AppTypography.caption.copyWith(color: SoftUiColors.muted),
        ),
        const SizedBox(height: 8),
        Container(
          height: barHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: entry.rank == 1 ? SoftUiColors.orange : SoftUiColors.tanSoft,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          alignment: Alignment.center,
          child: entry.delta == 0
              ? null
              : Icon(
                  entry.delta > 0
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 18,
                  color: SoftUiColors.muted,
                ),
        ),
      ],
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({required this.entry});

  final RankEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: entry.isYou ? const Color(0xFFFFF1E0) : SoftUiColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: entry.isYou ? SoftUiColors.orange : SoftUiColors.border,
          width: entry.isYou ? 2.2 : 1.5,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              '${entry.rank}',
              style: AppTypography.optionTitle.copyWith(
                color: SoftUiColors.ink,
                fontSize: 15,
              ),
            ),
          ),
          FinedgeAvatar(avatarId: entry.avatarId, radius: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              entry.name,
              style: AppTypography.optionTitle.copyWith(
                color: SoftUiColors.ink,
              ),
            ),
          ),
          Text(
            '${entry.xp} XP',
            style: AppTypography.label.copyWith(
              color: SoftUiColors.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (entry.delta != 0) ...[
            const SizedBox(width: 6),
            Icon(
              entry.delta > 0
                  ? Icons.arrow_drop_up_rounded
                  : Icons.arrow_drop_down_rounded,
              color: entry.delta > 0
                  ? const Color(0xFF43A047)
                  : const Color(0xFFE53935),
              size: 22,
            ),
          ],
        ],
      ),
    );
  }
}
