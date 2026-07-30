import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class AuthProvider extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  User? get currentUSer => _firebaseAuth.currentUser;
}