import 'package:findge/app.dart';
import 'package:findge/controllers/session_controller.dart';
import 'package:findge/controllers/session_store.dart';
import 'package:findge/core/router/app_tabs.dart';
import 'package:findge/core/theme/app_colors.dart';
import 'package:findge/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/session_fixture.dart';

void main() {
  testWidgets('applique le thème Fintech et les 4 onglets', (tester) async {
    await tester.pumpWidget(FinEdgeApp(session: await onboardedSession()));
    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme?.colorScheme.primary, AppColors.primary);
    expect(
      materialApp.theme?.textTheme.bodyLarge?.fontFamily,
      AppTypography.fontFamily,
    );

    expect(find.text(AppTabs.sentier), findsWidgets);
    expect(find.text(AppTabs.simulateur), findsOneWidget);
    expect(find.text(AppTabs.coach), findsOneWidget);
    expect(find.text(AppTabs.profil), findsOneWidget);

    expect(find.text('Ton sentier est tracé'), findsOneWidget);
  });

  testWidgets('navigue vers Simulateur, Coach IA et Profil', (tester) async {
    await tester.pumpWidget(FinEdgeApp(session: await onboardedSession()));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppTabs.simulateur));
    await tester.pumpAndSettle();
    expect(find.text('50 000 FCFA'), findsOneWidget);
    expect(find.text('Cockpit caisse'), findsOneWidget);

    await tester.tap(find.text(AppTabs.coach));
    await tester.pumpAndSettle();
    expect(find.text('Coach FinEdge'), findsOneWidget);
    expect(find.text('Comment calculer ma marge ?'), findsOneWidget);

    await tester.tap(find.text(AppTabs.profil));
    await tester.pumpAndSettle();
    expect(find.text('Invité'), findsOneWidget);
    expect(find.text('Trophées'), findsOneWidget);
  });

  testWidgets('premier lancement affiche le diagnostic sans mot de passe', (
    tester,
  ) async {
    await tester.pumpWidget(
      FinEdgeApp(session: SessionController(store: MemorySessionStore())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Salut ! Qui es-tu ?'), findsOneWidget);
    expect(find.text('Commerçant'), findsOneWidget);
    expect(find.text(AppTabs.sentier), findsNothing);
  });

  testWidgets('3 réponses génèrent un sentier caisse pour un commerçant', (
    tester,
  ) async {
    await tester.pumpWidget(
      FinEdgeApp(session: SessionController(store: MemorySessionStore())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Commerçant'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mieux gérer ma caisse'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('5 min / jour'));
    await tester.pumpAndSettle();

    expect(find.text('Ton sentier est tracé'), findsOneWidget);
    expect(find.text('5 min / jour · Commerçant'), findsOneWidget);
    expect(find.text('Ma caisse du jour'), findsOneWidget);
    expect(find.text('Leçon active'), findsOneWidget);
    expect(find.text(AppTabs.sentier), findsWidgets);
  });
}
