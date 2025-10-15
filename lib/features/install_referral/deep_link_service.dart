import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:commercepal/app/utils/logger.dart';

class DeepLinkService {
  static const String APP_SCHEME = 'commercepal';
  static const String APP_HOST = 'app.commercepal.com';

  static Future<void> initUniLinks(BuildContext context) async {
    try {
      // Handle app links while app is running
      final appLinks = AppLinks();

      // Handle initial app link
      final initialUri = await appLinks.getInitialLink();
      if (initialUri != null) {
        _handleLink(initialUri, context);
      }

      // Listen for app links while app is running
      appLinks.uriLinkStream.listen((uri) {
        if (uri != null) {
          _handleLink(uri, context);
        }
      });
    } catch (e) {
      appLog('Deep link initialization error: $e');
    }
  }

  static void _handleLink(Uri uri, BuildContext context) {
    final List<String> segments = uri.pathSegments;

    if (segments.length >= 2 && segments[0] == 'product') {
      final String productId = segments[1];
      Navigator.pushNamed(
        context,
        '/product',
        arguments: {'productId': productId},
      );
    }
  }

  static Future<void> shareProduct(String productId) async {
    try {
      // Create a deep link URL
      final String productUrl = 'https://$APP_HOST/product/$productId';

      // Create a more descriptive share message
      final String shareMessage =
          'Check out this amazing product on CommercePal!\n$productUrl';

      await Share.share(
        shareMessage,
        subject: 'CommercePal Product Share',
      );
    } catch (e) {
      appLog('Error sharing product: $e');
    }
  }
}
