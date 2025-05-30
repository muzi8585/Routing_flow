import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routing_flow/app/main/splash_screen.dart';

import '../services/provider.dart';

// @Riverpod(keepAlive: true)
// Future<void> appStartup(AppStartupRef ref) async {
//   ref.onDispose(() {
//     ref.invalidate(prefsProvider);
//   });
//   await ref.watch(prefsProvider.future);
// }

final appStartupProvider = FutureProvider.autoDispose((ref) {
  ref.onDispose(() {
    ref.invalidate(prefsProvider);
  });
  return ref.watch(prefsProvider.future);
});

class AppStartupWidget extends ConsumerWidget {
  const AppStartupWidget({super.key, required this.onLoaded});
  final WidgetBuilder onLoaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appStartupProvider);
    return appStartupState.when(
      data: (_) => const AppSplashScreen(),
      loading: () => const AppSplashScreen(),
      error: (e, st) => AppStartupErrorWidget(
        message: e.toString(),
        onRetry: () => ref.invalidate(appStartupProvider),
      ),
    );
  }
}

class FeatureHighlight extends StatelessWidget {
  final String text;
  const FeatureHighlight({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Color.fromARGB(255, 231, 231, 231),
            size: 18,
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Color.fromARGB(255, 231, 231, 231),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class AppStartupErrorWidget extends StatelessWidget {
  const AppStartupErrorWidget(
      {super.key, required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
