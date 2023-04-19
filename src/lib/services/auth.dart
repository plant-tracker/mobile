import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  final FirebaseAuth firebase = FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await firebase.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await firebase.signOut();
  }

  String? getUsername() {
    return firebase.currentUser?.displayName;
  }

  String? getUserID() {
    return firebase.currentUser?.uid;
  }
}

final authStateProvider = StateProvider<bool>(
  (ref) => false,
);

final authenticationProvider = Provider<AuthService>((ref) {
  final authService = AuthService();

  authService.firebase.authStateChanges().listen((User? user) {
    if (user == null) {
      ref.read(authStateProvider.state).state = false;
    } else {
      ref.read(authStateProvider.state).state = true;
    }
  });

  return authService;
});
