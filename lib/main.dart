import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:routing_flow/app/main/splash_screen.dart';
import 'app/app_router.dart';
import 'app/services/notification_service.dart';
import 'app/services/dynamic_link_service.dart';



@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotificationService().showNotificationFromRemote(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  runApp(const ProviderScope(child: AppInitializer()));
}

final initializeAppProvider = FutureProvider<void>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500)); 
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationService = NotificationService();
    notificationService.init();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      DynamicLinkService.tryNavigateToDynamicLink();
    });

    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        DynamicLinkService.initDynamicLinks();
        return child!;
      },
    );
  }
}

class AppInitializer extends ConsumerWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final init = ref.watch(initializeAppProvider);

    return init.when(
      data: (_) => const MyApp(),
      loading: () => const AppSplashScreen(),
      error: (_, __) => const AppSplashScreen(),
    );
  }
}