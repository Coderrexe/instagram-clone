import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  // Entry point to the Firebase Authentication SDK.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Entry point to the Firebase Cloud Firestore database.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function for creating a new user account.
  Future<Object> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
    required String bio,
    // required Uint8List profilePicture,
  }) async {
    try {
      // Wait for Firebase to create the user.
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = credential.user!;
      // Add user to our database.
      _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'username': username,
        'email': email,
        'bio': bio,
        'followers': [],
        'following': [],
      });
      return user;
    } catch (e) {
      return e.toString();
    }
  }
}
