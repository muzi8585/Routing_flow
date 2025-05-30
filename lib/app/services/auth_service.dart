import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService extends StateNotifier<bool> {
  AuthService() : super(false) {
    // Listen to Firebase Auth state changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      state = user != null; // Update auth state based on user presence
    });
  }

  // Sign in with email and password
  Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // Sign up with email and password
  Future<void> signup(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Signup failed: ${e.toString()}');
    }
  }

  // Log out
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}

final authServiceProvider = StateNotifierProvider<AuthService, bool>(
  (ref) => AuthService(),
);
