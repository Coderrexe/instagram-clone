import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:instagram_clone/global_variables.dart';
import 'package:instagram_clone/providers/user_provider.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  }) : super(key: key);

  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    refreshUser();
  }

  // Function for saving the current user information to provider.
  void refreshUser() async {
    // We only need to call refreshUser once, when the user logs in, so we set
    // the parameter `listen` to false.
    UserProvider _userProvider = Provider.of(context, listen: false);
    // Save the current user information to provider.
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder helps us build responsive layout.
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          // If user device is web view.
          return widget.webScreenLayout;
        } else {
          // If user device is mobile.
          return widget.mobileScreenLayout;
        }
      },
    );
  }
}
