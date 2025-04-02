part of openidconnect;

class OpenIdConnectAndroidiOS {
  static Future<String> authorizeInteractive({
    required BuildContext context,
    required String title,
    required String authorizationUrl,
    required String redirectUrl,
  }) async {
    final controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);

    Future<String?> resultFuture = Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (dialogContext) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                title,
              ),
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(dialogContext, null),
              ),
            ),
            body: flutterWebView.WebViewWidget(
              controller: controller
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onPageFinished: (String url) {
                      if (url.startsWith(redirectUrl)) {
                        Navigator.pop(dialogContext, url);
                      }
                    },
                  ),
                )
                ..loadRequest(Uri.parse(authorizationUrl)),
            ),
          );
        },
      ),
    );

    final result = await resultFuture;

    if (result == null) throw AuthenticationException(ERROR_USER_CLOSED);

    return result;
  }
}
