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

  testWidgets('Get Started puis onboarding style Duolingo', (tester) async {
    await tester.pumpWidget(
      FinEdgeApp(session: SessionController(store: MemorySessionStore())),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    expect(find.text('Tu t’y connais comment en argent ?'), findsOneWidget);
  });

  testWidgets('parcours Duolingo jusqu’à l’accueil', (tester) async {
    await tester.pumpWidget(
      FinEdgeApp(session: SessionController(store: MemorySessionStore())),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Je connais quelques bases'));
    await tester.pump();
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();

    expect(find.text('Et toi, tu fais quoi dans la vie ?'), findsOneWidget);
    await tester.tap(find.text('Étudiant'));
    await tester.pump();
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();

    expect(find.textContaining('étudiant'), findsOneWidget);
    await tester.tap(find.text('Mieux gérer mon budget'));
    await tester.pump();
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('5 min / jour'));
    await tester.pump();
    await tester.tap(find.text('Je m’engage'));
    await tester.pumpAndSettle();

    expect(find.textContaining('tu construis déjà'), findsOneWidget);
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Trouver mon niveau'));
    await tester.pump();
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();

    expect(find.textContaining('comment on t’appelle'), findsOneWidget);
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
