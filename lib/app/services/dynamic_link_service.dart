// ignore_for_file: deprecated_member_use

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_router.dart';
class DynamicLinkService {
  static Uri? _pendingDynamicLinkUri;

  static Future<void> initDynamicLinks() async {
    print("The init dynamic link function started.");

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      print("The app is opened via link");
      final Uri uri = dynamicLinkData.link;
      _handleDynamicLink(uri); 
    });

    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      print("The app is launched from link in terminated state");
      final Uri uri = initialLink.link;
      _pendingDynamicLinkUri = uri; 
    }
  }

  static void _handleDynamicLink(Uri uri) {
    _pendingDynamicLinkUri = uri; 
    tryNavigateToDynamicLink();
  }

  static void tryNavigateToDynamicLink() {
    if (_pendingDynamicLinkUri != null && navigatorKey.currentContext != null) {
      print('Navigating to: ${_pendingDynamicLinkUri!.path}');
      navigatorKey.currentContext!.go(_pendingDynamicLinkUri!.path);
      _pendingDynamicLinkUri = null; 
    }
  }
}