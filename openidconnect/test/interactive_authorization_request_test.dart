import 'dart:convert';

import 'package:crypto/crypto.dart' as referencia;
import 'package:flutter_test/flutter_test.dart';
import 'package:openidconnect/openidconnect.dart';

void main() {
  test(
    'gera desafio PKCE S256 a partir do verificador da requisição',
    () async {
      final configuracao = OpenIdConfiguration.fromJson({
        'issuer': 'https://oidc.example.invalid',
        'authorization_endpoint': 'https://oidc.example.invalid/authorize',
        'code_challenge_methods_supported': ['S256'],
      });
      final requisicao = await InteractiveAuthorizationRequest.create(
        clientId: 'cliente-teste',
        redirectUrl: 'https://app.example.invalid/callback',
        scopes: ['openid'],
        configuration: configuracao,
        autoRefresh: false,
        useWebPopup: false,
      );

      final digest = referencia.sha256.convert(
        ascii.encode(requisicao.codeVerifier),
      );
      final desafioEsperado = base64UrlEncode(digest.bytes).replaceAll('=', '');

      expect(
        requisicao.codeVerifier,
        matches(RegExp(r'^[A-Za-z0-9._~-]{43,128}$')),
      );
      expect(requisicao.codeChallenge, desafioEsperado);
      expect(requisicao.toMap()['code_challenge'], desafioEsperado);
      expect(requisicao.toMap()['code_challenge_method'], 'S256');
    },
  );
}
