import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:routing_flow/app/services/notification_service.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showBottomSheet(BuildContext context) {
    WoltModalSheet.show(
      context: context,
      pageListBuilder: (modalSheetContext) {
        return [
          WoltModalSheetPage(
            topBarTitle: const Text('My Bottom Sheet'),
            trailingNavBarWidget: const CloseButton(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('SnackBar shown!')),
                  );
                },
                child: const Text('Show SnackBar'),
              ),
            ),
          ),
        ];
      },
    );
  }

  void showDialogWithSnackbar(BuildContext context, String dialogTitle,
      String dialogMessage, String snackbarMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(dialogTitle),
        content: Text(dialogMessage),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(snackbarMessage)),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialogWithSnackbar(
                    context,
                    'Hello!',
                    'This is a dialog message.',
                    'This is a snackbar message.',
                  );
                },
                child: Text('Show Dialog'),
              ),
              ElevatedButton(
                onPressed: () => _showBottomSheet(context),
                child: Text('BottomSheet'),
              ),
              ElevatedButton(
                  onPressed: () {
                    String payload = jsonEncode({
                      "route": '/notifications',
                      "params": {
                        "notificationId": "jf8u4h82973",
                        "taskId": "fj3984j9j0",
                      },
                    });
                    NotificationService().showNotification(
                        'New Message',
                      'You have a new message',
                      payload: payload,
                  
                    );
                  },
                  child: Text("send notification")),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Item ${index + 1}'),
                  onTap: () {
                    // Navigate to details screen
                    GoRouter.of(context).go('/details/${index + 1}');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
