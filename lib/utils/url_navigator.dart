import 'dart:html' as html;

class UrlNavigator {
  void launchOrFocusUrl(String url) {
    // Check if the URL is already stored in local storage
    String? openedUrl = html.window.localStorage['openedUrl'];

    if (openedUrl == url) {
      // If it's already opened, just focus it (this will not work due to browser limitations)
      // There is no direct way to focus an already opened tab.
      // Instead, we can just inform the user or handle it gracefully.

      html.window.open(url, '_blank'); // Opens in
    } else {
      // Open the new URL in a new tab and store it
      html.window.localStorage['openedUrl'] = url;
      html.window.open(url, '_blank'); // Opens in a new tab
    }
  }
}
