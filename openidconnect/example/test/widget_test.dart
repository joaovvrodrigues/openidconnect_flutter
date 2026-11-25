import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openidconnect_example/main.dart';

void main() {
  testWidgets('mostra as opções de autenticação no app de exemplo', (
    tester,
  ) async {
    await tester.pumpWidget(MyApp());

    expect(
      find.widgetWithText(AppBar, 'Choose Your OpenIdConnect Flow'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(TextButton, 'Interactive Authorization Code PKCE'),
      findsOneWidget,
    );
  });
}
