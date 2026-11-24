import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openidconnect/openidconnect.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const tokenIdTeste =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";

void main() {
  group('identidade OpenID', () {
    setUp(() async {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
      await EncryptedSharedPreferencesAsync.initialize(
        List.filled(16, 'x').join(),
      );
    });

    tearDown(() {
      SharedPreferencesAsyncPlatform.instance = null;
    });
    test('salva a identidade', () async {
      final identity = OpenIdIdentity(
        accessToken: "testing_access_token",
        expiresAt: DateTime.now(),
        idToken: tokenIdTeste,
        tokenType: "Bearer",
      );

      await identity.save();
    });

    test('recupera a identidade salva', () async {
      final identity = OpenIdIdentity(
        accessToken: "testing_access_token",
        expiresAt: DateTime.now(),
        idToken: tokenIdTeste,
        tokenType: "Bearer",
      );

      await identity.save();

      final loaded = await OpenIdIdentity.load();
      expect(loaded?.accessToken, identity.accessToken);
      expect(loaded?.idToken, identity.idToken);
    });
  });
}
