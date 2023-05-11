import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoginLoadingProvider = StateProvider<bool>((ref) => false);

class AuthService {
  final FirebaseAuth firebase = FirebaseAuth.instance;
  final ProviderRef<AuthService> _container;

  AuthService(this._container);

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      _container.read(isLoginLoadingProvider.notifier).state = true;
      final result = await firebase.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _container.read(isLoginLoadingProvider.notifier).state = false;
      return result;
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'user-not-found') {
        try {
          _container.read(isLoginLoadingProvider.notifier).state = true;
          final result = await firebase.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          _container.read(isLoginLoadingProvider.notifier).state = false;
          return result;
        } catch (e) {
          _container.read(isLoginLoadingProvider.notifier).state = false;
          rethrow;
        }
      }
      _container.read(isLoginLoadingProvider.notifier).state = false;
      rethrow;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      _container.read(isLoginLoadingProvider.notifier).state = true;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final result = await firebase.signInWithCredential(credential);
      _container.read(isLoginLoadingProvider.notifier).state = false;
      return result;
    } catch (e) {
      _container.read(isLoginLoadingProvider.notifier).state = false;
      rethrow;
    }
  }

  Future<void> signOut() async {
    _container.read(isLoginLoadingProvider.notifier).state = true;
    await GoogleSignIn().signOut();
    await firebase.signOut();
    _container.read(isLoginLoadingProvider.notifier).state = false;
  }
}

final authStateProvider = StateProvider<bool>(
  (ref) => false,
);

final authenticationProvider = Provider<AuthService>((ref) {
  final authService = AuthService(ref);

  authService.firebase.authStateChanges().listen((User? user) {
    if (user == null) {
      ref.read(authStateProvider.notifier).state = false;
    } else {
      ref.read(authStateProvider.notifier).state = true;
    }
  });

  return authService;
});
