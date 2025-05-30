import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routing_flow/app/main/app_startup.dart';
import 'package:routing_flow/main.dart';

import '../services/splash_service.dart';

class AppSplashScreen extends StatelessWidget {
  const AppSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.6,
                    color: Color.fromARGB(255, 231, 231, 231),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Loading...",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 27, 27, 27),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
