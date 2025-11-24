part of openidconnect;

enum TokenType { idToken, accessToken, refreshToken }

class RevokeTokenRequest {
  final OpenIdConfiguration configuration;
  final String token;
  final TokenType tokenType;
  final String? clientId;
  final String? clientSecret;

  const RevokeTokenRequest({
    required this.configuration,
    required this.token,
    required this.tokenType,
    this.clientId,
    this.clientSecret,
  }) : assert(tokenType != TokenType.idToken, "ID Tokens cannot be revoked.");

  Map<String, String> toMap({bool useBasicAuth = true}) {
    var map = {
      "token": token,
      "token_type_hint": tokenType == TokenType.accessToken
          ? "access_token"
          : "refresh_token",
    };
    if (!useBasicAuth && clientId != null)
      map = {"client_id": clientId!, ...map};
    if (!useBasicAuth && clientSecret != null)
      map = {"client_secret": clientSecret!, ...map};
    return map;
  }
}
