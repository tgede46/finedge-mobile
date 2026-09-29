import 'package:findge/app.dart';
import 'package:findge/controllers/session_controller.dart';
import 'package:findge/controllers/session_store.dart';
import 'package:findge/core/router/app_tabs.dart';
import 'package:findge/core/theme/app_colors.dart';
import 'package:findge/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/session_fixture.dart';

Future<void> _tapNext(WidgetTester tester) async {
  final suivants = [
    find.text('SUIVANT'),
    find.text('Suivant'),
    find.text('C’est parti'),
    find.text('Continuer'),
  ];
  for (final f in suivants) {
    if (f.evaluate().isNotEmpty) {
      await tester.tap(f.first);
      await tester.pumpAndSettle();
      return;
    }
  }
  fail('Aucun bouton suivant trouvé');
}

void main() {
  testWidgets('applique le thème Fintech et les onglets', (tester) async {
    await tester.pumpWidget(FinEdgeApp(session: await onboardedSession()));
    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme?.colorScheme.primary, AppColors.primary);
    expect(
      materialApp.theme?.textTheme.bodyLarge?.fontFamily,
      AppTypography.fontFamily,
    );
    expect(find.text(AppTabs.accueil), findsWidgets);
  });

  testWidgets('Commencer puis mieux te comprendre', (tester) async {
    await tester.pumpWidget(
      FinEdgeApp(session: SessionController(store: MemorySessionStore())),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    expect(
      find.text('Quelques questions pour mieux te comprendre'),
      findsOneWidget,
    );
    expect(find.textContaining('sentier financier'), findsNothing);
  });

  testWidgets('parcours jeu jusqu’à l’accueil', (tester) async {
    await tester.pumpWidget(
      FinEdgeApp(session: SessionController(store: MemorySessionStore())),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();
    await _tapNext(tester);

    await tester.tap(find.text('Étudiant'));
    await tester.pump();
    await _tapNext(tester);

    await tester.tap(find.text('Je connais quelques bases'));
    await tester.pump();
    await _tapNext(tester);

    await tester.tap(find.text('5 min / jour'));
    await tester.pump();
    await _tapNext(tester);

    expect(find.text('Ton profil'), findsOneWidget);
    await _tapNext(tester);

    await tester.tap(find.text('Mieux gérer mon budget'));
    await tester.pump();
    await _tapNext(tester);

    expect(find.text('Comment t’appelles-tu ?'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Awa');
    await tester.pump();
    await _tapNext(tester);

    await tester.tap(find.text('18 – 25 ans'));
    await tester.pump();
    await _tapNext(tester);

    expect(find.text('Choisissez votre Avatar'), findsOneWidget);
    await tester.tap(find.text('Stratège'));
    await tester.pump();
    await tester.tap(find.text('Commencer l’Aventure'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Ne perds pas ta progression'), findsOneWidget);
    await tester.tap(find.text('Plus tard'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Salut Awa'), findsOneWidget);
    expect(find.text(AppTabs.accueil), findsWidgets);
  });
}
