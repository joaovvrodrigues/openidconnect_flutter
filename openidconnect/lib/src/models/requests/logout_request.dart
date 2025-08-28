part of openidconnect;

class LogoutRequest {
  final String idToken;
  final String? postLogoutRedirectUri;
  final String? state;
  final OpenIdConfiguration configuration;

  const LogoutRequest({
    required this.idToken,
    this.postLogoutRedirectUri,
    this.state,
    required this.configuration,
  });

  Map<String, String> toMap() {
    return {
      "id_token_hint": idToken,
      if (postLogoutRedirectUri != null)
        "post_logout_redirect_uri": postLogoutRedirectUri!,
      if (state != null) "state": state!,
    };
  }
}
