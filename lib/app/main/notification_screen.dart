import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Notification ${index + 1}'),
            subtitle: const Text('This is a sample notification'),
            onTap: () {
              GoRouter.of(context).go('/details/${index + 1}');
            },
          );
        },
      ),
    );
  }
}
