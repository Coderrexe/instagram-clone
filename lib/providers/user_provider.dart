import 'package:flutter/material.dart';

import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/services/auth_methods.dart';

class UserProvider with ChangeNotifier {
  // Current logged-in user.
  AppUser? _user;

  // Methods for authenticating users on Firebase.
  final AuthMethods _authMethods = AuthMethods();

  AppUser get getUser => _user!;

  // Function to be called every time a user logs in.
  Future<void> refreshUser() async {
    // Retrieve information of the current user.
    AppUser user = await _authMethods.getUserDetails();
    _user = user;
    // Notify all clients that the current user has been updated.
    notifyListeners();
  }
}
