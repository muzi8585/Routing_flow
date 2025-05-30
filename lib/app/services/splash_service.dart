import 'dart:math';

Future<bool> initializeApp() async {
  // Step 1: Initialize Firebase
  // DynamicLinkService.initDynamicLinks();
  await Future.delayed(Duration(seconds: 4));
  return Random().nextBool();
}
