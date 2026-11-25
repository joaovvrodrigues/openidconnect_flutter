import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openidconnect/openidconnect.dart';
import 'package:openidconnect_platform_interface/openidconnect_platform_interface.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

const _urlAutorizacao = 'https://oidc.example.invalid/authorize';
const _urlRetorno = 'https://app.example.invalid/callback';

void main() {
  late _WebViewTeste plataforma;

  setUp(() {
    final plataformaAnterior = WebViewPlatform.instance;
    plataforma = _WebViewTeste();
    WebViewPlatform.instance = plataforma;
    if (plataformaAnterior != null) {
      addTearDown(() => WebViewPlatform.instance = plataformaAnterior);
    }
  });

  Future<BuildContext> montarApp(WidgetTester tester) async {
    late BuildContext contexto;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: Builder(
          builder: (context) {
            contexto = context;
            return const Scaffold();
          },
        ),
      ),
    );
    return contexto;
  }

  testWidgets(
    'abre o login com Material em pt-BR e retorna a URL do callback',
    (tester) async {
      final contexto = await montarApp(tester);

      final resultado = OpenIdConnectAndroidiOS.authorizeInteractive(
        context: contexto,
        title: 'Entrar',
        authorizationUrl: _urlAutorizacao,
        redirectUrl: _urlRetorno,
      );
      const retorno = '$_urlRetorno?code=teste';
      final verificacao = expectLater(resultado, completion(retorno));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Entrar'), findsOneWidget);
      expect(tester.takeException(), isNull);
      plataforma.aoConcluirPagina(retorno);
      await tester.pumpAndSettle();
      await verificacao;
    },
  );

  testWidgets('fecha o login pelo botão da barra de título', (tester) async {
    final contexto = await montarApp(tester);

    final resultado = OpenIdConnectAndroidiOS.authorizeInteractive(
      context: contexto,
      title: 'Entrar',
      authorizationUrl: _urlAutorizacao,
      redirectUrl: _urlRetorno,
    );
    final verificacao = expectLater(
      resultado,
      throwsA(
        isA<AuthenticationException>().having(
          (e) => e.errorMessage,
          'errorMessage',
          ERROR_USER_CLOSED,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    await verificacao;
    expect(find.text('Entrar'), findsNothing);
  });
}

class _WebViewTeste extends WebViewPlatform {
  late PageEventCallback aoConcluirPagina;

  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) => _ControleWebView(params);

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) => _NavegacaoWebView(params, (callback) => aoConcluirPagina = callback);

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) => _WidgetWebView(params);
}

class _ControleWebView extends PlatformWebViewController {
  _ControleWebView(super.params) : super.implementation();

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}

  @override
  Future<void> loadRequest(LoadRequestParams params) async {}
}

class _NavegacaoWebView extends PlatformNavigationDelegate {
  _NavegacaoWebView(super.params, this.registrarConclusao)
    : super.implementation();

  final void Function(PageEventCallback) registrarConclusao;

  @override
  Future<void> setOnPageFinished(PageEventCallback onPageFinished) async {
    registrarConclusao(onPageFinished);
  }
}

class _WidgetWebView extends PlatformWebViewWidget {
  _WidgetWebView(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
