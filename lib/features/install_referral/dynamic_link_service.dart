import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:commercepal/app/utils/logger.dart';

class DynamicLinkService {
  static Future<String> createDynamicLink(String productId) async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse('https://commercepal.com/product/$productId'),
      uriPrefix: 'https://commercepal.page.link',
      androidParameters: const AndroidParameters(
        packageName: 'com.commercepal.app',
        minimumVersion: 1,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.commercepal.app',
        minimumVersion: '1.0.0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Check out this product on CommercePal',
        description:
            'I found this amazing product on CommercePal. Take a look!',
        imageUrl:
            Uri.parse('https://commercepal.com/assets/images/app_icon.png'),
      ),
    );

    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    return dynamicLink.shortUrl.toString();
  }

  static Future<void> handleDynamicLinks(BuildContext context) async {
    // Handle initial dynamic link if app was opened with it
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      _handleLink(initialLink, context);
    }

    // Handle dynamic links when app is already running
    FirebaseDynamicLinks.instance.onLink.listen(
      (dynamicLinkData) {
        _handleLink(dynamicLinkData, context);
      },
      onError: (error) {
        appLog('Dynamic Link Failed: \${error.message}');
      },
    );
  }

  static void _handleLink(PendingDynamicLinkData data, BuildContext context) {
    final Uri deepLink = data.link;
    final List<String> segments = deepLink.pathSegments;

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
      final dynamicLink = await createDynamicLink(productId);
      await Share.share(
        'Check out this amazing product on CommercePal: $dynamicLink',
        subject: 'CommercePal Product Share',
      );
    } catch (e) {
      appLog('Error sharing product: $e');
    }
  }
}
