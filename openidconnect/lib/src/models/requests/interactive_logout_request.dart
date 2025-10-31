part of openidconnect;

class InteractiveLogoutRequest {
  final String idToken;
  final OpenIdConfiguration configuration;
  final int popupWidth;
  final int popupHeight;
  final bool useWebPopup;
  final String postLogoutRedirectUrl;
  final String? state;

  InteractiveLogoutRequest({
    required this.configuration,
    required this.idToken,
    required this.postLogoutRedirectUrl,
    this.popupWidth = 640,
    this.popupHeight = 480,
    this.useWebPopup = true,
    this.state,
  });

  Map<String, String> toMap() {
    return {
      "id_token_hint": idToken,
      "post_logout_redirect_uri": postLogoutRedirectUrl,
      if (state != null) "state": state!,
    };
  }
}
