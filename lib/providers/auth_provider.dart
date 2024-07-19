import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  Future<void> signUp(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      await _user?.updateDisplayName(username);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  bool get isAuthenticated {
    return _user != null;
  }
}
