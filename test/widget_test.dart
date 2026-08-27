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
    expect(find.text(AppTabs.accueil), findsWidgets);
  });

  testWidgets('Get Started puis objectifs style quête', (tester) async {
    await tester.pumpWidget(
      FinEdgeApp(session: SessionController(store: MemorySessionStore())),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    expect(find.text('Quel est ton objectif ?'), findsOneWidget);
    expect(find.text('Économiser pour un achat'), findsOneWidget);
    expect(find.text('Gérer mon budget'), findsOneWidget);
    expect(find.textContaining('ÉTAPE 1 SUR 3'), findsOneWidget);
  });

  testWidgets('quête 3 étapes jusqu’à l’accueil', (tester) async {
    await tester.pumpWidget(
      FinEdgeApp(session: SessionController(store: MemorySessionStore())),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gérer mon budget'));
    await tester.pump();
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();

    expect(find.text('Choisis ton Avatar'), findsOneWidget);
    await tester.tap(find.text("L'Entrepreneur"));
    await tester.pump();
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();

    expect(find.text('Faisons connaissance !'), findsOneWidget);
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Awa');
    await tester.enterText(fields.at(1), '22');
    await tester.pump();
    await tester.tap(find.text("C'est parti ! 🚀"));
    await tester.pumpAndSettle();

    expect(find.textContaining('Salut Awa'), findsOneWidget);
    expect(find.text(AppTabs.accueil), findsWidgets);
  });
}
