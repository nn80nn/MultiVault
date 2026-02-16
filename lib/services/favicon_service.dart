class FaviconService {
  /// Returns a Google Favicon API URL for the given website URL.
  /// Returns null if the URL is empty or invalid.
  String? getFaviconUrl(String? url) {
    if (url == null || url.isEmpty) return null;

    try {
      final uri = Uri.parse(url);
      final host = uri.host;
      if (host.isEmpty) {
        // Try parsing as just a domain
        final domainUri = Uri.parse('https://$url');
        if (domainUri.host.isEmpty) return null;
        return 'https://www.google.com/s2/favicons?domain=${domainUri.host}&sz=64';
      }
      return 'https://www.google.com/s2/favicons?domain=$host&sz=64';
    } catch (e) {
      return null;
    }
  }
}
